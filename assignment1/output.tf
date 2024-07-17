output "velo_bastion_public_ip_address" {
  value = azurerm_public_ip.velo_bastion_public_ip.ip_address
}

output "velo_frontend_lb_public_ip_address" {
  value = azurerm_public_ip.velo_frontend_lb_public_ip.ip_address
}

output "velo_backend_lb_private_ip_address" {
  value = azurerm_lb.velo_backend_lb.private_ip_address
}

output "velo_frontend_nic_ip_addresses" {
  value = {
    for k, v in azurerm_network_interface.velo_frontend_nic :
    k => v.private_ip_address
  }
}

output "velo_backend_nic_ip_addresses" {
  value = {
    for k, v in azurerm_network_interface.velo_backend_nic :
    k => v.private_ip_address
  }
}

output "velo_database_fqdn" {
  value = azurerm_mysql_flexible_server.velo_mysql.fqdn
}