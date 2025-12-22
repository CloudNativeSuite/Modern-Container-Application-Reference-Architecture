resource "aws_msk_cluster" "this" {
  cluster_name           = var.name_prefix
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes

  broker_node_group_info {
    instance_type  = var.instance_type
    client_subnets = var.subnet_ids
    security_groups = []

    storage_info {
      ebs_storage_info {
        volume_size = var.volume_size
      }
    }
  }

  tags = merge(var.tags, {
    Name = var.name_prefix
  })
}
