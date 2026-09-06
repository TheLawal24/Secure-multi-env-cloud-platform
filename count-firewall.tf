locals {
  count_ports = ["8080", "9090"]
}

resource "google_compute_firewall" "count_demo" {
  count = length(local.count_ports)

  name    = "${local.count_firewall_prefix}-${local.count_ports[count.index]}"
  network = module.network.vpc_name

  allow {
    protocol = "tcp"
    ports    = [local.count_ports[count.index]]
  }

  source_ranges = [
    module.network.subnet_cidr
  ]

  target_tags = ["terraform-lab"]
}
