variable "gcp_project_id" {
  type = string
  description = "Project ID where issues occur and where you'll create an investigation"
}
variable "user_id" {
    type = string
    description = "Name of the principle who will access investigations. Should be in a format like: username@domain.com:user"
}

resource "google_project_service" "aicompnaionapi" {
  service            = "cloudaicompanion.googleapis.com"
  disable_on_destroy = true
  project = var.gcp_project_id
}

resource "google_project_service" "geminiapi" {
  service            = "geminicloudassist.googleapis.com"
  disable_on_destroy = true
  project = var.gcp_project_id
}

resource "google_project_service" "k8sapi" {
  service            = "container.googleapis.com"
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

resource "google_container_cluster" "primary" {
  name               = "my-gke-cluster"
  location           = "us-central1-a" # Replace with your desired location
  initial_node_count = 1

  node_config {
    machine_type = "e2-medium" # Or another machine type
    disk_size    = 30          # In GB
  }


output "investigation_url" {
     value = format("%s/%s","https://console.cloud.google.com/troubleshooting/investigations/list?project=",var.gcp_project_id)
}