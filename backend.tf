terraform {
  backend "remote" {
    organization = "ffddorf"

    workspaces {
      name = "dorfadventure-cluster"
    }
  }

  required_providers {
    kubernetes-alpha = {
      source  = "hashicorp/kubernetes-alpha"
      version = "0.3.3"
    }
  }
}

data "terraform_remote_state" "cluster_setup" {
  backend = "remote"

  config = {
    organization = "ffddorf"
    workspaces = {
      name = "k3os-on-proxmox"
    }
  }
}

locals {
  k8s_api_url = "https://k3s-dorfadventure.freifunk-duesseldorf.de:8443"
}

provider "kubernetes-alpha" {
  host  = local.k8s_api_url
  token = data.terraform_remote_state.cluster_setup.outputs.k8s_api_token
}

provider "kubernetes" {
  host  = local.k8s_api_url
  token = data.terraform_remote_state.cluster_setup.outputs.k8s_api_token
}

provider "helm" {
  kubernetes {
    host  = local.k8s_api_url
    token = data.terraform_remote_state.cluster_setup.outputs.k8s_api_token
  }
}
