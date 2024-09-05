provider "vault" {}

resource "vault_mount" "transit" {
  path                      = "transit-test"
  type                      = "transit-test"
  description               = "Example description"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}

resource "vault_transit_secret_backend_key" "key" {
  backend    = vault_mount.transit.path
  name       = "my-key-name"
  exportable = true
}

resource "vault_policy" "transit_admin" {
  name = "${vault_mount.transit.path}-admin"

  policy = <<-EOT
    path "${vault_mount.transit.path}" {
    capabilities = ["create", "read", "update", "delete", "list"]
    }

    path "${vault_mount.transit.path}/*" {
    capabilities = ["create", "read", "update", "delete", "list"]
    }
  EOT
}

