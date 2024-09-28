terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.53.1"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "4.4.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.3.0"
    }
  }
}


