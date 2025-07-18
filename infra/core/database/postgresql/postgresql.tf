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

resource "azurecaf_name" "postgres_name" {
  name          = var.resource_token
  resource_type = "azurerm_postgresql_flexible_server"
  random_length = 0
  clean_input   = true
}

# PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = azurecaf_name.postgres_name.result
  location               = var.location
  resource_group_name    = var.rg_name
  version                = var.postgres_version
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  sku_name              = var.sku_name
  storage_mb            = var.storage_mb

  # Ignore zone changes to prevent deployment issues
  lifecycle {
    ignore_changes = [zone]
  }

  tags = var.tags
}

# PostgreSQL Database
resource "azurerm_postgresql_flexible_server_database" "app_db" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.postgres.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

# PostgreSQL Firewall Rule (Allow Azure Services)
resource "azurerm_postgresql_flexible_server_firewall_rule" "azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}