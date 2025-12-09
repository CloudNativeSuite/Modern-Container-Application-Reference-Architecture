locals {
  account = yamldecode(
    file("${path.root}/../../config/accounts/dev.yaml")
  )

  alb_conf = yamldecode(
    file("${path.root}/../../config/resources/dev-alb/alb.yaml")
  )
}

module "alb" {
  source      = "../../modules/alb"

  name_prefix = local.alb_conf.name_prefix
  vpc_id      = local.alb_conf.vpc_id
  subnet_ids  = local.alb_conf.subnet_ids
  listeners   = local.alb_conf.listeners

  tags = local.account.tags
}
