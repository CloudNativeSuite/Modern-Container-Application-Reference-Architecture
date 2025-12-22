variable "resource_group_name" {
  description = "Resource group where role assignment is scoped"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "principal_id" {
  description = "Object ID of the user/service principal/group to assign"
  type        = string
}

variable "role_definition_name" {
  description = "Built-in role to assign"
  type        = string
  default     = "Contributor"
}

provider "azurerm" {
  features {}
}

data "azurerm_role_definition" "selected" {
  name = var.role_definition_name
}

resource "azurerm_resource_group" "iam" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_role_assignment" "scope_assignment" {
  scope              = azurerm_resource_group.iam.id
  role_definition_id = data.azurerm_role_definition.selected.id
  principal_id       = var.principal_id
}

output "role_definition" {
  value       = data.azurerm_role_definition.selected.name
  description = "Role assigned to the principal"
}

output "scope" {
  value       = azurerm_resource_group.iam.id
  description = "Scope where the role assignment is created"
}
