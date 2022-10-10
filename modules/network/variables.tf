variable "resource_group" {
  description = "The name of the resource group"
  type = object({
    name     = string
    location = string
  })
}
variable "cloud_shell_source" {
  description = "Ip from cloud shell"
}
variable "management_ip" {
  description = "Ip from your device"
}
variable "vn_name" {
  description = "Name of the ip"
}
variable "subnet_name" {
  description = "Name of the subnet"
  default     = "vmss-subnet"
}
