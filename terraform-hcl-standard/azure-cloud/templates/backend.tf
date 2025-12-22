terraform {
  backend "azurerm" {
    # 请在使用前替换为实际资源组、存储账户、容器和状态文件名
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateaccount"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
