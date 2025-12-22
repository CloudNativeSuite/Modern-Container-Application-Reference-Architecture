variable "region" {
  description = "Deployment region"
  type        = string
  default     = "cn-hangzhou"
}

variable "access_key" {
  description = "Alibaba Cloud Access Key ID"
  type        = string
  default     = null
}

variable "secret_key" {
  description = "Alibaba Cloud Access Key Secret"
  type        = string
  default     = null
  sensitive   = true
}

variable "security_token" {
  description = "Optional security token when using STS credentials"
  type        = string
  default     = null
  sensitive   = true
}

variable "ram_role_arn" {
  description = "Optional RAM role ARN to assume for operations"
  type        = string
  default     = null
}

variable "session_name" {
  description = "Session name when assuming a RAM role"
  type        = string
  default     = "terraform"
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "dev-vpc"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.10.0.0/16"
}

variable "vswitches" {
  description = "Map of vswitch definitions"
  type = map(object({
    cidr = string
    az   = string
  }))
  default = {
    a = { cidr = "10.10.1.0/24", az = "cn-hangzhou-b" }
    b = { cidr = "10.10.2.0/24", az = "cn-hangzhou-c" }
  }
}

variable "instance_type" {
  description = "ECS instance type"
  type        = string
  default     = "ecs.g6.large"
}

variable "image_id" {
  description = "ECS image ID"
  type        = string
  default     = "aliyun_2_1903_x64_20G_alibase_20240223.vhd"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = null
}

variable "bucket_name" {
  description = "OSS bucket name"
  type        = string
  default     = "dev-terraform-oss"
}

variable "rds_instance_type" {
  description = "RDS instance type"
  type        = string
  default     = "rds.mysql.c1.large"
}

variable "rds_password" {
  description = "RDS account password"
  type        = string
  sensitive   = true
}

variable "redis_password" {
  description = "Redis password"
  type        = string
  sensitive   = true
}
