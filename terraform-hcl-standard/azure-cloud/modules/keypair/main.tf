variable "algorithm" {
  description = "Algorithm for the SSH key"
  type        = string
  default     = "RSA"
}

variable "rsa_bits" {
  description = "RSA bits for the key when algorithm is RSA"
  type        = number
  default     = 4096
}

resource "tls_private_key" "ssh" {
  algorithm = var.algorithm
  rsa_bits  = var.algorithm == "RSA" ? var.rsa_bits : null
}

output "private_key_pem" {
  value       = tls_private_key.ssh.private_key_pem
  sensitive   = true
  description = "Generated private key"
}

output "public_key_openssh" {
  value       = tls_private_key.ssh.public_key_openssh
  description = "Generated public key"
}
