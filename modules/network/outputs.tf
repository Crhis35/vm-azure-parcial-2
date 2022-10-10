output "subnet_gw_id" {
  value = azurerm_subnet.appgw.id
}
output "subnet_id" {
  value = azurerm_subnet.app_subnet.id
}

output "vn_id" {
  value = azurerm_virtual_network.vn_app.id
}

output "nsg_id" {
  value = azurerm_network_security_group.app_nsg.id
}
