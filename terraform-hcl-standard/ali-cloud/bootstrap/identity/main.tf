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

locals {
  assume_principal = "acs:ram::${var.account_id}:root"
}

resource "alicloud_ram_role" "terraform" {
  name     = var.role_name
  document = <<POLICY
{
  "Version": "1", 
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "RAM": ["${local.assume_principal}"]
      }
    }
  ]
}
POLICY
  description = "Role assumed by CI/CD or operators for Terraform"
  force       = true
}

resource "alicloud_ram_policy" "terraform_admin" {
  name        = var.policy_name
  description = "Terraform administrative access"
  document    = <<POLICY
{
  "Version": "1", 
  "Statement": [
    {
      "Action": [
        "ecs:*",
        "vpc:*",
        "oss:*",
        "ram:*",
        "slb:*",
        "alb:*",
        "rds:*",
        "kvstore:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
POLICY
  force = true
}

resource "alicloud_ram_role_policy_attachment" "role_attach" {
  policy_name = alicloud_ram_policy.terraform_admin.name
  policy_type = alicloud_ram_policy.terraform_admin.type
  role_name   = alicloud_ram_role.terraform.name
}

resource "alicloud_ram_user" "terraform" {
  name         = var.user_name
  display_name = "terraform-automation"
  force        = true
}

resource "alicloud_ram_user_policy_attachment" "user_attach" {
  policy_name = alicloud_ram_policy.terraform_admin.name
  policy_type = alicloud_ram_policy.terraform_admin.type
  user_name   = alicloud_ram_user.terraform.name
}

resource "alicloud_ram_access_key" "terraform" {
  user_name = alicloud_ram_user.terraform.name
}

output "ram_role_name" {
  value = alicloud_ram_role.terraform.name
}

output "ram_user_name" {
  value = alicloud_ram_user.terraform.name
}

output "access_key_id" {
  value       = alicloud_ram_access_key.terraform.id
  description = "Access key ID for terraform user"
}

output "access_key_secret" {
  value       = alicloud_ram_access_key.terraform.secret
  description = "Access key secret for terraform user"
  sensitive   = true
}
