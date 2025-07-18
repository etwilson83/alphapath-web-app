# Input variables for the module

variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
  default     = "eastus"
}

variable "environment_name" {
  description = "The name of the azd environment to be deployed"
  type        = string
  default     = "dev"
}

variable "postgres_password" {
  description = "The PostgreSQL administrator password"
  type        = string
  sensitive   = true
  default     = "TempPassword123!"  # TODO: Use Key Vault or azd secrets in production
}

variable "backend_image" {
  description = "The backend container image to deploy"
  type        = string
  default     = "nginx:latest"
}

variable "frontend_image" {
  description = "The frontend container image to deploy"
  type        = string
  default     = "nginx:latest"
}

variable "resource_group_name" {
  description = "The name of the existing resource group to use"
  type        = string
}

variable "container_registry_name" {
  description = "The name of the existing container registry to use"
  type        = string
}

variable "container_apps_environment_name" {
  description = "The name of the existing container apps environment to use"
  type        = string
}
