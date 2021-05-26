terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.1.0"
    }
    kubernetes-alpha = {
      source  = "hashicorp/kubernetes-alpha"
      version = "0.3.3"
    }
  }
}

resource "kubernetes_namespace" "metallb_namespace" {
  metadata {
    name = "metallb-system"
  }
}

resource "helm_release" "metallb_chart" {
  name       = "metallb"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metallb"
  version    = "2.0.4"

  namespace = kubernetes_namespace.metallb_namespace.metadata.0.name

  set {
    name  = "configInline"
    value = file("${path.module}/config.yml")
  }
}
