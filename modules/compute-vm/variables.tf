variable "instance_name" {
  description = "Name of the Compute Engine instance"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the Compute Engine instance"
  type        = string
}

variable "zone" {
  description = "GCP zone for the Compute Engine instance"
  type        = string
}

variable "image" {
  description = "Boot disk image"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "disk_size" {
  description = "Boot disk size in GB"
  type        = number
}

variable "network" {
  description = "VPC network used by the instance"
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork used by the instance"
  type        = string
}

variable "labels" {
  description = "Labels applied to the instance"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Network tags applied to the instance"
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "enable_production_metadata" {
  description = "Whether to enable production startup metadata"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Whether GCP deletion protection is enabled"
  type        = bool
  default     = false
}

variable "enable_public_ip" {
  description = "Whether to assign a public external IP to the VM"
  type        = bool
  default     = false
}
