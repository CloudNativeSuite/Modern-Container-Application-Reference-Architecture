variable "resource_group_name" {
  description = "Resource group for the Application Gateway"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "name" {
  description = "Application Gateway name"
  type        = string
  default     = "app-gateway"
}

variable "subnet_id" {
  description = "Subnet ID used by the Application Gateway"
  type        = string
}

variable "backend_port" {
  description = "Backend port for the default pool"
  type        = number
  default     = 80
}

variable "sku_name" {
  description = "Application Gateway SKU"
  type        = string
  default     = "Standard_v2"
}

variable "capacity" {
  description = "Instance count"
  type        = number
  default     = 1
}

resource "azurerm_public_ip" "gateway" {
  name                = "${var.name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name = var.sku_name
    tier = "Standard_v2"
  }

  autoscale_configuration {
    min_capacity = var.capacity
    max_capacity = var.capacity
  }

  gateway_ip_configuration {
    name      = "gateway-ipcfg"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "frontend-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.gateway.id
  }

  backend_address_pool {
    name = "default-backend"
  }

  backend_http_settings {
    name                  = "default-http"
    cookie_based_affinity = "Disabled"
    port                  = var.backend_port
    protocol              = "Http"
    request_timeout       = 30
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "frontend-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "http-rule"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "default-backend"
    backend_http_settings_name = "default-http"
  }
}

output "application_gateway_id" {
  value       = azurerm_application_gateway.this.id
  description = "Application Gateway resource ID"
}

output "public_ip" {
  value       = azurerm_public_ip.gateway.ip_address
  description = "Public IP assigned to the Application Gateway"
}
