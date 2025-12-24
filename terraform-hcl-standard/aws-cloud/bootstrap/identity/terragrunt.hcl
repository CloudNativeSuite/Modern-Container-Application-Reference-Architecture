include "root" {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../state", "../lock"]
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//bootstrap/identity"
}

inputs = {
  bootstrap_config_path = get_env("BOOTSTRAP_CONFIG_PATH", "")
}
