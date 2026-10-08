# =====================================================
# WORKLOAD IDENTITY POOL
# El "club" donde viven las identidades federadas
# =====================================================
resource "google_iam_workload_identity_pool" "github_pool" {
  workload_identity_pool_id = var.pool_id
  display_name              = "GitHub Actions Pool"
  description               = "Pool para federar identidades de GitHub Actions"
  disabled                  = false
}

# =====================================================
# WORKLOAD IDENTITY POOL PROVIDER
# La "puerta" al pool - define a quien se cree y como
# =====================================================
resource "google_iam_workload_identity_pool_provider" "github_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.provider_id
  display_name                       = "GitHub Provider"
  description                        = "Provider OIDC para GitHub Actions"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
    "attribute.ref"        = "assertion.ref"
    "attribute.workflow"   = "assertion.workflow"
  }

  attribute_condition = "assertion.repository == \"${var.github_owner}/${var.github_repo}\""
}

# =====================================================
# SERVICE ACCOUNT: Terraform PLAN (solo lectura)
# =====================================================
resource "google_service_account" "gh_actions_plan" {
  account_id   = "gh-actions-plan"
  display_name = "GitHub Actions - Terraform Plan"
  description  = "SA de solo lectura usada por workflows de plan en PRs"
}

resource "google_project_iam_member" "plan_viewer" {
  project = var.project_id
  role    = "roles/viewer"
  member  = "serviceAccount:${google_service_account.gh_actions_plan.email}"
}

# ========================================================
# NOTA IMPORTANTE: Terraform plan necesita escribir
# un lockfile en el bucket GCS para prevenir concurrencia,
# aunque no modifique state ni infra. Por eso otorgamos
# objectUser directamente SOBRE EL BUCKET (no project-wide).
# Esto es mas granular y mas seguro.
# ========================================================
resource "google_storage_bucket_iam_member" "plan_bucket_user" {
  bucket = "terraform-gcp-lab521"
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.gh_actions_plan.email}"
}

# =====================================================
# SERVICE ACCOUNT: Terraform APPLY (escritura)
# =====================================================
resource "google_service_account" "gh_actions_apply" {
  account_id   = "gh-actions-apply"
  display_name = "GitHub Actions - Terraform Apply"
  description  = "SA de escritura usada por workflows de apply en main"
}

resource "google_project_iam_member" "apply_editor" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.gh_actions_apply.email}"
}

resource "google_project_iam_member" "apply_sa_admin" {
  project = var.project_id
  role    = "roles/iam.serviceAccountAdmin"
  member  = "serviceAccount:${google_service_account.gh_actions_apply.email}"
}

resource "google_project_iam_member" "apply_storage_admin" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.gh_actions_apply.email}"
}

# =====================================================
# BINDING: Workload Identity Pool impersona SA de PLAN
# =====================================================
resource "google_service_account_iam_member" "plan_wi_user" {
  service_account_id = google_service_account.gh_actions_plan.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_pool.workload_identity_pool_id}/attribute.repository/${var.github_owner}/${var.github_repo}"
}

# =====================================================
# BINDING: Workload Identity Pool impersona SA de APPLY
# =====================================================
resource "google_service_account_iam_member" "apply_wi_user" {
  service_account_id = google_service_account.gh_actions_apply.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_pool.workload_identity_pool_id}/attribute.repository/${var.github_owner}/${var.github_repo}"
}