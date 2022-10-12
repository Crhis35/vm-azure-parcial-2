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
cloud_shell_source = "ip" you azure cloud shell ip
management_ip      = "ip" your laptop ip
````

export ANSIBLE_HOST_KEY_CHECKING=False
