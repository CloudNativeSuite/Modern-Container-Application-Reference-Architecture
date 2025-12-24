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

  validation {
    condition     = var.bootstrap_config_path != null && trim(var.bootstrap_config_path) != ""
    error_message = "Set bootstrap_config_path to the GitHub Action environment input that points to the bootstrap YAML file."
  }
}

variable "config_root" {
  description = "Local path to the gitops repository root."
  type        = string
  default     = null
}

variable "create_bucket" {
  description = "Whether to create the Terraform state bucket. Set to false to use an existing bucket."
  type        = bool
  default     = true
}
