terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
    github = {
      source  = "integrations/github"
      version = "=6.9.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=3.6.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azuread" {

}
provider "azurerm" {
  subscription_id     = "fd3a592d-8768-4193-bf0a-476f4c71bfa0"
  storage_use_azuread = true
  features {
  }
}

provider "github" {
  token = var.github_token
}

data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}

data "github_repository" "petstore-repo" {
  full_name = var.github_repo
}

resource "azurerm_resource_group" "petstore-rg" {
  name     = var.resource_group_name
  location = var.location
}
