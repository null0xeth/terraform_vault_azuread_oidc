########### LOCALS:   ###############
locals {
  redirect_uris = [
    "${var.vault_domain}/ui/vault/auth/oidc/oidc/callback",
    "${var.vault_cli_domain}/oidc/callback"
  ]
}

module "azdata" {
  source = "github.com/null0xeth/terraform_azure_data"
}

########### AZURE AD: ###############
## 1. Create OIDC app in Azure AD:
module "application" {
  source                   = "git@github.com:null0xeth/terraform_azuread_vault_oidc_application.git"
  oidc_redirect_uris       = local.redirect_uris
  azurerm_sub_id           = module.azdata.azurerm_sub_id
  current_tenant_id        = module.azdata.azuread_tenant_id
  current_client_object_id = module.azdata.client_config_object_id
  directory_role_templates = module.azdata.directory_role_templates
  msgraph_resource_id      = module.azdata.msgraph_resource_id
  msgraph_role_ids         = module.azdata.msgraph_app_role_ids
}

########### VAULT:    ##################
## 1. Create OIDC auth provider in Vault:
module "azure_auth_vault" {
  source             = "git@github.com:null0xeth/terraform_vault_azuread_auth_provider_vault.git"
  oidc_redirect_uris = local.redirect_uris
  azure_ad_config = {
    client_id     = module.application.client_id
    client_secret = module.application.client_secret
    tenant_id     = module.application.tenant_id
    role          = "admin"
  }
}

## 2. Add Azure AD groups to vault:
module "groups" {
  source                 = "git@github.com:null0xeth/terraform_vault_azuread_groups.git"
  auth_method            = module.azure_auth_vault.mount_accessor
  azuread_group_ids      = module.azdata.azuread_group_ids
  azuread_group_names    = module.azdata.azuread_group_names
  create_internal_groups = true
}

# 3. Map Azure AD users to Vault entities:
module "users" {
  source                = "git@github.com:null0xeth/terraform_vault_azuread_users.git"
  auth_method           = module.azure_auth_vault.mount_accessor
  azuread_user_ids      = module.azdata.azuread_user_object_ids
  azuread_user_names    = module.azdata.azuread_user_names
  vault_oidc_group_name = values(module.groups.internal)
}

# 4. Configure Vault as OIDC provider:
module "vault_oidc_provider" {
  source = "git@github.com:null0xeth/terraform_vault_oidc_provider_azuread.git"
}


