resource "azurerm_public_ip" "mysql" {
  for_each            = toset(var.vm_name)
  name                = "public-mysql-${each.value}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "vm_interface" {
  for_each            = toset(var.vm_name)
  name                = each.value
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mysql[each.key].id
  }

}

resource "azurerm_network_interface_security_group_association" "nsg" {
  for_each                  = toset(var.vm_name)
  network_interface_id      = azurerm_network_interface.vm_interface[each.key].id
  network_security_group_id = var.nsg_id
}

resource "azurerm_availability_set" "app_set" {
  name                         = "app-set"
  location                     = var.resource_group.location
  resource_group_name          = var.resource_group.name
  platform_fault_domain_count  = 3
  platform_update_domain_count = 3

}
resource "azurerm_linux_virtual_machine" "vmss" {
  for_each                        = toset(var.vm_name)
  name                            = each.value
  location                        = var.resource_group.location
  resource_group_name             = var.resource_group.name
  admin_username                  = each.value
  admin_password                  = var.admin_password
  size                            = "Standard_B1ls"
  disable_password_authentication = false
  availability_set_id             = azurerm_availability_set.app_set.id

  network_interface_ids = [
    azurerm_network_interface.vm_interface[each.key].id
  ]



  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}
