output "resource_group_name" {
  description = "Name of the resource group"
  value       = data.azurerm_resource_group.network.name
}

output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = data.azurerm_virtual_network.main.name
}

output "virtual_network_id" {
  description = "ID of the virtual network"
  value       = data.azurerm_virtual_network.main.id
}

output "test_subnet_id" {
  description = "ID of the test subnet"
  value       = data.azurerm_subnet.test.id
}

output "network_security_group_id" {
  description = "ID of the network security group"
  value       = azurerm_network_security_group.main.id
} 