resource "azurerm_resource_group" "test-grp" {
  name     = local.resource_group_name
  location = local.location
}