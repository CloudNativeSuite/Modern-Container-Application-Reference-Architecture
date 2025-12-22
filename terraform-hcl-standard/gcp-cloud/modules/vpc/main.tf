variable "project_id" {
  description = "Project id"
  type        = string
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "main-vpc"
}

variable "subnets" {
  description = "List of subnet definitions"
  type = list(object({
    name          = string
    ip_cidr_range = string
    region        = string
  }))
  default = [
    {
      name          = "default-subnet"
      ip_cidr_range = "10.10.0.0/24"
      region        = "us-central1"
    }
  ]
}

resource "google_compute_network" "this" {
  name                    = var.network_name
  project                 = var.project_id
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "this" {
  for_each                 = { for subnet in var.subnets : subnet.name => subnet }
  name                     = each.value.name
  ip_cidr_range            = each.value.ip_cidr_range
  region                   = each.value.region
  network                  = google_compute_network.this.id
  private_ip_google_access = true
}

output "network_self_link" {
  value       = google_compute_network.this.self_link
  description = "VPC network self link"
}

output "subnet_self_links" {
  value       = [for subnet in google_compute_subnetwork.this : subnet.self_link]
  description = "Subnetwork self links"
}
