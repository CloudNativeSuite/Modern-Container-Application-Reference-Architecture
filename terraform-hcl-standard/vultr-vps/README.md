# Vultr VPS Terraform Standard

此目录在保持 AWS 模板目录结构的同时，提供 Vultr VPS 的等效实现，方便在 Vultr 上快速落地基础设施。模板包含引导阶段（bootstrap）、环境示例（envs）与模块库（modules），与 `aws-cloud`/`gcp-cloud` 目录一一对应。

## AWS → Vultr 资源映射
- **VPC (aws_vpc)** → `vultr_vpc`：创建私网并自定义 IPv4 段。
- **EC2 (aws_instance)** → `vultr_instance`：创建 VPS/计算实例，支持自定义镜像与云初始化脚本。
- **S3 (aws_s3_bucket)** → `vultr_object_storage`：提供 S3 兼容对象存储，可用于远端状态与应用资产。
- **IAM (aws_iam_user/role + aws_key_pair)** → `vultr_user` + `vultr_ssh_key`：管理子账号权限与 SSH 公钥分发。
- **RDS (aws_db_instance)** → `vultr_database`：托管数据库（MySQL/PostgreSQL/Redis），支持自动备份与高可用套餐。

## 目录结构
- `bootstrap/state/`：初始化 Vultr 对象存储集群与访问密钥，可作为 Terraform 远端状态桶。
- `bootstrap/identity/`：创建子账号与 SSH Key，实现最小权限访问与实例登录。
- `config/`：保留环境无关的账户与资源配置占位符（accounts/resources）。
- `templates/`：包含通用的 `backend.tf` 与 `provider.tf`，用于配置 S3 兼容后端与 Vultr Provider。
- `modules/`：核心模块实现（vpc、compute、storage、iam、data_store），接口与 AWS 模块命名保持一致。
- `envs/`：示例环境（`dev`）展示如何组合模块。

## 使用方式
1. 在 `templates/backend.tf` 中填写 Vultr 对象存储的 endpoint、bucket、访问密钥；在 `templates/provider.tf` 设置 `vultr_api_key` 与默认 region。
2. 使用引导模板创建状态桶与基础身份：
   ```bash
   terraform -chdir=bootstrap/state init
   terraform -chdir=bootstrap/state apply

   terraform -chdir=bootstrap/identity init
   terraform -chdir=bootstrap/identity apply
   ```
3. 根据需要复制 `envs/dev`，调整变量后运行：
   ```bash
   terraform -chdir=envs/dev init
   terraform -chdir=envs/dev apply
   ```
4. 模块可单独在 `envs` 下拆分（如 `dev-vpc`, `dev-compute`），以匹配 AWS 目录的分环境实践。

> 本目录只新增 Vultr 代码，不改动既有 AWS/GCP 模板。
