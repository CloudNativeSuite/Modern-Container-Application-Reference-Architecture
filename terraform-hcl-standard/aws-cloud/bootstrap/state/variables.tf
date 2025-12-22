variable "bucket_name" {
  description = "S3 bucket name for Terraform state"
  type        = string
  default     = null
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = null
}

variable "bootstrap_config_path" {
  description = "Path to the bootstrap account configuration YAML"
  type        = string
  default     = "../../config/accounts/bootstrap.yaml"
}

variable "create_bucket" {
  description = "Whether to create the Terraform state bucket. Set to false to use an existing bucket."
  type        = bool
  default     = true
}
