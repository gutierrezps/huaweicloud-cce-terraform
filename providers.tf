terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "~> 1.87.0"
    }

    kubernetes = {
      version = "~> 3.0.1"
    }
  }
}

provider "huaweicloud" {
  region     = var.region
  access_key = var.hwc_access_key
  secret_key = var.hwc_secret_key
}

provider "kubernetes" {
  config_path    = "output/kubeconfig.json"
  config_context = "external"
}
