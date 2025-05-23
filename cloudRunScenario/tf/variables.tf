
# This file is autogenerated. Do not edit this file directly.
# Please make changes to the application template instead.

variable "frontend-service-cloud-run_service_name" {
  description = "The name of the Cloud Run service to create"
  type = string
}
variable "backend-service-cloud-run_project_id" {
  description = "The project ID to deploy to"
  type = string
}
variable "backend-service-cloud-run_service_name" {
  description = "The name of the Cloud Run service to create"
  type = string
}
variable "database-postgresql_project_id" {
  description = "The project ID to manage the Cloud SQL resources"
  type = string
}
variable "database-postgresql_name" {
  description = "The name of the Cloud SQL instance"
  type = string
}
variable "memorystore_project_id" {
  description = "The ID of the project in which the resource belongs to."
  type = string
}
variable "memorystore_name" {
  description = "The ID of the instance or a fully qualified identifier for the instance."
  type = string
}
variable "apphub_project_id" {
  description = "The project ID of the host project where AppHub application is created."
  type = string
}
variable "apphub_location" {
  description = "The location of AppHub application."
  type = string
}
variable "apphub_application_id" {
  description = "The AppHub application identifier"
  type = string
}

variable "gcp_project_id" {
  type = string
  description = "Project ID where issues occur and where you'll create an investigation"
}
