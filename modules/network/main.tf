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

resource "azurerm_virtual_network" "main" {
  name                = "${var.environment}-vnet"
  resource_group_name = data.azurerm_resource_group.network.name
  location            = data.azurerm_resource_group.network.location
  address_space       = [var.vnet_address_space]
  tags                = var.tags
}

resource "azurerm_subnet" "prod" {
  name                 = "prod-subnet"
  resource_group_name  = data.azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.prod_subnet_address_space]
}

resource "azurerm_subnet" "test" {
  name                 = "test-subnet"
  resource_group_name  = data.azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.test_subnet_address_space]
}

resource "azurerm_subnet" "dev" {
  name                 = "dev-subnet"
  resource_group_name  = data.azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.dev_subnet_address_space]
}

resource "azurerm_subnet" "admin" {
  name                 = "admin-subnet"
  resource_group_name  = data.azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.admin_subnet_address_space]
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
  source_address_prefix       = "10.0.0.0/8" # Restrict to internal network
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

resource "azurerm_network_security_rule" "deny_all_inbound" {
  name                        = "deny-all-inbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.network.name
  network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_subnet_network_security_group_association" "prod" {
  subnet_id                 = azurerm_subnet.prod.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet_network_security_group_association" "test" {
  subnet_id                 = azurerm_subnet.test.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet_network_security_group_association" "dev" {
  subnet_id                 = azurerm_subnet.dev.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet_network_security_group_association" "admin" {
  subnet_id                 = azurerm_subnet.admin.id
  network_security_group_id = azurerm_network_security_group.main.id
} 