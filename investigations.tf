resource "google_project_service" "resourcemanagerapi" {
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = true
  project = var.gcp_project_id
}

resource "google_project_service" "geminiapi" {
  service            = "geminicloudassist.googleapis.com"
  disable_on_destroy = true
  project = var.gcp_project_id
}

resource "google_project_service" "aicompnaionapi" {
  service            = "cloudaicompanion.googleapis.com"
  disable_on_destroy = true
  project = var.gcp_project_id
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
