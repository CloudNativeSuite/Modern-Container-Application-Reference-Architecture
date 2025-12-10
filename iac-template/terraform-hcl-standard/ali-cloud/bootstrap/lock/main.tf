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

resource "alicloud_ots_instance" "this" {
  name        = var.instance_name
  description = "Terraform state locking"
  accessed_by = "Any"
}

resource "alicloud_ots_table" "lock" {
  instance_name = alicloud_ots_instance.this.name
  table_name    = var.table_name

  time_to_live = -1
  max_version  = 1

  primary_key {
    name = "LockID"
    type = "STRING"
  }
}

output "lock_table" {
  value = alicloud_ots_table.lock.table_name
}
