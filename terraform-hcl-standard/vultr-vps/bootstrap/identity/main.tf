terraform {
  required_version = ">= 1.5"

  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "~> 2.19"
    }
  }
}

provider "vultr" {
  api_key = var.vultr_api_key
}

resource "vultr_user" "readonly" {
  email       = var.user_email
  api_enabled = true
  acls        = var.acls
  password    = var.user_password
}

resource "vultr_ssh_key" "bootstrap" {
  name    = var.ssh_key_name
  ssh_key = var.public_key
}

output "user_id" {
  value       = vultr_user.readonly.id
  description = "最小权限 API 子账号 ID"
}

output "ssh_key_id" {
  value       = vultr_ssh_key.bootstrap.id
  description = "上传到 Vultr 的 SSH 公钥 ID"
}

variable "vultr_api_key" {
  description = "管理账号 API Key"
  type        = string
  sensitive   = true
}

variable "user_email" {
  description = "子账号邮箱"
  type        = string
}

variable "user_password" {
  description = "子账号初始密码"
  type        = string
  sensitive   = true
}

variable "acls" {
  description = "授予子账号的权限集合，例如 [\"subscriptions\", \"support\"]"
  type        = list(string)
  default     = ["subscriptions", "support", "billing"]
}

variable "ssh_key_name" {
  description = "SSH Key 的名称标签"
  type        = string
  default     = "bootstrap-key"
}

variable "public_key" {
  description = "SSH 公钥内容"
  type        = string
}
