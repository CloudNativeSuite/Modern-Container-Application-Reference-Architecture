locals {
  config_files = length(var.config_files) > 0 ? var.config_files : [
    abspath("${path.root}/../../../../../config/xzerolab/sit/aws-cloud/account/accounts.yaml"),
    abspath("${path.root}/../../../../../config/xzerolab/sit/aws-cloud/resources/vpc.yaml"),
  ]

  account = yamldecode(file(local.config_files[0]))

  vpc_conf = yamldecode(file(local.config_files[1]))
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr        = local.vpc_conf.vpc_cidr
  public_subnets  = local.vpc_conf.public_subnets
  private_subnets = local.vpc_conf.private_subnets
  name_prefix     = local.vpc_conf.name_prefix

  tags = local.account.tags
}
