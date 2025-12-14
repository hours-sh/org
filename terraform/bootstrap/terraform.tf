terraform {
  cloud {
    organization = "hours-sh"

    workspaces {
      name = "bootstrap"
    }
  }
  required_providers {
    github = {
      source = "integrations/github"
    }
    google = {
      source = "hashicorp/google"
    }
    scaleway = {
      source = "scaleway/scaleway"
    }
    tfe = {
      source = "hashicorp/tfe"
    }
  }
}
