# App Service Plan
resource "azurerm_service_plan" "frontend" {
  name                = "ansuman-frontend-asp"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  os_type             = "Linux"
  sku_name            = "F1"
}


# Main App Service
resource "azurerm_linux_web_app" "frontend" {
  for_each            = toset(var.apps_name)
  name                = each.value
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  service_plan_id     = azurerm_service_plan.frontend.id

  site_config {
    always_on = false
    application_stack {
      php_version = "8.0"
    }
  }
}

resource "azurerm_app_service_source_control" "repo" {
  for_each               = toset(var.apps_name)
  app_id                 = azurerm_linux_web_app.frontend[each.key].id
  repo_url               = "https://github.com/Crhis35/Simple-PHP-Blog.git"
  branch                 = "main"
  use_manual_integration = true
  use_mercurial          = false
}

