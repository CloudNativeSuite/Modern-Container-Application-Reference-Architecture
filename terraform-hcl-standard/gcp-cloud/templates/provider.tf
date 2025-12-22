variable "project" {
  description = "GCP project to deploy into"
  type        = string
}

variable "region" {
  description = "Default region"
  type        = string
  default     = "asia-east1"
}

provider "google" {
  project = var.project
  region  = var.region
}
