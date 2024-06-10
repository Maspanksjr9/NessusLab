terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "08834ce2-3156-43e4-bf83-f22d05af7b2e"
  tenant_id = "31060bab-6cd4-424f-a9ee-7f2982a6e218"
  }
