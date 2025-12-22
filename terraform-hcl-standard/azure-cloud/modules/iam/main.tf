variable "scope" {
  description = "Scope for the role assignment"
  type        = string
}

variable "principal_id" {
  description = "Object ID of the principal to assign"
  type        = string
}

variable "role_definition_name" {
  description = "Built-in role name"
  type        = string
  default     = "Contributor"
}

data "azurerm_role_definition" "selected" {
  name = var.role_definition_name
  scope = var.scope
}

resource "azurerm_role_assignment" "assignment" {
  scope              = var.scope
  role_definition_id = data.azurerm_role_definition.selected.id
  principal_id       = var.principal_id
}

output "role_definition" {
  value       = data.azurerm_role_definition.selected.name
  description = "Role assigned to the principal"
}
