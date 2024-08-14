resource "azurerm_network_security_group" "APPNSG" {
  name                = "APPNSG"
  location            = local.location
  resource_group_name = local.resource_group_name
  
  depends_on = [
    azurerm_resource_group.test-grp
  ]

}

resource "azurerm_network_security_rule" "appnsg-rule" {
  name                        = "RDP_block"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.test-grp.name
  network_security_group_name = azurerm_network_security_group.APPNSG.name
}

resource "azurerm_virtual_network" "app-network" {
  name                = local.virtual_network.name
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.app-network.name
  address_prefixes     = ["10.0.1.0/24"]
}

