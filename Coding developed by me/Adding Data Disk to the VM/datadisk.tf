
resource "azurerm_managed_disk" "datadisk1" {
  name                 = "datadisk1"
  location             = local.location
  resource_group_name  = data.azurerm_resource_group.test-prince.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10

  depends_on = [
    azurerm_windows_virtual_machine.testvm
  ]
}

resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  managed_disk_id    = azurerm_managed_disk.datadisk1.id
  virtual_machine_id = azurerm_windows_virtual_machine.testvm.id
  lun                = 10
  caching            = "ReadWrite"

  depends_on = [
    azurerm_managed_disk.datadisk1,
    azurerm_windows_virtual_machine.testvm
  ]
}
