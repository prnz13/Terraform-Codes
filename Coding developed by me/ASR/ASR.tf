
# Create a Resource Group
resource "azurerm_resource_group" "example" {
  name     = "test-asr"
  location = "South india"
}

#Create a Recovery Services Vault
resource "azurerm_recovery_services_vault" "example" {
  name                = "exampleRecoveryServicesVault"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Standard"
}

#Create a Site Recovery Fabric and Protection Container

resource "azurerm_site_recovery_fabric" "example" {
  name                = "exampleSiteRecoveryFabric"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  vault_name          = azurerm_recovery_services_vault.example.name
  type                = "Azure"
}

resource "azurerm_site_recovery_protection_container" "example" {
  name                = "exampleProtectionContainer"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  vault_name          = azurerm_recovery_services_vault.example.name
  fabric_name         = azurerm_site_recovery_fabric.example.name
}

# Create a Replication Policy

resource "azurerm_site_recovery_policy" "example" {
  name                = "exampleSiteRecoveryPolicy"
  resource_group_name = azurerm_resource_group.example.name
  vault_name          = azurerm_recovery_services_vault.example.name
  replication_policy {
    recovery_point_retention = 24
    app_consistent_snapshot_frequency = 4
  }
}


#Create the VM (assuming it exists, reference it for replicatio

data "azurerm_virtual_machine" "example" {
  name                = "existingVMName"
  resource_group_name = "existingVMResourceGroup"
}


#Create Replication Protection Container Mapping
resource "azurerm_site_recovery_protection_container_mapping" "example" {
  name                = "exampleProtectionContainerMapping"
  resource_group_name = azurerm_resource_group.example.name
  vault_name          = azurerm_recovery_services_vault.example.name
  primary_fabric_name = azurerm_site_recovery_fabric.example.name
  primary_protection_container_name = azurerm_site_recovery_protection_container.example.name
  recovery_fabric_name = azurerm_site_recovery_fabric.example.name
  recovery_protection_container_name = azurerm_site_recovery_protection_container.example.name
  policy_id           = azurerm_site_recovery_policy.example.id
}

#Enable Replication for the VM

resource "azurerm_site_recovery_replication_protected_item" "example" {
  name                = "exampleReplicationProtectedItem"
  resource_group_name = azurerm_resource_group.example.name
  vault_name          = azurerm_recovery_services_vault.example.name
  source_recovery_fabric_name = azurerm_site_recovery_fabric.example.name
  source_protection_container_name = azurerm_site_recovery_protection_container.example.name
  source_replication_provider_id = data.azurerm_virtual_machine.example.id
  policy_id           = azurerm_site_recovery_policy.example.id
}




