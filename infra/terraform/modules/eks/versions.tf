terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 5.34"
      configuration_aliases = [aws.us_east_1]
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.7"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0"
    }
  }
}

