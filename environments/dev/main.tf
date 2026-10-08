provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# =====================================================
# Modulo red - toda la plomeria de red
# =====================================================
module "network" {
  source = "../../modules/network"

  project_id          = var.project_id
  region              = var.region
  vpc_name            = "vpc-lab-${var.environment}"
  public_subnet_cidr  = "10.10.1.0/24"
  private_subnet_cidr = "10.10.2.0/24"
  environment         = var.environment
}

# =====================================================
# VM PUBLICA (demo de bastion-like, solo para contrastar)
# Lleva un nginx para probar el firewall de HTTP
# =====================================================
module "vm_public" {
  source = "../../modules/compute"

  name             = "vm-public-${var.environment}"
  zone             = var.zone
  subnet_id        = module.network.public_subnet_id
  assign_public_ip = true
  tags             = ["ssh-iap", "web"]

  labels = {
    environment = var.environment
    owner       = var.owner
    managed_by  = "terraform"
    tier        = "public"
    phase       = "1-networking"
  }

  startup_script = <<-SCRIPT
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    echo "<h1>VM publica - ${var.environment}</h1>" > /var/www/html/index.html
    systemctl enable nginx
    systemctl start nginx
  SCRIPT
}

# =====================================================
# VM PRIVADA (el patron correcto para workloads de banca)
# Sin IP publica. Egress solo via Cloud NAT.
# =====================================================
module "vm_private" {
  source = "../../modules/compute"

  name             = "vm-private-${var.environment}"
  zone             = var.zone
  subnet_id        = module.network.private_subnet_id
  assign_public_ip = false
  tags             = ["ssh-iap"]

  labels = {
    environment = var.environment
    owner       = var.owner
    managed_by  = "terraform"
    tier        = "private"
    phase       = "1-networking"
    test_label  = "demo-oidc"    # ← AGREGA ESTA LINEA
  }
}
