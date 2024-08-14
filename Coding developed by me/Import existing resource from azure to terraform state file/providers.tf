/*

The following links provide the documentation for the new blocks used
in this terraform configuration file

1. azurerm_resource_group - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group

*/

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.110.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "c956ab6f-b8de-4d31-9179-5096bfe493f4"
  tenant_id = "6dcf4e98-d8d8-4377-9a28-ebcadd8b0acb"
  client_id = "54b8b525-9a0a-4bb2-902b-3cbd5c806d2b"
  client_secret = "rsS8Q~zjRDciHgV1aW~FPMUkVCysfuSP3pzRjbel"
  features {}  
}