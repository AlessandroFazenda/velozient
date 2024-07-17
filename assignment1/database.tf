resource "azurerm_mysql_flexible_server" "velo_mysql" {
  name                   = "velo-mysql"
  resource_group_name    = azurerm_resource_group.velo.name
  location               = azurerm_resource_group.velo.location
  administrator_login    = "mysqladmin"
  administrator_password = "1Verycomplexpassword!"
  backup_retention_days  = 7
  delegated_subnet_id    = azurerm_subnet.velo_database.id
  sku_name               = "B_Standard_B2ms"
  zone                   = 2

  storage {
    size_gb = 50
  }
}

resource "azurerm_mysql_flexible_database" "velo_mysql_db" {
  name                = "exampledb"
  resource_group_name = azurerm_resource_group.velo.name
  server_name         = azurerm_mysql_flexible_server.velo_mysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}