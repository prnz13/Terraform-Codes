resource "azurerm_resource_group" "test-grp" {
  name     = local.resource_group_name
  location = local.location
}

resource "azurerm_storage_account" "appstore55698232212122" {
  name                     = "appstore55698232212122"
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  
  tags = {
    NAME = "test-grp"
  }
}
