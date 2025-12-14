terraform {
  cloud {
    organization = "sh-hours"

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
