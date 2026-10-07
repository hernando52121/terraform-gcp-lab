output "name" {
  value = google_compute_instance.vm.name
}

output "internal_ip" {
  value = google_compute_instance.vm.network_interface[0].network_ip
}

output "external_ip" {
  description = "IP publica si fue asignada, vacio si no"
  value       = var.assign_public_ip ? google_compute_instance.vm.network_interface[0].access_config[0].nat_ip : ""
}

output "self_link" {
  value = google_compute_instance.vm.self_link
}
