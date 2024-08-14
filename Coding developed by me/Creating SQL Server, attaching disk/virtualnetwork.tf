
# Data block to fetch the existing resource group
data "azurerm_resource_group" "test-prince" {
  name = "test-prince"
}

# Data block to fetch the existing virtual network
data "azurerm_virtual_network" "test-prince-vnet" {
  name                = "test-prince-vnet"
  resource_group_name = data.azurerm_resource_group.test-prince.name
}

# Data block to fetch the existing subnet
data "azurerm_subnet" "subnet2" {
  name                 = "default"
  resource_group_name  = data.azurerm_resource_group.test-prince.name
  virtual_network_name = data.azurerm_virtual_network.test-prince-vnet.name
}


# Data block to fetch the existing network security group
data "azurerm_network_security_group" "APPNSG-test" {
  name                = "APPNSG-test"
  resource_group_name = data.azurerm_resource_group.test-prince.name
}

# Resource block to create a new network security rule
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
  resource_group_name         = data.azurerm_resource_group.test-prince.name
  network_security_group_name = data.azurerm_network_security_group.APPNSG-test.name
}


