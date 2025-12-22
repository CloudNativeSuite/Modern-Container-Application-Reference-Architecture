terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.90.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
  }
}

variable "subscription_id" {
  type        = string
  description = "Target subscription"
}

variable "tenant_id" {
  type        = string
  description = "AAD tenant id"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "eastus"
}

variable "principal_id" {
  type        = string
  description = "Principal to grant Contributor on the landing zone"
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

locals {
  resource_group_name = "demo-rg"
  vnet_name           = "demo-vnet"
}

module "landingzone" {
  source              = "../../modules/landingzone"
  resource_group_name = local.resource_group_name
  location            = var.location
}

module "iam" {
  source               = "../../modules/iam"
  scope                = module.landingzone.resource_group_id
  principal_id         = var.principal_id
  role_definition_name = "Contributor"
}

module "vpc" {
  source              = "../../modules/vpc"
  resource_group_name = module.landingzone.resource_group_name
  location            = var.location
  vnet_name           = local.vnet_name
  address_space       = ["10.20.0.0/16"]
  subnets = [
    {
      name           = "app"
      address_prefix = "10.20.1.0/24"
    }
  ]
}

module "nsg" {
  source              = "../../modules/sg"
  resource_group_name = module.landingzone.resource_group_name
  location            = var.location
  name                = "demo-nsg"
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = module.vpc.subnet_ids["app"]
  network_security_group_id = module.nsg.nsg_id
}

module "keypair" {
  source = "../../modules/keypair"
}

module "vm" {
  source              = "../../modules/ec2"
  resource_group_name = module.landingzone.resource_group_name
  location            = var.location
  vm_name             = "demo-vm"
  subnet_id           = module.vpc.subnet_ids["app"]
  admin_username      = "azureuser"
  ssh_public_key      = module.keypair.public_key_openssh
}

module "storage" {
  source               = "../../modules/s3"
  resource_group_name  = module.landingzone.resource_group_name
  location             = var.location
  storage_account_name = "demostorageacct01"
  container_name       = "artifacts"
}

module "database" {
  source                    = "../../modules/rds"
  resource_group_name       = module.landingzone.resource_group_name
  location                  = var.location
  server_name               = "demo-postgres"
  admin_username            = "pgadmin"
  admin_password            = "P@ssword12345!"
  db_name                   = "appdb"
  public_network_access_enabled = true
}

module "cache" {
  source              = "../../modules/redis"
  resource_group_name = module.landingzone.resource_group_name
  location            = var.location
  name                = "demorediscache"
  sku_name            = "Standard"
  capacity            = 1
}

output "resource_group" {
  value       = module.landingzone.resource_group_name
  description = "Resource group provisioned for demo"
}

output "vm_id" {
  value       = module.vm.vm_id
  description = "Demo VM ID"
}

output "ssh_private_key" {
  value       = module.keypair.private_key_pem
  description = "Private key to access the VM"
  sensitive   = true
}
