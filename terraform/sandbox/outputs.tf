output main-resource-group {
  value = yamlencode(data.azurerm_resource_group.feiseu2-supply-rg-001)
}

output tenant-id {
  value = yamlencode(data.azuread_client_config.sandbox)
}

output spn {
  value = yamlencode(data.azuread_service_principal.main)
}