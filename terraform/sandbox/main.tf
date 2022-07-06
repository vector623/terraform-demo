terraform {
  backend azurerm {
    resource_group_name  = "feiseu2-supply-rg-001"
    storage_account_name = "supplysandboxtf"
    container_name       = "tfstate"
    key                  = "terraform-demo.tfstate"
    subscription_id      = "8d01f77a-4a6f-4548-b5f3-743769a1b178"
  }
}

provider azurerm {
  alias                      = "sandbox"
  subscription_id            = var.SBX_SUBSCRIPTION_ID
  features {}
  skip_provider_registration = true
}

provider azuread {}

provider kubernetes {
  alias                  = "feissupplyaks001"
  host                   = var.K8S_HOST
  cluster_ca_certificate = base64decode(var.K8S_CLUSTER_CA_CERTIFICATE)
  token                  = base64decode(var.K8S_TOKEN)
}

data azurerm_resource_group feiseu2-supply-rg-001 {
  provider = azurerm.sandbox
  name     = "feiseu2-supply-rg-001"
}

data azurerm_client_config sandbox {
  provider = azurerm.sandbox
}

data azuread_client_config sandbox {}

data azuread_service_principal main {
  application_id = var.SBX_APP_SPN_APPID
}