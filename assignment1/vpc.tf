resource "azurerm_virtual_network" "velo_vnet" {
  name                = "velo-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.velo.location
  resource_group_name = azurerm_resource_group.velo.name
}

resource "azurerm_subnet" "velo_frontend" {
  name                 = "velo-frontend"
  resource_group_name  = azurerm_resource_group.velo.name
  virtual_network_name = azurerm_virtual_network.velo_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "velo_backend" {
  name                 = "velo-backend"
  resource_group_name  = azurerm_resource_group.velo.name
  virtual_network_name = azurerm_virtual_network.velo_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "velo_database" {
  name                 = "velo-database"
  resource_group_name  = azurerm_resource_group.velo.name
  virtual_network_name = azurerm_virtual_network.velo_vnet.name
  address_prefixes     = ["10.0.3.0/24"]

  delegation {
    name = "delegation"

    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "azure_bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.velo.name
  virtual_network_name = azurerm_virtual_network.velo_vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

