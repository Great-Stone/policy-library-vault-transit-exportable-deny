# Transit Key Exportable Deny

> Here's what Sentinel looks like in Vault
>
> [Vault - transit_exportable_deny](https://github.com/Great-Stone/policy-library-vault-transit-exportable-deny/blob/main/docs/policies/transit_exportable_deny.md)

## 1. Terraform Sample

[main.tf](https://github.com/Great-Stone/policy-library-vault-transit-exportable-deny/blob/main/policies/terraform/main.tf)

```hcl
resource "vault_transit_secret_backend_key" "key" {
  backend    = vault_mount.transit.path
  name       = "my-key-name"
  exportable = true
}
```

## 2. Policy

```hcl
import "tfplan-functions" as plan

transit_key = plan.find_resources("vault_transit_secret_backend_key")

# (KR) Transit Key는 내보내기를 허용하지 않습니다.
# (EN) Transit Key does not allow exporting.
exportable_check = rule {
    all transit_key as _, rc {
      print("Current key exportable is ", rc.change.after.exportable) and
      (rc.change.after.exportable is false)
    }
}

# Check transit key exporting
main = rule {
  exportable_check
}
```

- exportable_check: Returns `TRUE` if `exportable` of any transit key type resource has a value of `false`.

## 3. TEST

![](https://github.com/Great-Stone/policy-library-vault-transit-exportable-deny/blob/main/images/vault-transit-exportable-check.png?raw=true)