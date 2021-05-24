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

data "azurerm_client_config" "current" {}

module "data_lake" {
  source = "../../../"

  region               = azurerm_resource_group.this.location
  resource_group_name  = azurerm_resource_group.this.name
  storage_account_name = local.random_string
  tags                 = local.tags

  data_lake_containers = ["test1", "test2", "test3"]
  data_lake_container_paths = [
    { container_name = "test1", path_name = "test_path1" },
    { container_name = "test2", path_name = "test_path1" },
    { container_name = "test2", path_name = "test_path2" },
    { container_name = "test3", path_name = "test_path1" }
  ]

  storage_account_role_assignments = [
    { principal_id = data.azurerm_client_config.current.object_id, role_definition_name = "Owner" }
  ]

  storage_account_network_acls = {
    bypass                     = ["AzureServices"]
    default_action             = "Deny"
    ip_rules                   = ["any"]
    virtual_network_subnet_ids = []
  }
}

output "random_string" {
  value = local.random_string
}

output "name" {
  value = module.data_lake.storage_account_name
}