# =====================================================
# VPC CUSTOM (sin auto-subnets)
# =====================================================
resource "google_compute_network" "vpc" {
  name                            = var.vpc_name
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  delete_default_routes_on_create = false
  description                     = "VPC lab ambiente ${var.environment}"
}

# =====================================================
# SUBNET PUBLICA
# Puede alojar recursos con IP publica (bastion, LB, etc)
# =====================================================
resource "google_compute_subnetwork" "public" {
  name          = "${var.vpc_name}-public"
  ip_cidr_range = var.public_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id

  # Logging de flujo para auditoria
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# =====================================================
# SUBNET PRIVADA
# Sin IPs publicas. Egress solo via Cloud NAT.
# Private Google Access activado para APIs de Google.
# =====================================================
resource "google_compute_subnetwork" "private" {
  name                     = "${var.vpc_name}-private"
  ip_cidr_range            = var.private_subnet_cidr
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# =====================================================
# CLOUD ROUTER - prerequisito de Cloud NAT
# =====================================================
resource "google_compute_router" "router" {
  name    = "${var.vpc_name}-router"
  region  = var.region
  network = google_compute_network.vpc.id
}

# =====================================================
# CLOUD NAT - egress a internet para la subnet privada
# =====================================================
resource "google_compute_router_nat" "nat" {
  name                               = "${var.vpc_name}-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  # LOGS - critico para auditoria bancaria
  log_config {
    enable = true
    filter = "ALL"
  }
}

# =====================================================
# FIREWALL 1: SSH via IAP (ambas subnets)
# =====================================================
resource "google_compute_firewall" "allow_iap_ssh" {
  name          = "${var.vpc_name}-allow-iap-ssh"
  network       = google_compute_network.vpc.name
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["ssh-iap"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

# =====================================================
# FIREWALL 2: Trafico interno entre VMs de la VPC
# =====================================================
resource "google_compute_firewall" "allow_internal" {
  name          = "${var.vpc_name}-allow-internal"
  network       = google_compute_network.vpc.name
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["10.10.0.0/16"]

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }
}

# =====================================================
# FIREWALL 3: HTTP desde internet (solo VMs con tag "web")
# =====================================================
resource "google_compute_firewall" "allow_http" {
  name          = "${var.vpc_name}-allow-http"
  network       = google_compute_network.vpc.name
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

# =====================================================
# FIREWALL 4: Health checks de Google LB
# Rangos oficiales de Google Load Balancer
# =====================================================
resource "google_compute_firewall" "allow_health_checks" {
  name          = "${var.vpc_name}-allow-health-checks"
  network       = google_compute_network.vpc.name
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["web"]

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080"]
  }
}
