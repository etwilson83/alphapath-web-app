variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
}

variable "rg_name" {
  description = "The name of the resource group to deploy resources into"
  type        = string
}

variable "tags" {
  description = "A list of tags used for deployed services."
  type        = map(string)
}

variable "resource_token" {
  description = "A suffix string to centrally mitigate resource name collisions."
  type        = string
}

variable "administrator_login" {
  type        = string
  description = "The PostgreSQL administrator login"
  default     = "pgadmin"
}

variable "administrator_password" {
  type        = string
  description = "The PostgreSQL administrator password"
  sensitive   = true
}

variable "database_name" {
  type        = string
  description = "The database name of PostgreSQL"
  default     = "research_app"
}

variable "postgres_version" {
  type        = string
  description = "The PostgreSQL version to deploy"
  default     = "15"
}

variable "sku_name" {
  type        = string
  description = "The PostgreSQL SKU name"
  default     = "B_Standard_B1ms"
}

variable "storage_mb" {
  type        = number
  description = "The PostgreSQL storage size in MB"
  default     = 32768
}