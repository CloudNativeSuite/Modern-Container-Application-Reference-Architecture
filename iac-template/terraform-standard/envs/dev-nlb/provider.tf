terraform {
  required_version = ">= 1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92.0"
    }
  }
}

provider "aws" {
  region = local.account.region

  assume_role {
    role_arn     = "arn:aws:iam::730335654753:role/TerraformDeployRole-Dev"
    session_name = "TerraformDevSession"
  }
}

