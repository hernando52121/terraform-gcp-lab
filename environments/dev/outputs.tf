output "vpc_name" {
  value = module.network.vpc_name
}

output "nat_gateway" {
  value = module.network.nat_name
}

output "vm_public_name" {
  value = module.vm_public.name
}

output "vm_public_external_ip" {
  description = "Prueba curl a esta IP desde tu iMac para validar firewall HTTP"
  value       = module.vm_public.external_ip
}

output "vm_public_internal_ip" {
  value = module.vm_public.internal_ip
}

output "vm_private_name" {
  value = module.vm_private.name
}

output "vm_private_internal_ip" {
  description = "VM sin IP publica. Egress solo via NAT."
  value       = module.vm_private.internal_ip
}
