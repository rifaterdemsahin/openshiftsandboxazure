variable "location" {
  type    = string
  description = "The location/region where the resource group will be created"
  default = "UK South"
}
variable "admin_username" {
  description = "The admin username for the virtual machine"
  type        = string
}

variable "admin_password" {
  description = "The admin password for the virtual machine"
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "subscription_id" {
  description = "The subscription ID for Azure"
  type        = string
}

variable "client_id" {
  description = "The client ID for Azure"
  type        = string
}

variable "client_secret" {
  description = "The client secret for Azure"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "The tenant ID for Azure"
  type        = string
}

variable "ssh_public_key" {
  description = "The SSH public key for accessing the virtual machine"
  type        = string
}
