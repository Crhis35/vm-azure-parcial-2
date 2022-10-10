variable "resource_group" {
  description = "The name of the resource group"
  type = object({
    name     = string
    location = string
  })
}

variable "subnet_id" {
  description = "Subnet ID"
}

variable "app_name" {
  description = "Name of the application"
  default     = "app-parcial"
}
variable "vn_name" {
  description = "Name of the virtual network"
}

variable "apps_name" {
  description = "Name of the apps service"
  type        = list(string)
}
