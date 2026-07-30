# spring-devops-lab

[![Java](https://img.shields.io/badge/Java-21-orange?style=flat-square)](https://openjdk.org/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-6DB33F?style=flat-square&logo=springboot&logoColor=white)](https://spring.io/projects/spring-boot)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791?style=flat-square&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?style=flat-square&logo=docker&logoColor=white)](https://www.docker.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-kind-326CE5?style=flat-square&logo=kubernetes&logoColor=white)](https://kind.sigs.k8s.io/)
[![CI](https://github.com/LucianDanielCroitoru/spring-devops-lab/actions/workflows/ci.yml/badge.svg)](https://github.com/LucianDanielCroitoru/spring-devops-lab/actions/workflows/ci.yml)

Small end-to-end DevOps portfolio project built around a Spring Boot task management application and PostgreSQL.

The purpose of this repository is to show a practical delivery flow from local development to containerization, CI, Kubernetes deployment on kind, basic monitoring, and Terraform-based infrastructure management.

## Overview

This project demonstrates:

- local application startup
- PostgreSQL integration
- Docker image build
- Docker Compose orchestration
- GitHub Actions CI
- Kubernetes deployment on kind
- Prometheus and Grafana monitoring
- Terraform-based infrastructure management

## Features

The application exposes a simple task management API built with Spring Boot.

Main application layers included in the project:

- REST controller layer
- service layer
- repository layer
- DTOs for create and update requests
- global exception handling
- persistence with Spring Data JPA and PostgreSQL
- health and metrics endpoints with Spring Boot Actuator

## Tech stack

- Java 21
- Spring Boot
- Spring Data JPA
- Spring Boot Actuator
- PostgreSQL 16
- Docker
- Docker Compose
- GitHub Actions
- Kubernetes
- kind
- Prometheus
- Grafana
- Terraform

## Repository structure

```text
.
├── Dockerfile
├── HELP.md
├── README.md
├── docker-compose.yaml
├── k8s/
│   ├── app-configmap.yaml
│   ├── app-deployment.yaml
│   ├── app-secret.yaml
│   ├── app-service.yaml
│   ├── grafana-configmap.yaml
│   ├── grafana-deployment.yaml
│   ├── grafana-service.yaml
│   ├── postgres-deployment.yaml
│   ├── postgres-secret.yaml
│   ├── postgres-service.yaml
│   ├── prometheus-configmap.yaml
│   ├── prometheus-deployment.yaml
│   └── prometheus-service.yaml
├── src/
│   ├── main/
│   │   ├── java/ro/lucian/springdevopslab/
│   │   │   ├── config/
│   │   │   ├── controller/
│   │   │   ├── dto/
│   │   │   ├── model/
│   │   │   ├── repository/
│   │   │   └── service/
│   │   └── resources/
│   └── test/
├── terraform/
│   ├── app.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── postgres.tf
│   ├── providers.tf
│   ├── terraform.tfvars
│   └── variables.tf
├── mvnw
├── mvnw.cmd
└── pom.xml
```

## Architecture diagram

```mermaid
flowchart TD
    Dev[Developer]
    GH[GitHub Repository]
    GHA[GitHub Actions CI]
    Docker[Docker Image]

    subgraph Local[Local environment]
        AppLocal[Spring Boot App]
        PgLocal[(PostgreSQL)]
        AppLocal --> PgLocal
    end

    subgraph K8s[kind Kubernetes Cluster]
        AppSvc[Application Service]
        AppPod[Spring Boot Pod]
        PgSvc[PostgreSQL Service]
        PgPod[PostgreSQL Pod]
        Prom[Prometheus]
        Graf[Grafana]

        AppSvc --> AppPod
        AppPod --> PgSvc
        PgSvc --> PgPod
        Prom -->|scrapes actuator metrics| AppPod
        Graf --> Prom
    end

    Dev --> AppLocal
    Dev --> GH
    GH --> GHA --> Docker
    Docker --> K8s
```

## Delivery flow

### 1. Run locally

Start the application directly with Maven:

```bash
./mvnw spring-boot:run
```

Default local URL:

```text
http://localhost:8080
```

### 2. Run with Docker Compose

Start application and database:

```bash
docker compose up --build
```

Useful endpoints:

- App: `http://localhost:8080`
- Health: `http://localhost:8080/actuator/health`
- Prometheus metrics: `http://localhost:8080/actuator/prometheus`

### 3. CI with GitHub Actions

The CI workflow validates the project on push.

Current responsibilities:

- checkout source code
- set up Java
- run Maven build and tests
- verify the application builds successfully

### 4. Deploy on Kubernetes with kind

Create the cluster:

```bash
kind create cluster --name spring-devops-lab
```

Build the Docker image:

```bash
docker build -t spring-devops-lab-app:latest .
```

Load the image into kind:

```bash
kind load docker-image spring-devops-lab-app:latest --name spring-devops-lab
```

Apply Kubernetes manifests:

```bash
kubectl apply -f k8s/
```

Verify resources:

```bash
kubectl get pods
kubectl get svc
kubectl get deployments
```

Access the application, depending on your chosen service setup, either through port-forwarding or through the configured local exposure.

### 5. Monitoring with Prometheus and Grafana

The `k8s/` folder also contains manifests for:

- Prometheus `ConfigMap`, `Deployment`, and `Service`
- Grafana `ConfigMap`, `Deployment`, and `Service`

The application exposes these useful Actuator endpoints:

- `/actuator/health`
- `/actuator/health/liveness`
- `/actuator/health/readiness`
- `/actuator/prometheus`

### 6. Provision with Terraform

From the `terraform/` folder:

```bash
terraform init
terraform validate
terraform apply
```

Terraform files included in the project:

- `providers.tf`
- `variables.tf`
- `main.tf`
- `app.tf`
- `postgres.tf`
- `outputs.tf`

## Kubernetes resources

The `k8s/` folder contains manifests for:

- application `ConfigMap`
- application `Secret`
- application `Deployment`
- application `Service`
- PostgreSQL `Secret`
- PostgreSQL `Deployment`
- PostgreSQL `Service`
- Prometheus `ConfigMap`
- Prometheus `Deployment`
- Prometheus `Service`
- Grafana `ConfigMap`
- Grafana `Deployment`
- Grafana `Service`

## Configuration

The application reads database settings from environment variables:

- `SPRING_DATASOURCE_URL`
- `SPRING_DATASOURCE_USERNAME`
- `SPRING_DATASOURCE_PASSWORD`

This keeps the application portable across local development, Docker Compose, and Kubernetes.

## Screenshots

```md

### Local run
![Local app](docs/local-run.png)

### Docker Compose
![Docker Compose](docs/docker-compose.png)

### Kubernetes pods
![Kubernetes pods](docs/k8s-pods.png)

### Prometheus targets
![Prometheus targets](docs/prometheus-targets.png)

### Grafana dashboard
![Grafana dashboard](docs/grafana-dashboard.png)
```

## Troubleshooting

### Port already in use

If local port `8080` is already occupied, stop the existing process or use a different local mapping.

### Image updated but pod still uses old version

Rebuild and reload the image into kind, then restart the deployment:

```bash
docker build -t spring-devops-lab-app:latest .
kind load docker-image spring-devops-lab-app:latest --name spring-devops-lab
kubectl rollout restart deployment/spring-devops-lab-app
```

### Check pod logs

```bash
kubectl logs deployment/spring-devops-lab-app
kubectl logs deployment/postgres
```

## Roadmap

- [x] Run application locally
- [x] Run application with PostgreSQL
- [x] Dockerize the application
- [x] Add GitHub Actions CI
- [x] Deploy on Kubernetes with kind
- [x] Add monitoring with Prometheus and Grafana
- [x] Add Terraform
- [x] Add architecture diagram and screenshots

## Notes

`HELP.md` is kept as the default Spring Boot helper file.

`README.md` is the main portfolio-oriented documentation for this repository.