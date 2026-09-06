# Architecture

The platform will use Terraform to provision infrastructure across development,
staging, and production environments.

GitHub Actions will provide CI/CD using Workload Identity Federation instead of
long-lived cloud credentials.

Security controls include:

- Branch protection
- Gitleaks secret scanning
- Trivy configuration scanning
- TFLint validation
- Terraform plan policy checks
- Environment-specific IAM
- Protected production deployments
- CI concurrency control

Application workloads will be containerized with Docker and deployed through
an automated delivery pipeline.
