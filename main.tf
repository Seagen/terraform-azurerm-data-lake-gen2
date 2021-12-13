########################################################################################################################
# Local Values
########################################################################################################################
locals {
  # Returns 'true' if the word 'any' exists in the IP rules list.
  is_any_acl_present = try(
    contains(var.storage_account_network_acls.ip_rules, "any"),
    false
  )

  /* storage_account_network_acls
  Description: Returns a specific object that sets the Firewall of the storage account to a disabled state if no custom
  Firewall rules are defined or if the word 'any' exists in the Firewall IP rules.

  Example Outputs:
  [
    {
      bypass = ["AzureServices],
      default_action = "Allow",
      ip_rules = [],
      virtual_network_subnet_ids = []
    }
  ]
  */
  storage_account_network_acls = [
    local.is_any_acl_present || var.storage_account_network_acls == null ? {
      bypass                     = ["AzureServices"],
      default_action             = "Allow",
      ip_rules                   = [],
      virtual_network_subnet_ids = []
    } : var.storage_account_network_acls
  ]

  /* storage_account_role_assignments_hash_map
  Description: If any role assignments are provided as inputs, this local variable will loop through each assignment and
  it will generate a map of hashed keys and assignment values as shown below.

  Example Outputs:
  {
    "283bad9a002455a5f2cad5758540b278" = { principal_id = 'xxx', role_definition_name = 'Example' },
    "431bad9a002455a5f2cad5758540b271" = { principal_id = 'yyy', role_definition_name = 'Example' }
  }
  */
  storage_account_role_assignments_hash_map = {
    for assignment in var.storage_account_role_assignments :
    md5("${assignment.principal_id}${assignment.role_definition_name}") => assignment
  }

  data_lake_containers = {
    for container_object in var.data_lake_containers :
    md5("${container_object.container_name}${container_object.ace_scope}${container_object.ace_type}${container_object.ace_id}${container_object.ace_perm})") => container_object
  }


  data_lake_container_paths = {
    for path_object in var.data_lake_container_paths :
    md5("${path_object.container_name}${path_object.path_name})") => path_object
  }
}

########################################################################################################################
# Azure Storage Account
########################################################################################################################
resource "azurerm_storage_account" "this" {
  location                  = var.region
  resource_group_name       = var.resource_group_name
  tags                      = var.tags
  name                      = var.storage_account_name
  access_tier               = var.storage_account_access_tier
  account_replication_type  = var.storage_account_replication_type
  account_tier              = var.storage_account_tier
  account_kind              = var.storage_account_kind
  allow_blob_public_access  = var.storage_account_blob_public_access_enabled
  is_hns_enabled            = var.storage_account_hns_enabled
  min_tls_version           = var.storage_account_min_tls_version
  enable_https_traffic_only = true

  dynamic "network_rules" {
    for_each = local.storage_account_network_acls
    iterator = acl
    content {
      bypass                     = acl.value.bypass
      default_action             = acl.value.default_action
      ip_rules                   = acl.value.ip_rules
      virtual_network_subnet_ids = acl.value.virtual_network_subnet_ids
    }
  }
}

########################################################################################################################
# Azure Storage Data Lake
########################################################################################################################
resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  for_each           = local.data_lake_containers
  storage_account_id = azurerm_storage_account.this.id
  name               = each.container_name
  ace {
    scope       = each.value.ace_scope
    type        = each.value.ace_type
    id          = each.value.ace_id
    permissions = each.value.ace_perm
  }
}

resource "azurerm_storage_data_lake_gen2_path" "this" {
  for_each           = local.data_lake_container_paths
  storage_account_id = azurerm_storage_account.this.id
  path               = each.value.path_name
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.this[each.value.container_name].name
  resource           = try(each.value.resource_type, "directory")
}

########################################################################################################################
# Azure Role Assignment
########################################################################################################################
resource "azurerm_role_assignment" "main" {
  for_each             = local.storage_account_role_assignments_hash_map
  scope                = azurerm_storage_account.this.id
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}