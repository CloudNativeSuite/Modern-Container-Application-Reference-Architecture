output "iam_role_arn" {
  description = "IAM role ARN created for Terraform deployment"
  value       = module.role.arn
}

output "iam_role_name" {
  description = "IAM role name"
  value       = module.role.name
}
