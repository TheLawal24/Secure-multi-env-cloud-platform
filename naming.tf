locals {
  vpc_name = var.environment == "dev" ? "terraform-devops-vpc" : "terraform-${var.environment}-vpc"

  subnet_name = var.environment == "dev" ? "terraform-devops-subnet" : "terraform-${var.environment}-subnet"

  allow_http_name = var.environment == "dev" ? "terraform-allow-http" : "terraform-${var.environment}-allow-http"

  internal_firewall_prefix = var.environment == "dev" ? "terraform-internal" : "terraform-${var.environment}-internal"

  count_firewall_prefix = var.environment == "dev" ? "terraform-count-port" : "terraform-${var.environment}-count-port"
}
