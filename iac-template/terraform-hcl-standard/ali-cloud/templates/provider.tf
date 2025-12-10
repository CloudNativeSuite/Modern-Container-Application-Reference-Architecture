terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = ">= 1.210.0"
    }
  }
}

provider "alicloud" {
  region         = var.region
  access_key     = var.access_key
  secret_key     = var.secret_key
  security_token = var.security_token

  dynamic "assume_role" {
    for_each = var.ram_role_arn == null ? [] : [var.ram_role_arn]
    content {
      role_arn     = assume_role.value
      session_name = var.session_name
    }
  }
}
