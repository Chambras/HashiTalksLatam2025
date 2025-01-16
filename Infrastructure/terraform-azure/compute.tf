resource "azurerm_public_ip" "mainDevPublicIP" {
  name                = "${var.suffix}${var.mainDevVMName}${var.publicIPName}"
  location            = azurerm_resource_group.devVMRG.location
  resource_group_name = azurerm_resource_group.devVMRG.name
  allocation_method   = var.publicIPAllocation

  tags = var.tags
}

resource "azurerm_network_interface" "mainDevNI" {
  name                = "${var.suffix}${var.mainDevVMName}${var.networkInterfaceName}"
  location            = azurerm_resource_group.devVMRG.location
  resource_group_name = azurerm_resource_group.devVMRG.name

  ip_configuration {
    name                          = "${var.suffix}${var.mainDevVMName}IPConf"
    subnet_id                     = azurerm_subnet.dev.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mainDevPublicIP.id
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "mainDevSG" {
  network_interface_id      = azurerm_network_interface.mainDevNI.id
  network_security_group_id = azurerm_network_security_group.genericNSG.id
}

resource "azurerm_linux_virtual_machine" "mainDevVM" {
  name                = "${var.suffix}${var.mainDevVMName}"
  resource_group_name = azurerm_resource_group.devVMRG.name
  location            = azurerm_resource_group.devVMRG.location
  size                = var.vmSize
  admin_username      = var.vmUserName
  network_interface_ids = [
    azurerm_network_interface.mainDevNI.id,
  ]

  admin_ssh_key {
    username   = var.vmUserName
    public_key = file(var.sshKeyPath)
  }

  os_disk {
    name                 = "${var.suffix}${var.mainDevVMName}OSDisk"
    caching              = "ReadWrite"
    storage_account_type = var.osDisk
    disk_size_gb         = var.vmDiskSize
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = var.sku
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = "https://mzvperstrgccnt.blob.core.windows.net/"
  }

  # This is to ensure SSH comes up before we run the local exec.
  provisioner "remote-exec" {
    inline = ["echo 'Hello World'"]

    connection {
      type        = "ssh"
      host        = azurerm_public_ip.mainDevPublicIP.ip_address
      user        = var.vmUserName
      private_key = file(var.sshPrvtKeyPath)
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${azurerm_public_ip.mainDevPublicIP.ip_address},' -u ${var.vmUserName} --private-key ${var.sshPrvtKeyPath} ../../Ansible/devVM/mainDev.yml"
  }

  tags = var.tags
}


resource "azurerm_dev_test_global_vm_shutdown_schedule" "autoshutdownVM" {
  virtual_machine_id = azurerm_linux_virtual_machine.mainDevVM.id
  location           = azurerm_resource_group.devVMRG.location
  enabled            = true

  daily_recurrence_time = "1830"
  timezone              = "Eastern Standard Time"

  notification_settings {
    enabled = false

  }

  tags = var.tags
}
