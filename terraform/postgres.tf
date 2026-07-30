resource "kubernetes_secret" "postgres_credentials" {
  metadata {
    name      = "${var.postgres_name}-credentials"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  type = "Opaque"

  data = {
    POSTGRES_USER     = var.postgres_user
    POSTGRES_PASSWORD = var.postgres_password
  }
}

resource "kubernetes_config_map" "postgres_config" {
  metadata {
    name      = "${var.postgres_name}-config"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  data = {
    POSTGRES_DB   = var.postgres_db
    POSTGRES_HOST = var.postgres_name
    POSTGRES_PORT = tostring(var.postgres_port)
  }
}

resource "kubernetes_storage_class" "postgres_manual" {
  metadata {
    name = var.postgres_storage_class_name
  }

  storage_provisioner    = "kubernetes.io/no-provisioner"
  reclaim_policy         = "Retain"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = false
}

resource "kubernetes_persistent_volume" "postgres_data" {
  metadata {
    name = "${var.postgres_name}-pv"
  }

  spec {
    capacity = {
      storage = var.postgres_storage_size
    }

    access_modes                     = ["ReadWriteOnce"]
    storage_class_name               = kubernetes_storage_class.postgres_manual.metadata[0].name
    persistent_volume_reclaim_policy = "Retain"

    persistent_volume_source {
      host_path {
        path = var.postgres_host_path
        type = "DirectoryOrCreate"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "postgres_data" {
  metadata {
    name      = "${var.postgres_name}-pvc"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = kubernetes_storage_class.postgres_manual.metadata[0].name
    volume_name        = kubernetes_persistent_volume.postgres_data.metadata[0].name

    resources {
      requests = {
        storage = var.postgres_storage_size
      }
    }
  }
}

resource "kubernetes_deployment" "postgres" {
  metadata {
    name      = var.postgres_name
    namespace = kubernetes_namespace.app.metadata[0].name

    labels = {
      app = var.postgres_name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.postgres_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.postgres_name
        }
      }

      spec {
        container {
          name  = var.postgres_name
          image = var.postgres_image

          port {
            container_port = var.postgres_port
          }

          resources {
            requests = {
              cpu    = var.postgres_cpu_request
              memory = var.postgres_memory_request
            }
            limits = {
              cpu    = var.postgres_cpu_limit
              memory = var.postgres_memory_limit
            }
          }

          env {
            name = "POSTGRES_DB"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.postgres_config.metadata[0].name
                key  = "POSTGRES_DB"
              }
            }
          }

          env {
            name = "POSTGRES_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.postgres_credentials.metadata[0].name
                key  = "POSTGRES_USER"
              }
            }
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.postgres_credentials.metadata[0].name
                key  = "POSTGRES_PASSWORD"
              }
            }
          }

          volume_mount {
            name       = "postgres-data"
            mount_path = "/var/lib/postgresql/data"
          }

          readiness_probe {
            tcp_socket {
              port = var.postgres_port
            }
            initial_delay_seconds = 10
            period_seconds        = 5
            timeout_seconds       = 2
            failure_threshold     = 6
          }

          liveness_probe {
            tcp_socket {
              port = var.postgres_port
            }
            initial_delay_seconds = 20
            period_seconds        = 10
            timeout_seconds       = 2
            failure_threshold     = 6
          }
        }

        volume {
          name = "postgres-data"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgres_data.metadata[0].name
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_persistent_volume_claim.postgres_data
  ]
}

resource "kubernetes_service" "postgres" {
  metadata {
    name      = var.postgres_name
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    selector = {
      app = var.postgres_name
    }

    port {
      port        = var.postgres_port
      target_port = var.postgres_port
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}