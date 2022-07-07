locals {
  kv-users = toset([
    data.azuread_user.david-gallmeier.object_id,
    data.azuread_user.carl-napoli.object_id,
    data.azuread_service_principal.main.application_id
  ])
}

resource azurerm_key_vault keyvault {
  provider            = azurerm.sandbox
  name                = var.kv-name
  resource_group_name = data.azurerm_resource_group.feiseu2-supply-rg-001.name
  location            = data.azurerm_resource_group.feiseu2-supply-rg-001.location
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.sandbox.tenant_id
  tags                = {
    "classofservice"  = "sbx"
    "costcenter"      = "8957"
    "criticality"     = "bronze"
    "description"     = "supply-core-webapp"
    "projectid"       = "m&a"
    "reference"       = "ritm2292716"
    "securityprofile" = "std"
    "service"         = "supply"
    "system"          = "core"
  }
}

resource azurerm_key_vault_access_policy dev-access {
  provider = azurerm.sandbox
  for_each = local.kv-users

  key_vault_id       = azurerm_key_vault.keyvault.id
  object_id          = each.value
  tenant_id          = data.azurerm_client_config.sandbox.tenant_id
  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]
}

resource azurerm_key_vault_secret acr-id {
  provider     = azurerm.sandbox
  key_vault_id = azurerm_key_vault.keyvault.id

  name  = "ACR-SPN-ID"
  value = var.SBX_APP_SPN_APPID
}

resource azurerm_key_vault_secret acr-pass {
  provider     = azurerm.sandbox
  key_vault_id = azurerm_key_vault.keyvault.id

  name  = "ACR-SPN-PASS"
  value = var.SBX_APP_SPN_PASS
}

resource github_repository_environment env {
  provider = github.supplycom
  environment = "sandbox"

  repository = data.github_repository.project-repo.name
}

locals {
  azurekvcreds = tomap({
    clientId: var.SBX_APP_SPN_APPID,
    clientSecret: var.SBX_APP_SPN_PASS,
    subscriptionId: data.azurerm_client_config.sandbox.subscription_id,
    tenantId: data.azurerm_client_config.sandbox.tenant_id
  })
}

resource github_actions_environment_secret azure-kv-creds-json {
  provider = github.supplycom
  repository = data.github_repository.project-repo.name
  environment = github_repository_environment.env.environment
  secret_name = "AZURE_KEYVAULT_CREDS"
  plaintext_value = jsonencode(local.azurekvcreds)
}
