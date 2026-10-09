variable "project_id" {
  description = "ID del proyecto GCP"
  type        = string
}

variable "region" {
  description = "Region GCP para el cluster"
  type        = string
  default     = "us-east1"
}

variable "environment" {
  description = "Ambiente logico"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner del ambiente (para labels)"
  type        = string
  default     = "hernando-almanza"
}