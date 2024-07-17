resource "azurerm_network_security_group" "velo_frontend_nsg" {
  name                = "velo-frontend-nsg"
  location            = azurerm_resource_group.velo.location
  resource_group_name = azurerm_resource_group.velo.name

  security_rule {
    name                         = "Allow-SSH"
    priority                     = 100
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "22"
    source_address_prefixes      = azurerm_subnet.azure_bastion_subnet.address_prefixes
    destination_address_prefixes = azurerm_subnet.velo_frontend.address_prefixes
  }

  security_rule {
    name                         = "Allow-HTTP"
    priority                     = 200
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "80"
    source_address_prefix        = "AzureLoadBalancer"
    destination_address_prefixes = azurerm_subnet.velo_frontend.address_prefixes
  }

  security_rule {
    name                         = "Allow-HTTPS"
    priority                     = 201
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_address_prefix        = "AzureLoadBalancer"
    destination_address_prefixes = azurerm_subnet.velo_frontend.address_prefixes
  }
}

resource "azurerm_network_security_group" "velo_backend_nsg" {
  name                = "velo-backend-nsg"
  location            = azurerm_resource_group.velo.location
  resource_group_name = azurerm_resource_group.velo.name

  security_rule {
    name                         = "Allow-SSH"
    priority                     = 100
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "22"
    source_address_prefixes      = azurerm_subnet.azure_bastion_subnet.address_prefixes
    destination_address_prefixes = azurerm_subnet.velo_frontend.address_prefixes
  }

  security_rule {
    name                         = "Allow-Port-5000"
    priority                     = 200
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "5000"
    source_address_prefixes      = azurerm_subnet.velo_frontend.address_prefixes
    destination_address_prefixes = azurerm_subnet.velo_backend.address_prefixes
  }
}

resource "azurerm_network_security_group" "velo_database_nsg" {
  name                = "velo-database-nsg"
  location            = azurerm_resource_group.velo.location
  resource_group_name = azurerm_resource_group.velo.name

  security_rule {
    name                         = "Allow-MySQL"
    priority                     = 100
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "3306"
    source_address_prefixes      = azurerm_subnet.velo_backend.address_prefixes
    destination_address_prefixes = azurerm_subnet.velo_database.address_prefixes
  }
}

resource "azurerm_subnet_network_security_group_association" "velo_frontend_nsg_association" {
  subnet_id                 = azurerm_subnet.velo_frontend.id
  network_security_group_id = azurerm_network_security_group.velo_frontend_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "velo_backend_nsg_association" {
  subnet_id                 = azurerm_subnet.velo_backend.id
  network_security_group_id = azurerm_network_security_group.velo_backend_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "velo_database_nsg_association" {
  subnet_id                 = azurerm_subnet.velo_database.id
  network_security_group_id = azurerm_network_security_group.velo_database_nsg.id
}
