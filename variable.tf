variable "pass_sql_server_list" {
  type = list(any)
  description = "list of sql servers "
}

variable "resource_group_output" {
  type = map(any)
  description = "object list of resource group"
}

variable "user_assigned_identity_output" {
  type        = map(any)
  default     = {}
  description = "user identity output"
}

variable "key_vault_output" {
  type = map(any)
  default = {}
  description = "key vault object output"
}