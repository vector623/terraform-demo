data kubernetes_namespace sa-namespace {
  provider = kubernetes.feissupplyaks001
  metadata {
    name = "default"
  }
}

data kubernetes_service_account supply-sa-for-kubectl {
  provider = kubernetes.feissupplyaks001
  metadata {
    name      = "default"
    namespace = data.kubernetes_namespace.sa-namespace.metadata[0].name
  }
}

data kubernetes_secret supply-sa-for-kubectl-auth {
  provider = kubernetes.feissupplyaks001
  metadata {
    name      = data.kubernetes_service_account.supply-sa-for-kubectl.default_secret_name
    namespace = data.kubernetes_service_account.supply-sa-for-kubectl.metadata[0].namespace
  }
}


locals {
  k8s-secret = jsonencode({
    apiVersion = "v1"
    data       = {
      "ca.crt"    = base64encode(data.kubernetes_secret.supply-sa-for-kubectl-auth.data["ca.crt"])
      "namespace" = base64encode(data.kubernetes_secret.supply-sa-for-kubectl-auth.data["namespace"])
      "token"     = base64encode(data.kubernetes_secret.supply-sa-for-kubectl-auth.data["token"])
    }
    kind     = "Secret"
    metadata = {
      annotations = {
        "kubernetes.io/service-account.name" = "default"
        "kubernetes.io/service-account.uid"  = data.kubernetes_service_account.supply-sa-for-kubectl.metadata[0].uid
      }
      name            = data.kubernetes_secret.supply-sa-for-kubectl-auth.metadata[0].name
      namespace       = data.kubernetes_secret.supply-sa-for-kubectl-auth.metadata[0].namespace
      uid             = data.kubernetes_secret.supply-sa-for-kubectl-auth.metadata[0].uid
      resourceVersion = data.kubernetes_service_account.supply-sa-for-kubectl.metadata[0].resource_version
    }
    type = "kubernetes.io/service-account-token"
    #raw_svcacct = data.kubernetes_service_account.supply-sa-for-kubectl
    #raw_secret  = data.kubernetes_secret.supply-sa-for-kubectl-auth
  })
}


resource github_actions_environment_secret azure-kv-creds-json {
  provider = github.supplycom
  repository = data.github_repository.project-repo.name
  environment = github_repository_environment.env.environment
  secret_name = "AZURE_KEYVAULT_CREDS"
  plaintext_value = jsonencode(local.azurekvcreds)
}

resource github_actions_environment_secret k8s-auth {
  provider = github.supplycom
  secret_name = "K8S_AUTH"
  repository = data.github_repository.project-repo.name
  environment = github_repository_environment.env.environment
  plaintext_value = local.k8s-secret
  depends_on      = [ local.k8s-secret ]
}
