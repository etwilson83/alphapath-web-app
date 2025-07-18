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

# Data source for existing container registry
data "azurerm_container_registry" "existing" {
  name                = var.container_registry_name
  resource_group_name = var.rg_name
}