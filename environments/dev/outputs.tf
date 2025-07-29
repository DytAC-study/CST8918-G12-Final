output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.network.resource_group_name
}

output "kubernetes_cluster_name" {
  description = "Name of the Kubernetes cluster"
  value       = module.aks.kubernetes_cluster_name
}

output "acr_login_server" {
  description = "Azure Container Registry login server"
  value       = module.weather_app.acr_login_server
}

output "redis_hostname" {
  description = "Redis cache hostname"
  value       = module.weather_app.redis_hostname
}

output "kubernetes_service_name" {
  description = "Name of the Kubernetes service"
  value       = module.weather_app.kubernetes_service_name
} 