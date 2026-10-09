# ============================================================
# Backend remoto: Google Cloud Storage
# ============================================================
# State separado del ambiente dev (que tiene VMs) y del
# bootstrap (que tiene WIF+SAs). Un state por dominio funcional.
# ============================================================

terraform {
  required_version = ">= 1.9.0"

  backend "gcs" {
    bucket = "terraform-gcp-lab521"
    prefix = "environments/dev-gke"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}