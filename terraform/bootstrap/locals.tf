locals {
  tokens = {
    github   = data.google_secret_manager_secret_version.github.secret_data
    scaleway = jsondecode(data.google_secret_manager_secret_version.scaleway.secret_data)
  }

  gcp = {
    services = [
      "cloudbilling.googleapis.com",
      "dns.googleapis.com",
      "secretmanager.googleapis.com",
      "serviceusage.googleapis.com",

      # required by oidc-tfc
      "cloudresourcemanager.googleapis.com",
      "iam.googleapis.com",
      "iamcredentials.googleapis.com",
      "sts.googleapis.com",
    ]
    roles = [
      "roles/dns.admin",
      "roles/secretmanager.admin",
      "roles/storage.admin",

      # required by oidc-tfc
      "roles/iam.securityAdmin",
      "roles/iam.serviceAccountAdmin",
      "roles/iam.serviceAccountKeyAdmin",
      "roles/iam.workloadIdentityPoolAdmin",
    ]
  }
}
