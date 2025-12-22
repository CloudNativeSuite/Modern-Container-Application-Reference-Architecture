variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "listeners" {
  description = "Listener definitions for ALB"
  type = list(object({
    port                  = number
    protocol              = string
    target_group_port     = number
    target_group_protocol = string
    certificate_arn       = optional(string)
  }))
}

variable "tags" {
  type = map(string)
  default = {}
}

