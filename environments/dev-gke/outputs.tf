# ============================================================
# Outputs del ambiente dev-gke
# ============================================================

output "cluster_name" {
  description = "Nombre del cluster GKE Autopilot"
  value       = module.gke.cluster_name
}

output "cluster_location" {
  description = "Region del cluster"
  value       = module.gke.cluster_location
}

output "vpc_name" {
  description = "Nombre de la VPC dedicada para GKE"
  value       = google_compute_network.vpc_gke.name
}

output "subnet_name" {
  description = "Nombre de la subnet de nodos GKE"
  value       = google_compute_subnetwork.gke_nodes.name
}

output "nat_name" {
  description = "Nombre del Cloud NAT"
  value       = google_compute_router_nat.gke_nat.name
}

output "kubectl_config_command" {
  description = "Comando para conectar kubectl al cluster"
  value       = module.gke.kubectl_config_command
}

output "workload_identity_pool" {
  description = "Workload Identity pool del cluster (para IAM bindings K8s SA <-> GCP SA)"
  value       = module.gke.workload_identity_pool
}