# ============================================================
# Modulo: GKE Autopilot Cluster
# ============================================================
# Variables de entrada del modulo. Define el contrato publico
# del modulo: lo que el consumidor debe o puede pasar.
# ============================================================

variable "project_id" {
  description = "ID del proyecto GCP donde se crea el cluster"
  type        = string
}

variable "region" {
  description = "Region GCP donde se despliega el cluster Autopilot (es regional por diseño)"
  type        = string
  default     = "us-east1"
}

variable "cluster_name" {
  description = "Nombre del cluster GKE Autopilot"
  type        = string
}

variable "network" {
  description = "Nombre o self_link de la VPC donde vive el cluster"
  type        = string
}

variable "subnetwork" {
  description = "Nombre o self_link de la subnet donde se asignan IPs a nodos"
  type        = string
}

variable "release_channel" {
  description = "Canal de releases GKE: RAPID (bleeding edge), REGULAR (default, prod), STABLE (conservador)"
  type        = string
  default     = "REGULAR"

  validation {
    condition     = contains(["RAPID", "REGULAR", "STABLE"], var.release_channel)
    error_message = "release_channel debe ser RAPID, REGULAR o STABLE."
  }
}

variable "master_authorized_networks" {
  description = "Lista de CIDRs autorizados para acceder al API server del cluster. Vacio = publico (NO recomendado prod)"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

variable "environment" {
  description = "Ambiente logico: dev, staging, prod"
  type        = string
}

variable "labels" {
  description = "Labels (key/value) para aplicar al cluster. Se mergean con los defaults"
  type        = map(string)
  default     = {}
}