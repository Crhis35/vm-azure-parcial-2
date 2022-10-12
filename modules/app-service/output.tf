
output "hostnames" {
  value = [
    for instance in azurerm_linux_web_app.frontend : instance.default_hostname
  ]
}
