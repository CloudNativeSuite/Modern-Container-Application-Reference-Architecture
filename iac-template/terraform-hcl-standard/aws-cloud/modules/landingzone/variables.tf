variable "region" {
  type = string
}

variable "account_id" {
  type = string
}

variable "console_mode" {
  type    = string
  default = "readonly"
}

variable "enable_risp_controls" {
  type    = bool
  default = true
}

variable "enable_root_limited" {
  type    = bool
  default = true
}

variable "enable_mfa_enforce" {
  type    = bool
  default = true
}

variable "enable_identity_center_block" {
  type    = bool
  default = true
}

variable "enable_service_guardrails" {
  type    = bool
  default = true
}

variable "service_allow_list" {
  type        = list(string)
  default     = []
  description = "Additional service action patterns to allow when service guardrails are enabled."
}

variable "service_deny_list" {
  type        = list(string)
  default     = []
  description = "Additional service action patterns to deny when service guardrails are enabled."
}
