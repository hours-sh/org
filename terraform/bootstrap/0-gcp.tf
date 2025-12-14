# projects
data "google_project" "this" {
  project_id = "sh-hours-org-bootstrap"
}
data "google_project" "hours_dev" {
  project_id = "sh-hours-hours-dev"
}

# secrets
data "google_secret_manager_secret_version" "github" {
  secret = "github"
}
data "google_secret_manager_secret_version" "scaleway" {
  secret = "scaleway"
}
