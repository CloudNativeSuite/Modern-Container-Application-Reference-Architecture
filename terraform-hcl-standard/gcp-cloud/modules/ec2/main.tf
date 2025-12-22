variable "project_id" {
  description = "Project id"
  type        = string
}

variable "name" {
  description = "Instance name"
  type        = string
}

variable "zone" {
  description = "Instance zone"
  type        = string
  default     = "us-central1-a"
}

variable "machine_type" {
  description = "Machine type"
  type        = string
  default     = "e2-medium"
}

variable "network" {
  description = "Network self link"
  type        = string
}

variable "subnet" {
  description = "Subnetwork self link"
  type        = string
}

variable "image" {
  description = "Source image"
  type        = string
}

variable "ssh_keys" {
  description = "SSH key metadata entries"
  type        = list(string)
  default     = []
}

resource "google_compute_instance" "vm" {
  name         = var.name
  project      = var.project_id
  zone         = var.zone
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnet
    access_config {}
  }

  metadata = length(var.ssh_keys) > 0 ? {
    ssh-keys = join("\n", var.ssh_keys)
  } : {}
}

output "instance_self_link" {
  value       = google_compute_instance.vm.self_link
  description = "Instance self link"
}
