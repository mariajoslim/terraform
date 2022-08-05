terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
  #"dop_v1_45690958e74c2c2709f9e8d254cb6cd2b67efc4b4aa9d5e50eff598d4cf275c8"
}

resource "digitalocean_kubernetes_cluster" "k8s_iniciativa" {
  name   = var.k8s_name
  #"k8s-iniciativa-devops"
  region = var.region
  #"nyc1"
  version = "1.23.9-do.0"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-4gb"
    node_count = 2
  }
}
resource "digitalocean_kubernetes_node_pool" "node_premium" {
  cluster_id = digitalocean_kubernetes_cluster.k8s_iniciativa.id

  name       = "premium"
  size       = "s-4vcpu-8gb"
  node_count = 2

}

variable "do_token" {} 
variable "k8s_name"{}
variable "region" {}

output "kube_endpoint" {
    value = digitalocean_kubernetes_cluster.k8s_iniciativa.endpoint

}

resourse "local_file" "kube_config" {
    content = difitalocean_kubernetes_cluster.k8s_iniciativa.kube_config.0.raw._config
    filename = "kube_config.yaml"
}  

