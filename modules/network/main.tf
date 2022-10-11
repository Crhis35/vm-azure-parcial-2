resource "azurerm_virtual_network" "vn_app" {
  name                = var.vn_name
  address_space       = ["10.0.0.0/16"]
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
}

resource "azurerm_subnet" "appgw" {
  name                 = "${var.subnet_name}-gateway"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.vn_app.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "app_subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.vn_app.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Web"]

}

resource "azurerm_network_security_group" "app_nsg" {
  name                = "app-nsg"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  # security_rule {
  #   name                       = "Allow_HTTP"
  #   priority                   = 200
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "80"
  #   source_address_prefix      = "*"
  #   destination_address_prefix = "*"
  # }
  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.management_ip
    destination_address_prefix = "*"

  }
  ## Create a rule to allow Ansible to connect to each VM from the Azure Cloud Shell
  ## source_address_prefix will be the IP Azure Cloud Shell is coming from
  ## You'll pass the value of the variable to the plan when invoking it.

  security_rule {
    name                       = "allowWinRm"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5986"
    source_address_prefix      = var.cloud_shell_source
    destination_address_prefix = "*"
  }

  ## Create a rule to allow your local machine with Visual Studio installed to connect to
  ## the web management service and Web Deploy to deploy a web app. This locks down Web Deploy
  ## to your local public IP address.
  ## You'll pass the value of the variable to the plan when invoking it.
  security_rule {
    name                       = "allowWebDeploy"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8172"
    source_address_prefix      = var.management_ip
    destination_address_prefix = "*"
  }

  ## Create a rule to allow web clients to connect to the web app
  security_rule {
    name                       = "allowPublicWeb"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  ## not required. Only needed if you need to RDP to the VMs to troubleshoot
  security_rule {
    name                       = "allowRDP"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.management_ip
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allowMysql"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefixes = setunion(
      azurerm_subnet.appgw.address_prefixes,
      azurerm_subnet.app_subnet.address_prefixes,
    )
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allowMysqlLocal"
    priority                   = 106
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix = var.management_ip
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_association-gw" {
  subnet_id                 = azurerm_subnet.appgw.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
  depends_on = [
    azurerm_network_security_group.app_nsg
  ]
}
resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.app_subnet.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
  depends_on = [
    azurerm_network_security_group.app_nsg
  ]
}
