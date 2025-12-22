locals {
  root_policy       = var.enable_root_limited     ? "deny-root.json"          : null
  mfa_policy        = var.enable_mfa_enforce      ? "deny-no-mfa.json"        : null
  console_policy    = var.console_mode == "readonly" ? "deny-console-write.json" : null
  risp_policy       = var.enable_risp_controls    ? "deny-ri-sp.json"         : null
  sso_policy        = var.enable_identity_center_block ? "deny-sso-and-saml.json" : null

  service_allow_list = distinct(concat([
    "autoscaling:*",
    "cloudformation:*",
    "cloudtrail:*",
    "cloudwatch:*",
    "ec2:*",
    "ecr:*",
    "ecs:*",
    "eks:*",
    "elasticloadbalancing:*",
    "iam:*",
    "kms:*",
    "logs:*",
    "organizations:*",
    "rds:*",
    "route53:*",
    "s3:*",
    "ses:*",
    "sns:*",
    "sqs:*",
    "ssm:*",
    "sts:*"
  ], var.service_allow_list))

  service_deny_list = distinct(concat([
    "aoss:*",
    "apigateway:*",
    "appflow:*",
    "appintegrations:*",
    "appstream:*",
    "appsync:*",
    "chime:*",
    "cloudsearch:*",
    "cognito-identity:*",
    "cognito-idp:*",
    "cognito-sync:*",
    "connect:*",
    "dynamodb:*",
    "eventbridge:*",
    "finspace:*",
    "grafana:*",
    "iot:*",
    "ivschat:*",
    "kafka:*",
    "kinesis:*",
    "lambda:*",
    "license-manager-user-subscriptions:*",
    "lightsail:*",
    "mediaconnect:*",
    "pinpoint:*",
    "quicksight:*",
    "redshift-serverless:*",
    "rekognition:*",
    "sagemaker:*",
    "sesv2:*",
    "stepfunctions:*",
    "timestream:*",
    "transcribe:*",
    "translate:*",
    "workmail:*",
    "workspaces:*"
  ], var.service_deny_list))

  policies = compact([
    local.root_policy,
    local.mfa_policy,
    local.console_policy,
    local.risp_policy,
    local.sso_policy
  ])
}

data "aws_iam_policy_document" "service_controls" {
  count = var.enable_service_guardrails ? 1 : 0

  statement {
    sid        = "DenyActionsOutsideAllowList"
    effect     = "Deny"
    not_action = local.service_allow_list
    resource   = "*"
  }

  statement {
    sid     = "DenyBlacklistedServices"
    effect  = "Deny"
    action  = local.service_deny_list
    resource = "*"
  }
}

#
# Baseline IAM group
#
resource "aws_iam_group" "baseline" {
  name = "LandingZoneBaseline"
}

#
# Create IAM policies
#
resource "aws_iam_policy" "baseline" {
  for_each = toset(local.policies)

  name   = "landingzone-${replace(each.value, ".json", "")}"
  policy = file("${path.module}/policies/${each.value}")
}

#
# Attach policies to baseline group
#
resource "aws_iam_group_policy_attachment" "attach" {
  for_each  = aws_iam_policy.baseline

  group      = aws_iam_group.baseline.name
  policy_arn = each.value.arn
}

resource "aws_iam_policy" "service_controls" {
  count = var.enable_service_guardrails ? 1 : 0

  name   = "landingzone-service-guardrails"
  policy = data.aws_iam_policy_document.service_controls[0].json
}

resource "aws_iam_group_policy_attachment" "service_controls" {
  count = var.enable_service_guardrails ? 1 : 0

  group      = aws_iam_group.baseline.name
  policy_arn = aws_iam_policy.service_controls[0].arn
}
