terraform {
  required_providers {
    azurerm = {
      version = "~>3.97.1"
      source  = "hashicorp/azurerm"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~>1.2.24"
    }
  }
}

# Data source for existing container apps environment
data "azurerm_container_app_environment" "existing" {
  name                = var.container_apps_environment_name
  resource_group_name = var.rg_name
}

resource "azurecaf_name" "ca_backend_name" {
  name          = "${var.resource_token}-backend"
  resource_type = "azurerm_container_app"
  random_length = 0
  clean_input   = true
}

resource "azurecaf_name" "ca_frontend_name" {
  name          = "${var.resource_token}-frontend"
  resource_type = "azurerm_container_app"
  random_length = 0
  clean_input   = true
}

# Container App for Frontend
resource "azurerm_container_app" "frontend" {
  name                         = azurecaf_name.ca_frontend_name.result
  container_app_environment_id = data.azurerm_container_app_environment.existing.id
  resource_group_name          = var.rg_name
  revision_mode                = "Single"

  dynamic "secret" {
    for_each = var.registry_server != "" ? [1] : []
    content {
      name  = "registry-password"
      value = var.registry_password
    }
  }

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = "frontend"
      image  = var.frontend_image
      cpu    = var.container_cpu
      memory = var.container_memory
    }
  }

  dynamic "registry" {
    for_each = var.registry_server != "" ? [1] : []
    content {
      server               = var.registry_server
      username             = var.registry_username
      password_secret_name = "registry-password"
    }
  }

  ingress {
    external_enabled = var.external_ingress_enabled
    target_port      = "80"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = merge(var.tags, {
    "azd-service-name" = "frontend"
  })
}

# Container App for Backend
resource "azurerm_container_app" "backend" {
  name                         = azurecaf_name.ca_backend_name.result
  container_app_environment_id = data.azurerm_container_app_environment.existing.id
  resource_group_name          = var.rg_name
  revision_mode                = "Single"

  dynamic "secret" {
    for_each = var.registry_server != "" ? [1] : []
    content {
      name  = "registry-password"
      value = var.registry_password
    }
  }

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = "backend"
      image  = var.container_image
      cpu    = var.container_cpu
      memory = var.container_memory

      env {
        name  = "DATABASE_URL"
        value = var.database_url
      }

      env {
        name  = "PORT"
        value = var.container_port
      }

      env {
        name  = "FRONTEND_URL"
        value = "https://${azurerm_container_app.frontend.ingress[0].fqdn}"
      }

      env {
        name  = "ENVIRONMENT"
        value = "production"
      }

      dynamic "env" {
        for_each = var.additional_env_vars
        content {
          name  = env.key
          value = env.value
        }
      }
    }
  }

  dynamic "registry" {
    for_each = var.registry_server != "" ? [1] : []
    content {
      server               = var.registry_server
      username             = var.registry_username
      password_secret_name = "registry-password"
    }
  }

  ingress {
    external_enabled = var.external_ingress_enabled
    target_port      = var.container_port

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = merge(var.tags, {
    "azd-service-name" = var.service_name
  })
} 