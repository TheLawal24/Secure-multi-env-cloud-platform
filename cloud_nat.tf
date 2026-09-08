resource "google_compute_router" "nat_router" {
  count = var.environment == "prod" ? 1 : 0

  name    = "terraform-${var.environment}-nat-router"
  network = module.network.vpc_name
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  count = var.environment == "prod" ? 1 : 0

  name   = "terraform-${var.environment}-cloud-nat"
  router = google_compute_router.nat_router[0].name
  region = var.region

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
