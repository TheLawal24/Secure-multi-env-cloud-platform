resource "google_compute_firewall" "iap_ssh" {
  name    = "terraform-${var.environment}-allow-iap-ssh"
  network = module.network.vpc_name

  direction = "INGRESS"

  source_ranges = [
    "35.235.240.0/20"
  ]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = [
    "secure-cloud-platform"
  ]

  description = "Allow SSH to managed VMs only through Google Cloud IAP"
}
