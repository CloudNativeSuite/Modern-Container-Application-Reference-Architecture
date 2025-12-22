variable "name" {
  description = "Security Group name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the Security Group"
  type        = string
}

variable "ssh_cidr" {
  description = "CIDR allowed to SSH"
  type        = string
}

variable "additional_ingress" {
  description = "Additional ingress rules"
  type = list(object({
    port     = number
    protocol = string
    cidr     = string
  }))
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}

