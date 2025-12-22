variable "name" {
  description = "SLB/NLB name"
  type        = string
}

variable "vswitch_id" {
  description = "VSwitch ID for the load balancer"
  type        = string
}

variable "address_type" {
  description = "Address type"
  type        = string
  default     = "Internet"
}

variable "spec" {
  description = "Load balancer specification"
  type        = string
  default     = "slb.s2.small"
}

variable "protocol" {
  description = "Listener protocol"
  type        = string
  default     = "tcp"
}

variable "frontend_port" {
  description = "Frontend listener port"
  type        = number
  default     = 80
}

variable "backend_port" {
  description = "Backend server port"
  type        = number
  default     = 80
}
