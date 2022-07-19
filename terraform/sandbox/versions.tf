terraform {
  required_providers {
    acme = {
      source = "terraform-providers/acme"
      version = "~> 2.0"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 2"
    }
    github = {
      source = "integrations/github"
      version = "~> 4"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2"
    }
  }
}
