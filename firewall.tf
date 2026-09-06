resource "google_compute_firewall" "allow_http" {
  name    = local.allow_http_name
  network = module.network.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["terraform-lab"]
}
