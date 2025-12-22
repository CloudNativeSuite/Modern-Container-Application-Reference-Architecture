variable "name" {
  description = "ECS instance name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ECS instance"
  type        = string
}

variable "vswitch_id" {
  description = "VSwitch ID to place the instance"
  type        = string
}

variable "image_id" {
  description = "Image ID"
  type        = string
  default     = "aliyun_2_1903_x64_20G_alibase_20240223.vhd"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "ecs.g6.large"
}

variable "system_disk_category" {
  description = "System disk category"
  type        = string
  default     = "cloud_essd"
}

variable "system_disk_size" {
  description = "System disk size in GB"
  type        = number
  default     = 40
}

variable "internet_max_bandwidth_out" {
  description = "Max outbound bandwidth"
  type        = number
  default     = 10
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = null
}

variable "ssh_cidr" {
  description = "CIDR allowed for SSH"
  type        = string
  default     = "0.0.0.0/0"
}

variable "user_data" {
  description = "Optional user data"
  type        = string
  default     = null
}
