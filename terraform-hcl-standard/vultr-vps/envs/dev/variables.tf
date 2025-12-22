variable "vultr_api_key" {
  description = "Vultr API Key"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "部署区域"
  type        = string
  default     = "ewr"
}

variable "vpc_description" {
  description = "VPC 描述"
  type        = string
  default     = "dev-vpc"
}

variable "v4_subnet" {
  description = "VPC IPv4 段"
  type        = string
  default     = "10.20.0.0"
}

variable "v4_subnet_size" {
  description = "掩码位数"
  type        = number
  default     = 22
}

variable "cluster_id" {
  description = "对象存储集群 ID"
  type        = string
  default     = "ewr1"
}

variable "object_bucket" {
  description = "对象存储桶名称"
  type        = string
  default     = "dev-app-bucket"
}

variable "enable_block" {
  description = "是否创建块存储"
  type        = bool
  default     = true
}

variable "block_size_gb" {
  description = "块存储大小"
  type        = number
  default     = 100
}

variable "name_prefix" {
  description = "资源名前缀"
  type        = string
  default     = "demo"
}

variable "plan" {
  description = "实例套餐"
  type        = string
  default     = "vc2-1c-1gb"
}

variable "os_id" {
  description = "操作系统 ID"
  type        = number
  default     = 215
}

variable "users" {
  description = "子账号配置"
  type = list(object({
    email    = string
    password = string
    acls     = list(string)
  }))
  default = [
    {
      email    = "devops@example.com"
      password = "ChangeMe123!"
      acls     = ["subscriptions", "support"]
    }
  ]
}

variable "ssh_keys" {
  description = "SSH 公钥列表"
  type = list(object({
    name   = string
    public = string
  }))
  default = [
    {
      name   = "dev-key"
      public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKexamplegenerated dev@example"
    }
  ]
}

variable "user_data_file" {
  description = "cloud-init 脚本路径"
  type        = string
  default     = "cloud-init.yaml"
}

variable "db_engine" {
  description = "数据库引擎"
  type        = string
  default     = "pg"
}

variable "db_plan" {
  description = "数据库套餐"
  type        = string
  default     = "vultr-dbaas-startup-cc-1-7-5"
}

variable "dbname" {
  description = "数据库名称"
  type        = string
  default     = "app"
}

variable "db_username" {
  description = "数据库用户名"
  type        = string
  default     = "app"
}

variable "db_password" {
  description = "数据库密码"
  type        = string
  sensitive   = true
  default     = "ChangeMeP@ssw0rd"
}

variable "db_ha" {
  description = "启用数据库高可用"
  type        = bool
  default     = false
}
