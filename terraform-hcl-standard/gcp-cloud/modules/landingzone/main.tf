variable "project_id" {
  description = "Project id"
  type        = string
}

variable "services" {
  description = "APIs to enable"
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "logging.googleapis.com"
  ]
}

resource "google_project_service" "enabled" {
  for_each = toset(var.services)
  project  = var.project_id
  service  = each.key
}

output "enabled_services" {
  value       = [for s in google_project_service.enabled : s.service]
  description = "List of enabled services"
}
