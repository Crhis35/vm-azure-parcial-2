locals {
  backend_probe_name             = "${var.vn_name}-probe"
  http_setting_name              = "${var.vn_name}-be-htst"
  public_ip_name                 = "${var.vn_name}-pip"
  frontend_ip_configuration_name = "${var.vn_name}-feip"
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
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }


  # waf_configuration {
  #   enabled          = "true"
  #   firewall_mode    = "Detection"
  #   rule_set_type    = "OWASP"
  #   rule_set_version = "3.0"
  # }

  gateway_ip_configuration {
    name      = "subnet"
    subnet_id = var.subnet_id
  }

  dynamic "frontend_port" {
    for_each = var.apps_name
    content {
      name = "${frontend_port.value}.azurewebsites.net-feport"
      port = tonumber("808${frontend_port.key}")
    }
  }


  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }

  dynamic "backend_address_pool" {
    for_each = toset(var.hostnames)
    content {
      name  = "${backend_address_pool.key}-beap"
      fqdns = [backend_address_pool.value]
    }
  }



  probe {
    name                                      = local.backend_probe_name
    protocol                                  = "Http"
    path                                      = "/"
    interval                                  = 30
    timeout                                   = 120
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true
    match {
      status_code = [200, 399]
    }
  }

  backend_http_settings {
    name                                = local.http_setting_name
    probe_name                          = local.backend_probe_name
    cookie_based_affinity               = "Disabled"
    path                                = "/"
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 120
    pick_host_name_from_backend_address = true
  }

  dynamic "http_listener" {
    for_each = var.hostnames
    content {
      name                           = "${http_listener.value}-httplstn"
      frontend_ip_configuration_name = "${var.vn_name}-feip"
      frontend_port_name             = "${http_listener.value}-feport"
      protocol                       = "Http"
    }
  }
  dynamic "request_routing_rule" {
    for_each = var.hostnames
    content {
      name                       = "${request_routing_rule.value}-rqrt"
      rule_type                  = "Basic"
      http_listener_name         = "${request_routing_rule.value}-httplstn"
      backend_address_pool_name  = "${request_routing_rule.value}-beap"
      backend_http_settings_name = local.http_setting_name
    }
  }
}
