provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# ----------------------------------------------------------
# Fase 0 - Recurso de validacion end-to-end
# Objetivo: confirmar que Terraform crea/destruye recursos en GCP
# usando backend remoto en GCS. La VM e2-micro cae en Always Free.
# ----------------------------------------------------------

resource "google_compute_network" "lab_vpc" {
  name                    = "vpc-lab-bootstrap"
  auto_create_subnetworks = false
  description             = "VPC minima para validar Terraform en Fase 0"
}

resource "google_compute_subnetwork" "lab_subnet" {
  name          = "subnet-lab-bootstrap"
  ip_cidr_range = "10.10.0.0/24"
  region        = var.region
  network       = google_compute_network.lab_vpc.id
}

resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "fw-allow-iap-ssh"
  network = google_compute_network.lab_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Rango oficial de Google IAP - permite SSH sin IP publica
  source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_instance" "bootstrap_vm" {
  name         = "vm-lab-bootstrap"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = google_compute_network.lab_vpc.id
    subnetwork = google_compute_subnetwork.lab_subnet.id
    # Sin access_config = sin IP publica (acceso solo por IAP)
  }

  labels = {
    environment = var.environment
    owner       = var.owner
    managed_by  = "terraform"
    phase       = "0-bootstrap"
  }

  tags = ["lab", "bootstrap"]
}
