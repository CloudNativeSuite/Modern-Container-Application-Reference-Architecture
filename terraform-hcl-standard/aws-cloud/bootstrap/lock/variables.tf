variable "table_name" {
  description = "DynamoDB table name for Terraform state lock"
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
