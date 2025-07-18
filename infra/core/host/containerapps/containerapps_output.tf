output "environment_id" {
  description = "The Container App Environment ID"
  value       = data.azurerm_container_app_environment.existing.id
}

output "environment_name" {
  description = "The Container App Environment name"
  value       = data.azurerm_container_app_environment.existing.name
}

output "backend_app_name" {
  description = "The backend Container App name"
  value       = azurerm_container_app.backend.name
}

output "backend_app_fqdn" {
  description = "The backend Container App FQDN"
  value       = azurerm_container_app.backend.ingress[0].fqdn
}

output "backend_app_url" {
  description = "The backend Container App URL"
  value       = "https://${azurerm_container_app.backend.ingress[0].fqdn}"
}

output "frontend_app_name" {
  description = "The frontend Container App name"
  value       = azurerm_container_app.frontend.name
}

output "frontend_app_fqdn" {
  description = "The frontend Container App FQDN"
  value       = azurerm_container_app.frontend.ingress[0].fqdn
}

output "frontend_app_url" {
  description = "The frontend Container App URL"
  value       = "https://${azurerm_container_app.frontend.ingress[0].fqdn}"
} 