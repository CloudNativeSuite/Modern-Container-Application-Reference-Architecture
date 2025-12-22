locals {
  bootstrap = yamldecode(file(abspath(var.bootstrap_config_path)))

  dynamodb_table_name = coalesce(var.table_name, local.bootstrap.state.dynamodb_table_name)
  region              = coalesce(var.region, local.bootstrap.region)
  environment         = try(local.bootstrap.environment, "bootstrap")
  tags                = try(local.bootstrap.tags, {})
}
