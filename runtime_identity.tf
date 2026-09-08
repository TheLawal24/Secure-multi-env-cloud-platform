resource "google_service_account" "runtime" {
  account_id   = "secure-platform-${var.environment}-runtime"
  display_name = "Secure Cloud Platform ${title(var.environment)} Runtime"

  description = "Least-privilege runtime identity for ${var.environment} application workloads"
}

resource "google_artifact_registry_repository_iam_member" "runtime_reader" {
  project    = var.project_id
  location   = var.region
  repository = "secure-cloud-platform"

  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.runtime.email}"
}
