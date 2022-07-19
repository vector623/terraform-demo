data kubernetes_namespace dev {
  provider = kubernetes.feissupplyaks001
  metadata {
    name = "dev"
  }
}

locals {
  letsencrypt-settings = {
    description  = "settings map for Let's Encrypt"
    min_days     = "30"
    acme_url     = "https://acme-v02.api.letsencrypt.org/directory"
    server_url   = "https://acme-v02.api.letsencrypt.org/directory"
    email        = "atlanta.cicd@supply.com"
    organization = "Supply.com"
  }
}

resource tls_private_key reg_private_key {
  algorithm = "RSA"
}

resource acme_registration reg {
  account_key_pem = tls_private_key.reg_private_key.private_key_pem
  email_address   = local.letsencrypt-settings.email
}

resource acme_certificate wildcard-demo-site-sandbox-nbsupply-ws {
  account_key_pem    = acme_registration.reg.account_key_pem
  min_days_remaining = local.letsencrypt-settings.min_days
  common_name        = "*.demo-site.sandbox.nbsupply.ws"
  must_staple        = false

  dns_challenge {
    provider = "azure"
    config   = {
      AZURE_SUBSCRIPTION_ID     = data.azurerm_client_config.dev.subscription_id
      AZURE_TENANT_ID           = data.azurerm_client_config.dev.tenant_id
      AZURE_CLIENT_ID           = var.DEV_APP_SPN_APPID
      AZURE_CLIENT_SECRET       = var.DEV_APP_SPN_PASS
      AZURE_RESOURCE_GROUP      = data.azurerm_resource_group.feideu2-supply-rg-001.name
      AZURE_POLLING_INTERVAL    = "30"
      AZURE_PROPAGATION_TIMEOUT = "900"
      AZURE_TTL                 = "300"
    }
  }
}

resource kubernetes_secret wildcard-preph-sandbox-nbsupply-ws-chained {
  provider = kubernetes.feissupplyaks001
  metadata {
    name      = "wildcard-demo-site-sandbox-nbsupply-ws-chained"
    namespace = data.kubernetes_namespace.dev.metadata[0].name
  }
  type = "kubernetes.io/tls"
  data = {
    "tls.crt" = format("%s%s",acme_certificate.wildcard-demo-site-sandbox-nbsupply-ws.certificate_pem,acme_certificate.wildcard-demo-site-sandbox-nbsupply-ws.issuer_pem)
    "tls.key" = acme_certificate.wildcard-demo-site-sandbox-nbsupply-ws.private_key_pem
  }
}
