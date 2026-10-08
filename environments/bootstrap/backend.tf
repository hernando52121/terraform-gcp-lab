terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.40"
    }
  }

  backend "gcs" {
    bucket = "terraform-gcp-lab521"
    prefix = "environments/bootstrap"
  }
}