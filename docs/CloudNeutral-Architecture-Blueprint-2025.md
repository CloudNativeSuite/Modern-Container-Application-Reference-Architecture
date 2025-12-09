这一份 Blueprint 定义了现代企业级系统在 2025 年最小即可运行的全景架构。
它同时也是 CloudNeutral 模块体系的全局定位图：任何模块（XCloudFlow / XControl / XScopeHub / XPlane / AI Runtime / Infra-as-Code）都可以从此获取“自己在全局中的位置”。

🧩 全局架构图（Mermaid，可直接复制使用）
```···
flowchart TB

%% ---------------------------
%% IaaS & Core Infrastructure
%% ---------------------------

subgraph IaaS["IaaS 层（运行时基础设施）"]
  direction TB
  LB[负载均衡<br/>ALB / NLB / Ingress]
  Compute[计算资源<br/>VM / GPU VM / K8s Node]
  Network[VPC / 子网 / 路由 / SG]
  Storage[对象存储 / 块存储<br/>S3 / GCS / OSS / MinIO]
  Cache[缓存服务<br/>Redis / Memcached]
  MQ[消息队列<br/>RabbitMQ / AWS SQS]
  APIgw[API Gateway<br/>Kong / APISIX / Cloud GW]
end

%% ---------------------------
%% Core Data Layer
%% ---------------------------

subgraph CoreData["核心数据层（Database / Storage）"]
  direction TB
  Postgres[PostgreSQL<br/>OLTP 主数据库]
  ClickHouse[ClickHouse<br/>OLAP 数仓]
  MinIO[MinIO<br/>S3 兼容对象存储]
end

%% ---------------------------
%% Data Compute Layer
%% ---------------------------

subgraph BigData["大数据计算层（Batch / SQL / Stream）"]
  direction TB
  Trino[Trino / Presto<br/>SQL 查询引擎]
  Redpanda[Redpanda（或 Kafka）<br/>事件流 / 消息总线]
end

%% ---------------------------
%% AI Compute Layer
%% ---------------------------

subgraph AI["AI / ML / LLM Runtime（训练 & 推理）"]
  direction TB
  Ray[Ray Cluster （单节点 Dev / K8s Prod）]
  MLflow[MLflow Tracking + Model Registry]
  Embd[Embedding Service<br/>向量生成]
  VLLM[vLLM / SGLang<br/>LLM 推理服务]
  InferenceGW[Inference Gateway<br/>Prompt 路由 / A/B / Token 限流]
end

%% ---------------------------
%% Observability Layer
%% ---------------------------

subgraph Obs["可观测性层（Observability）"]
  direction TB
  Prom[Prometheus Stack<br/>指标 + 告警]
  Loki[Loki<br/>日志]
  Grafana[Grafana<br/>统一可视化]
end

%% ---------------------------
%% Data Flow & Dependencies
%% ---------------------------

Network --> Compute
Compute --> CoreData
Compute --> BigData
Compute --> AI
Compute --> Obs

Storage --> CoreData
Storage --> BigData
Storage --> AI
Storage --> Obs

Postgres --> Trino
ClickHouse --> Trino
MinIO --> Trino

Redpanda --> Trino
Redpanda --> Ray
Redpanda --> VLLM

Ray --> MLflow
MLflow --> VLLM

VLLM --> InferenceGW
Embd --> InferenceGW

APIgw --> InferenceGW
LB --> APIgw

Prom --> Grafana
Loki --> Grafana

📘 架构分层说明
① IaaS 层（底座层：Compute / Network / Storage / Gateway）

在现代系统中已高度标准化：

LB / Ingress / API Gateway：服务入口

VPC / SG / 子网：网络结构

K8s Node / GPU Node / VM：计算资源

对象存储（S3/GCS/OSS/MinIO）：统一的数据落地层

Redis / MQ（Kafka/SQS/Redpanda）：缓存 + 异步事件

APISIX / Kong：南北向流量入口

管理方式：

Terraform 管基础设施

Ansible 管操作系统

Helm 不负责系统底座，仅负责 K8s 内部应用

这是 CloudNeutral 的 Infra Runtime Plane。

② 核心数据库层（OLTP / OLAP / Object Store）

现代企业数据三件套：

类型	组件	用途
OLTP	PostgreSQL	主业务数据库
OLAP	ClickHouse	实时分析数仓
Data Lake	MinIO (S3 API)	模型存储、日志、湖仓结构

MinIO 在全景中的角色异常重要，它不是“对象存储替代品”，而是：

你的 模型仓库

Trino 的底层数据湖

AI 模型、Embedding、日志文件的中心落地点

这是 CloudNeutral 的 DataStore Plane。

③ 大数据计算层（Batch / SQL / Streaming）

现代系统的“数据中枢”：

Trino：跨库 SQL 统一查询（Postgres + ClickHouse + MinIO 同查）

Redpanda（Kafka）：事件数据总线（代替传统 MQ）

功能定位：

Query Layer（SQL 查询）

Event Layer（事件驱动）

这是 CloudNeutral Data Compute Plane（数据计算平面）。

④ AI / ML / LLM Runtime 层

2025 年系统的“智能心脏”：

Ray：分布式训练、特征处理、批量计算

MLflow：实验追踪 + 模型库

Embedding Service：向量生成（RAG 基石）

vLLM / SGLang：推理服务

Inference Gateway：Prompt 路由、A/B、限流、多模型融合

这是 CloudNeutral AI Runtime Plane 的核心。

⑤ 可观测性层（Observability）

统一观测系统的三件套：

Prometheus Stack：指标 + 告警

Loki：日志

Grafana：统一查询与可视化

你的 XScopeHub 就是从这一层自然生长出来的。

📐 这张全景图的意义

为什么说这是 2025 年最小可运行的现代系统架构？

因为它完整串起：
传统 IaaS 底座
数据库与湖仓系统
SQL + 流式事件 + 批处理
AI/LLM 推理与训练
统一观测体系

并且为 CloudNeutral 所有模块提供了清晰定位：

CloudNeutral 模块	在全景图的位置
XCloudFlow	IaC + 多云管理控制面
XControl	统一界面 / DevOps Portal
XScopeHub	Observability Plane
XPlane	全局流量、DNS GSLB、自动扩缩容控制面
XStream（LLM Client）	Inference Gateway 客户端
Data / AI 子项目	MinIO + Trino + Ray + vLLM 全链路

这一张图就是 CloudNeutral 的宇宙坐标系，未来任何模块扩展都能找到它的参考方向。
