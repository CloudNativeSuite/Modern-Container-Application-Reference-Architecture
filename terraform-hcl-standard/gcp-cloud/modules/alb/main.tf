variable "project_id" {
  description = "Project id"
  type        = string
}

variable "name" {
  description = "Load balancer name"
  type        = string
  default     = "http-lb"
}

variable "bucket_name" {
  description = "Name for the backend bucket"
  type        = string
}

resource "google_storage_bucket" "static" {
  name                        = var.bucket_name
  location                    = "US"
  project                     = var.project_id
  uniform_bucket_level_access = true
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_compute_backend_bucket" "static" {
  name        = "${var.name}-backend"
  bucket_name = google_storage_bucket.static.name
  enable_cdn  = true
}

resource "google_compute_url_map" "static" {
  name            = "${var.name}-url-map"
  default_service = google_compute_backend_bucket.static.self_link
}

resource "google_compute_target_http_proxy" "static" {
  name    = "${var.name}-http-proxy"
  url_map = google_compute_url_map.static.self_link
}

resource "google_compute_global_forwarding_rule" "static" {
  name                  = "${var.name}-fwd"
  port_range            = "80"
  target                = google_compute_target_http_proxy.static.self_link
  load_balancing_scheme = "EXTERNAL"
}

output "bucket" {
  value       = google_storage_bucket.static.name
  description = "Static site bucket"
}

output "forwarding_rule" {
  value       = google_compute_global_forwarding_rule.static.name
  description = "HTTP forwarding rule"
}
