locals {
  tags                         = { azd-env-name : var.environment_name }
  sha                          = base64encode(sha256("${var.environment_name}${var.location}${data.azurerm_client_config.current.subscription_id}"))
  resource_token               = substr(replace(lower(local.sha), "[^A-Za-z0-9_]", ""), 0, 13)
}

# Data source for existing resource group
data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
}

# ------------------------------------------------------------------------------------------------------
# Core Infrastructure Modules
# ------------------------------------------------------------------------------------------------------

# PostgreSQL Database
module "postgresql" {
  source = "./core/database/postgresql"

  location                = data.azurerm_resource_group.existing.location
  rg_name                = data.azurerm_resource_group.existing.name
  resource_token         = local.resource_token
  tags                   = local.tags
  administrator_password = var.postgres_password
}

# Azure Container Registry
module "containerregistry" {
  source = "./core/host/containerregistry"

  location                = data.azurerm_resource_group.existing.location
  rg_name                 = data.azurerm_resource_group.existing.name
  resource_token          = local.resource_token
  tags                    = local.tags
  container_registry_name = var.container_registry_name
}

# Container Apps (Backend + Frontend Apps)
module "containerapps" {
  source = "./core/host/containerapps"

  location                = data.azurerm_resource_group.existing.location
  rg_name                 = data.azurerm_resource_group.existing.name
  resource_token          = local.resource_token
  tags                    = local.tags
  service_name            = "backend"  # Explicitly set backend service name
  container_image         = var.backend_image
  frontend_image          = var.frontend_image
  database_url            = module.postgresql.database_url
  registry_server         = module.containerregistry.container_registry_login_server
  registry_username       = module.containerregistry.container_registry_admin_username
  registry_password       = module.containerregistry.container_registry_admin_password
  container_apps_environment_name = var.container_apps_environment_name
  
  depends_on = [module.postgresql, module.containerregistry]
}
