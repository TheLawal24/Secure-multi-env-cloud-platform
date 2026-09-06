module "network" {
  source = "./modules/network"

  vpc_name    = local.vpc_name
  subnet_name = local.subnet_name
  subnet_cidr = var.environment_config[var.environment].subnet_cidr
  region      = var.region
  environment = var.environment
}
