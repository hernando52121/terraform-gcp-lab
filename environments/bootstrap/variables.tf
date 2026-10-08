variable "project_id" {
  description = "ID del proyecto GCP"
  type        = string
}

variable "project_number" {
  description = "Numero del proyecto GCP (numerico)"
  type        = string
}

variable "region" {
  description = "Region por defecto"
  type        = string
  default     = "us-east1"
}

variable "github_owner" {
  description = "Usuario u organizacion GitHub"
  type        = string
}

variable "github_repo" {
  description = "Nombre del repositorio GitHub"
  type        = string
}