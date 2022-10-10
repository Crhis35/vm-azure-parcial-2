variable "resource_group" {
  description = "The name of the resource group"
  type = object({
    name     = string
    location = string
  })
}

variable "admin-login" {
  description = "username of the database"
  default     = "mysqladminun"
}

variable "admin-password" {
  description = "password of the database"
  default     = "H@Sh1CoR3!"
}

variable "subnet_id" {
  description = "Id of the subnet"
}
variable "db_name" {
  description = "Name of the database"
  default     = "mysqlserver-vm"
}
variable "vn_rule" {
  description = "Name of the virtual network rule"
  default     = "mysql-vnet-rule"
}
