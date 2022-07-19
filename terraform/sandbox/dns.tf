data kubernetes_service nginx-ingress {
  provider = kubernetes.feissupplyaks001
  metadata {
    name = "gateway-nginx-ingress"
    namespace = "ingress-nginx"
  }
}

data azurerm_dns_zone nbsupply-ws {
  provider = azurerm.dns
  name = "nbsupply.ws"
}

resource azurerm_dns_a_record wildcard-demo-site-sandbox-nbsupply-ws {
  provider = azurerm.dns
  name                = "*.demo-site.sandbox"
  resource_group_name = data.azurerm_resource_group.feideu2-supply-rg-001.name
  ttl                 = 600
  zone_name           = data.azurerm_dns_zone.nbsupply-ws.name
  records = [
    data.kubernetes_service.nginx-ingress.status[0].load_balancer[0].ingress[0].ip
  ]
}
