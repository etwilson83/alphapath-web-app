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

variable "service_name" {
  description = "The azd service name for the backend container app"
  type        = string
  default     = "backend"
}

variable "container_image" {
  description = "The backend container image to deploy"
  type        = string
  default     = "nginx:latest"
}

variable "frontend_image" {
  description = "The frontend container image to deploy"
  type        = string
  default     = "nginx:latest"
}

variable "container_cpu" {
  description = "The CPU allocation for the container"
  type        = number
  default     = 0.25
}

variable "container_memory" {
  description = "The memory allocation for the container"
  type        = string
  default     = "0.5Gi"
}

variable "container_port" {
  description = "The port the container listens on"
  type        = string
  default     = "8080"
}

variable "min_replicas" {
  description = "The minimum number of replicas"
  type        = number
  default     = 0
}

variable "max_replicas" {
  description = "The maximum number of replicas"
  type        = number
  default     = 3
}

variable "external_ingress_enabled" {
  description = "Whether external ingress is enabled"
  type        = bool
  default     = true
}

variable "database_url" {
  description = "The database connection URL"
  type        = string
  sensitive   = true
}

variable "additional_env_vars" {
  description = "Additional environment variables for the container"
  type        = map(string)
  default     = {}
}

variable "registry_server" {
  description = "Container registry server URL"
  type        = string
  default     = ""
}

variable "registry_username" {
  description = "Container registry username"
  type        = string
  default     = ""
}

variable "registry_password" {
  description = "Container registry admin password"
  type        = string
  default     = ""
  sensitive   = true
}

variable "container_apps_environment_name" {
  description = "The name of the existing container apps environment to use"
  type        = string
}