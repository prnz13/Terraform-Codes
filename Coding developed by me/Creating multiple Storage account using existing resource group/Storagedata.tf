
resource "azurerm_storage_account" "example" {
  count = 3
  name                     = "storatname86221${count.index + 1}"
  resource_group_name      = data.azurerm_resource_group.test-prince.name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    NAME = "storatname86221${count.index + 1}"
  }
}

