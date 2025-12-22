variable "resource_group_name" {
  description = "Resource group for Redis"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "name" {
  description = "Redis cache name"
  type        = string
}

variable "sku_name" {
  description = "Redis SKU name"
  type        = string
  default     = "Standard"
}

variable "capacity" {
  description = "Redis capacity (size family dependent)"
  type        = number
  default     = 1
}

resource "azurerm_redis_cache" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.capacity
  family              = "C"
  sku_name            = var.sku_name
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"
}

output "hostname" {
  value       = azurerm_redis_cache.this.hostname
  description = "Redis hostname"
}

output "primary_key" {
  value       = azurerm_redis_cache.this.primary_access_key
  sensitive   = true
  description = "Redis primary key"
}
