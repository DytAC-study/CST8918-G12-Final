variable "resource_group_name" {
  description = "Name of the resource group for the backend storage"
  type        = string
}

variable "location" {
  description = "Azure region for the resources"
  type        = string
  default     = "East US"
}

variable "storage_account_name" {
  description = "Name of the storage account for Terraform backend"
  type        = string
}

variable "container_name" {
  description = "Name of the storage container for Terraform state"
  type        = string
  default     = "terraform-state"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 