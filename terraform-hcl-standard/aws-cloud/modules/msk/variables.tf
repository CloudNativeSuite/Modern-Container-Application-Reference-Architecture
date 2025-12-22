variable "name_prefix" {
  description = "Prefix for the MSK cluster name"
  type        = string
}

variable "kafka_version" {
  type        = string
  description = "Kafka version (e.g. 3.6.0)"
}

variable "instance_type" {
  type        = string
  description = "MSK broker instance type"
}

variable "number_of_broker_nodes" {
  type = number
}

variable "volume_size" {
  type = number
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}
