output "resource_group_name" {
  value       = azurerm_resource_group.resource_group.name
  description = "Name of the resource group"
}

output "vmpIps" {
  value = module.vm-database.vm-ips
}
