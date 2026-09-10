# Secure Multi-Environment Cloud Platform

A production-style DevOps platform built on Google Cloud using Terraform, GitHub Actions, Workload Identity Federation, Docker, Artifact Registry, Ansible, IAP, and environment-specific deployment controls.

This project demonstrates how to design, provision, secure, deploy, promote, and operate applications across multiple environments using infrastructure as code and modern CI/CD practices.

## Architecture Overview

The platform supports three environments:

- Development
- Staging
- Production

Each environment is managed through Terraform workspaces and environment-specific configuration.

Core technologies:

- Google Cloud Platform
- Terraform
- GitHub Actions
- Workload Identity Federation
- Docker
- Google Artifact Registry
- Ansible
- Google Cloud IAP
- Cloud NAT
- Python / Flask
- Trivy

## High-Level Architecture

```text
Developer
   |
   v
GitHub Repository
   |
   +-----------------------------+
   |                             |
   v                             v
Application CI              Terraform CI/CD
   |                             |
   |                             |
   v                             v
Tests + Trivy            Workload Identity Federation
   |                             |
   v                             v
Docker Build               GCP Plan / Apply Identities
   |
   v
Dedicated Image Publisher
   |
   v
Google Artifact Registry
   |
   +---------------------+
   |                     |
   v                     v
Dev Runtime Identity   Prod Runtime Identity
   |                     |
   v                     v
Dev VM                Private Prod VM
                         |
                         v
                     Cloud NAT
Environment Design
Development

The Development environment is used for validating infrastructure and application changes before production promotion.

Key characteristics:

Terraform-managed Compute Engine VM
Dedicated runtime service account
Artifact Registry Reader access
Application deployment through GitHub Actions
Docker image pulled using the VM's own metadata identity
IAP-based SSH access
No unnecessary application firewall exposure
Automated health and version verification
Staging

The Staging environment provides an additional non-production environment for infrastructure validation.

Key characteristics:

Dedicated VPC and subnet
Dedicated runtime service account
Artifact Registry Reader access
IAP-only SSH firewall
Professional environment labels and tags
Terraform-managed infrastructure
Existing infrastructure migrated safely into reusable Terraform modules
Production

Production is designed with stronger controls and reduced public exposure.

Key characteristics:

Private Compute Engine VM
No public VM IP
Google Cloud NAT for outbound internet access
Dedicated production runtime identity
Artifact Registry Reader access
IAP-only administrative access
Terraform deletion protection
Protected GitHub environment approval
Destructive Terraform changes blocked by default
Immutable application promotion
Automated post-deployment health verification
Rollback capability
Infrastructure as Code

Terraform manages:

VPC networks
Subnets
Compute Engine instances
Firewall rules
Runtime service accounts
Artifact Registry IAM
Cloud NAT
Cloud Router
Environment labels and tags
Production security controls

Reusable Terraform modules are used for infrastructure components including networking and compute resources.

Terraform workspaces:

default  -> Development
staging  -> Staging
prod     -> Production

Environment-specific values are stored separately.

Example:

dev.tfvars
staging.tfvars
prod.tfvars
Remote Terraform State

Terraform state is stored remotely in Google Cloud Storage.

Backend prefix:

terraform/secure-multi-env-cloud-platform

Workspace states include:

default.tfstate
staging.tfstate
prod.tfstate

GitHub Terraform identities receive scoped state access through conditional IAM policies.

This prevents unrestricted access to unrelated objects in the state bucket.

CI/CD Pipeline

The GitHub Actions pipeline separates application delivery from infrastructure management.

Application CI

Application changes are validated using:

Python dependency installation
Automated tests
Docker build validation
Trivy container security scanning
Non-root container validation

Images are published to Google Artifact Registry.

Each application image receives an immutable Git commit SHA tag.

Example:

europe-west2-docker.pkg.dev/PROJECT_ID/secure-cloud-platform/lawal-cloud-platform:<git-sha>
Dedicated Image Publishing Identity

Application images are published using a dedicated service account:

scp-image-publisher

This identity receives only Artifact Registry Writer permissions on the required repository.

Terraform Apply credentials are therefore not reused for normal image publishing.

Workload Identity Federation

GitHub Actions authenticates to Google Cloud using Workload Identity Federation.

No long-lived Google Cloud service-account keys are stored in GitHub.

Separate service accounts are used for:

Dev Plan
Dev Apply
Prod Plan
Prod Apply
Image Publishing
Runtime Workloads

This supports separation of duties and least-privilege access.

Terraform Plan and Apply Separation

Terraform planning and applying use different identities.

Development:

terraform-github-plan
terraform-github-apply

Production:

terraform-github-prod-plan
terraform-github-prod

Plan identities receive read-focused permissions.

Apply identities receive the permissions required to modify infrastructure.

Production Destructive Change Protection

Production Terraform plans are inspected before apply.

If Terraform detects a delete action during a normal production run, the workflow fails.

Example policy:

Normal production workflow
    |
    v
Terraform Plan
    |
    v
Delete detected?
    |
    +---- Yes ---> BLOCK
    |
    +---- No ----> Continue

Destructive changes require an explicit manually initiated workflow path.

This reduces the risk of accidental production deletion.

Immutable Dev-to-Prod Promotion

Production does not rebuild the application image.

Instead, the exact image tested in Development is promoted to Production.

Deployment process:

Application commit
      |
      v
Build once
      |
      v
Artifact Registry
      |
      v
Deploy exact SHA to Dev
      |
      v
Health + version verification
      |
      v
Manual production approval
      |
      v
Deploy SAME SHA to Prod
      |
      v
Health + version verification

This prevents differences between Development and Production artifacts.

Runtime Identity

Each VM uses its own runtime service account.

Examples:

secure-platform-dev-runtime
secure-platform-stg-runtime
secure-platform-prod-runtime

Runtime identities receive only Artifact Registry Reader access.

The application VM obtains a temporary OAuth access token through the Google Compute Engine metadata service.

That token is then used to authenticate Docker to Artifact Registry.

No static registry credentials are stored on the VM.

Secure Production Networking

The Production VM has no public IP address.

Administrative access is performed through Google Cloud IAP.

Administrator / GitHub Actions
          |
          v
Google Cloud IAP
          |
          v
Private Production VM

The allowed IAP source range is:

35.235.240.0/20

Outbound internet access is provided through:

Cloud Router
Cloud NAT

This allows the private VM to retrieve required packages and services without exposing it directly to the public internet.

Configuration Management with Ansible

Ansible is used to bootstrap and configure Compute Engine instances.

The Ansible role manages:

Docker installation
Docker service startup
Docker service enablement
User Docker group membership
Idempotent host configuration

Example structure:

ansible/
├── ansible.cfg
├── bootstrap.yml
├── inventory/
│   └── hosts.yml
└── roles/
    └── docker/
        └── tasks/
            └── main.yml

Ansible connects through Google Cloud IAP using a gcloud ProxyCommand.

Docker Application

The application is packaged as a Docker container.

The container runs:

Flask
Gunicorn
Non-root application execution
Docker health checks

Application endpoints include:

/
 /health
 /version
 /environment

Example:

curl http://localhost:8080/health
Rollback Strategy

Before replacing a running container, the deployment workflow records the currently deployed image.

If the new deployment fails health validation:

New container fails
      |
      v
Capture logs
      |
      v
Remove failed container
      |
      v
Redeploy previous image
      |
      v
Verify health

This provides automated application-level rollback without rebuilding the previous artifact.

Security Controls

The platform implements multiple security controls:

Workload Identity Federation
No long-lived GCP keys in GitHub
Separate Plan and Apply identities
Dedicated image publishing identity
Dedicated runtime identities
Repository-scoped Artifact Registry IAM
Conditional Terraform state IAM
Private Production VM
IAP administrative access
Cloud NAT for Production outbound access
Production deletion protection
Destructive Terraform plan detection
Protected Production GitHub environment
Manual Production approval
Immutable application images
Trivy image scanning
Non-root Docker execution
Infrastructure tagging and labeling
Project Structure
.
├── .github/
│   └── workflows/
│       ├── terraform-ci.yml
│       └── promote-prod.yml
├── ansible/
│   ├── ansible.cfg
│   ├── bootstrap.yml
│   ├── inventory/
│   └── roles/
├── modules/
│   ├── compute-vm/
│   └── network/
├── app/
├── backend.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── locals.tf
├── naming.tf
├── runtime_identity.tf
├── iap_ssh.tf
├── dev.tfvars
├── staging.tfvars
├── prod.tfvars
├── Dockerfile
└── README.md
Deployment Workflow

Typical infrastructure workflow:

Pull Request
    |
    v
Terraform Validation
    |
    v
Terraform Plan
    |
    v
Review
    |
    v
Merge
    |
    v
Protected Terraform Apply

Application workflow:

Code Change
    |
    v
Tests
    |
    v
Security Scan
    |
    v
Docker Build
    |
    v
Artifact Registry
    |
    v
Development
    |
    v
Production Promotion
Key Engineering Decisions
Why Workload Identity Federation?

It eliminates long-lived Google Cloud service-account keys from GitHub Actions.

Why separate Plan and Apply identities?

A CI process that only needs to inspect infrastructure should not automatically receive modification privileges.

Why use immutable Git SHA image tags?

It ensures Development and Production use the exact same tested artifact.

Why remove the Production public IP?

It reduces the attack surface of the production workload.

Why use IAP?

It provides authenticated administrative access without exposing SSH directly to the public internet.

Why use Cloud NAT?

Private workloads still require controlled outbound connectivity without public network interfaces.

Why use runtime service accounts?

Applications should authenticate using workload identity rather than reusable credentials.

Lessons Demonstrated

This project demonstrates practical experience with:

Infrastructure as Code
Modular Terraform architecture
Remote Terraform state
Terraform workspaces
GCP IAM
IAM Conditions
Workload Identity Federation
Secure CI/CD
Docker
Artifact Registry
Infrastructure security
Environment promotion
Rollback design
Private networking
IAP
Cloud NAT
Configuration management
GitHub branch protection
Production approval controls
Troubleshooting state and IAM issues
Safe infrastructure migration
Future Improvements

Potential future improvements include:

Google Kubernetes Engine
Helm
Argo CD
GitOps-based deployments
Prometheus and Grafana
Centralized Cloud Logging
Application metrics and alerting
OpenTelemetry
Policy-as-code
Secret Manager integration
Automated integration testing
Managed load balancing and HTTPS
Blue/green or canary deployments
Author

Lawal Oladele Sulaiman

DevOps / Cloud Engineering Portfolio Project
