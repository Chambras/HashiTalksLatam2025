variable "location" {
  type        = string
  default     = "eastus2"
  description = "Location where the resoruces are going to be created."
}

variable "suffix" {
  type        = string
  default     = "MZ"
  description = "Suffix to use in all resources."
}

variable "mainRGName" {
  type        = string
  default     = "MZVMain"
  description = "VNet Resource Group Name."
}

variable "devVMRGName" {
  type        = string
  default     = "HashitalksLatam2025"
  description = "Dev VMs Resource Group Name."
}

variable "tags" {
  type = map(any)
  default = {
    "Environment" = "Dev"
    "Project"     = "HashitalksLatam2025"
    "BillingCode" = "Internal"
    "Customer"    = "Personal"
  }
  description = "tags to be applied to resources."
}

## Networking variables

locals {
  base_cidr_block = "10.70.0.0/16"
}

variable "mainVNetName" {
  type        = string
  default     = "MZVMain"
  description = "VNet name."
}
variable "subnetName" {
  type        = string
  default     = "dev2"
  description = "Subnet to be in the VNet to be used to create the VM"
}

## Security variables
variable "sgName" {
  type        = string
  default     = "default_RDPSSH_SG"
  description = "Default Security Group Name to be applied by default to VMs and subnets."
}

variable "sourceIPs" {
  type        = list(any)
  default     = ["74.96.174.80"]
  description = "Public IPs to allow inboud communications."
}
