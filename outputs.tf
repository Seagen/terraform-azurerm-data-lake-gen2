########################################################################################################################
# OUTPUTS
########################################################################################################################
output "storage_account_id" {
  value       = azurerm_storage_account.this.id
  description = "The ID of the Azure Storage Account."
}

output "storage_account_name" {
  value       = azurerm_storage_account.this.name
  description = "The name of the Azure Storage Account."
}

output "storage_account_blob_endpoint" {
  value = {
    primary   = azurerm_storage_account.this.primary_blob_endpoint
    secondary = azurerm_storage_account.this.secondary_blob_endpoint
  }
  description = "The primary and secondary Azure Blob endpoints."
}

output "storage_account_file_endpoint" {
  value = {
    primary   = azurerm_storage_account.this.primary_file_endpoint
    secondary = azurerm_storage_account.this.secondary_file_endpoint
  }
  description = "The primary and secondary Azure File endpoints."
}

output "storage_account_queue_endpoint" {
  value = {
    primary   = azurerm_storage_account.this.primary_queue_endpoint
    secondary = azurerm_storage_account.this.secondary_queue_endpoint
  }
  description = "The primary and secondary Azure Queue Service endpoints."
}

output "storage_account_table_endpoint" {
  value = {
    primary   = azurerm_storage_account.this.primary_table_endpoint
    secondary = azurerm_storage_account.this.secondary_table_endpoint
  }
  description = "The primary and secondary Azure Table Service endpoints."
}

output "storage_account_dfs_endpoint" {
  value = {
    primary   = azurerm_storage_account.this.primary_dfs_endpoint
    secondary = azurerm_storage_account.this.primary_dfs_endpoint
  }
  description = "The primary and secondary Data Lake storage endpoints."
}

output "storage_account_static_website_endpoint" {
  value       = azurerm_storage_account.this.static_website
  description = "The primary and secondary static website endpoint."
}

output "storage_account_access_tier" {
  value       = azurerm_storage_account.this.access_tier
  description = "The storage account access tier."
}

output "storage_account_kind" {
  value       = azurerm_storage_account.this.account_kind
  description = "The storage account kind."
}

output "storage_account_account_tier" {
  value       = azurerm_storage_account.this.account_tier
  description = "The storage account tire."
}

output "storage_account_replication_type" {
  value       = azurerm_storage_account.this.account_replication_type
  description = "The storage account replication type."
}

output "data_lake_containers" {
  value       = try(azurerm_storage_data_lake_gen2_filesystem.this, {})
  description = "A map of Azure Data Lake Gen 2 filesystem containers."
}

output "data_lake_paths" {
  value       = try(azurerm_storage_data_lake_gen2_path.this, {})
  description = "A map of Azure Data Lake Gen 2 filesystem paths."
}

########################################################################################################################
# SENSITIVE OUTPUTS
########################################################################################################################
output "storage_account_access_key" {
  value = {
    primary   = azurerm_storage_account.this.primary_access_key
    secondary = azurerm_storage_account.this.secondary_access_key
  }
  description = "The storage account primary and secondary access keys."
  sensitive   = true
}

output "storage_account_connection_string" {
  value = {
    primary   = azurerm_storage_account.this.primary_connection_string
    secondary = azurerm_storage_account.this.secondary_connection_string
  }
  description = "The storage account primary and secondary connection strings."
  sensitive   = true
}
