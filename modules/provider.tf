terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.57.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "aks-statefile"
    storage_account_name = "remotebackendstorage"
    container_name       = "remotebackend"
    key                  = "remote.terraform.tfstate"
  }
}

provider "azurerm" {
  features {
  }
}