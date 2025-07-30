variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "vnet_address_space" {
  description = "Virtual network address space"
  type        = string
  default     = "10.0.0.0/14"
}

variable "prod_subnet_address_space" {
  description = "Production subnet address space"
  type        = string
  default     = "10.0.0.0/16"
}

variable "test_subnet_address_space" {
  description = "Test subnet address space"
  type        = string
  default     = "10.1.0.0/16"
}

variable "dev_subnet_address_space" {
  description = "Development subnet address space"
  type        = string
  default     = "10.2.0.0/16"
}

variable "admin_subnet_address_space" {
  description = "Admin subnet address space"
  type        = string
  default     = "10.3.0.0/16"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 