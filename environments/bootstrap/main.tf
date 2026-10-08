provider "google" {
  project = var.project_id
  region  = var.region
}

module "github_oidc" {
  source = "../../modules/iam-github-oidc"

  project_id     = var.project_id
  project_number = var.project_number
  github_owner   = var.github_owner
  github_repo    = var.github_repo
}