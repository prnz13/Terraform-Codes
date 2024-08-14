
resource "azurerm_network_interface" "testvm-nic" {
  name                = "testvm-nic"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "testvm-ip"
    subnet_id                     = azurerm_subnet.subnet2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.testvmpublicip.id
  }
}

  resource "azurerm_public_ip" "testvmpublicip" {
  name                = "testvmpublicip"
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = "Static"

  }

resource "azurerm_windows_virtual_machine" "testvm" {
  name                = "testvm"
  resource_group_name = local.resource_group_name
  location            = local.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.testvm-nic.id,
  ]

    depends_on = [
    azurerm_resource_group.test-grp,
    azurerm_virtual_network.app-network
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

    tags = {
    NAME = "USPRD"
  }

}