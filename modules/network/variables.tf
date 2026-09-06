variable "vpc_name" {
  type = string

  validation {
    condition = (
      length(var.vpc_name) >= 1 &&
      length(var.vpc_name) <= 63 &&
      can(regex("^[a-z]([-a-z0-9]*[a-z0-9])?$", var.vpc_name))
    )

    error_message = "vpc_name must be a valid lowercase GCP resource name."
  }
}

variable "subnet_name" {
  type = string

  validation {
    condition = (
      length(var.subnet_name) >= 1 &&
      length(var.subnet_name) <= 63 &&
      can(regex("^[a-z]([-a-z0-9]*[a-z0-9])?$", var.subnet_name))
    )

    error_message = "subnet_name must be a valid lowercase GCP resource name."
  }
}

variable "subnet_cidr" {
  type = string

  validation {
    condition     = can(cidrhost(var.subnet_cidr, 0))
    error_message = "subnet_cidr must be a valid IPv4 CIDR block."
  }
}

variable "region" {
  type = string
}

variable "environment" {
  type = string

  validation {
    condition = contains(
      ["dev", "staging", "prod"],
      var.environment
    )

    error_message = "Environment must be dev, staging, or prod."
  }
}
