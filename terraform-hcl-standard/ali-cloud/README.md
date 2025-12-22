# Alibaba Cloud Terraform Standard

该目录提供与 AWS 目录对应的阿里云版本，用于在阿里云上快速引导基础设施。结构与 AWS 模板保持一致，包含引导阶段 (bootstrap)、环境示例 (envs) 与模块库 (modules)。

## AWS → Alibaba Cloud 映射
- **S3 → OSS**：`bootstrap/state` 创建远端状态桶，开启版本化与服务器端加密。
- **DynamoDB → TableStore (OTS)**：`bootstrap/lock` 创建状态锁表，用于 Terraform 后端锁定。
- **IAM → RAM**：`bootstrap/identity` 建立基础访问控制（RAM 角色、策略与用户）。
- **VPC**：`modules/vpc` 使用专有网络与交换机，替代 AWS VPC/Subnet。
- **ALB / NLB**：`modules/alb` 和 `modules/nlb` 分别映射到应用型负载均衡 (ALB) 与传统负载均衡 (SLB/NLB)。
- **EC2 → ECS**：`modules/ecs` 提供计算实例与安全组。
- **S3 → OSS**：`modules/oss` 作为通用对象存储模块。
- **IAM → RAM**：`modules/ram` 封装 RAM 角色与策略创建。
- **RDS / Redis / MSK**：`modules/rds`、`modules/redis` 提供 ApsaraDB 数据库与缓存，Kafka 类似需求可通过云消息队列/中间件扩展。

## 使用方式
1. 在 `templates/backend.tf` 中配置远端状态（OSS 桶与可选 OTS 锁表）。
2. 在 `templates/provider.tf` 中设置 `region`、`access_key`、`secret_key` 或 RAM 角色扮演信息，可通过环境变量传入。
3. 运行引导阶段：
   ```bash
   terraform -chdir=bootstrap/state init && terraform -chdir=bootstrap/state apply
   terraform -chdir=bootstrap/lock init && terraform -chdir=bootstrap/lock apply
   terraform -chdir=bootstrap/identity init && terraform -chdir=bootstrap/identity apply
   ```
4. 按需修改 `envs/dev` 下的示例，执行：
   ```bash
   terraform -chdir=envs/dev init
   terraform -chdir=envs/dev apply
   ```

本目录仅新增阿里云模板，不改动现有 AWS/GCP 代码。
