# terraform-gcp-lab

Laboratorio personal de **Site Reliability Engineering sobre Google Cloud Platform**, construido como preparación para rol Senior Cloud SRE en banca.

## Objetivos

- Infraestructura como código con **Terraform** y backend remoto en GCS.
- Red privada estilo banca (VPC custom, Cloud NAT, IAP, sin bastion).
- **GKE** privado con Workload Identity y External Secrets.
- **GitOps** con Argo CD, repos separados código/manifiestos.
- CI/CD con **GitHub Actions + Workload Identity Federation** (sin keys estáticas).
- **SRE**: SLI/SLO formales, error budgets, postmortems blameless.
- Automatización en **Python** contra APIs de GCP.

## Fases

- **Fase 0** — Bootstrap: backend GCS, service account, VPC mínima, VM de validación. ✅
- **Fase 1** — Networking seguro (Cloud NAT, firewall, IAP, LB).
- **Fase 2** — Workload Identity Federation + CI/CD en GitHub Actions.
- **Fase 3** — GKE privado + External Secrets + app de ejemplo.
- **Fase 4** — Argo CD + GitOps.
- **Fase 5** — Observabilidad, SLI/SLO, Python automation.
- **Fase 6** — Incident response + postmortem documentado.

## Autor

Hernando Almanza — Bogotá, Colombia.
