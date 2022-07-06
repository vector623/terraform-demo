terraform {
  required_providers {
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
