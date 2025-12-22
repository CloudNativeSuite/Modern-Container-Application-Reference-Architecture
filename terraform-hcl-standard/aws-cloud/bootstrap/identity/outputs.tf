output "iam_role_arn" {
  value       = var.create_role ? aws_iam_role.terraform_deploy_role[0].arn : var.existing_role_arn
  description = "The ARN of the role assumed by Terraform"
}

output "terraform_user_name" {
  value       = var.create_user ? aws_iam_user.terraform_user[0].name : local.terraform_user_name
  description = "Terraform IAM User"
}

output "github_actions_oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.github_actions.arn
  description = "OIDC provider ARN for GitHub Actions"
}

output "github_actions_deploy_role_arn" {
  value       = aws_iam_role.github_actions_deploy_role.arn
  description = "IAM role ARN assumed by GitHub Actions via OIDC"
}
