resource "kind_cluster" "this" {
  name            = var.kind_cluster_name
  node_image      = var.kind_node_image
  wait_for_ready  = true
  kubeconfig_path = pathexpand(var.kubeconfig_path)

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      extra_port_mappings {
        container_port = 30080
        host_port      = 8081
      }

      extra_port_mappings {
        container_port = 30443
        host_port      = 8444
      }
    }

    node {
      role = "worker"
    }
  }
}

resource "kubernetes_namespace" "app" {
  metadata {
    name = var.app_namespace
  }
}