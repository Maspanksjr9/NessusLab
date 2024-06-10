output "resource_group_name" {
  value = azurerm_resource_group.Nessuslab.name
}

output "public_ip_address" {
  value = azurerm_windows_virtual_machine.Nessusvm.public_ip_address
}

output "admin_password" {
  sensitive = true
  value     = azurerm_windows_virtual_machine.Nessusvm.admin_password
}
