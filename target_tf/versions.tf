terraform {
  required_version = ">= 1.1.0"

  # Terraform Providers block - Note: Google has a separate provider for the "beta" resources.
  required_providers {

    # Google Provider Configuration Reference: https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference
    google = {
      source  = "hashicorp/google"
      version = ">= 4.45.0, < 7.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.45.0, < 7.0.0"
    }
  }
}
