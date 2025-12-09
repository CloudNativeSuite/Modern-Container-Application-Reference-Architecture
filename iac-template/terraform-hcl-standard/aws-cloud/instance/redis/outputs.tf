output "redis_endpoint" {
  description = "Primary Redis endpoint"
  value       = module.redis.endpoint
}

output "redis_port" {
  description = "Redis port"
  value       = module.redis.port
}

output "redis_cluster_id" {
  description = "Redis cluster ID"
  value       = module.redis.cluster_id
}

