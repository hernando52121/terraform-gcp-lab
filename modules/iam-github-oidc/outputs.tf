output "pool_name" {
  description = "Nombre completo del Workload Identity Pool"
  value       = google_iam_workload_identity_pool.github_pool.name
}

output "provider_name" {
  description = "Nombre completo del provider - PEGAR en GitHub Actions"
  value       = google_iam_workload_identity_pool_provider.github_provider.name
}

output "sa_plan_email" {
  description = "Email de la SA de plan - PEGAR en GitHub Actions"
  value       = google_service_account.gh_actions_plan.email
}

output "sa_apply_email" {
  description = "Email de la SA de apply - PEGAR en GitHub Actions"
  value       = google_service_account.gh_actions_apply.email
}

output "github_secrets_setup" {
  description = "Instrucciones para configurar GitHub secrets"
  value = <<-EOT

  =============================================
  SECRETOS A CONFIGURAR EN GITHUB
  =============================================

  Repo -> Settings -> Secrets and variables -> Actions
  Crear estos secrets:

  WIF_PROVIDER = ${google_iam_workload_identity_pool_provider.github_provider.name}

  SA_PLAN_EMAIL = ${google_service_account.gh_actions_plan.email}

  SA_APPLY_EMAIL = ${google_service_account.gh_actions_apply.email}

  GCP_PROJECT_ID = ${var.project_id}

  Nota: estos "secrets" son publicos tecnicamente. La seguridad vive en
  el attribute_condition del provider, no en ocultarlos.
  =============================================
  EOT
}