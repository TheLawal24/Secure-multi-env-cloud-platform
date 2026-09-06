check "environment_configuration" {
  assert {
    condition = contains(
      keys(var.environment_config),
      var.environment
    )

    error_message = "The selected environment has no environment_config entry."
  }
}

check "subnet_configuration" {
  assert {
    condition = (
      module.network.subnet_cidr ==
      var.environment_config[var.environment].subnet_cidr
    )

    error_message = "The subnet CIDR does not match the selected environment configuration."
  }
}
