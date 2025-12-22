variable "label" {
  description = "数据库实例标签"
  type        = string
  default     = "app-db"
}

variable "region" {
  description = "Vultr 区域代码"
  type        = string
}

variable "engine" {
  description = "数据库引擎 (mysql, pg, redis)"
  type        = string
}

variable "plan" {
  description = "数据库套餐代号（如 vultr-dbaas-startup-cc-1-7-5）"
  type        = string
}

variable "dbname" {
  description = "数据库名称"
  type        = string
  default     = "app"
}

variable "username" {
  description = "数据库用户名"
  type        = string
  default     = "app"
}

variable "password" {
  description = "数据库密码"
  type        = string
  sensitive   = true
}

variable "ha" {
  description = "启用高可用"
  type        = bool
  default     = false
}

resource "vultr_database" "this" {
  label    = var.label
  region   = var.region
  plan     = var.plan
  engine   = var.engine
  replicas = var.ha ? 1 : 0

  database = var.dbname
  username = var.username
  password = var.password
}

output "dsn" {
  description = "标准连接串（host:port/database）"
  value       = "${vultr_database.this.hostname}:${vultr_database.this.port}/${vultr_database.this.database}"
}

output "username" {
  value       = vultr_database.this.username
  description = "数据库用户名"
}

output "password" {
  value       = vultr_database.this.password
  sensitive   = true
  description = "数据库密码"
}
