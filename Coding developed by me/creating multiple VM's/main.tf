/*
import {
 to = azurerm_resource_group.prince-test.main
 id = "/subscriptions/c956ab6f-b8de-4d31-9179-5096bfe493f4/resourceGroups/prince-test"
}
*/

resource "azurerm_resource_group" "test-grp" {
  name     = local.resource_group_name
  location = local.location
}

