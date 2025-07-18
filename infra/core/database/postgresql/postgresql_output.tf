output "database_name" {
  description = "The PostgreSQL database name"
  value       = azurerm_postgresql_flexible_server_database.app_db.name
}

output "server_fqdn" {
  description = "The PostgreSQL server FQDN"
  value       = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "administrator_login" {
  description = "The PostgreSQL administrator login"
  value       = azurerm_postgresql_flexible_server.postgres.administrator_login
}

output "database_url" {
  description = "The PostgreSQL database connection URL for Go applications"
  value       = "postgresql://${azurerm_postgresql_flexible_server.postgres.administrator_login}:${var.administrator_password}@${azurerm_postgresql_flexible_server.postgres.fqdn}:5432/${azurerm_postgresql_flexible_server_database.app_db.name}?sslmode=require"
  sensitive   = true
}