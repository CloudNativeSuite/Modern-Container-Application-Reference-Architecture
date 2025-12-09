terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }
}

variable "project_id" { type = string }

provider "google" {
  project = var.project_id
  region  = "us-central1"
}

module "alb" {
  source      = "../../modules/alb"
  project_id  = var.project_id
  bucket_name = "dev-alb-static-${var.project_id}"
  name        = "dev-alb"
}

output "forwarding_rule" {
  value = module.alb.forwarding_rule
}
