resource "kubernetes_service_account" "reflector" {
  metadata {
    name      = "kube-route-reflector"
    namespace = "kube-system"
  }
}

data "kubernetes_secret" "reflector_service_account_token" {
  metadata {
    name      = kubernetes_service_account.reflector.default_secret_name
    namespace = "kube-system"
  }
}

output "reflector_service_account_token" {
  value     = data.kubernetes_secret.reflector_service_account_token.data.token
  sensitive = true
}
