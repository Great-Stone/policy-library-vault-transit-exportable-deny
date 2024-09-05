terraform {
  cloud {
    organization = "great-stone-biz"
    workspaces {
      name = "vault-transit-exportable-deny"
    }
  }
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.0"
    }
  }
}