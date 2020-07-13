provider "google" {
  project     = var.project_id
  credentials = var.google_credentials
  region      = var.project_region
  zone        = var.project_zone
}
