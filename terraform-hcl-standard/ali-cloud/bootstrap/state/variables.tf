variable "region" {
  description = "Alibaba Cloud region for OSS"
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

variable "state_bucket" {
  description = "Name of the OSS bucket used for remote state"
  type        = string
}

variable "acl" {
  description = "ACL for the OSS bucket"
  type        = string
  default     = "private"
}
