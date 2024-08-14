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

resource "azurerm_virtual_network" "appvnet" {
  name                = local.virtual_network.name
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = ["10.0.0.0/16"]
  
  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.APPNSG.id
  }

  tags = {
    environment = "Production"
  }
}
