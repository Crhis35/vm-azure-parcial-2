resource "azurerm_mysql_server" "example" {
  name                = var.db_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  administrator_login          = var.admin-login
  administrator_login_password = var.admin-password

  sku_name   = "GP_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  ssl_enforcement_enabled      = true
}

resource "azurerm_mysql_virtual_network_rule" "example" {
  name                = var.vn_rule
  resource_group_name = var.resource_group.name
  server_name         = azurerm_mysql_server.example.name
  subnet_id           = var.subnet_id
}
