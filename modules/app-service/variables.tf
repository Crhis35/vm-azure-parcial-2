variable "resource_group" {
  description = "The name of the resource group"
  type = object({
    name     = string
    location = string
  })
}


variable "vn_id" {
  description = "Virtual network identifier"
}

variable "apps_name" {
  description = "Name of the apps service"
  type        = list(string)
}
