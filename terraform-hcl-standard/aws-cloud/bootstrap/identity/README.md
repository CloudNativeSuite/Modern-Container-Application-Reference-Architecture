# AWS Bootstrap Identity (Terraform / GitHub Actions OIDC)

此目录在原有 Terraform AK/SK 引导身份的基础上，新增 GitHub Actions OIDC 专用角色，便于无长生命周期凭证的 IaC 自动化。若 OIDC 服务不可用，仍可使用原有 Terraform IAM User + AssumeRole 路径作为应急逃逸出口。

## 资源概览

- `aws_iam_openid_connect_provider.github_actions`：GitHub Actions 公共 OIDC Provider（`https://token.actions.githubusercontent.com`）。
- `aws_iam_role.github_actions_deploy_role`：供 GitHub Actions 通过 OIDC 假设的角色，限制到仓库 `cloud-neutral-toolkit/Modern-Container-Application-Reference-Architecture` 的 `main` 分支。
- `aws_iam_role_policy_attachment.github_actions_deploy_role_admin`：示例使用 AWS 托管策略 `AdministratorAccess`（实际项目请收敛至 S3 state / DynamoDB lock 所需的最小权限）。

## Terraform 输出

- `github_actions_oidc_provider_arn`：GitHub Actions OIDC Provider ARN。
- `github_actions_deploy_role_arn`：GitHub Actions OIDC AssumeRole ARN。
- 兼容保留：`iam_role_arn`（Terraform Deploy Role）、`terraform_user_name`（Terraform IAM User）。

## GitHub Actions 配置要点

Workflow 需要的权限：

```yaml
permissions:
  id-token: write
  contents: read
```

示例步骤（仅示例，不生成 workflow 文件）：

```yaml
- uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: <terraform output: github_actions_deploy_role_arn>
    aws-region: ap-northeast-1
```

可根据需要在后续步骤执行 Terraform CLI，使用 OIDC 方式取代长期 AK/SK。若 OIDC 服务异常，可切回输出的 `iam_role_arn` 与 `terraform_user_name` 路径。
