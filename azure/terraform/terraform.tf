terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.23.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}
