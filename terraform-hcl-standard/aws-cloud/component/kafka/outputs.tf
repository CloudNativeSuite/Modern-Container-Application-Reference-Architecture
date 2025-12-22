output "cluster_arn" {
  value = module.kafka.cluster_arn
}

output "bootstrap_brokers" {
  value = module.kafka.bootstrap_brokers
}

output "zookeeper_connect_string" {
  value = module.kafka.zookeeper_connect_string
}
