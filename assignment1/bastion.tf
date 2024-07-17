resource "azurerm_public_ip" "velo_bastion_public_ip" {
  name                = "velo-bastion-public-ip"
  location            = azurerm_resource_group.velo.location
  resource_group_name = azurerm_resource_group.velo.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "velo_bastion" {
  name                = "velo-bastion"
  location            = azurerm_resource_group.velo.location
  resource_group_name = azurerm_resource_group.velo.name
  sku                 = "Basic"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.azure_bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.velo_bastion_public_ip.id
  }
}
