locals {
  principals = [for principal in var.assume_principals : "acs:ram::${principal}:root"]
}

resource "alicloud_ram_role" "this" {
  name     = var.role_name
  document = jsonencode({
    Version   = "1"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { RAM = local.principals }
    }]
  })
  description = var.description
  force       = true
}

resource "alicloud_ram_policy" "this" {
  name        = var.policy_name
  description = "Custom RAM policy"
  document    = jsonencode({
    Version   = "1"
    Statement = [{
      Action   = var.actions
      Effect   = "Allow"
      Resource = var.resource
    }]
  })
  force = true
}

resource "alicloud_ram_role_policy_attachment" "attachment" {
  policy_name = alicloud_ram_policy.this.name
  policy_type = alicloud_ram_policy.this.type
  role_name   = alicloud_ram_role.this.name
}

output "role_name" {
  value = alicloud_ram_role.this.name
}

output "policy_name" {
  value = alicloud_ram_policy.this.name
}
