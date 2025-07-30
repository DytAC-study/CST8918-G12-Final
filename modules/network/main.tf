terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Use data source for existing resource group instead of creating new one
data "azurerm_resource_group" "network" {
  name = var.resource_group_name
}

# Use data source for existing virtual network
data "azurerm_virtual_network" "main" {
  name                = "${var.environment}-vnet"
  resource_group_name = data.azurerm_resource_group.network.name
}

# Use data sources for existing subnets
data "azurerm_subnet" "test" {
  name                 = "test-subnet"
  resource_group_name  = data.azurerm_resource_group.network.name
  virtual_network_name = data.azurerm_virtual_network.main.name
}

resource "azurerm_network_security_group" "main" {
  name                = "${var.environment}-nsg"
  location            = data.azurerm_resource_group.network.location
  resource_group_name = data.azurerm_resource_group.network.name
  tags                = var.tags
}

# Network Security Group Rules
resource "azurerm_network_security_rule" "allow_https" {
  name                        = "allow-https"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "10.0.0.0/8" # Restrict to internal network
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.network.name
  network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_network_security_rule" "allow_http" {
  name                        = "allow-http"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*" # Allow external access
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.network.name
  network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "allow-ssh"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "10.0.0.0/8" # Restrict to internal network
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.network.name
  network_security_group_name = azurerm_network_security_group.main.name
}

# Additional rule for LoadBalancer health checks and external access
resource "azurerm_network_security_rule" "allow_lb_health_check" {
  name                        = "allow-lb-health-check"
  priority                    = 105
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.network.name
  network_security_group_name = azurerm_network_security_group.main.name
}

# Removed deny-all-inbound rule to allow external access

resource "azurerm_subnet_network_security_group_association" "test" {
  subnet_id                 = data.azurerm_subnet.test.id
  network_security_group_id = azurerm_network_security_group.main.id
} 