variable "project_id" {
  description = "Project id"
  type        = string
}

variable "name" {
  description = "Instance name"
  type        = string
  default     = "default-sql"
}

variable "database_version" {
  description = "Cloud SQL engine"
  type        = string
  default     = "POSTGRES_15"
}

variable "tier" {
  description = "Machine tier"
  type        = string
  default     = "db-f1-micro"
}

variable "region" {
  description = "Instance region"
  type        = string
  default     = "us-central1"
}

resource "google_sql_database_instance" "this" {
  name             = var.name
  project          = var.project_id
  region           = var.region
  database_version = var.database_version

  settings {
    tier = var.tier
  }
}

output "connection_name" {
  value       = google_sql_database_instance.this.connection_name
  description = "Instance connection string"
}
