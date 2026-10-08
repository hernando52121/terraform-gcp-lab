variable "project_id" {
  description = "ID del proyecto GCP"
  type        = string
}

variable "project_number" {
  description = "Numero del proyecto GCP (distinto al project_id, es numerico)"
  type        = string
}

variable "github_owner" {
  description = "Usuario u organizacion de GitHub"
  type        = string
}

variable "github_repo" {
  description = "Nombre del repositorio (sin el owner)"
  type        = string
}

variable "pool_id" {
  description = "ID del Workload Identity Pool"
  type        = string
  default     = "github-pool"
}

variable "provider_id" {
  description = "ID del provider dentro del pool"
  type        = string
  default     = "github-provider"
}