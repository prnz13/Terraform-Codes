
import {
 to = azurerm_resource_group.test-prince
 id = "/subscriptions/c956ab6f-b8de-4d31-9179-5096bfe493f4/resourceGroups/test-prince"
}

resource "azurerm_resource_group" "test-prince1" {
  name     = "test-prince"
  location = "Central India"
}

