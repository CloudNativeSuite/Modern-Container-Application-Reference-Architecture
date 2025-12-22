variable "resource_group_name" {
  description = "Resource group for the Cosmos DB account"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "account_name" {
  description = "Cosmos DB account name"
  type        = string
}

variable "table_name" {
  description = "Table (Table API) name"
  type        = string
  default     = "tfstate-lock"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "cosmos" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_cosmosdb_account" "table" {
  name                = var.account_name
  location            = azurerm_resource_group.cosmos.location
  resource_group_name = azurerm_resource_group.cosmos.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Session"
  }

  capabilities {
    name = "EnableTable"
  }

  geo_location {
    location          = azurerm_resource_group.cosmos.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_table" "state_lock" {
  name                = var.table_name
  resource_group_name = azurerm_resource_group.cosmos.name
  account_name        = azurerm_cosmosdb_account.table.name
  throughput          = 400
}

output "account" {
  value       = azurerm_cosmosdb_account.table.name
  description = "Cosmos DB account for lock table"
}

output "table" {
  value       = azurerm_cosmosdb_table.state_lock.name
  description = "Table API collection used for state locking"
}
