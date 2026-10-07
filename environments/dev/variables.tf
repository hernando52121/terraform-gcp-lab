variable "project_id" {
  description = "ID del proyecto GCP"
  type        = string
}

variable "region" {
  description = "Region por defecto"
  type        = string
  default     = "us-east1"
}

variable "zone" {
  description = "Zona por defecto"
  type        = string
  default     = "us-east1-b"
}

variable "environment" {
  description = "Nombre del ambiente"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Dueno/responsable"
  type        = string
  default     = "hernando-almanza"
}
