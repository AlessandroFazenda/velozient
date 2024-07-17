resource "azurerm_network_interface" "velo_backend_nic" {
  for_each            = var.backendvm
  name                = "${each.value.computername}-nic"
  location            = azurerm_resource_group.velo.location
  resource_group_name = azurerm_resource_group.velo.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.velo_backend.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "velo_backend_lb_association" {
  for_each                = var.backendvm
  network_interface_id    = azurerm_network_interface.velo_backend_nic[each.key].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.velo_backend_lb_backend_pool.id
}

resource "azurerm_linux_virtual_machine" "velo_backend_vm" {
  for_each              = var.backendvm
  name                  = "${each.value.computername}-vm"
  location              = azurerm_resource_group.velo.location
  resource_group_name   = azurerm_resource_group.velo.name
  network_interface_ids = [azurerm_network_interface.velo_backend_nic[each.key].id]
  size                  = each.value.computersize

  os_disk {
    name                 = "${each.value.computername}-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = each.value.osdisksize
  }

  source_image_reference {
    publisher = each.value.ospublisher
    offer     = each.value.osoffer
    sku       = each.value.ossku
    version   = each.value.osversion
  }

  computer_name  = "${each.value.computername}-vm"
  admin_username = "adminuser"

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
}
