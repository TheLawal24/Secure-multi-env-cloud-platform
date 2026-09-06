resource "google_compute_network" "this" {
  name                    = var.vpc_name
  auto_create_subnetworks = false

  lifecycle {
    precondition {
      condition = (
        (terraform.workspace == "default" && var.environment == "dev") ||
        (terraform.workspace != "default" && terraform.workspace == var.environment)
      )

      error_message = "Workspace and environment do not match."
    }
  }
}

resource "google_compute_subnetwork" "this" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.this.id
}
