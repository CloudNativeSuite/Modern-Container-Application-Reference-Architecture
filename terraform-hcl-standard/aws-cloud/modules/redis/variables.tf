variable "name_prefix" {
  description = "Redis cluster name prefix"
  type        = string
}

variable "engine_version" {
  description = "Redis engine version"
  type        = string
  default     = "7.0"
}

variable "node_type" {
  description = "Cache node type"
  type        = string
}

variable "num_cache_nodes" {
  description = "Number of cache nodes"
  type        = number
}

variable "subnet_ids" {
  description = "Subnet IDs for the Redis subnet group"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security Groups for redis"
  type        = list(string)
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
}
