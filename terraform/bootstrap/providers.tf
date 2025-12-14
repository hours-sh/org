provider "github" {
  owner = "hours-sh"
  token = local.tokens.github
  # app_auth {}
}
provider "google" {
  project = "sh-hours-org-bootstrap"
  region  = "global"
}
provider "scaleway" {
  organization_id = local.tokens.scaleway.organization_id
  project_id      = local.tokens.scaleway.project_id
  access_key      = local.tokens.scaleway.access_key
  secret_key      = local.tokens.scaleway.secret_key
}
provider "tfe" {
  token    = var.tfe_token
  hostname = "app.terraform.io"
}
