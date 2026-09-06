module "compute_vm" {
  source = "./modules/compute-vm"

  instance_name = var.instance_name
  machine_type  = local.selected_machine_type
  disk_size     = var.environment_config[var.environment].disk_size
  zone          = var.zone

  environment                = var.environment
  enable_production_metadata = var.environment == "prod"
  deletion_protection        = var.environment == "prod"
  enable_public_ip           = var.environment != "prod"

  network    = module.network.vpc_id
  subnetwork = module.network.subnet_id

  labels = local.common_labels

  tags = ["terraform-lab"]
}
