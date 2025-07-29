terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

# Azure Container Registry
resource "azurerm_container_registry" "main" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false # Disable admin access for security
  tags                = var.tags
}

# Azure Cache for Redis
resource "azurerm_redis_cache" "main" {
  name                 = "${var.environment}-redis-${random_string.suffix.result}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  capacity             = var.redis_capacity
  family               = "C"
  sku_name             = var.redis_sku
  non_ssl_port_enabled = false  # Ensure SSL is enabled
  tags                 = var.tags
}

# Random string for unique naming
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Kubernetes Provider Configuration
provider "kubernetes" {
  host                   = var.kubernetes_host
  client_certificate     = var.kubernetes_client_certificate
  client_key             = var.kubernetes_client_key
  cluster_ca_certificate = var.kubernetes_cluster_ca_certificate
}

# Kubernetes Namespace
resource "kubernetes_namespace" "weather_app" {
  depends_on = [azurerm_container_registry.main, azurerm_redis_cache.main]
  
  metadata {
    name = "weather-app"
    labels = {
      environment = var.environment
      app         = "weather-app"
    }
  }
}

# Kubernetes Secret for Redis Connection
resource "kubernetes_secret" "redis_secret" {
  metadata {
    name      = "redis-secret"
    namespace = kubernetes_namespace.weather_app.metadata[0].name
    labels = {
      app = "weather-app"
    }
  }

  data = {
    redis-host = azurerm_redis_cache.main.hostname
    redis-port = azurerm_redis_cache.main.ssl_port
    redis-key  = azurerm_redis_cache.main.primary_access_key
  }

  type = "Opaque"
}

# Kubernetes ConfigMap for Application Configuration
resource "kubernetes_config_map" "weather_app_config" {
  metadata {
    name      = "weather-app-config"
    namespace = kubernetes_namespace.weather_app.metadata[0].name
    labels = {
      app = "weather-app"
    }
  }

  data = {
    REDIS_HOST = azurerm_redis_cache.main.hostname
    REDIS_PORT = azurerm_redis_cache.main.ssl_port
    NODE_ENV   = var.environment
  }
}

# Kubernetes Deployment
resource "kubernetes_deployment" "weather_app" {
  metadata {
    name      = "weather-app"
    namespace = kubernetes_namespace.weather_app.metadata[0].name
    labels = {
      app = "weather-app"
    }
  }

  spec {
    replicas = var.app_replicas

    selector {
      match_labels = {
        app = "weather-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "weather-app"
        }
      }

      spec {
        security_context {
          run_as_non_root = true
          run_as_user     = 1000
          fs_group        = 1000
        }

        container {
          image = "${azurerm_container_registry.main.login_server}/weather-app:latest"
          name  = "weather-app"

          port {
            container_port = 3000
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.weather_app_config.metadata[0].name
            }
          }

          env_from {
            secret_ref {
              name = kubernetes_secret.redis_secret.metadata[0].name
            }
          }

          resources {
            limits = {
              cpu    = "200m"
              memory = "256Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 3000
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 3000
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 3
            failure_threshold     = 3
          }

          security_context {
            allow_privilege_escalation = false
            read_only_root_filesystem  = true
            capabilities {
              drop = ["ALL"]
            }
          }
        }
      }
    }
  }
}

# Kubernetes Service
resource "kubernetes_service" "weather_app" {
  metadata {
    name      = "weather-app-service"
    namespace = kubernetes_namespace.weather_app.metadata[0].name
    labels = {
      app = "weather-app"
    }
  }

  spec {
    selector = {
      app = "weather-app"
    }

    port {
      port        = 80
      target_port = 3000
      protocol    = "TCP"
    }

    type = "LoadBalancer"
  }
} 