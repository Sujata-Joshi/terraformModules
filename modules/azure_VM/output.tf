# WEB Public IP
output "Red" {
  value = "http://${azurerm_linux_virtual_machine.main[0].public_ip_address}"
}

output "Green" {
  value = "http://${azurerm_linux_virtual_machine.main[1].public_ip_address}"
}