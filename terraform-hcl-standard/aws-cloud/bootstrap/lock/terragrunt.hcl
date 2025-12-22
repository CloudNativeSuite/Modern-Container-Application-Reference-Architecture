include "root" {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../state"]
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//bootstrap/lock"
}

inputs = {
  bootstrap_config_path = abspath("${get_parent_terragrunt_dir()}/../config/accounts/bootstrap.yaml")
}
