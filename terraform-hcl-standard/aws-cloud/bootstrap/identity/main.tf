#
# GitHub Actions OIDC Provider & IAM Role for Terraform Deployments
# -----------------------------------------------------------------
resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

data "aws_iam_policy_document" "github_actions_oidc_assume_role" {
  override_policy_documents = [
    templatefile(
      "${path.module}/policies/github-actions-deploy-assume-role.json",
      {
        oidc_provider_arn = aws_iam_openid_connect_provider.github_actions.arn
      }
    )
  ]
}

resource "aws_iam_role" "github_actions_deploy_role" {
  name = "GithubAction_IAC_Deploy_Role"

  assume_role_policy = data.aws_iam_policy_document.github_actions_oidc_assume_role.json

  tags = merge(
    {
      Name        = "GithubAction_IAC_Deploy_Role"
      Environment = coalesce(try(local.account.environment, null), local.environment)
    },
    try(local.account.tags, {}),
    local.extra_tags,
  )
}

resource "aws_iam_role_policy_attachment" "github_actions_deploy_role_admin" {
  role       = aws_iam_role.github_actions_deploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

#
# IAM Role: Terraform Deploy Role
# ----------------------------------------
data "aws_iam_policy_document" "terraform_deploy_assume_role" {
  override_policy_documents = [
    templatefile(
      "${path.module}/policies/terraform-deploy-assume-role.json",
      {
        account_id          = local.account.account_id
        terraform_user_name = local.config_terraform_user
      }
    )
  ]
}

resource "aws_iam_role" "terraform_deploy_role" {
  count = var.create_role ? 1 : 0

  name               = local.role_name
  assume_role_policy = data.aws_iam_policy_document.terraform_deploy_assume_role.json

  tags = merge(
    {
      Name        = local.config_role_name
      Environment = coalesce(try(local.account.environment, null), local.environment)
    },
    try(local.account.tags, {}),
    local.extra_tags,
  )
}

data "aws_iam_policy_document" "terraform_deploy_inline" {
  override_policy_documents = [
    templatefile(
      "${path.module}/policies/terraform-deploy-inline-policy.json",
      {
        account_id  = local.account.account_id
        bucket_name = local.state_bucket_name
        region      = local.config_region
        role_name   = local.role_name
        table_name  = local.lock_table_name
      }
    )
  ]
}

resource "aws_iam_role_policy" "terraform_deploy_role_policy" {
  count = var.create_role ? 1 : 0

  name   = "${local.role_name}-bootstrap-minimal"
  role   = aws_iam_role.terraform_deploy_role[0].id
  policy = data.aws_iam_policy_document.terraform_deploy_inline.json
}

resource "aws_iam_role_policy_attachment" "terraform_deploy_role_managed" {
  count = var.create_role ? length(var.managed_policy_arns) : 0

  role       = aws_iam_role.terraform_deploy_role[0].name
  policy_arn = var.managed_policy_arns[count.index]
}

#
# IAM User for Terraform (AK/SK)
# ----------------------------------------
resource "aws_iam_user" "terraform_user" {
  count = var.create_user ? 1 : 0

  name = local.terraform_user_name
}

#
# IAM User Policy: 最小权限
# ----------------------------------------
data "aws_iam_policy_document" "terraform_user" {
  override_policy_documents = [
    templatefile(
      "${path.module}/policies/terraform-user-assume-role.json",
      {
        account_id = local.account.account_id
        role_name  = local.role_name
      }
    )
  ]
}

resource "aws_iam_user_policy" "terraform_user_policy" {
  count = var.create_user ? 1 : 0

  name   = "${local.terraform_user_name}-iac-policy"
  user   = aws_iam_user.terraform_user[0].name
  policy = data.aws_iam_policy_document.terraform_user.json
}
