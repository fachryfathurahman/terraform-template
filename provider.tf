terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  region = "ap-southeast-1"
}

provider "aws" {
  default_tags {
    tags = {
      Terraform   = "true"
      Environment = "dev"
    }
  }
  region     = local.region
  access_key = var.access_key
  secret_key = var.secret_key
  token      = var.session_token
}