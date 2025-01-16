## Create Network
resource "azurerm_virtual_network" "mainVNet" {
  name                = "${var.suffix}${var.mainVNetName}"
  location            = azurerm_resource_group.devVMRG.location
  resource_group_name = azurerm_resource_group.devVMRG.name
  address_space       = [local.base_cidr_block]

  tags = var.tags
}

resource "azurerm_subnet" "dev" {
  name                 = var.subnetName
  resource_group_name  = azurerm_resource_group.devVMRG.name
  virtual_network_name = azurerm_virtual_network.mainVNet.name
  address_prefixes     = [cidrsubnet(local.base_cidr_block, 8, 1)]
}
