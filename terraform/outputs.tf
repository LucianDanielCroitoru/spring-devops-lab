output "cluster_name" {
  value = kind_cluster.this.name
}

output "kubeconfig_path" {
  value = pathexpand(var.kubeconfig_path)
}

output "namespace" {
  value = kubernetes_namespace.app.metadata[0].name
}

output "app_name" {
  value = kubernetes_deployment.app.metadata[0].name
}

output "service_node_port" {
  value = kubernetes_service.app.spec[0].port[0].node_port
}

output "postgres_service_name" {
  value = kubernetes_service.postgres.metadata[0].name
}

output "postgres_pvc_name" {
  value = kubernetes_persistent_volume_claim.postgres_data.metadata[0].name
}