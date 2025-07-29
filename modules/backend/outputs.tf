output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.backend.name
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.backend.name
}

output "container_name" {
  description = "Name of the storage container"
  value       = azurerm_storage_container.backend.name
}

output "storage_account_key" {
  description = "Primary access key for the storage account"
  value       = azurerm_storage_account.backend.primary_access_key
  sensitive   = true
} 