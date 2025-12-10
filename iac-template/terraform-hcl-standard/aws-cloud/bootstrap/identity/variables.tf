variable "region" {
  description = "AWS region"
  type        = string
  default     = null
}

variable "account_name" {
  type        = string
  description = "Which account configuration to load (e.g., dev)"
  default     = null
}

variable "create_role" {
  description = "Whether to create the Terraform deploy IAM role"
  type        = bool
  default     = true

  validation {
    condition     = var.create_role || (var.existing_role_arn != null && var.existing_role_name != null)
    error_message = "existing_role_name and existing_role_arn must be provided when create_role is false."
  }
}

variable "existing_role_name" {
  description = "Existing IAM role name to reference when create_role is false"
  type        = string
  default     = null
}

variable "existing_role_arn" {
  description = "Existing IAM role ARN to reference when create_role is false"
  type        = string
  default     = null
}

variable "role_name" {
  type        = string
  description = "IAM role name to create (e.g., TerraformDeployRole-Dev)"
  default     = null
}

variable "existing_user_name" {
  description = "Existing IAM username to reference when create_user is false"
  type        = string
  default     = null
}

variable "terraform_user_name" {
  type        = string
  description = "IAM username for Terraform IAC runner"
  default     = null
}

variable "create_user" {
  description = "Whether to create the IAM user for Terraform"
  type        = bool
  default     = true

  validation {
    condition     = var.create_user || var.existing_user_name != null
    error_message = "existing_user_name must be provided when create_user is false."
  }
}
