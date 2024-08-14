locals {
  resource_group_name="test-grp"
  location="West Europe"
  virtual_network = {
    name="app-network"
    address_space="10.0.0.0/16"
}
}

