terraform {
  backend "azurerm" {
    resource_group_name  = "feiseu2-supply-rg-001"
    storage_account_name = "supplysandboxtf"
    container_name       = "tfstate"
    key                  = "terraform-demo.tfstate"
    subscription_id      = "8d01f77a-4a6f-4548-b5f3-743769a1b178"
  }
}
