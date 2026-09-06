output "instance_name" {
  value = module.compute_vm.name
}

output "external_ip" {
  value = module.compute_vm.external_ip
}

output "internal_ip" {
  value = module.compute_vm.internal_ip
}

output "network_name" {
  value = module.network.vpc_name
}

output "network_self_link" {
  value = module.network.vpc_self_link
}

output "subnet_name" {
  value = module.network.subnet_name
}

output "subnet_cidr" {
  value = module.network.subnet_cidr
}

output "deployment_name" {
  value = local.deployment_name
}

output "environment_tier" {
  value = local.environment_labels.tier
}
