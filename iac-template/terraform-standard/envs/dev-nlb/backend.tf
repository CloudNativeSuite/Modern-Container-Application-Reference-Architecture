terraform {
  backend "s3" {
    bucket         = "svc-plus-iac-state"
    key            = "account/dev/nlb/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "svc-plus-iac-state-dynamodb-lock"
  }
}

