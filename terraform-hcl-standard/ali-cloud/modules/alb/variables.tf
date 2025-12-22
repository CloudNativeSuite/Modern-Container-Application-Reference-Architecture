variable "name" {
  description = "ALB name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ALB"
  type        = string
}

variable "address_type" {
  description = "Address type: Internet or Intranet"
  type        = string
  default     = "Internet"
}

variable "edition" {
  description = "Load balancer edition"
  type        = string
  default     = "Standard"
}

variable "protocol" {
  description = "Listener protocol"
  type        = string
  default     = "HTTP"
}

variable "listener_port" {
  description = "Listener port"
  type        = number
  default     = 80
}

variable "zone_mappings" {
  description = "List of zone mappings with vswitch_id and zone_id"
  type = list(object({
    vswitch_id = string
    zone_id    = string
  }))
}
