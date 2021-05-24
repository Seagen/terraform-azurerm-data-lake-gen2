terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  tags = {
    Owner       = "Ingenii"
    Environment = "Development"
    Description = "This resources belongs to automated testing environment."
  }
  random_string = lower(random_string.this.result)
}

resource "random_string" "this" {
  length  = 8
  number  = false
  special = false
}

resource "azurerm_resource_group" "this" {
  location = "UKSouth"
  name     = local.random_string
}

module "data_lake" {
  source = "../../../"

  region               = azurerm_resource_group.this.location
  resource_group_name  = azurerm_resource_group.this.name
  storage_account_name = local.random_string
  tags                 = local.tags

  data_lake_containers = ["test1", "test2", "test3"]
}

output "random_string" {
  value = local.random_string
}

output "name" {
  value = module.data_lake.storage_account_name
}