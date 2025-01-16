provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "TestRG" {
  name     = "TestRG"
  location = "eastus2"
}
