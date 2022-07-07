data azurerm_container_registry supplysandbox {
  provider = azurerm.sandbox
  name                = "supplysandbox"
  resource_group_name = data.azurerm_resource_group.feiseu2-supply-rg-001.name
}

locals {
  acr-roles = toset([
    "AcrPull",
    "AcrPush",
    "AcrDelete",
    "AcrImageSigner",
  ])
}

data azurerm_role_definition acr-roles {
  provider = azurerm.sandbox
  for_each = local.acr-roles

  name = each.key
}

# These are provisioned by another project
#resource azurerm_role_assignment spn-acr-role {
#  provider = azurerm.sandbox
#  for_each = data.azurerm_role_definition.acr-roles
#
#  principal_id = data.azuread_service_principal.main.id
#  scope = data.azurerm_container_registry.supplysandbox.id
#  role_definition_id = each.value.id
#}