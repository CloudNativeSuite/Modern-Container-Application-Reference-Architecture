variable "region" {
  description = "Vultr 区域代码"
  type        = string
}

variable "object_bucket" {
  description = "对象存储桶名称"
  type        = string
}

variable "cluster_id" {
  description = "对象存储集群 ID (如 ewr1)"
  type        = string
}

variable "enable_block" {
  description = "是否同时创建块存储卷"
  type        = bool
  default     = false
}

variable "block_size_gb" {
  description = "块存储大小 (GB)"
  type        = number
  default     = 100
}

variable "label" {
  description = "资源标签"
  type        = string
  default     = "app-storage"
}

resource "vultr_object_storage" "bucket" {
  region      = var.region
  cluster_id  = var.cluster_id
  label       = var.label
  bucket_name = var.object_bucket
  minio_access = true
}

resource "vultr_object_storage_key" "bucket" {
  object_storage_id = vultr_object_storage.bucket.id
  description       = "app-storage"
}

resource "vultr_block_storage" "volume" {
  count       = var.enable_block ? 1 : 0
  region      = var.region
  label       = "${var.label}-block"
  size_gb     = var.block_size_gb
  block_type  = "storage_opt"
}

output "bucket_name" {
  value       = vultr_object_storage.bucket.bucket_name
  description = "创建的对象存储桶"
}

output "bucket_endpoint" {
  value       = vultr_object_storage.bucket.s3_hostname
  description = "S3 兼容 Endpoint"
}

output "access_key" {
  value       = vultr_object_storage_key.bucket.access_key
  sensitive   = true
  description = "对象存储 Access Key"
}

output "secret_key" {
  value       = vultr_object_storage_key.bucket.secret_key
  sensitive   = true
  description = "对象存储 Secret Key"
}

output "block_volume_id" {
  value       = try(vultr_block_storage.volume[0].id, null)
  description = "可选块存储卷 ID"
}
