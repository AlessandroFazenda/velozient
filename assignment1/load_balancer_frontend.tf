resource "azurerm_public_ip" "velo_frontend_lb_public_ip" {
  name                = "velo-frontend-lb-public-ip"
  location            = azurerm_resource_group.velo.location
  resource_group_name = azurerm_resource_group.velo.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "velo_frontend_lb" {
  name                = "velo-frontend-lb"
  location            = azurerm_resource_group.velo.location
  resource_group_name = azurerm_resource_group.velo.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "FrontendLBIPAddress"
    public_ip_address_id = azurerm_public_ip.velo_frontend_lb_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "velo_frontend_lb_backend_pool" {
  loadbalancer_id = azurerm_lb.velo_frontend_lb.id
  name            = "FrontendPool"
}

resource "azurerm_lb_probe" "velo_https_probe" {
  loadbalancer_id     = azurerm_lb.velo_frontend_lb.id
  name                = "https-probe"
  protocol            = "Https"
  request_path        = "/"
  port                = 443
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "velo_https_lb_rule" {
  loadbalancer_id                = azurerm_lb.velo_frontend_lb.id
  name                           = "HTTPS"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "FrontendLBIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.velo_frontend_lb_backend_pool.id]
  probe_id                       = azurerm_lb_probe.velo_https_probe.id
}

resource "azurerm_lb_probe" "velo_http_probe" {
  loadbalancer_id     = azurerm_lb.velo_frontend_lb.id
  name                = "http-probe"
  protocol            = "Http"
  request_path        = "/"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "velo_http_lb_rule" {
  loadbalancer_id                = azurerm_lb.velo_frontend_lb.id
  name                           = "HTTP"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "FrontendLBIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.velo_frontend_lb_backend_pool.id]
  probe_id                       = azurerm_lb_probe.velo_http_probe.id
}
