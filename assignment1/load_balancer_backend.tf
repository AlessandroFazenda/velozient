resource "azurerm_lb" "velo_backend_lb" {
  name                = "velo-backend-lb"
  location            = azurerm_resource_group.velo.location
  resource_group_name = azurerm_resource_group.velo.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "BackendLBIPAddress"
    subnet_id                     = azurerm_subnet.velo_backend.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb_backend_address_pool" "velo_backend_lb_backend_pool" {
  loadbalancer_id = azurerm_lb.velo_backend_lb.id
  name            = "BackendPool"
}

resource "azurerm_lb_probe" "velo_app_probe" {
  loadbalancer_id     = azurerm_lb.velo_backend_lb.id
  name                = "App-probe"
  protocol            = "Https"
  request_path        = "/"
  port                = 5000
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "velo_app_lb_rule" {
  loadbalancer_id                = azurerm_lb.velo_backend_lb.id
  name                           = "HTTPS"
  protocol                       = "Tcp"
  frontend_port                  = 5000
  backend_port                   = 5000
  frontend_ip_configuration_name = "BackendLBIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.velo_backend_lb_backend_pool.id]
  probe_id                       = azurerm_lb_probe.velo_app_probe.id
}
