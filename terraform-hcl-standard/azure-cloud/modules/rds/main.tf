variable "resource_group_name" {
  description = "Resource group for the database"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "server_name" {
  description = "PostgreSQL flexible server name"
  type        = string
}

variable "admin_username" {
  description = "Admin username"
  type        = string
  default     = "pgadmin"
}

variable "admin_password" {
  description = "Admin password"
  type        = string
  sensitive   = true
}

variable "version" {
  description = "PostgreSQL version"
  type        = string
  default     = "14"
}

variable "sku_name" {
  description = "SKU name for flexible server"
  type        = string
  default     = "GP_Standard_D2ds_v4"
}

variable "storage_mb" {
  description = "Storage in MB"
  type        = number
  default     = 32768
}

variable "db_name" {
  description = "Default database name"
  type        = string
  default     = "app"
}

variable "public_network_access_enabled" {
  description = "Allow public network access"
  type        = bool
  default     = true
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                   = var.server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = var.version
  administrator_login    = var.admin_username
  administrator_password = var.admin_password
  sku_name               = var.sku_name
  storage_mb             = var.storage_mb
  zone                   = 1
  backup_retention_days  = 7
  public_network_access_enabled = var.public_network_access_enabled
}

resource "azurerm_postgresql_flexible_database" "db" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.this.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_all" {
  count            = var.public_network_access_enabled ? 1 : 0
  name             = "allow-all"
  server_id        = azurerm_postgresql_flexible_server.this.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

output "server_fqdn" {
  value       = azurerm_postgresql_flexible_server.this.fqdn
  description = "Database server FQDN"
}

output "database_name" {
  value       = azurerm_postgresql_flexible_database.db.name
  description = "Database name created"
}
