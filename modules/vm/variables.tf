variable "resource_group" {
  description = "The name of the resource group"
  type = object({
    name     = string
    location = string
  })
}

variable "vm_name" {
  description = "Name of the vms"
  type        = list(string)
  default     = ["Vm1"]
}

variable "ip_name" {
  description = "Name of the ip"
  default     = "public_ip"
}
variable "lb_name" {
  description = "Name of the ip"
  default     = "vmss-lb"
}
variable "application_port" {
  description = "Name of the ip"
  default     = 3389
}

variable "subnet_id" {
  description = "Id of the subnet"
}
variable "net_id" {
  description = "Id of the net"
}
variable "nsg_id" {
  description = "Id of the network security group"
}

variable "admin_password" {
  description = "Id of the subnet"
  default     = "Th1sIsAP@ssw0rd"
}

