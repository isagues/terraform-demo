terraform {
 required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.24.0"
    }
 }

 required_version = "~> 1.2.0"
}

provider "google" {
  project = local.gcp_project
  region  = local.gcp_region
  zone    = local.gcp_default_zone
}
