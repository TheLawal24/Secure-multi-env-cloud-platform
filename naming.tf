locals {
  vpc_name = var.environment == "dev" ? "terraform-devops-vpc" : "terraform-${var.environment}-vpc"

  subnet_name = var.environment == "dev" ? "terraform-devops-subnet" : "terraform-${var.environment}-subnet"



}
