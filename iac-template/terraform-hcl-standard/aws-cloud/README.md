# Terraform Bootstrap for S3 Backend & DynamoDB Lock Table

This repository provides bootstrap Terraform modules that must be applied before enabling a Terraform remote backend on AWS.
It creates:
- IAM artifacts — a deploy role plus a dedicated DevOps/automation user for Terraform
- S3 bucket — to store Terraform remote state
- DynamoDB table — to store Terraform state locks

Both modules can be run independently.

- bootstrap-s3/           # S3 state bucket (versioning + SSE)
- bootstrap-dynamodb/     # DynamoDB lock table (LockID)

---
** Note: S3 bucket must be emptied before deletion. **

## 1. AWS Credentials Setup

Terraform reads AWS credentials through the standard AWS credential chain. You may use either A or B.

### A. Environment Variables (recommended for local / CI)

```
export AWS_ACCESS_KEY_ID="AKIAxxxxxxxxxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxxxxxxxxxxxxx"
export AWS_DEFAULT_REGION="ap-northeast-1"
```

Terraform will automatically detect them.

### B. AWS CLI Credentials File (~/.aws/credentials)

- Run: aws configure
- Credentials file: ~/.aws/credentials

```
Example:
[default]
aws_access_key_id     = AKIAxxxxxxxxxxxx
aws_secret_access_key = xxxxxxxxxxxxxxxxx
region                = ap-northeast-1
```

Select profile if needed: export AWS_PROFILE=default

## 2. Bootstrap: Create S3 Bucket

```
cd bootstrap-s3
terraform init
terraform apply \
  -var="bucket_name=svc-plus-iac-state" \
  -var="region=ap-northeast-1"
```

This creates: 
- S3 bucket for Terraform state
- Versioning enabled
- Server-side encryption (AES256) enabled

## 3. Bootstrap: Create DynamoDB Lock Table

```
cd bootstrap-dynamo-db
terraform init
terraform plan \
  -var="region=ap-northeast-1" \
  -var="table_name=svc-plus-iac-state-dynamodb-lock"
terraform apply \
  -var="region=ap-northeast-1" \
  -var="table_name=svc-plus-iac-state-dynamodb-lock"
terraform output
```

This creates: 

- DynamoDB table: terraform-locks
- Primary key: LockID

PAY_PER_REQUEST billing mode Compatible with Terraform backend locking

## 4. Bootstrap IAM Role

```
cd bootstrap-iam
terraform init
terraform apply \
  -var="account_name=dev" \
  -var="role_name=TerraformDeployRole-Dev"
```

## 5. Use in Terraform Backend

After both bootstrap steps are completed:

terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "envs/dev/terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

Then run:

terraform init -migrate-state

5. Security Notes

Never store AWS credentials in Terraform variables
Never commit credentials to Git

Prefer:

- environment variables
- AWS CLI profiles
- IAM Role / SSO / OIDC (recommended)
- S3 bucket has: Versioning ON

Server-side encryption ON

## 6. Cleanup

To remove bootstrap resources:

terraform destroy


# Access Key + STS 的执行流程（内部机制）

你的 Terraform 执行流程变成：

Terraform 读取你的 Access Key
→ 用 GET CALLER IDENTITY 验证身份
调用 sts:AssumeRole
获得临时凭证（Session Token）
Terraform 使用临时凭证执行所有资源创建

AccessKey → STS → AssumeRole → 临时 Token → Terraform apply

