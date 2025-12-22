variable "project_id" {
  description = "Project id"
  type        = string
}

variable "name" {
  description = "Bucket name"
  type        = string
}

variable "location" {
  description = "Bucket location"
  type        = string
  default     = "US"
}

resource "google_storage_bucket" "this" {
  name                        = var.name
  project                     = var.project_id
  location                    = var.location
  uniform_bucket_level_access = true
  versioning { enabled = true }
}

output "bucket" {
  value       = google_storage_bucket.this.name
  description = "Storage bucket"
}
