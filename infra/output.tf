# Declare output values for the main terraform module.
#
# This allows the main terraform module outputs to be referenced by other modules,
# or by the local machine as a way to reference created resources in Azure for local development.
# Secrets should not be added here.
#
# Outputs are automatically saved in the local azd environment .env file.
# To see these outputs, run `azd env get-values`. `azd env get-values --output json` for json output.

output "AZURE_LOCATION" {
  value = var.location
}

output "AZURE_TENANT_ID" {
  value = data.azurerm_client_config.current.tenant_id
}

# PostgreSQL outputs
output "POSTGRES_SERVER_FQDN" {
  value = module.postgresql.server_fqdn
}

output "POSTGRES_DATABASE_NAME" {
  value = module.postgresql.database_name
}

# Container Apps outputs  
output "BACKEND_APP_URL" {
  value = module.containerapps.backend_app_url
}

output "FRONTEND_APP_URL" {
  value = module.containerapps.frontend_app_url
}

output "CONTAINER_APP_ENVIRONMENT_NAME" {
  value = module.containerapps.environment_name
}

# Container Registry outputs
output "AZURE_CONTAINER_REGISTRY_ENDPOINT" {
  value = module.containerregistry.container_registry_login_server
}

output "AZURE_CONTAINER_REGISTRY_NAME" {
  value = module.containerregistry.container_registry_name
}
