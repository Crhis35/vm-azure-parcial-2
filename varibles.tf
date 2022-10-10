variable "location" {
  description = "The Azure Region in which all resources groups should be created."
}

variable "rg-name" {
  description = "The name of the resource group"
}
variable "vn_name" {
  description = "The name of the virtual network"
}
variable "cloud_shell_source" {
  description = "The ip from Azure Cloud Shell to get run the follow command in the cloud **curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'**"
}
variable "management_ip" {
  description = "The ip from your device"
}
variable "apps_name" {
  description = "The name of app service"
  type        = list(string)
}
