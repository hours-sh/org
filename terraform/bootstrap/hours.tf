# projects
resource "tfe_project" "hours" {
  organization = "sh-hours"
  name         = "hours"
}

# envs
module "hours_dev" {
  source = "github.com/miran248/org//terraform/modules/env"

  gcp = {
    project  = "sh-hours-hours-dev"
    services = flatten([local.gcp.services, "storage-api.googleapis.com"])
    org_roles = [
      "roles/billing.user",
      "roles/dns.admin",
      "roles/resourcemanager.organizationAdmin",
      "roles/resourcemanager.projectCreator",
      "roles/resourcemanager.projectDeleter",
      "roles/secretmanager.admin",
      "roles/serviceusage.serviceUsageAdmin",

      "roles/iam.securityAdmin",
      "roles/iam.serviceAccountAdmin",
      "roles/iam.serviceAccountKeyAdmin",
      "roles/iam.workloadIdentityPoolAdmin",
    ]
    roles = flatten([local.gcp.roles, "roles/storage.admin"])
  }
  scw = { organization_id = local.tokens.scaleway.organization_id, project = "sh-hours-hours-dev" }
  tfc = { organization = "sh-hours", project = tfe_project.hours.name, workspace = "dev", working_directory = "terraform/dev" }

  tokens = { github = local.tokens.github }

  depends_on = [tfe_project.hours]
}

# dns
resource "google_dns_managed_zone" "hours_dev" {
  project = data.google_project.hours_dev.project_id

  name     = "dev"
  dns_name = "dev.${google_dns_managed_zone.this.dns_name}"

  dnssec_config {
    state = "on"
  }
}
resource "google_dns_record_set" "hours_dev" {
  project      = data.google_project.this.project_id
  managed_zone = google_dns_managed_zone.this.name

  name = google_dns_managed_zone.hours_dev.dns_name
  type = "NS"
  ttl  = 300

  rrdatas = google_dns_managed_zone.hours_dev.name_servers
}

# repos
resource "github_repository" "hours" {
  name        = "hours"
  description = "hours.sh is a local-first time-tracking and invoicing tool"

  homepage_url = "https://hours.sh"

  allow_auto_merge       = true
  allow_merge_commit     = true
  allow_squash_merge     = false
  allow_rebase_merge     = false
  auto_init              = false
  delete_branch_on_merge = false
  has_issues             = true
  has_projects           = false
  has_wiki               = false
  visibility             = "public"

  topics = [
    "local-first",
    "time-tracking",
    "invoicing",
  ]
}
