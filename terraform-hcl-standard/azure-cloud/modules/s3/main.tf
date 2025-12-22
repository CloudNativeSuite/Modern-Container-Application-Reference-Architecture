variable "resource_group_name" {
  description = "Resource group for storage"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "storage_account_name" {
  description = "Storage account name"
  type        = string
}

variable "container_name" {
  description = "Blob container name"
  type        = string
  default     = "app"
}

resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  allow_blob_public_access = false
}

resource "azurerm_storage_container" "this" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

output "storage_account_id" {
  value       = azurerm_storage_account.this.id
  description = "Storage account ID"
}

output "container_name" {
  value       = azurerm_storage_container.this.name
  description = "Blob container name"
}
