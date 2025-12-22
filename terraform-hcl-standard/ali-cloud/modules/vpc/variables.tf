variable "name" {
  description = "Name of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vswitches" {
  description = "Map of vswitches with cidr and az, e.g. { a = { cidr = \"10.0.1.0/24\", az = \"cn-hangzhou-b\" } }"
  type = map(object({
    cidr = string
    az   = string
  }))
}
