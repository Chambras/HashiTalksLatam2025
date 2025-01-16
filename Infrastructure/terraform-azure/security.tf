resource "azurerm_network_security_group" "genericNSG" {
  name                = "${var.suffix}${var.mainDevVMName}${var.sgName}"
  location            = azurerm_resource_group.devVMRG.location
  resource_group_name = azurerm_resource_group.devVMRG.name

  security_rule {
    name                   = "SSH"
    priority               = 100
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "22"
    source_address_prefix  = "*"
    # source_address_prefixes    = var.sourceIPs
    destination_address_prefix = "VirtualNetwork"
  }

  tags = var.tags
}
