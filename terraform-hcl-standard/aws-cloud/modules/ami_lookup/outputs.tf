output "id" {
  description = "Resolved AMI ID"
  value       = data.aws_ami.selected.id
}

output "name" {
  description = "Resolved AMI name"
  value       = data.aws_ami.selected.name
}
