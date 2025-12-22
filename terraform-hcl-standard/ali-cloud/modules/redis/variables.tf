variable "name" {
  description = "Redis instance name"
  type        = string
}

variable "instance_class" {
  description = "Instance class"
  type        = string
  default     = "redis.master.small.default"
}

variable "engine_version" {
  description = "Redis engine version"
  type        = string
  default     = "6.0"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vswitch_id" {
  description = "VSwitch ID"
  type        = string
}

variable "password" {
  description = "Instance password"
  type        = string
  sensitive   = true
}
