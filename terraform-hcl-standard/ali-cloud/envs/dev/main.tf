terraform {
  required_version = ">= 1.5.0"
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = ">= 1.210.0"
    }
  }
}

provider "alicloud" {
  region         = var.region
  access_key     = coalesce(var.access_key, "mock-access-key")
  secret_key     = coalesce(var.secret_key, "mock-secret-key")
  security_token = var.security_token

  dynamic "assume_role" {
    for_each = var.ram_role_arn == null ? [] : [var.ram_role_arn]
    content {
      role_arn     = assume_role.value
      session_name = var.session_name
    }
  }
}

module "network" {
  source      = "../modules/vpc"
  name        = var.vpc_name
  cidr_block  = var.vpc_cidr
  vswitches   = var.vswitches
}

locals {
  zone_mappings = [for key, cfg in var.vswitches : {
    vswitch_id = module.network.vswitch_ids[key]
    zone_id    = cfg.az
  }]
  primary_vswitch = module.network.vswitch_ids[local.primary_vswitch_key]
  primary_vswitch_key = keys(module.network.vswitch_ids)[0]
}

module "alb" {
  source         = "../modules/alb"
  name           = "dev-alb"
  vpc_id         = module.network.vpc_id
  zone_mappings  = local.zone_mappings
  address_type   = "Internet"
  edition        = "Standard"
  protocol       = "HTTP"
  listener_port  = 80
}

module "nlb" {
  source        = "../modules/nlb"
  name          = "dev-nlb"
  vswitch_id    = local.primary_vswitch
  address_type  = "Internet"
  spec          = "slb.s2.small"
  protocol      = "tcp"
  frontend_port = 443
  backend_port  = 443
}

module "bucket" {
  source            = "../modules/oss"
  name              = var.bucket_name
  enable_versioning = true
}

module "compute" {
  source                    = "../modules/ecs"
  name                      = "dev-ecs"
  vpc_id                    = module.network.vpc_id
  vswitch_id                = local.primary_vswitch
  instance_type             = var.instance_type
  image_id                  = var.image_id
  key_name                  = var.key_name
  internet_max_bandwidth_out = 50
}

module "database" {
  source           = "../modules/rds"
  vpc_id           = module.network.vpc_id
  vswitch_id       = local.primary_vswitch
  engine           = "MySQL"
  engine_version   = "8.0"
  instance_type    = var.rds_instance_type
  account_password = var.rds_password
}

module "cache" {
  source         = "../modules/redis"
  name           = "dev-redis"
  vpc_id         = module.network.vpc_id
  vswitch_id     = local.primary_vswitch
  password       = var.redis_password
  engine_version = "6.0"
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "alb_endpoint" {
  value = module.alb.alb_id
}

output "ecs_instance" {
  value = module.compute.instance_id
}
