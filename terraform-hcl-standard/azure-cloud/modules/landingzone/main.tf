variable "resource_group_name" {
  description = "Resource group to bootstrap"
  type        = string
  default     = "landingzone-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "log_analytics_workspace_name" {
  description = "Log Analytics workspace name"
  type        = string
  default     = "landingzone-law"
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "logs" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

output "resource_group_id" {
  value       = azurerm_resource_group.this.id
  description = "Landing zone resource group ID"
}

output "log_analytics_workspace_id" {
  value       = azurerm_log_analytics_workspace.logs.id
  description = "Log Analytics workspace ID"
}

output "resource_group_name" {
  value       = azurerm_resource_group.this.name
  description = "Landing zone resource group name"
}
