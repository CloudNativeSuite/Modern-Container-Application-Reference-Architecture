variable "project_id" {
  type        = string
  description = "Project id"
}

variable "bindings" {
  type = list(object({
    role   = string
    member = string
  }))
  description = "List of role/member bindings"
  default     = []
}

resource "google_project_iam_member" "bindings" {
  for_each = { for idx, binding in var.bindings : idx => binding }
  project  = var.project_id
  role     = each.value.role
  member   = each.value.member
}

output "applied_bindings" {
  value       = [for binding in google_project_iam_member.bindings : binding.role]
  description = "Roles applied to members"
}
