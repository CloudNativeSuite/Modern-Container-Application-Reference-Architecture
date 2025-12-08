locals {
  bootstrap = yamldecode(file("${path.root}/../config/accounts/bootstrap.yaml"))

  config_account_name     = coalesce(var.account_name, local.bootstrap.account_name)
  config_region           = coalesce(var.region, local.bootstrap.region)
  config_role_name        = coalesce(var.role_name, local.bootstrap.iam.role_name)
  config_terraform_user   = coalesce(var.terraform_user_name, local.bootstrap.iam.terraform_user_name)
  environment             = coalesce(try(local.bootstrap.environment, null), try(local.bootstrap.iam.environment, null), "bootstrap")
  extra_tags              = try(local.bootstrap.tags, {})
}

locals {
  account_file_path = "${path.root}/../config/accounts/${local.config_account_name}.yaml"
  account = fileexists(local.account_file_path) ? yamldecode(file(local.account_file_path)) : {
    account_id  = local.bootstrap.account_id
    environment = local.environment
    tags        = local.extra_tags
  }
}
