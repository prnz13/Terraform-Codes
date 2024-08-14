data "azurerm_resource_group" "test-prince" {
  name = "test-prince"
}

resource "azurerm_storage_account" "example" {
  name                     = "storatname8624521"
  resource_group_name      = data.azurerm_resource_group.test-prince.name
  location                 = "Central India"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    NAME = "storatname8624521"
  }
}