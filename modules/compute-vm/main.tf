#trivy:ignore:GCP-0031
resource "google_compute_instance" "this" {
  name                      = var.instance_name
  machine_type              = var.machine_type
  zone                      = var.zone
  allow_stopping_for_update = true
  deletion_protection       = var.deletion_protection

  lifecycle {
    prevent_destroy = true

    postcondition {
      condition     = self.current_status == "RUNNING"
      error_message = "The Compute Engine VM must be in RUNNING state."
    }
  }

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size
    }
  }

  labels = var.labels

  metadata_startup_script = var.enable_production_metadata ? "#!/bin/bash\necho \"Environment: ${var.environment}\" > /tmp/environment.txt\n" : null

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    dynamic "access_config" {
      for_each = var.enable_public_ip ? [1] : []

      content {}
    }
  }

  tags = var.tags
}
