terraform {
  backend "s3" {
    region         = "eu-west-1"
    bucket         = "vault-oidc-azuread-assuring-swift"
    key            = "terraform/stacks/by-id/vault-oidc-azuread/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "vault-oidc-azuread-terraform-lock-massive_mastiff"
  }
}

data "terraform_remote_state" "bootstrap" {
  backend  = "s3"
  config = {
    region         = "eu-west-1"
    bucket         = "vault-oidc-azuread-assuring-swift"
    key            = "terraform/stacks/by-id/vault-oidc-azuread/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "vault-oidc-azuread-terraform-lock-massive_mastiff"
  }
}
