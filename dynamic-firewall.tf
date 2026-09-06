locals {
  dynamic_allow_rules = [
    {
      protocol = "tcp"
      ports    = ["22", "443"]
    },
    {
      protocol = "udp"
      ports    = ["53"]
    }
  ]
}

resource "google_compute_firewall" "dynamic_demo" {
  name = var.environment == "dev" ? "terraform-dynamic-demo" : "terraform-${var.environment}-dynamic-demo"

  network = module.network.vpc_name

  dynamic "allow" {
    for_each = local.dynamic_allow_rules

    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  source_ranges = [
    module.network.subnet_cidr
  ]

  target_tags = ["terraform-lab"]
}
