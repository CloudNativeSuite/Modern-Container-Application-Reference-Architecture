variable "bucket_name" {
  description = "S3 bucket name (must be globally unique)"
  type        = string
}

variable "enable_versioning" {
  description = "Whether to enable S3 versioning"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}

