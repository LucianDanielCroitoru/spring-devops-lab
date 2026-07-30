variable "kind_cluster_name" {
  description = "Name of the kind cluster"
  type        = string
  default     = "spring-devops-lab"
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig file used by kind and kubernetes provider"
  type        = string
  default     = "~/.kube/config-kind-spring-devops-lab"
}

variable "kubeconfig_context" {
  description = "Kubernetes context name from kubeconfig"
  type        = string
  default     = "kind-spring-devops-lab"
}

variable "app_namespace" {
  description = "Kubernetes namespace for the application"
  type        = string
  default     = "spring-devops-lab"
}

variable "kind_node_image" {
  description = "Kind node image version"
  type        = string
  default     = "kindest/node:v1.30.0"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "spring-devops-lab"
}

variable "app_image" {
  description = "Docker image for the application"
  type        = string
  default     = "spring-devops-lab-app:latest"
}

variable "app_container_port" {
  description = "Container port exposed by the application"
  type        = number
  default     = 8080
}

variable "app_service_port" {
  description = "Kubernetes service port"
  type        = number
  default     = 8080
}

variable "app_node_port" {
  description = "NodePort used to expose the application"
  type        = number
  default     = 30080
}

variable "app_cpu_request" {
  description = "CPU request for the application"
  type        = string
  default     = "100m"
}

variable "app_memory_request" {
  description = "Memory request for the application"
  type        = string
  default     = "256Mi"
}

variable "app_cpu_limit" {
  description = "CPU limit for the application"
  type        = string
  default     = "500m"
}

variable "app_memory_limit" {
  description = "Memory limit for the application"
  type        = string
  default     = "512Mi"
}

variable "postgres_name" {
  description = "PostgreSQL application and service name inside Kubernetes"
  type        = string
  default     = "postgres"
}

variable "postgres_image" {
  description = "Docker image for PostgreSQL"
  type        = string
  default     = "postgres:16-alpine"
}

variable "postgres_db" {
  description = "PostgreSQL database name"
  type        = string
  default     = "devops_lab"
}

variable "postgres_user" {
  description = "PostgreSQL username"
  type        = string
  sensitive   = true
}

variable "postgres_password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
}

variable "postgres_port" {
  description = "PostgreSQL container and service port"
  type        = number
  default     = 5432
}

variable "postgres_storage_size" {
  description = "Persistent volume size for PostgreSQL"
  type        = string
  default     = "1Gi"
}

variable "postgres_storage_class_name" {
  description = "Storage class name used for PostgreSQL persistent storage"
  type        = string
  default     = "manual"
}

variable "postgres_host_path" {
  description = "Host path on the kind node used by the PostgreSQL persistent volume"
  type        = string
  default     = "/tmp/spring-devops-lab-postgres"
}

variable "postgres_cpu_request" {
  description = "CPU request for PostgreSQL"
  type        = string
  default     = "100m"
}

variable "postgres_memory_request" {
  description = "Memory request for PostgreSQL"
  type        = string
  default     = "256Mi"
}

variable "postgres_cpu_limit" {
  description = "CPU limit for PostgreSQL"
  type        = string
  default     = "500m"
}

variable "postgres_memory_limit" {
  description = "Memory limit for PostgreSQL"
  type        = string
  default     = "512Mi"
}