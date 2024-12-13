variable "gcp_project_id" {
  type = string
  description = "Project ID where issues occur and where you'll create an investigation"
}
variable "user_id" {
    type = string
    description = "Name of the principle who will access investigations. Should be in a format like: username@domain.com:user"
}

resource "google_project_service" "apis" {
  service            = "cloudaicompanion.googleapis.com"
  disable_on_destroy = true
  project = "gcp-project-id"
}

resource "google_project_service" "apis" {
  service            = "geminicloudassist.googleapis.com"
  disable_on_destroy = true
  project = "gcp-project-id"
}

resource "google_project_iam_member" "gemini_cloud_assist_investigation_admin" {
  project = var.gcp_project_id # Assuming project ID is stored in a variable
  role    = "roles/geminicloudassist.investigationAdmin"
  member  = var.user_id# Assuming member is stored in a variable
}

resource "google_project_iam_member" "gemini_for_google_cloud_user" {
  project = var.gcp_project_id
  role    = "roles/cloudaicompanion.user"
  member  = var.user_id
}
