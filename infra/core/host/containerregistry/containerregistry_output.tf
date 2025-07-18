output "container_registry_name" {
  description = "The Container Registry name"
  value       = data.azurerm_container_registry.existing.name
}

output "container_registry_login_server" {
  description = "The Container Registry login server URL"
  value       = data.azurerm_container_registry.existing.login_server
}

output "container_registry_admin_username" {
  description = "The Container Registry admin username"
  value       = data.azurerm_container_registry.existing.admin_username
}

output "container_registry_admin_password" {
  description = "The Container Registry admin password"
  value       = data.azurerm_container_registry.existing.admin_password
  sensitive   = true
}