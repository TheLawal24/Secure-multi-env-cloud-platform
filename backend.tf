terraform {
  backend "gcs" {
    bucket = "lawal-terraform-state-84096"
    prefix = "terraform/gcp-lab"
  }
}
