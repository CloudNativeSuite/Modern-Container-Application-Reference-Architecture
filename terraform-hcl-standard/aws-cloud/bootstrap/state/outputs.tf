output "bucket_name" {
  value = local.bucket_name
}

output "bucket_arn" {
  value       = local.bucket_arn
  description = "ARN of the Terraform state bucket"
}

output "region" {
  value       = local.region
  description = "AWS region hosting the state bucket"
}
