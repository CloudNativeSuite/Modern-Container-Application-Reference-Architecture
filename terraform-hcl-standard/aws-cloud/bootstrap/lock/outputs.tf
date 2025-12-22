output "dynamodb_table_name" {
  description = "The name of the DynamoDB state lock table"
  value       = aws_dynamodb_table.terraform_locks.name
}

output "region" {
  description = "AWS region hosting the DynamoDB lock table"
  value       = local.region
}
