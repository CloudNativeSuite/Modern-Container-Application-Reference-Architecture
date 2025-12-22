terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
  }
}

variable "algorithm" {
  type        = string
  description = "Algorithm for the SSH key"
  default     = "RSA"
}

variable "rsa_bits" {
  type        = number
  description = "RSA key length when algorithm is RSA"
  default     = 4096
}

resource "tls_private_key" "ssh" {
  algorithm = var.algorithm
  rsa_bits  = var.rsa_bits
}

output "public_key_openssh" {
  value       = tls_private_key.ssh.public_key_openssh
  description = "Generated public key"
}

output "private_key_pem" {
  value       = tls_private_key.ssh.private_key_pem
  sensitive   = true
  description = "Generated private key"
}
