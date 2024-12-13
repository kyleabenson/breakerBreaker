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


resource "google_project_service" "resourcemanagerapi" {
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = true
  project = var.gcp_project_id
}

resource "google_project_service" "computeapi" {
  service            = "compute.googleapis.com"
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

resource "google_compute_network" "default" {
  name = "example-network"

  auto_create_subnetworks  = false
  enable_ula_internal_ipv6 = true
}

resource "google_compute_subnetwork" "default" {
  name = "example-subnetwork"

  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"

  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "INTERNAL" # Change to "EXTERNAL" if creating an external loadbalancer

  network = google_compute_network.default.id
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.0.0/24"
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "192.168.1.0/24"
  }
}

resource "google_container_cluster" "default" {
  name = "example-autopilot-cluster"

  location                 = "us-central1"
  enable_autopilot         = true
  enable_l4_ilb_subsetting = true

  network    = google_compute_network.default.id
  subnetwork = google_compute_subnetwork.default.id

  ip_allocation_policy {
    stack_type                    = "IPV4_IPV6"
    services_secondary_range_name = google_compute_subnetwork.default.secondary_ip_range[0].range_name
    cluster_secondary_range_name  = google_compute_subnetwork.default.secondary_ip_range[1].range_name
  }

  # Set `deletion_protection` to `true` will ensure that one cannot
  # accidentally delete this instance by use of Terraform.
  deletion_protection = false
}

output "investigation_url" {
     value = format("%s/%s","https://console.cloud.google.com/troubleshooting/investigations/list?project=",var.gcp_project_id)
}