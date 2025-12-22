terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }
}

variable "project_id" {
  description = "Target project for IAM bootstrap"
  type        = string
}

variable "service_account_id" {
  description = "ID of the bootstrap service account"
  type        = string
  default     = "terraform-bootstrap"
}

variable "service_account_roles" {
  description = "List of roles to attach to the bootstrap service account"
  type        = list(string)
  default     = [
    "roles/resourcemanager.projectIamAdmin",
    "roles/storage.admin",
    "roles/compute.admin"
  ]
}

resource "google_project_service" "iam" {
  project = var.project_id
  service = "iam.googleapis.com"

  # Prevent accidental disablement of a core API when destroying the stack
  disable_on_destroy = false
}

resource "google_service_account" "bootstrap" {
  account_id   = var.service_account_id
  display_name = "Terraform Bootstrap"
  project      = var.project_id

  depends_on = [google_project_service.iam]
}

resource "google_project_iam_member" "bootstrap" {
  for_each = toset(var.service_account_roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.bootstrap.email}"
}

output "service_account_email" {
  value       = google_service_account.bootstrap.email
  description = "Bootstrap service account email"
}
