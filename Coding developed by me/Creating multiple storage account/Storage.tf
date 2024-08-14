resource "azurerm_storage_account" "appstore5569856987412" {
  count = 3
  name                     = "appstoreapppprdddd0${count.index + 1}"
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  depends_on = [
    azurerm_resource_group.test-grp
  ]
/*
  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["100.0.0.1"]
    virtual_network_subnet_ids = [azurerm_subnet.example.id]
  }
*/

  tags = {
    NAME = "test-grp"
  }
}

/*
resource "azurerm_storage_account_network_rules" "Storage account networkrule" {
  storage_account_id = azurerm_storage_account.${count.index + 1}.id

  default_action             = "Allow"
  ip_rules                   = ["127.0.0.1"]
  virtual_network_subnet_ids = [azurerm_subnet.subnet2.id]
  bypass                     = ["Metrics"]
}

*/

/*
resource "azurerm_storage_account" "appstore5569856987412" {
  name                     = "$appstore5569856987412"
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  depends_on = [
    azurerm_resource_group.test-grp
  ]
  tags = {
    NAME = "test-grp"
  }
*/