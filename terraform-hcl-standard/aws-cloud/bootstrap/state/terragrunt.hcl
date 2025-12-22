include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//bootstrap/state"
}

inputs = {
  bootstrap_config_path = abspath("${get_parent_terragrunt_dir()}/../config/accounts/bootstrap.yaml")
}
