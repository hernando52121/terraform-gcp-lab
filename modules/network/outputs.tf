output "vpc_id" {
  description = "ID completo de la VPC"
  value       = google_compute_network.vpc.id
}

output "vpc_name" {
  description = "Nombre de la VPC"
  value       = google_compute_network.vpc.name
}

output "vpc_self_link" {
  description = "Self link de la VPC (requerido por algunos recursos)"
  value       = google_compute_network.vpc.self_link
}

output "public_subnet_id" {
  description = "ID subnet publica"
  value       = google_compute_subnetwork.public.id
}

output "public_subnet_name" {
  description = "Nombre subnet publica"
  value       = google_compute_subnetwork.public.name
}

output "private_subnet_id" {
  description = "ID subnet privada"
  value       = google_compute_subnetwork.private.id
}

output "private_subnet_name" {
  description = "Nombre subnet privada"
  value       = google_compute_subnetwork.private.name
}

output "nat_name" {
  description = "Nombre del Cloud NAT"
  value       = google_compute_router_nat.nat.name
}
