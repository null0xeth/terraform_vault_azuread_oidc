provider "azuread" {}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
}

provider "vault" {
  address = var.vault_domain
}



