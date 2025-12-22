output "keypair_name" {
  description = "The name of the AWS KeyPair"
  value       = aws_key_pair.this.key_name
}

output "fingerprint" {
  description = "KeyPair fingerprint"
  value       = aws_key_pair.this.fingerprint
}

