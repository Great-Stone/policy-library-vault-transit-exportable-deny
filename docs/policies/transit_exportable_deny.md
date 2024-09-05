# Transit Key Exportable Deny - Vault Enterprise case

## 1. Create a policy for EGP exportable_deny.sentinel

```hcl
import "strings"

exportable = request.data.exportable

exportable_check = rule {
  exportable is "false"
}

main = rule {
  exportable_check
}
```

- exportable_check : Returns `TRUE` if `exportable` in the request's Body has a value of `false`.


## 2. Setting up policies in EGP
EGP enforces the policy for the specified path

```bash
vault write sys/policies/egp/exportable-check \
  policy="$(base64 -i exportable-deny.sentinel)" \
  paths="*" \
  enforcement_level="hard-mandatory"
```

- Act when a request is made to the API path specified by paths

## 3. TEST

### 3.1 Test Policy

Users with full control of the transit route

```bash
vault policy write transit-admin - << EOF
  path "transit" {
  capabilities = ["create", "read", "update", "delete", "list"]
  }

  path "transit/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
  }
EOF
```

### 3.2 Creating Policy Token

```bash
VAULT_TOKEN=$(vault token create -policy=transit-admin)
```

### 3.3 Sentinel Testing

Perform as normal if exportable option is `false`

```bash
$ vault write -f transit/keys/my-key-name exportable=false

Key                       Value
---                       -----
allow_plaintext_backup    false
auto_rotate_period        0s
deletion_allowed          false
derived                   false
exportable                false
imported_key              false
keys                      map[1:1702877441]
latest_version            1
min_available_version     0
min_decryption_version    1
min_encryption_version    0
name                      my-key-name
supports_decryption       true
supports_derivation       true
supports_encryption       true
supports_signing          false
type                      aes256-gcm96
```

Rejected if exportable option is `true`

```bash
$ vault write -f transit/keys/my-key-name exportable=true

Error writing data to transit/keys/my-key-name: Error making API request.

URL: PUT http://127.0.0.1:8200/v1/transit/keys/my-key-name
Code: 403. Errors:

* 2 errors occurred:
	* egp standard policy "root/exportable-check" evaluation resulted in denial.

The specific error was:
<nil>

A trace of the execution for policy "root/exportable-check" is available:

Result: false

Description: <none>

Rule "main" (root/exportable-check:9:1) = false
Rule "exportable_check" (root/exportable-check:5:1) = false
	* permission denied
```
