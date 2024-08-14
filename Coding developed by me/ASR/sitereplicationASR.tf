resource "azurerm_resource_group" "test-prince-ASR" {
  name     = "test-prince-ASR"
  location = "South India"
}

data "azurerm_virtual_machine" "testvm" {
  name                = "testvm"
  resource_group_name = azurerm_resource_group.test-prince-ASR.name
}

data "azurerm_managed_disk" "testvm_os_disk" {
  name                = data.azurerm_virtual_machine.testvm.storage_os_disk[0].name
  resource_group_name = azurerm_resource_group.test-prince-ASR.name
}

resource "azurerm_recovery_services_vault" "vault" {
  name                = "vault-test"
  location            = "South India"
  resource_group_name = azurerm_resource_group.test-prince-ASR.name
  sku                 = "Standard"
}

resource "azurerm_site_recovery_fabric" "primary" {
  name                = "primary-fabric"
  resource_group_name = azurerm_resource_group.test-prince-ASR.name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  location            = "Central India"
}

resource "azurerm_site_recovery_fabric" "secondary" {
  name                = "secondary-fabric"
  resource_group_name = azurerm_resource_group.test-prince-ASR.name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  location            = "South India"
}

resource "azurerm_site_recovery_protection_container" "primary" {
  name                 = "primary-protection-container"
  resource_group_name  = azurerm_resource_group.test-prince-ASR.name
  recovery_vault_name  = azurerm_recovery_services_vault.vault.name
  recovery_fabric_name = azurerm_site_recovery_fabric.primary.name
}

resource "azurerm_site_recovery_protection_container" "secondary" {
  name                 = "secondary-protection-container"
  resource_group_name  = azurerm_resource_group.test-prince-ASR.name
  recovery_vault_name  = azurerm_recovery_services_vault.vault.name
  recovery_fabric_name = azurerm_site_recovery_fabric.secondary.name
}

resource "azurerm_site_recovery_replication_policy" "policy" {
  name                                                 = "policy"
  resource_group_name                                  = azurerm_resource_group.test-prince-ASR.name
  recovery_vault_name                                  = azurerm_recovery_services_vault.vault.name
  recovery_point_retention_in_minutes                  = 24 * 60
  application_consistent_snapshot_frequency_in_minutes = 4 * 60
}

resource "azurerm_site_recovery_protection_container_mapping" "container-mapping" {
  name                                      = "container-mapping"
  resource_group_name                       = azurerm_resource_group.test-prince-ASR.name
  recovery_vault_name                       = azurerm_recovery_services_vault.vault.name
  recovery_fabric_name                      = azurerm_site_recovery_fabric.primary.name
  recovery_source_protection_container_name = azurerm_site_recovery_protection_container.primary.name
  recovery_target_protection_container_id   = azurerm_site_recovery_protection_container.secondary.id
  recovery_replication_policy_id            = azurerm_site_recovery_replication_policy.policy.id
}

resource "azurerm_site_recovery_network_mapping" "network-mapping" {
  name                        = "network-mapping"
  resource_group_name         = azurerm_resource_group.test-prince-ASR.name
  recovery_vault_name         = azurerm_recovery_services_vault.vault.name
  source_recovery_fabric_name = azurerm_site_recovery_fabric.primary.name
  target_recovery_fabric_name = azurerm_site_recovery_fabric.secondary.name
  source_network_id           = azurerm_virtual_network.primary.id
  target_network_id           = azurerm_virtual_network.secondary.id
}

resource "azurerm_storage_account" "primary" {
  name                     = "primaryrecoverycache"
  location                 = "Central India"
  resource_group_name      = azurerm_resource_group.test-prince-ASR.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_virtual_network" "primary" {
  name                = "network1"
  resource_group_name = azurerm_resource_group.test-prince-ASR.name
  address_space       = ["192.168.1.0/24"]
  location            = "Central India"
}

resource "azurerm_virtual_network" "secondary" {
  name                = "network2"
  resource_group_name = azurerm_resource_group.test-prince-ASR.name
  address_space       = ["192.168.2.0/24"]
  location            = azurerm_resource_group.test-prince-ASR.location
}

resource "azurerm_subnet" "primary" {
  name                 = "network1-subnet"
  resource_group_name  = azurerm_resource_group.test-prince-ASR.name
  virtual_network_name = azurerm_virtual_network.primary.name
  address_prefixes     = ["192.168.1.0/24"]
}

resource "azurerm_subnet" "secondary" {
  name                 = "network2-subnet"
  resource_group_name  = azurerm_resource_group.test-prince-ASR.name
  virtual_network_name = azurerm_virtual_network.secondary.name
  address_prefixes     = ["192.168.2.0/24"]
}

resource "azurerm_public_ip" "primary" {
  name                = "vm-public-ip-primary"
  allocation_method   = "Static"
  location            = "Central India"
  resource_group_name = azurerm_resource_group.test-prince-ASR.name
  sku                 = "Basic"
}

resource "azurerm_public_ip" "secondary" {
  name                = "vm-public-ip-secondary"
  allocation_method   = "Static"
  location            = azurerm_resource_group.test-prince-ASR.location
  resource_group_name = azurerm_resource_group.test-prince-ASR.name
  sku                 = "Basic"
}

resource "azurerm_network_interface" "vm" {
  name                = "vm-nic"
  location            = "Central India"
  resource_group_name = azurerm_resource_group.test-prince-ASR.name

  ip_configuration {
    name                          = "vm"
    subnet_id                     = azurerm_subnet.primary.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.primary.id
  }
}

resource "azurerm_site_recovery_replicated_vm" "vm-replication" {
  name                                      = "vm-replication"
  resource_group_name                       = azurerm_resource_group.test-prince-ASR.name
  recovery_vault_name                       = azurerm_recovery_services_vault.vault.name
  source_recovery_fabric_name               = azurerm_site_recovery_fabric.primary.name
  source_vm_id                              = data.azurerm_virtual_machine.testvm.id
  recovery_replication_policy_id            = azurerm_site_recovery_replication_policy.policy.id
  source_recovery_protection_container_name = azurerm_site_recovery_protection_container.primary.name

  target_resource_group_id                = azurerm_resource_group.test-prince-ASR.id
  target_recovery_fabric_id               = azurerm_site_recovery_fabric.secondary.id
  target_recovery_protection_container_id = azurerm_site_recovery_protection_container.secondary.id

  managed_disk {
    disk_id                    = data.azurerm_managed_disk.testvm_os_disk.id
    staging_storage_account_id = azurerm_storage_account.primary.id
    target_resource_group_id   = azurerm_resource_group.test-prince-ASR.id
    target_disk_type           = "Premium_LRS"
    target_replica_disk_type   = "Premium_LRS"
  }

  network_interface {
    source_network_interface_id   = azurerm_network_interface.vm.id
    target_subnet_name            = azurerm_subnet.secondary.name
    recovery_public_ip_address_id = azurerm_public_ip.secondary.id
  }

  depends_on = [
    azurerm_site_recovery_protection_container_mapping.container-mapping,
    azurerm_site_recovery_network_mapping.network-mapping,
  ]
}
