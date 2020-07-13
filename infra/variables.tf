variable "project_id" {
  type        = string
  description = "ID of the project"
}
variable "google_credentials" {
  type        = string
  description = "Credential JSON file content for google"
}
variable "project_region" {
  type        = string
  description = "The region to use for GCP"
}
variable "project_zone" {
  type        = string
  description = "The zone to use for GCP"
}