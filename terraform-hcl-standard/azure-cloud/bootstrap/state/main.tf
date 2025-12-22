variable "resource_group_name" {
  description = "Resource group for state storage"
  type        = string
  default     = "tfstate-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "storage_account_name" {
  description = "Storage account name for Terraform state"
  type        = string
  default     = "tfstateaccount"
}

variable "container_name" {
  description = "Blob container to store state"
  type        = string
  default     = "tfstate"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "state" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "state" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.state.name
  location                 = azurerm_resource_group.state.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  allow_blob_public_access = false
}

resource "azurerm_storage_container" "state" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.state.name
  container_access_type = "private"
}

output "resource_group" {
  value       = azurerm_resource_group.state.name
  description = "Resource group created for Terraform state"
}

output "storage_account" {
  value       = azurerm_storage_account.state.name
  description = "Storage account for Terraform state"
}

output "container" {
  value       = azurerm_storage_container.state.name
  description = "Blob container used for Terraform state"
}
