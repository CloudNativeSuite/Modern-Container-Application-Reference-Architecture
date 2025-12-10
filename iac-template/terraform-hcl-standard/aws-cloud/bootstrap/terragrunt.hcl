terraform_version_constraint  = ">= 1.2.0"
terragrunt_version_constraint = ">= 0.67.14"

locals {
  bootstrap_config = yamldecode(file(abspath("${get_parent_terragrunt_dir()}/config/accounts/bootstrap.yaml")))
}
