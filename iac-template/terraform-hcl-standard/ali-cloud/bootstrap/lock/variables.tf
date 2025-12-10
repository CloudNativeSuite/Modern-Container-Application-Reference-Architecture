variable "region" {
  description = "Alibaba Cloud region for OTS"
  type        = string
  default     = "cn-hangzhou"
}

variable "access_key" {
  description = "Alibaba Cloud Access Key ID"
  type        = string
  default     = null

  validation {
    condition     = (var.access_key == null && var.secret_key == null) || (var.access_key != null && var.secret_key != null)
    error_message = "Provide both access_key and secret_key, or leave both null to rely on environment-sourced credentials."
  }
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

variable "instance_name" {
  description = "Name of the OTS instance"
  type        = string
  default     = "terraform-locks"
}

variable "table_name" {
  description = "Name of the lock table"
  type        = string
  default     = "terraform-locks"
}
