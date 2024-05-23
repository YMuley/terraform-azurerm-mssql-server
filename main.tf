resource "azurerm_mssql_server" "sql_server"{
    for_each                     = local.sql_server
    name                         = each.value.name
    resource_group_name          = var.resource_group_output[each.value.resource_group_name].name
    location                     = var.resource_group_output[each.value.resource_group_name].location
    version                      = each.value.version
    administrator_login          = each.value.azuread_administrator.value.azuread_authentication_only == true ? null : each.value.administrator_login_name
    administrator_login_password = each.value.azuread_administrator.value.azuread_authentication_only == true ? null : each.value.administrator_login_password
    minimum_tls_version          = each.value.minimum_tls_version
    public_network_access_enabled = each.value.public_network_access_enabled


    dynamic "azuread_administrator" {
      for_each = each.value.administrator_login_name != null || length(each.value.administrator_login_name) != "0" ? [] : each.value.azuread_administrator
      content {
        azuread_authentication_only = azuread_administrator.value.azuread_authentication_only
        login_username  = var.user_assigned_identity_output[azuread_administrator.value.login_username].name
        object_id = var.user_assigned_identity_output[azuread_administrator.value.login_username].principal_id
        tenant_id = var.user_assigned_identity_output[azuread_administrator.value.login_username].tenant_id
      }
    }

    dynamic "identity" {
      for_each = each.value.azuread_administrator
      content {
        type = "UserAssigned"
        identity_ids = var.user_assigned_identity_output[each.value.azuread_administrator.value.login_username].id
      }
    } 

    primary_user_assigned_identity_id            = var.user_assigned_identity_output[each.value.azuread_administrator.value.login_username].id
    transparent_data_encryption_key_vault_key_id = var.key_vault_output[each.value.key_vault_name].id
    
}