terraform {
  required_providers {
    kubernetes-alpha = {
      source  = "hashicorp/kubernetes-alpha"
      version = "0.3.3"
    }
  }
}

locals {
  app_name = "nginx-demo"
}

resource "kubernetes_manifest" "namespace" {
  provider = kubernetes-alpha

  manifest = {
    apiVersion = "v1"
    kind       = "Namespace"
    metadata = {
      name = "lb-test-app"
    }
  }
}

resource "kubernetes_manifest" "deployment" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "labels" = {
        "app" = local.app_name
      }
      "name"    = "nginx-demo"
      namespace = kubernetes_manifest.namespace.manifest.metadata.name
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = local.app_name
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = local.app_name
          }
          "name" = "static-web"
        }
        "spec" = {
          "containers" = [
            {
              "image" = "nginxdemos/hello"
              "name"  = "web"
              "ports" = [
                {
                  "containerPort" = 80
                  "name"          = "web"
                  "protocol"      = "TCP"
                },
              ]
            },
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "name"    = "nginx-demo"
      namespace = kubernetes_manifest.namespace.manifest.metadata.name
    }
    "spec" = {
      "type"           = "LoadBalancer"
      "loadBalancerIP" = "45.151.166.29"
      "ports" = [
        {
          "port"       = 80
          "targetPort" = 80
          "protocol"   = "TCP"
        },
      ]
      "selector" = {
        "app" = local.app_name
      }
    }
  }
}
