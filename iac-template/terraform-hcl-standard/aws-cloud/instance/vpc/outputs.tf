output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID for this instance"
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "Public Subnet IDs"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "Private Subnet IDs"
}

output "nat_gateway_id" {
  value       = module.vpc.nat_gateway_id
  description = "NAT Gateway ID"
}
