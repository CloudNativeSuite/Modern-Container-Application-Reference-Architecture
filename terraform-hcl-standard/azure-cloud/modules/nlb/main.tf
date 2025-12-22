variable "resource_group_name" {
  description = "Resource group for the load balancer"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "name" {
  description = "Load balancer name"
  type        = string
  default     = "nlb"
}

variable "protocol" {
  description = "Frontend protocol"
  type        = string
  default     = "Tcp"
}

variable "frontend_port" {
  description = "Frontend port"
  type        = number
  default     = 80
}

variable "backend_port" {
  description = "Backend port"
  type        = number
  default     = 80
}

variable "backend_pool_backend_ids" {
  description = "List of backend NIC IDs or IP configurations"
  type        = list(string)
  default     = []
}

resource "azurerm_public_ip" "lb" {
  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "public"
    public_ip_address_id = azurerm_public_ip.lb.id
  }
}

resource "azurerm_lb_backend_address_pool" "pool" {
  name            = "backendpool"
  loadbalancer_id = azurerm_lb.this.id
}

resource "azurerm_lb_probe" "tcp" {
  name                = "tcp-probe"
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.this.id
  protocol            = var.protocol
  port                = var.backend_port
}

resource "azurerm_lb_rule" "lb_rule" {
  name                           = "lb-rule"
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.this.id
  protocol                       = var.protocol
  frontend_port                  = var.frontend_port
  backend_port                   = var.backend_port
  frontend_ip_configuration_name = "public"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.pool.id
  probe_id                       = azurerm_lb_probe.tcp.id
}

resource "azurerm_network_interface_backend_address_pool_association" "attach" {
  for_each                = toset(var.backend_pool_backend_ids)
  network_interface_id    = each.value
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.pool.id
}

output "lb_public_ip" {
  value       = azurerm_public_ip.lb.ip_address
  description = "Public IP assigned to the load balancer"
}

output "backend_pool_id" {
  value       = azurerm_lb_backend_address_pool.pool.id
  description = "Backend address pool ID"
}
