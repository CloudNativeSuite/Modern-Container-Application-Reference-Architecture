terraform {
  required_version = ">= 1.5"

  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "~> 2.19"
    }
  }
}

provider "vultr" {
  api_key = var.vultr_api_key
}

module "vpc" {
  source         = "../modules/vpc"
  region         = var.region
  description    = var.vpc_description
  v4_subnet      = var.v4_subnet
  v4_subnet_size = var.v4_subnet_size
}

module "iam" {
  source   = "../modules/iam"
  users    = var.users
  ssh_keys = var.ssh_keys
}

module "storage" {
  source        = "../modules/storage"
  region        = var.region
  cluster_id    = var.cluster_id
  object_bucket = var.object_bucket
  enable_block  = var.enable_block
  block_size_gb = var.block_size_gb
  label         = "${var.name_prefix}-storage"
}

module "compute" {
  source       = "../modules/compute"
  label        = "${var.name_prefix}-vm"
  region       = var.region
  plan         = var.plan
  os_id        = var.os_id
  enable_ipv6  = true
  backups      = true
  tags         = [var.name_prefix, "dev"]
  vpc_id       = module.vpc.vpc_id
  ssh_key_ids  = values(module.iam.ssh_key_ids)
  user_data    = file(var.user_data_file)
}

module "data_store" {
  source   = "../modules/data_store"
  label    = "${var.name_prefix}-db"
  region   = var.region
  engine   = var.db_engine
  plan     = var.db_plan
  dbname   = var.dbname
  username = var.db_username
  password = var.db_password
  ha       = var.db_ha
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "instance_ip" {
  value = module.compute.main_ip
}

output "bucket" {
  value = module.storage.bucket_name
}

output "database_dsn" {
  value = module.data_store.dsn
}
