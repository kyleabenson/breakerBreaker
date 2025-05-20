
resource "google_project_service" "computeapi" {
  service            = "compute.googleapis.com"
  disable_on_destroy = true
  project = var.gcp_project_id
}


resource "google_project_service" "k8sapi" {
  service            = "container.googleapis.com"
  disable_on_destroy = true
  project = var.gcp_project_id
}

