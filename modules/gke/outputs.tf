# ============================================================
# Outputs del modulo GKE
# ============================================================
# Lo que el consumidor del modulo puede leer despues del apply.
# ============================================================

output "cluster_name" {
  description = "Nombre del cluster creado"
  value       = google_container_cluster.autopilot.name
}

output "cluster_location" {
  description = "Region/zona del cluster"
  value       = google_container_cluster.autopilot.location
}

output "cluster_endpoint" {
  description = "Endpoint del API server (publico o privado)"
  value       = google_container_cluster.autopilot.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Certificado CA del cluster (base64)"
  value       = google_container_cluster.autopilot.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "workload_identity_pool" {
  description = "Workload Identity pool del cluster (usado para IAM bindings de SAs K8s)"
  value       = google_container_cluster.autopilot.workload_identity_config[0].workload_pool
}

output "kubectl_config_command" {
  description = "Comando gcloud para configurar kubectl y conectarse al cluster"
  value       = "gcloud container clusters get-credentials ${google_container_cluster.autopilot.name} --region ${google_container_cluster.autopilot.location} --project ${var.project_id}"
}