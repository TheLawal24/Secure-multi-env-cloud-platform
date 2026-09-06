locals {
  workspace_environment = terraform.workspace == "default" ? "dev" : terraform.workspace

  base_labels = {
    managed_by = "terraform"
    owner      = "devops-training"
  }

  environment_labels = {
    environment = var.environment
    workspace   = local.workspace_environment

    tier = lookup({
      dev     = "nonprod"
      staging = "nonprod"
      prod    = "production"
    }, var.environment, "unknown")
  }

  common_labels = merge(
    local.base_labels,
    local.environment_labels
  )

  selected_machine_type = try(
    var.environment_config[var.environment].machine_type,
    "e2-micro"
  )

  deployment_name = format(
    "%s-%s",
    var.environment,
    var.instance_name
  )
}
