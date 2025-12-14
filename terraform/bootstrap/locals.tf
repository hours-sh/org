locals {
  tokens = {
    github   = data.google_secret_manager_secret_version.github.secret_data
    scaleway = jsondecode(data.google_secret_manager_secret_version.scaleway.secret_data)
  }
}
