# Parcial 2

```terraform
 terraform plan -var-file=variables/dev.tfvars
```

variables

```env
location           = "westus"
rg-name            = "rg-parcialapp"
vn_name            = "vn-parcialapp"
apps_name          = ["app-parcial-1", "app-parcial-2"]
cloud_shell_source = "ip"
management_ip      = "ip"
````
