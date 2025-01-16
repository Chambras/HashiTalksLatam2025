variable "vmSize" {
  type    = string
  default = "Standard_D8as_v6"
  # default     = "Standard_D2as_v4"
  description = "VM size."
}

variable "osDisk" {
  type        = string
  default     = "StandardSSD_LRS"
  description = "The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS and Premium_LRS"
}

variable "vmDiskSize" {
  type        = string
  default     = "300"
  description = "The size of the VM's OS disk in GB."
}

variable "mainDevVMName" {
  type        = string
  default     = "HashiTalksServer"
  description = "Default JumpBox VM server name."
}

variable "vmUserName" {
  type        = string
  default     = "marcelo"
  description = "Username to be added to the VM."
}

variable "sshKeyPath" {
  type        = string
  default     = "~/.ssh/vm_ssh.pub"
  description = "SSH Key to use when creating the VM."
}

variable "sshPrvtKeyPath" {
  type        = string
  default     = "~/.ssh/vm_ssh"
  description = "Private SSH Key to use when creating the VM."
  sensitive   = false
}

variable "publicIPName" {
  type        = string
  default     = "PublicIP"
  description = "Default Public IP name."
}

variable "publicIPAllocation" {
  type        = string
  default     = "Static"
  description = "Default Public IP allocation. Could be Static or Dynamic."
}

variable "networkInterfaceName" {
  type        = string
  default     = "NIC"
  description = "Default Windows Network Interface Name."
}

variable "sku" {
  type        = string
  default     = "server"
  description = "VM OS version to be used."
}
