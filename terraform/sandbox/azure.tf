resource azurerm_key_vault keyvault {
  provider            = azurerm.sandbox
  name                = var.kv-name
  resource_group_name = data.azurerm_resource_group.feiseu2-supply-rg-001.name
  location            = data.azurerm_resource_group.feiseu2-supply-rg-001.location
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.sandbox.tenant_id
}

data azuread_user david-gallmeier {
  user_principal_name = "david.gallmeier@supply.com"
}

data azuread_user carl-napoli {
  user_principal_name = "carl.napoli1@ferguson.com"
}

locals {
  kv-users = toset([
    data.azuread_user.david-gallmeier.object_id,
    data.azuread_user.carl-napoli.object_id
  ])
}

resource azurerm_key_vault_access_policy david-gallmeier {
  provider = azurerm.sandbox
  for_each = local.kv-users

  key_vault_id = azurerm_key_vault.keyvault.id
  object_id    = each.value
  tenant_id    = data.azurerm_client_config.sandbox.tenant_id
  secret_permissions = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
}