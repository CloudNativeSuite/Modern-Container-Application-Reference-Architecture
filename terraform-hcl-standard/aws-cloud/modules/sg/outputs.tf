output "sg_id" {
  description = "Security Group ID"
  value       = aws_security_group.this.id
}

output "sg_name" {
  description = "Security Group Name"
  value       = aws_security_group.this.name
}

output "sg_arn" {
  description = "ARN of the Security Group"
  value       = aws_security_group.this.arn
}
