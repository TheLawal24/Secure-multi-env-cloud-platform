terraform {
  backend "gcs" {
    bucket = "lawal-terraform-state-84096"
    prefix = "terraform/secure-multi-env-cloud-platform"
  }
}
