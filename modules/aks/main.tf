terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.0.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

# ✅ 用 data 引用现有 VNet 和 Subnet，而不是资源
data "azurerm_virtual_network" "test" {
  name                = "test-vnet"
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "test" {
  name                 = "test-subnet"
  virtual_network_name = data.azurerm_virtual_network.test.name
  resource_group_name  = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "test-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "testaks"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"

    # ✅ 绑定到 data.subnet，而不是 resource.subnet
    vnet_subnet_id = data.azurerm_subnet.test.id
  }

  identity {
    type = "SystemAssigned"
  }
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.main.kube_config[0].host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.main.kube_config[0].client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.main.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate)
}
