terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }
}

variable "project_id" {
  description = "Project id where the state bucket will be created"
  type        = string
}

variable "bucket_name" {
  description = "Name of the GCS bucket"
  type        = string
}

variable "location" {
  description = "Bucket location"
  type        = string
  default     = "US"
}

resource "google_storage_bucket" "state" {
  name                        = var.bucket_name
  location                    = var.location
  project                     = var.project_id
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 365
    }
  }
}

output "bucket" {
  value       = google_storage_bucket.state.name
  description = "Created state bucket"
}
