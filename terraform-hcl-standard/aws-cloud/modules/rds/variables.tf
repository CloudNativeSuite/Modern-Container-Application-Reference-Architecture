variable "name_prefix" { type = string }

variable "engine" { type = string }
variable "engine_version" { type = string }
variable "instance_class" { type = string }

variable "username" { type = string }
variable "password" { type = string }

variable "allocated_storage" { type = number }
variable "max_allocated_storage" { type = number }

variable "multi_az" { type = bool }
variable "publicly_accessible" { type = bool }

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "parameters" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "tags" {
  type = map(string)
}
