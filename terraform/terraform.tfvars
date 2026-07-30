kind_cluster_name  = "spring-devops-lab"
kubeconfig_path    = "~/.kube/config-kind-spring-devops-lab"
kubeconfig_context = "kind-spring-devops-lab"
app_namespace      = "spring-devops-lab"
kind_node_image    = "kindest/node:v1.30.0"

app_name           = "spring-devops-lab"
app_image          = "spring-devops-lab-app:latest"
app_container_port = 8080
app_service_port   = 8080
app_node_port      = 30080

app_cpu_request    = "100m"
app_memory_request = "256Mi"
app_cpu_limit      = "500m"
app_memory_limit   = "512Mi"

postgres_name               = "postgres"
postgres_image              = "postgres:16-alpine"
postgres_db                 = "devops_lab"
postgres_user               = "postgres"
postgres_password           = "postgres"
postgres_port               = 5432
postgres_storage_size       = "1Gi"
postgres_storage_class_name = "manual"
postgres_host_path          = "/tmp/spring-devops-lab-postgres"

postgres_cpu_request    = "100m"
postgres_memory_request = "256Mi"
postgres_cpu_limit      = "500m"
postgres_memory_limit   = "512Mi"