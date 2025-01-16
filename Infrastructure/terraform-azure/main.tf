terraform {
  cloud {
    organization = "zambrana"

    workspaces {
      name    = "HashiTalksLatam2025"
      project = "Hashitalks"
    }
  }
  required_version = ">= 1.10.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.14.0"
    }
  }
}


provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "devVMRG" {
  name     = "${var.suffix}${var.devVMRGName}"
  location = var.location
  tags     = var.tags
}
