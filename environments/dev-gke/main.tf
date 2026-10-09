# ============================================================
# Ambiente: dev-gke - Cluster GKE Autopilot para GitOps
# ============================================================

resource "google_compute_network" "vpc_gke" {
  name                    = "vpc-gke-dev"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  project                 = var.project_id
  description             = "VPC dedicada para cluster GKE Autopilot - Fase 3"
}

resource "google_compute_subnetwork" "gke_nodes" {
  name          = "subnet-gke-nodes"
  ip_cidr_range = "10.20.0.0/20"
  region        = var.region
  network       = google_compute_network.vpc_gke.id
  project       = var.project_id
  description   = "Subnet para nodos del cluster GKE Autopilot"

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.21.0.0/16"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.22.0.0/20"
  }

  private_ip_google_access = true
}

resource "google_compute_router" "gke_router" {
  name    = "router-gke-dev"
  region  = var.region
  network = google_compute_network.vpc_gke.id
  project = var.project_id
}

resource "google_compute_router_nat" "gke_nat" {
  name                               = "nat-gke-dev"
  router                             = google_compute_router.gke_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  project                            = var.project_id

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

module "gke" {
  source = "../../modules/gke"

  project_id   = var.project_id
  region       = var.region
  cluster_name = "gke-lab-dev"
  environment  = var.environment

  network    = google_compute_network.vpc_gke.name
  subnetwork = google_compute_subnetwork.gke_nodes.name

  release_channel = "REGULAR"

  master_authorized_networks = []

  labels = {
    owner = var.owner
  }
}