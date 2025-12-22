variable "project_id" {
  description = "Project id"
  type        = string
}

variable "name" {
  description = "Redis instance name"
  type        = string
  default     = "default-redis"
}

variable "region" {
  description = "Region for the instance"
  type        = string
  default     = "us-central1"
}

variable "tier" {
  description = "Service tier"
  type        = string
  default     = "STANDARD_HA"
}

variable "memory_size_gb" {
  description = "Memory size"
  type        = number
  default     = 1
}

resource "google_redis_instance" "this" {
  name           = var.name
  project        = var.project_id
  region         = var.region
  tier           = var.tier
  memory_size_gb = var.memory_size_gb
}

output "host" {
  value       = google_redis_instance.this.host
  description = "Redis host"
}
