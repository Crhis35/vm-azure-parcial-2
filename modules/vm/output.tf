output "vm-ips" {
  value = [
    for instance in azurerm_public_ip.mysql : instance.ip_address
  ]
}
