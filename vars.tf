variable "gcp_project_id" {
  type = string
  description = "Project ID where issues occur and where you'll create an investigation"
}
variable "user_id" {
    type = string
    description = "Name of the principle who will access investigations. Should be in a format like: username@domain.com:user"
}