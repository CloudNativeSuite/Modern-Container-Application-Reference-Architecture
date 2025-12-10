#
# IAM Role: Terraform Deploy Role
# ----------------------------------------
resource "aws_iam_role" "terraform_deploy_role" {
  count = var.create_role ? 1 : 0

  name = local.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${local.account.account_id}:user/${local.config_terraform_user}"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = merge(
    {
      Name        = local.config_role_name
      Environment = coalesce(try(local.account.environment, null), local.environment)
    },
    try(local.account.tags, {}),
    local.extra_tags
  )
}

resource "aws_iam_role_policy" "terraform_deploy_role_policy" {
  count = var.create_role ? 1 : 0

  name = "${local.role_name}-bootstrap-minimal"
  role = aws_iam_role.terraform_deploy_role[0].id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Bootstrap S3 backend (state bucket)
      {
        Effect = "Allow",
        Action = [
          "s3:CreateBucket",
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:PutBucketVersioning",
          "s3:PutBucketPolicy",
          "s3:PutBucketTagging",
          "s3:PutEncryptionConfiguration",
          "s3:PutBucketPublicAccessBlock",
        ],
        Resource = "arn:aws:s3:::${local.bootstrap.state.bucket_name}"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:PutObjectTagging"
        ],
        Resource = "arn:aws:s3:::${local.bootstrap.state.bucket_name}/*"
      },

      # DynamoDB state lock table
      {
        Effect = "Allow",
        Action = [
          "dynamodb:CreateTable",
          "dynamodb:DescribeTable",
          "dynamodb:UpdateTable",
          "dynamodb:TagResource",
          "dynamodb:UntagResource"
        ],
        Resource = "arn:aws:dynamodb:${local.config_region}:${local.account.account_id}:table/${local.bootstrap.state.dynamodb_table_name}"
      },

      # IAM roles needed for bootstrap lifecycle
      {
        Effect = "Allow",
        Action = [
          "iam:GetRole",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:UpdateAssumeRolePolicy",
          "iam:TagRole",
          "iam:UntagRole"
        ],
        Resource = [
          "arn:aws:iam::${local.account.account_id}:role/${local.role_name}",
          "arn:aws:iam::${local.account.account_id}:role/bootstrap-*",
          "arn:aws:iam::${local.account.account_id}:role/terraform-*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy"
        ],
        Resource = [
          "arn:aws:iam::${local.account.account_id}:role/${local.role_name}",
          "arn:aws:iam::${local.account.account_id}:role/bootstrap-*",
          "arn:aws:iam::${local.account.account_id}:role/terraform-*"
        ]
      }
    ]
  })
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
resource "aws_iam_user_policy" "terraform_user_policy" {
  count = var.create_user ? 1 : 0

  name = "${local.terraform_user_name}-iac-policy"
  user = aws_iam_user.terraform_user[0].name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # 允许 Assume TerraformDeployRole
      {
        Effect = "Allow",
        Action = [
          "sts:AssumeRole"
        ],
        Resource = var.create_role ? aws_iam_role.terraform_deploy_role[0].arn : var.existing_role_arn
      }
    ]
  })
}
