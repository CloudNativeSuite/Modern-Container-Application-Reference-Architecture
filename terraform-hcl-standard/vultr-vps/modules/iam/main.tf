variable "users" {
  description = "需要创建的子账号列表"
  type = list(object({
    email    = string
    password = string
    acls     = list(string)
  }))
  default = []
}

variable "ssh_keys" {
  description = "需要上传的 SSH 公钥列表"
  type = list(object({
    name    = string
    public  = string
  }))
  default = []
}

resource "vultr_user" "this" {
  for_each     = { for u in var.users : u.email => u }
  email        = each.value.email
  password     = each.value.password
  api_enabled  = true
  acls         = each.value.acls
}

resource "vultr_ssh_key" "this" {
  for_each = { for k in var.ssh_keys : k.name => k }
  name     = each.value.name
  ssh_key  = each.value.public
}

output "user_ids" {
  value       = { for k, v in vultr_user.this : k => v.id }
  description = "创建的子账号 ID 映射"
}

output "ssh_key_ids" {
  value       = { for k, v in vultr_ssh_key.this : k => v.id }
  description = "上传的 SSH Key ID 映射"
}
