variable "family" {
  description = "Image family to lookup"
  type        = string
  default     = "debian-12"
}

variable "project" {
  description = "Project hosting the image"
  type        = string
  default     = "debian-cloud"
}

data "google_compute_image" "family" {
  family  = var.family
  project = var.project
}

output "image" {
  value       = data.google_compute_image.family.self_link
  description = "Self link of the resolved image"
}
