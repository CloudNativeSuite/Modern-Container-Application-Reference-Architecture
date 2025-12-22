output "cluster_arn" {
  value       = aws_msk_cluster.this.arn
  description = "MSK cluster ARN"
}

output "bootstrap_brokers" {
  value       = aws_msk_cluster.this.bootstrap_brokers
  description = "Bootstrap brokers connection string"
}

output "zookeeper_connect_string" {
  value       = aws_msk_cluster.this.zookeeper_connect_string
  description = "Zookeeper connection string"
}

