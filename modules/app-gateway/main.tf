locals {
  backend_address_pool_name      = "${var.vn_name}-beap"
  frontend_port_name             = "${var.vn_name}-feport"
  frontend_ip_configuration_name = "${var.vn_name}-feip"
  http_setting_name              = "${var.vn_name}-be-htst"
  listener_name                  = "${var.vn_name}-httplstn"
  request_routing_rule_name      = "${var.vn_name}-rqrt"
  redirect_configuration_name    = "${var.vn_name}-rdrcfg"
}

resource "azurerm_public_ip" "public_ip" {
  name                = "app-pip"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method   = "Dynamic"
}

# Application Gateway
resource "azurerm_application_gateway" "agw" {
  name                = "app-agw"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  sku {
    name     = "WAF_Medium"
    tier     = "WAF"
    capacity = 2
  }

  waf_configuration {
    enabled          = "true"
    firewall_mode    = "Detection"
    rule_set_type    = "OWASP"
    rule_set_version = "3.0"
  }

  gateway_ip_configuration {
    name      = "subnet"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }

  backend_address_pool {
    name  = local.backend_address_pool_name
    fqdns = [for dns in toset(var.apps_name) : "${dns}.azurewebsites.net"]
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  probe {
    name = "probe"
    host = "${var.app_name}.azurewebsites.net"

    protocol            = "Http"
    path                = "/"
    interval            = "30"
    timeout             = "30"
    unhealthy_threshold = "3"
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
    probe_name            = "probe"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}
