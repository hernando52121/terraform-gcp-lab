# ============================================================
# Modulo: GKE Autopilot Cluster
# ============================================================
# Crea un cluster GKE en modo Autopilot:
# - Google gestiona nodos (no VMs expuestas al usuario)
# - Billing por pod/hora, no por nodo
# - Workload Identity habilitado por default
# - Hardening de seguridad por default
# - VPC-native (IP alias ranges para pods/services)
# ============================================================

# Labels mergeados: defaults + lo que pase el consumidor
locals {
  default_labels = {
    managed_by  = "terraform"
    environment = var.environment
    phase       = "3-gke-argocd"
    cluster     = var.cluster_name
  }

  merged_labels = merge(local.default_labels, var.labels)
}

resource "google_container_cluster" "autopilot" {
  name     = var.cluster_name
  location = var.region # Autopilot es siempre regional (3 zonas, HA built-in)
  project  = var.project_id

  # ========================================================
  # Modo Autopilot
  # ========================================================
  # enable_autopilot = true activa el modo serverless K8s.
  # No se puede combinar con node_pools custom ni con muchas
  # otras configs de GKE Standard.
  # ========================================================
  enable_autopilot = true

  # ========================================================
  # Networking: VPC-native (IP aliases)
  # ========================================================
  # Autopilot requiere VPC-native. Google auto-asigna rangos
  # IP para pods y services dentro de la subnet. No necesitamos
  # ip_allocation_policy explicito en Autopilot (se infiere).
  # ========================================================
  network    = var.network
  subnetwork = var.subnetwork

  ip_allocation_policy {
    # Rangos secundarios se crean automaticamente si no existen
    # (bloque vacio = defaults de GKE Autopilot)
  }

  # ========================================================
  # Release channel: controla actualizaciones automaticas
  # ========================================================
  # REGULAR es el default recomendado para prod. Google actualiza
  # el cluster automaticamente en ventanas de mantenimiento.
  # ========================================================
  release_channel {
    channel = var.release_channel
  }

  # ========================================================
  # Deletion protection
  # ========================================================
  # Por default GKE habilita deletion_protection = true, lo cual
  # impide "terraform destroy". Para un lab lo desactivamos.
  # En prod se deja true como control compensatorio.
  # ========================================================
  deletion_protection = false

  # ========================================================
  # Master authorized networks (control plane access)
  # ========================================================
  # Limita quien puede hablar con el API server. Si la lista
  # esta vacia, el API server es publico. Para lab es OK; para
  # prod se restringe a CIDRs corporativos.
  # ========================================================
  dynamic "master_authorized_networks_config" {
    for_each = length(var.master_authorized_networks) > 0 ? [1] : []
    content {
      dynamic "cidr_blocks" {
        for_each = var.master_authorized_networks
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = cidr_blocks.value.display_name
        }
      }
    }
  }

  # ========================================================
  # Workload Identity
  # ========================================================
  # Habilita que ServiceAccounts de K8s se mapeen a SAs de GCP
  # sin usar JSON keys. Es el equivalente a WIF que ya usamos
  # en Fase 2 (GitHub -> GCP), pero intra-cluster.
  # ========================================================
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Labels aplicados al cluster (para billing/organizacion)
  resource_labels = local.merged_labels

  # ========================================================
  # Timeouts
  # ========================================================
  # Autopilot tarda ~5-7 min en crear por primera vez
  # ========================================================
  timeouts {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
}