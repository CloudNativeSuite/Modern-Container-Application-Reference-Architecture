variable "region" {
  description = "Vultr 区域代码"
  type        = string
}

variable "description" {
  description = "VPC 描述标签"
  type        = string
  default     = "app-vpc"
}

variable "v4_subnet" {
  description = "VPC 的 IPv4 子网，例如 10.10.0.0/22"
  type        = string
}

variable "v4_subnet_size" {
  description = "子网掩码位数，Vultr 需要单独传递"
  type        = number
}

resource "vultr_vpc" "this" {
  region       = var.region
  description  = var.description
  v4_subnet    = var.v4_subnet
  v4_subnet_size = var.v4_subnet_size
}

output "vpc_id" {
  value       = vultr_vpc.this.id
  description = "创建的 VPC ID"
}
