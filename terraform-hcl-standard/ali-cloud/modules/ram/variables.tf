variable "role_name" {
  description = "RAM role name"
  type        = string
}

variable "policy_name" {
  description = "Policy name"
  type        = string
}

variable "assume_principals" {
  description = "List of account IDs allowed to assume the role"
  type        = list(string)
}

variable "actions" {
  description = "Actions allowed by the policy"
  type        = list(string)
}

variable "resource" {
  description = "Resource ARN(s)"
  type        = string
  default     = "*"
}

variable "description" {
  description = "Role description"
  type        = string
  default     = "Custom RAM role"
}
