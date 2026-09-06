# Secure Multi-Environment Cloud Platform

A production-style DevSecOps platform that demonstrates secure cloud infrastructure, multi-environment deployment, CI/CD automation, infrastructure-as-code, and application delivery on Google Cloud Platform.

## Project Goals

This project is designed to demonstrate practical DevOps and cloud engineering skills through a realistic multi-environment platform supporting:

- Development
- Staging
- Production

The platform emphasizes security, automation, reliability, and controlled deployments.

## Core Technologies

- Terraform
- Google Cloud Platform
- GitHub Actions
- Workload Identity Federation
- Docker
- Python / Flask
- Gunicorn
- Gitleaks
- Trivy
- TFLint
- GitHub branch protection
- CI/CD
- Monitoring and logging

## Key DevSecOps Features

- Infrastructure as Code using reusable Terraform modules
- Remote Terraform state stored in Google Cloud Storage
- Environment-isolated state
- Least-privilege IAM
- OIDC / Workload Identity Federation instead of long-lived cloud credentials
- Pull-request based Terraform validation and planning
- Protected production deployments
- Terraform policy checks
- Secret scanning with Gitleaks
- Infrastructure security scanning with Trivy
- Terraform linting with TFLint
- GitHub Actions concurrency controls
- Branch protection and required checks
- Production deletion protection
- Private production VM networking
- Dockerized non-root application
- Application health, version, and environment endpoints
- Structured application logging

## Application Endpoints

The platform includes a lightweight production-style API.

| Endpoint | Purpose |
|---|---|
| `/` | Service information |
| `/health` | Health check |
| `/version` | Application version |
| `/environment` | Current deployment environment |

## Architecture

Current high-level flow:

```text
Developer
    |
    v
GitHub Pull Request
    |
    v
CI / Security Validation
    |
    +--> Gitleaks
    +--> Trivy
    +--> TFLint
    +--> Terraform Validate
    +--> Terraform Plan
    +--> Application Tests
    |
    v
Container Build
    |
    v
Development Environment
    |
    v
Production Approval
    |
    v
Production Environment
    |
    v
Monitoring / Logging
.
├── .github/
│   └── workflows/
├── app/
│   ├── app.py
│   ├── Dockerfile
│   ├── requirements.txt
│   └── test_app.py
├── architecture/
├── docs/
├── modules/
│   ├── compute-vm/
│   └── network/
├── monitoring/
├── scripts/
├── main.tf
├── variables.tf
├── outputs.tf
└── PROJECT.md
Security Design

The project uses several layers of security rather than relying on one control.

Production infrastructure is protected through:

dedicated production identity
environment-specific state access
protected production deployment approvals
Terraform destructive-action detection
deletion protection
restricted public IP exposure
policy checks
secret scanning
vulnerability scanning
immutable GitHub Action references
Project Status

This project is under active development.

Planned additions include:

automated application CI
container image vulnerability scanning
container registry integration
automated deployment pipeline
Kubernetes deployment
centralized monitoring
alerting
architecture diagrams
deployment rollback controls
Author

Lawal Oladele Sulaiman

DevOps / Cloud Engineering Portfolio Project
