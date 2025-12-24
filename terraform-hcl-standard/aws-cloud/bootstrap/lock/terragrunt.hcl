include "root" {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../state"]
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//bootstrap/lock"
}

locals {
  gitops_repo_root = get_env(
    "GITOPS_REPO_ROOT",
    abspath("${get_parent_terragrunt_dir()}/../../../../../gitops")
  )
  config_root = "${local.gitops_repo_root}/config"
  bootstrap_config_path = get_env(
    "GITOPS_BOOTSTRAP_CONFIG",
    "${local.config_root}/accounts/bootstrap.yaml"
  )
}

inputs = {
  bootstrap_config_path = local.bootstrap_config_path
  config_root           = local.gitops_repo_root
}
