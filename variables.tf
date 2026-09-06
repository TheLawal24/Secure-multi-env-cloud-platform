variable "region" {
  type    = string
  default = "europe-west2"
}

variable "zone" {
  type    = string
  default = "europe-west2-a"
}

variable "instance_name" {
  type    = string
  default = "terraform-devops-vm"
}

variable "environment" {
  type    = string
  default = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "environment_config" {
  type = map(object({
    machine_type = string
    disk_size    = number
    subnet_cidr  = string
  }))

  default = {
    dev = {
      machine_type = "e2-micro"
      disk_size    = 10
      subnet_cidr  = "10.20.0.0/24"
    }

    staging = {
      machine_type = "e2-small"
      disk_size    = 20
      subnet_cidr  = "10.30.0.0/24"
    }

    prod = {
      machine_type = "e2-medium"
      disk_size    = 30
      subnet_cidr  = "10.40.0.0/24"
    }
  }
}
