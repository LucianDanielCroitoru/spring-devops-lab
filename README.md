# spring-devops-lab

[![Java](https://img.shields.io/badge/Java-21-orange?style=flat-square)](https://openjdk.org/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-Framework-6DB33F?style=flat-square&logo=springboot&logoColor=white)](https://spring.io/projects/spring-boot)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791?style=flat-square&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?style=flat-square&logo=docker&logoColor=white)](https://www.docker.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-kind-326CE5?style=flat-square&logo=kubernetes&logoColor=white)](https://kind.sigs.k8s.io/)
[![CI](https://github.com/LucianDanielCroitoru/spring-devops-lab/actions/workflows/ci.yml/badge.svg)](https://github.com/LucianDanielCroitoru/spring-devops-lab/actions/workflows/ci.yml)

Small end-to-end DevOps portfolio project built around a Spring Boot application and PostgreSQL.

The goal of this repository is to show a practical delivery flow from local development to containerization, CI, and Kubernetes deployment using modern, free-to-run tooling.

## Overview

This project currently demonstrates:

- local application startup
- PostgreSQL integration
- Docker image build
- Docker Compose orchestration
- GitHub Actions CI
- Kubernetes deployment on kind

Planned next steps:

- Prometheus and Grafana monitoring
- Terraform structure
- final polish, screenshots, and architecture diagram

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

## Repository structure

```text
.
├── .github/workflows/ci.yml
├── k8s/
│   ├── app-configmap.yaml
│   ├── app-deployment.yaml
│   ├── app-secret.yaml
│   ├── app-service.yaml
│   ├── postgres-deployment.yaml
│   ├── postgres-secret.yaml
│   └── postgres-service.yaml
├── src/
├── Dockerfile
├── docker-compose.yaml
├── HELP.md
├── mvnw
├── mvnw.cmd
├── pom.xml
└── README.md
```

## Architecture

Current local/Kubernetes flow:

- Spring Boot application exposes HTTP endpoints on port `8080`
- PostgreSQL stores application data
- Docker packages the application
- GitHub Actions validates the build and tests
- kind runs the Kubernetes cluster locally
- Kubernetes manifests define:
    - `Deployment`
    - `Service`
    - `ConfigMap`
    - `Secret`

## Run locally

Start the application directly:

```bash
./mvnw spring-boot:run
```

Default local app URL:

```text
http://localhost:8080
```

## Run with Docker Compose

Start application and database:

```bash
docker compose up --build
```

Useful endpoints:

- App: `http://localhost:8080`
- Health: `http://localhost:8080/actuator/health`

## GitHub Actions

The CI pipeline validates the project on push.

Current CI responsibilities:

- checkout source code
- set up Java
- run Maven build and tests
- verify the application builds successfully

## Kubernetes on kind

### 1. Create the cluster

```bash
kind create cluster --name devops-lab
```

### 2. Build the Docker image

```bash
docker build -t spring-devops-lab:latest .
```

### 3. Load the image into kind

```bash
kind load docker-image spring-devops-lab:latest --name devops-lab
```

### 4. Apply Kubernetes manifests

```bash
kubectl apply -f k8s/
```

### 5. Verify resources

```bash
kubectl get pods
kubectl get svc
kubectl get deployments
```

### 6. Access the application

```bash
kubectl port-forward service/spring-devops-lab-app 18080:8080
```

Then open:

- `http://localhost:18080/actuator/health`
- `http://localhost:18080/actuator/health/liveness`
- `http://localhost:18080/actuator/health/readiness`

## Kubernetes resources

The `k8s/` folder contains the manifests for:

- PostgreSQL `Secret`
- PostgreSQL `Deployment`
- PostgreSQL `Service`
- Application `ConfigMap`
- Application `Secret`
- Application `Deployment`
- Application `Service`

## Configuration

The application reads database connection settings from environment variables:

- `SPRING_DATASOURCE_URL`
- `SPRING_DATASOURCE_USERNAME`
- `SPRING_DATASOURCE_PASSWORD`

This allows the same application to run:

- locally
- with Docker Compose
- in Kubernetes

## Health and probes

Spring Boot Actuator is enabled and used for health checks.

Kubernetes probes are configured with:

- `/actuator/health/liveness`
- `/actuator/health/readiness`

This setup makes the deployment more stable during startup and database initialization.

## Troubleshooting

### Port 8080 already in use

If local port `8080` is already occupied, use a different port for port-forwarding:

```bash
kubectl port-forward service/spring-devops-lab-app 18080:8080
```

### Image updated but pod still uses old version

Rebuild and reload the image into kind:

```bash
docker build -t spring-devops-lab:latest .
kind load docker-image spring-devops-lab:latest --name devops-lab
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
- [ ] Add monitoring with Prometheus and Grafana
- [ ] Add Terraform
- [ ] Add architecture diagram and screenshots

## Notes

`HELP.md` is kept as the default Spring Boot starter helper file.

`README.md` is the main project documentation for the portfolio version of this repository.