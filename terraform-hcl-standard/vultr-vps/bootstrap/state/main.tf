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

resource "vultr_object_storage" "state" {
  region        = var.region
  cluster_id    = var.cluster_id
  label         = var.name
  smtp_enabled  = false
  minio_access  = true
  minio_secret  = var.seed_secret
  bucket_name   = var.bucket
}

resource "vultr_object_storage_key" "state" {
  object_storage_id = vultr_object_storage.state.id
  description       = "terraform-state"
}

output "bucket" {
  description = "对象存储桶名称"
  value       = vultr_object_storage.state.bucket_name
}

output "endpoint" {
  description = "S3 兼容 Endpoint"
  value       = vultr_object_storage.state.s3_hostname
}

output "access_key" {
  description = "访问密钥 Access Key"
  value       = vultr_object_storage_key.state.access_key
  sensitive   = true
}

output "secret_key" {
  description = "访问密钥 Secret Key"
  value       = vultr_object_storage_key.state.secret_key
  sensitive   = true
}

variable "vultr_api_key" {
  description = "Vultr API Key"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Vultr 区域代码"
  type        = string
}

variable "cluster_id" {
  description = "对象存储集群 ID（例如 ewr1）"
  type        = string
}

variable "bucket" {
  description = "对象存储桶名称"
  type        = string
}

variable "name" {
  description = "资源标签"
  type        = string
  default     = "terraform-state"
}

variable "seed_secret" {
  description = "可选的初始密钥种子，确保生成的 secret 可追踪"
  type        = string
  default     = ""
  sensitive   = true
}
