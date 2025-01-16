output "devVMsRGName" {
  value       = azurerm_resource_group.devVMRG.name
  description = "Resource Group Name."
}

output "public_ip_address" {
  value       = azurerm_public_ip.mainDevPublicIP.ip_address
  description = "Public IP Address."
}

output "private_ip_address" {
  value       = azurerm_network_interface.mainDevNI.private_ip_address
  description = "Private IP Address."
}

output "sshAccess" {
  description = "Command to ssh into the VM."
  value       = <<SSHCONFIG
  ssh ${var.vmUserName}@${azurerm_public_ip.mainDevPublicIP.ip_address} -i ${trimsuffix(var.sshKeyPath, ".pub")}
  SSHCONFIG
}
