output "vm_name" {
  description = "Nombre de la VM de validacion"
  value       = google_compute_instance.bootstrap_vm.name
}

output "vm_internal_ip" {
  description = "IP interna de la VM"
  value       = google_compute_instance.bootstrap_vm.network_interface[0].network_ip
}

output "vpc_id" {
  description = "ID de la VPC creada"
  value       = google_compute_network.lab_vpc.id
}

output "subnet_cidr" {
  description = "CIDR de la subnet"
  value       = google_compute_subnetwork.lab_subnet.ip_cidr_range
}
