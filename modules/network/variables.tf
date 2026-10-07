variable "project_id" {
  description = "ID del proyecto GCP"
  type        = string
}

variable "region" {
  description = "Region GCP para todos los recursos regionales"
  type        = string
}

variable "vpc_name" {
  description = "Nombre de la VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR de la subnet publica"
  type        = string
  default     = "10.10.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR de la subnet privada"
  type        = string
  default     = "10.10.2.0/24"
}

variable "environment" {
  description = "Nombre del ambiente para labels/tags"
  type        = string
}
