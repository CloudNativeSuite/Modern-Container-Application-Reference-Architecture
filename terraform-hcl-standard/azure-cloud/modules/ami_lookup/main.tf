variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "publisher" {
  description = "Image publisher"
  type        = string
  default     = "Canonical"
}

variable "offer" {
  description = "Image offer"
  type        = string
  default     = "0001-com-ubuntu-server-focal"
}

variable "sku" {
  description = "Image SKU"
  type        = string
  default     = "20_04-lts"
}

data "azurerm_platform_image" "ubuntu" {
  location  = var.location
  publisher = var.publisher
  offer     = var.offer
  sku       = var.sku
}

output "image" {
  value = {
    publisher = data.azurerm_platform_image.ubuntu.publisher
    offer     = data.azurerm_platform_image.ubuntu.offer
    sku       = data.azurerm_platform_image.ubuntu.sku
    version   = data.azurerm_platform_image.ubuntu.version
  }
  description = "Latest platform image metadata"
}
