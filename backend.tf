
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-parcial2app"
    storage_account_name = "devparcial2app32672"
    container_name       = "parcial2app"
    key                  = "terraform.tfstate"
  }
}
