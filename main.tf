provider "azurerm" {
  features = {}
}

resource "azurerm_resource_group" "openshiftsandbox" {
  name     = "openshiftsandbox"
  location = "UK South"
}
