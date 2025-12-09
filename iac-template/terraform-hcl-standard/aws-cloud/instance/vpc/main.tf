locals {
  account = yamldecode(
    file("${path.root}/../../config/accounts/dev.yaml")
  )

  vpc_conf = yamldecode(
    file("${path.root}/../../config/resources/vpc/dev.yaml")
  )
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr        = local.vpc_conf.vpc_cidr
  public_subnets  = local.vpc_conf.public_subnets
  private_subnets = local.vpc_conf.private_subnets
  name_prefix     = local.vpc_conf.name_prefix

  tags = local.account.tags
}
