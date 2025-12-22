locals {
  account = yamldecode(
    file("${path.root}/../../config/accounts/dev.yaml")
  )

  s3_conf = yamldecode(
    file("${path.root}/../../config/resources/dev-object/bucket.yaml")
  )
}

module "s3" {
  source = "../../modules/s3"

  bucket_name       = local.s3_conf.bucket_name
  enable_versioning = local.s3_conf.enable_versioning
  tags              = local.account.tags
}

