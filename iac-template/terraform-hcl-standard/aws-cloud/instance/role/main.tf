locals {
  account = yamldecode(
    file("${path.root}/../../config/accounts/dev.yaml")
  )
}


data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account.account_id}:root"]
    }
  }
}

module "role" {
  source = "../../modules/iam"

  name               = "app-role"
  assume_role_policy = data.aws_iam_policy_document.assume.json

  tags = local.account.tags
}
