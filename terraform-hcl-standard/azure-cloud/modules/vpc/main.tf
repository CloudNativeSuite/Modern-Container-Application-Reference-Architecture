variable "resource_group_name" {
  description = "Resource group for the virtual network"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_name" {
  description = "Virtual network name"
  type        = string
  default     = "main-vnet"
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "subnets" {
  description = "Subnets to create inside the VNet"
  type = list(object({
    name           = string
    address_prefix = string
    service_endpoints = optional(list(string), [])
  }))
  default = [
    {
      name           = "default"
      address_prefix = "10.10.1.0/24"
    }
  ]
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "this" {
  for_each             = { for subnet in var.subnets : subnet.name => subnet }
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]
  service_endpoints    = lookup(each.value, "service_endpoints", [])
}

output "vnet_id" {
  value       = azurerm_virtual_network.this.id
  description = "Virtual network resource ID"
}

output "subnet_ids" {
  value       = { for name, subnet in azurerm_subnet.this : name => subnet.id }
  description = "Map of subnet IDs keyed by name"
}
