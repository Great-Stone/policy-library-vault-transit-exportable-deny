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
