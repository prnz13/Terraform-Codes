resource "azurerm_managed_disk" "manageddatadisk" {
  name                 = "manageddatadisk-disk1"
  location             = local.location
  resource_group_name  = local.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "manageddatadisk" {
  managed_disk_id    = azurerm_managed_disk.manageddatadisk.id
  virtual_machine_id = azurerm_windows_virtual_machine.testvm.id
  lun                = "5"
  caching            = "ReadWrite"
}
