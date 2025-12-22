variable "project_id" {
  description = "Project id"
  type        = string
}

variable "topic" {
  description = "Pub/Sub topic name"
  type        = string
  default     = "default-topic"
}

variable "subscription" {
  description = "Subscription name"
  type        = string
  default     = "default-subscription"
}

resource "google_pubsub_topic" "this" {
  name    = var.topic
  project = var.project_id
}

resource "google_pubsub_subscription" "this" {
  name  = var.subscription
  topic = google_pubsub_topic.this.name
}

output "topic" {
  value       = google_pubsub_topic.this.name
  description = "Pub/Sub topic name"
}

output "subscription" {
  value       = google_pubsub_subscription.this.name
  description = "Pub/Sub subscription name"
}
