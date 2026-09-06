locals {
  internal_ports = {
    ssh   = "22"
    https = "443"
  }
}

resource "google_compute_firewall" "internal_services" {
  for_each = local.internal_ports

  name    = "${local.internal_firewall_prefix}-${each.key}"
  network = module.network.vpc_name

  allow {
    protocol = "tcp"
    ports    = [each.value]
  }

  source_ranges = [
    module.network.subnet_cidr
  ]

  target_tags = ["terraform-lab"]
}
