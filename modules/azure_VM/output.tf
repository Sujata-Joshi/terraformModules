# WEB Public IP
output "WEB" {
  value = "http://${azurerm_linux_virtual_machine.main.public_ip_address}"
}