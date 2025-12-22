locals {
  bootstrap = yamldecode(file(abspath(var.bootstrap_config_path)))

  config_account_name   = coalesce(var.account_name, local.bootstrap.account_name)
  config_region         = coalesce(var.region, local.bootstrap.region)
  config_role_name      = coalesce(var.role_name, local.bootstrap.iam.role_name)
  config_terraform_user = coalesce(var.terraform_user_name, local.bootstrap.iam.terraform_user_name)
  environment           = coalesce(try(local.bootstrap.environment, null), try(local.bootstrap.iam.environment, null), "bootstrap")
  extra_tags            = try(local.bootstrap.tags, {})

  role_name           = coalesce(var.existing_role_name, local.config_role_name)
  terraform_user_name = coalesce(var.existing_user_name, local.config_terraform_user)
  state_bucket_name   = coalesce(var.state_bucket_name, try(local.bootstrap.state.bucket_name, null))
  lock_table_name     = coalesce(var.state_lock_table_name, try(local.bootstrap.state.dynamodb_table_name, null))
}

locals {
  account_file_path = "${path.module}/../../../config/accounts/${local.config_account_name}.yaml"
  account = fileexists(local.account_file_path) ? yamldecode(file(local.account_file_path)) : {
    account_id  = local.bootstrap.account_id
    environment = local.environment
    tags        = local.extra_tags
  }
}
