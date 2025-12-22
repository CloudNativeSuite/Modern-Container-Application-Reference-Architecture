variable "resource_group_name" {
  description = "Resource group for Event Hubs"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "namespace_name" {
  description = "Event Hubs namespace name"
  type        = string
}

variable "eventhub_name" {
  description = "Event Hub name"
  type        = string
  default     = "events"
}

variable "partition_count" {
  description = "Number of partitions"
  type        = number
  default     = 2
}

variable "message_retention" {
  description = "Message retention in days"
  type        = number
  default     = 1
}

resource "azurerm_eventhub_namespace" "ns" {
  name                = var.namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  capacity            = 1
}

resource "azurerm_eventhub" "hub" {
  name                = var.eventhub_name
  namespace_name      = azurerm_eventhub_namespace.ns.name
  resource_group_name = var.resource_group_name
  partition_count     = var.partition_count
  message_retention   = var.message_retention
}

output "namespace_id" {
  value       = azurerm_eventhub_namespace.ns.id
  description = "Event Hubs namespace ID"
}

output "eventhub_id" {
  value       = azurerm_eventhub.hub.id
  description = "Event Hub ID"
}
