########################################################################################################################
# REQUIRED INPUTS
########################################################################################################################
variable "tags" {
  type        = map(string)
  description = "Key/value pairs of tags that will be applied to all resources in this module."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group where the all resources will be deployed."
}

variable "region" {
  type        = string
  description = "The Azure Region (location) name where all resources will be deployed. e.g. UKSouth, EastUS. Changes to this value force resources to be recreated."
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account."
  validation {
    condition     = length(var.storage_account_name) > 3 && length(var.storage_account_name) < 24 && lower(var.storage_account_name) == var.storage_account_name
    error_message = "The storage account name should only contain lowercase letters, numbers and must be between 3 and 24 characters long."
  }
}

variable "data_lake_containers" {
  type = map(object({
    ace_scope      = string
    ace_type       = string
    ace_id         = string
    ace_perm       = string
  }))
  description = "A list of Data Lake Gen 2 file system container names and ACL permissions."
}

# variable "data_lake_containers" {
#   type        = list(string)
#   description = "A list of Data Lake Gen 2 file system container names."
# }

########################################################################################################################
# OPTIONAL INPUTS
########################################################################################################################
## Storage Account Properties
variable "storage_account_access_tier" {
  type        = string
  description = "The storage account access tier."
  default     = "Hot"
  validation {
    condition     = contains(["Hot", "Cold"], var.storage_account_access_tier)
    error_message = "You can only specify one of the following Storage Account Access Tiers Types: Hot or Cold."
  }
}

variable "storage_account_replication_type" {
  type        = string
  description = "The storage account replication type."
  default     = "RAGRS"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.storage_account_replication_type)
    error_message = "You can only specify one of the following Storage Account Replication Types: LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS."
  }
}

variable "storage_account_tier" {
  type        = string
  description = "The storage account tier."
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "You can only specify one of the following Storage Account Tiers: Standard and Premium."
  }
}

variable "storage_account_kind" {
  type        = string
  description = "The storage account type."
  default     = "StorageV2"
  validation {
    condition     = contains(["BlobStorage", "BlockBlobStorage", "FileStorage", "Storage", "StorageV2"], var.storage_account_kind)
    error_message = "You can only specify one of the following Storage Account Kinds: BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2."
  }
}

variable "storage_account_blob_public_access_enabled" {
  type        = bool
  description = "Allow or deny public access to all blobs or containers in a storage account."
  default     = false
}

variable "storage_account_hns_enabled" {
  type        = bool
  description = "Enable or disable hierarchical namespace. This is required for Azure Data Lake Storage Gen 2."
  default     = true
}

variable "storage_account_min_tls_version" {
  type        = string
  description = "The minimum TLS version this Storage Account supports."
  default     = "TLS1_2"
  validation {
    # TLS1_0 and TLS1_1 are also valid options, but since they are no longer considered secure, we have removed them from the list of allowed versions.
    condition     = contains(["TLS1_2", "TLS1_3"], var.storage_account_min_tls_version)
    error_message = "You can only specify one of the following Storage Account Minimum TLS Versions: TSL1_2 and TLS1_3."
  }
}

variable "storage_account_network_acls" {
  type = object({
    bypass                     = list(string)
    default_action             = string
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
  })

  description = "Requires a custom object with attributes 'bypass', 'default_action', 'ip_rules', 'virtual_network_subnet_ids'."
  default     = null
}

variable "storage_account_role_assignments" {
  type = list(
    object({
      principal_id         = string
      role_definition_name = string
    })
  )
  description = "A list of objects that define role assignments for the storage account."
  default     = []
}

variable "data_lake_container_paths" {
  type = list(object({
    container_name = string
    path_name      = string
  }))
  description = "Data Lake filesystem paths."
  default     = []
}