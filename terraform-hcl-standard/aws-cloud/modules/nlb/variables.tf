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
  description = "List of listener configurations"
  type = list(object({
    port                 = number
    protocol             = string
    target_group_port    = number
    target_group_protocol = string
  }))
}

variable "tags" {
  type = map(string)
  default = {}
}
