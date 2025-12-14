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
