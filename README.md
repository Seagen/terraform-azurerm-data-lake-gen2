## terraform-azurerm-data-lake-gen2

[![Maintainer](https://img.shields.io/badge/maintainer%20-ingenii-orange?style=flat)](https://ingenii.dev/)
[![License](https://img.shields.io/badge/license%20-MPL2.0-orange?style=flat)](https://github.com/ingenii-solutions/terraform-azurerm-data-lake-gen2/blob/main/LICENSE)
[![Contributing](https://img.shields.io/badge/howto%20-contribute-blue?style=flat)](https://github.com/ingenii-solutions/terraform-azurerm-data-lake-gen2/blob/main/CONTRIBUTING.md)
[![Static Code Analysis](https://github.com/ingenii-solutions/terraform-azurerm-data-lake-gen2/actions/workflows/static-code-analysis.yml/badge.svg?branch=main)](https://github.com/ingenii-solutions/terraform-azurerm-data-lake-gen2/actions/workflows/static-code-analysis.yml)
[![Unit Tests](https://github.com/ingenii-solutions/terraform-azurerm-data-lake-gen2/actions/workflows/unit-tests.yml/badge.svg?branch=main)](https://github.com/ingenii-solutions/terraform-azurerm-data-lake-gen2/actions/workflows/unit-tests.yml)

## Description

This module can be used to deploy [Azure Data Lake](https://azure.microsoft.com/en-us/solutions/data-lake/) Storage file
system. The [Data Lake Storage](https://azure.microsoft.com/en-us/services/storage/data-lake-storage/) is just a feature
of an [Azure Storage Account](https://azure.microsoft.com/en-us/services/storage/). Using the module you can also create
containers (directories), paths (sub-directories), network access rules and manage the permissions of the storage
account.

## Requirements

<!--- <<ii-tf-requirements-begin>> -->
| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2 |
<!--- <<ii-tf-requirements-end>> -->

## Example Usage

```terraform
module "data-lake-gen2" {
  source  = "app.terraform.io/Seagen/data-lake-gen2/azurerm"
  version = "x.x.x"

  region               = azurerm_resource_group.rg01.location
  resource_group_name  = azurerm_resource_group.rg01.name
  storage_account_name = "heroqueststore"
  tags                 = local.tags

  data_lake_containers = {
    "bronze" = { ace_scope = "access", ace_type = "user", ace_id = "99331b05-b78e-4c92-9e8a-5c7d42a36c1a", ace_perm = "rwx" },
    "silver" = { ace_scope = "access", ace_type = "user", ace_id = "99331b05-b78e-4c92-9e8a-5c7d42a36c1a", ace_perm = "rwx" },
    "gold"   = { ace_scope = "access", ace_type = "user", ace_id = "99331b05-b78e-4c92-9e8a-5c7d42a36c1a", ace_perm = "rwx" },
  }

  data_lake_container_paths = [
    { container_name = "bronze", path_name = "con01" },
    { container_name = "silver", path_name = "con01" },
    { container_name = "silver", path_name = "con02" },
    { container_name = "gold", path_name = "con01" }
  ]
 
  storage_account_network_acls = {
    bypass                     = ["AzureServices"]
    default_action             = "Deny"
    ip_rules                   = ["any"]
    virtual_network_subnet_ids = []
  }
}
```

## Inputs

<!--- <<ii-tf-inputs-begin>> -->
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_data_lake_containers"></a> [data\_lake\_containers](#input\_data\_lake\_containers) | A list of Data Lake Gen 2 file system container names. | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The Azure Region (location) name where all resources will be deployed. e.g. UKSouth, EastUS. Changes to this value force resources to be recreated. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Azure Resource Group where the all resources will be deployed. | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The name of the storage account. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Key/value pairs of tags that will be applied to all resources in this module. | `map(string)` | n/a | yes |
| <a name="input_data_lake_container_paths"></a> [data\_lake\_container\_paths](#input\_data\_lake\_container\_paths) | Data Lake filesystem paths. | <pre>list(object({<br>    container_name = string<br>    path_name      = string<br>  }))</pre> | `[]` | no |
| <a name="input_storage_account_access_tier"></a> [storage\_account\_access\_tier](#input\_storage\_account\_access\_tier) | The storage account access tier. | `string` | `"Hot"` | no |
| <a name="input_storage_account_blob_public_access_enabled"></a> [storage\_account\_blob\_public\_access\_enabled](#input\_storage\_account\_blob\_public\_access\_enabled) | Allow or deny public access to all blobs or containers in a storage account. | `bool` | `false` | no |
| <a name="input_storage_account_hns_enabled"></a> [storage\_account\_hns\_enabled](#input\_storage\_account\_hns\_enabled) | Enable or disable hierarchical namespace. This is required for Azure Data Lake Storage Gen 2. | `bool` | `true` | no |
| <a name="input_storage_account_kind"></a> [storage\_account\_kind](#input\_storage\_account\_kind) | The storage account type. | `string` | `"StorageV2"` | no |
| <a name="input_storage_account_min_tls_version"></a> [storage\_account\_min\_tls\_version](#input\_storage\_account\_min\_tls\_version) | The minimum TLS version this Storage Account supports. | `string` | `"TLS1_2"` | no |
| <a name="input_storage_account_network_acls"></a> [storage\_account\_network\_acls](#input\_storage\_account\_network\_acls) | Requires a custom object with attributes 'bypass', 'default\_action', 'ip\_rules', 'virtual\_network\_subnet\_ids'. | <pre>object({<br>    bypass                     = list(string)<br>    default_action             = string<br>    ip_rules                   = list(string)<br>    virtual_network_subnet_ids = list(string)<br>  })</pre> | `null` | no |
| <a name="input_storage_account_replication_type"></a> [storage\_account\_replication\_type](#input\_storage\_account\_replication\_type) | The storage account replication type. | `string` | `"RAGRS"` | no |
| <a name="input_storage_account_role_assignments"></a> [storage\_account\_role\_assignments](#input\_storage\_account\_role\_assignments) | A list of objects that define role assignments for the storage account. | <pre>list(<br>    object({<br>      principal_id         = string<br>      role_definition_name = string<br>    })<br>  )</pre> | `[]` | no |
| <a name="input_storage_account_tier"></a> [storage\_account\_tier](#input\_storage\_account\_tier) | The storage account tier. | `string` | `"Standard"` | no |
<!--- <<ii-tf-inputs-end>> -->

## Outputs

<!--- <<ii-tf-outputs-begin>> -->
| Name | Description |
|------|-------------|
| <a name="output_data_lake_containers"></a> [data\_lake\_containers](#output\_data\_lake\_containers) | A map of Azure Data Lake Gen 2 filesystem containers. |
| <a name="output_data_lake_paths"></a> [data\_lake\_paths](#output\_data\_lake\_paths) | A map of Azure Data Lake Gen 2 filesystem paths. |
| <a name="output_storage_account_access_key"></a> [storage\_account\_access\_key](#output\_storage\_account\_access\_key) | The storage account primary and secondary access keys. |
| <a name="output_storage_account_access_tier"></a> [storage\_account\_access\_tier](#output\_storage\_account\_access\_tier) | The storage account access tier. |
| <a name="output_storage_account_account_tier"></a> [storage\_account\_account\_tier](#output\_storage\_account\_account\_tier) | The storage account tire. |
| <a name="output_storage_account_blob_endpoint"></a> [storage\_account\_blob\_endpoint](#output\_storage\_account\_blob\_endpoint) | The primary and secondary Azure Blob endpoints. |
| <a name="output_storage_account_connection_string"></a> [storage\_account\_connection\_string](#output\_storage\_account\_connection\_string) | The storage account primary and secondary connection strings. |
| <a name="output_storage_account_dfs_endpoint"></a> [storage\_account\_dfs\_endpoint](#output\_storage\_account\_dfs\_endpoint) | The primary and secondary Data Lake storage endpoints. |
| <a name="output_storage_account_file_endpoint"></a> [storage\_account\_file\_endpoint](#output\_storage\_account\_file\_endpoint) | The primary and secondary Azure File endpoints. |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | The ID of the Azure Storage Account. |
| <a name="output_storage_account_kind"></a> [storage\_account\_kind](#output\_storage\_account\_kind) | The storage account kind. |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | The name of the Azure Storage Account. |
| <a name="output_storage_account_queue_endpoint"></a> [storage\_account\_queue\_endpoint](#output\_storage\_account\_queue\_endpoint) | The primary and secondary Azure Queue Service endpoints. |
| <a name="output_storage_account_replication_type"></a> [storage\_account\_replication\_type](#output\_storage\_account\_replication\_type) | The storage account replication type. |
| <a name="output_storage_account_static_website_endpoint"></a> [storage\_account\_static\_website\_endpoint](#output\_storage\_account\_static\_website\_endpoint) | The primary and secondary static website endpoint. |
| <a name="output_storage_account_table_endpoint"></a> [storage\_account\_table\_endpoint](#output\_storage\_account\_table\_endpoint) | The primary and secondary Azure Table Service endpoints. |
<!--- <<ii-tf-outputs-end>> -->

## Nested Modules

<!--- <<ii-tf-modules-begin>> -->
No modules.
<!--- <<ii-tf-modules-end>> -->

## Resource Types

<!--- <<ii-tf-resources-begin>> -->
| Name | Type |
|------|------|
| [azurerm_role_assignment.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_data_lake_gen2_filesystem.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_filesystem) | resource |
| [azurerm_storage_data_lake_gen2_path.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_path) | resource |
<!--- <<ii-tf-resources-end>> -->

## Related Modules

* N/A

## Solutions Using This Module

* N/A
