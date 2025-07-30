output "aks_name" {
  value = azurerm_kubernetes_cluster.main.name
}

output "aks_host" {
  value = azurerm_kubernetes_cluster.main.kube_config[0].host
}

# ✅ 输出 subnet_id（但它是 data，不会被 Terraform 删除）
output "subnet_id" {
  value = data.azurerm_subnet.test.id
}
