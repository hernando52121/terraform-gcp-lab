variable "name" {
  description = "Nombre de la VM"
  type        = string
}

variable "zone" {
  description = "Zona donde desplegar"
  type        = string
}

variable "machine_type" {
  description = "Tipo de maquina"
  type        = string
  default     = "e2-micro"
}

variable "subnet_id" {
  description = "ID de la subnet"
  type        = string
}

variable "assign_public_ip" {
  description = "Si true, asigna IP publica efimera"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Network tags para firewalls"
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "Labels"
  type        = map(string)
  default     = {}
}

variable "startup_script" {
  description = "Script bash de arranque"
  type        = string
  default     = ""
}
