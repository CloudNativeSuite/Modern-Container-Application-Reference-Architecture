
CloudNeutral Virtual Cloud（VNC Minimal）

A Unified Virtual Cloud Abstraction Layer for Multi-Cloud Infrastructure

1. 一句话概念

虚拟中立云（Virtual Neutral Cloud）= 用 5 个 CloudNeutral 核心模块，把 AWS / GCP / 阿里云 / 自建集群伪装成“一朵统一的云”。
用户永远只看见：

Tenant → Project → Environment → Region → Services


而不会再感知底层：

AWS / GCP / AliCloud / On-Prem


CloudNeutral 成为云之上的云。

2. 架构总览（MVP）

下面是 CloudNeutral Virtual Cloud 的最小可运行版本（Minimum Viable Cloud）：

flowchart TB

subgraph VNC["CloudNeutral Virtual Cloud（最小可运行版本）"]
  XLogin[XLogin<br/>统一身份 / Tenant / RBAC]
  XCloudFlow[XCloudFlow<br/>虚拟资源 → 多云 Terraform]
  XPlane[XPlane<br/>虚拟 Region/Env + GSLB]
  XScopeHub[XScopeHub<br/>统一观测 API]
  XControl[XControl<br/>虚拟云控制台]
end

subgraph Clouds["实际多云资源（被抽象和隐藏）"]
  AWS[(AWS)]
  GCP[(GCP)]
  Aliyun[(Aliyun)]
  OnPrem[(On-Prem K8s)]
end

XCloudFlow --> AWS
XCloudFlow --> GCP
XCloudFlow --> Aliyun
XCloudFlow --> OnPrem

XPlane --> AWS
XPlane --> GCP

XScopeHub --> AWS
XScopeHub --> GCP
XScopeHub --> OnPrem

XControl --> XLogin
XControl --> XCloudFlow
XControl --> XPlane
XControl --> XScopeHub


CloudNeutral 的五大模块每个只做一件事，各司其职，联合构成虚拟云。

3. 五大核心模块（Minimal Responsibility Set）
3.1 XLogin — 虚拟云的统一 IAM

XLogin 把所有云厂商的用户体系“降级”为资源后端。
它自己定义：

登录方式（OIDC → JWT）

租户（Tenant）

权限模型（RBAC → 哪个用户能访问哪些项目/区域）

最终结果：

AWS IAM 不再是主角，只是 XLogin 的一个 OIDC Consumer。
XLogin 才是“虚拟云的账户系统”。

3.2 XCloudFlow — 虚拟资源 → 多云资源编排器（IaC Orchestrator）

用户永远只描述“虚拟资源”，例如：

service: orders-api
env: prod
region: jp1
size: small
runtime: k8s


XCloudFlow 的职责：

将虚拟 Region → 映射到真实云
jp1 → AWS ap-northeast-1

将虚拟规格 → 映射到真实模板
small → t4g.medium + 2 pods

渲染标准 Terraform 模块

触发 GitHub Actions 完成 plan/apply

它是整朵虚拟云的“发动机”。

3.3 XPlane — 虚拟 Region / Env + 全局流量控制（GSLB）

它让用户只需要关心：

jp1 / sg1 / eu1 / cn1
dev / test / prod


真实配置隐藏在映射表里：

regions:
  jp1:
    backend:
      - type: aws
        region: ap-northeast-1
        ingress: eks.jp.example.com


同时负责：

全局流量路由（latency / weight / failover）

服务入口：api.cloudneutral.io / ai.cloudneutral.io

XPlane 让 CloudNeutral 看起来像一朵真正的全球云。

3.4 XScopeHub — 虚拟云的统一观测入口

它不是替代 Prometheus/Loki，而是做一层“虚拟云视角的统一查询 API”。

职责：

聚合多云 Prometheus（Metrics）

聚合多云 Loki（Logs）

强制统一标签体系：
tenant / project / env / region / service

提供标准 API：
/metrics?region=jp1&service=orders-api

于是：

多云观测 → 变成一朵云的观测。

3.5 XControl — 虚拟云的 Portal / Console

登录（XLogin） 项目/环境/区域视图

管理流量 → 调用 XPlane
创建服务 → 触发 XCloudFlow
监控视图 → 来自 XScopeHub

所有功能最终收敛到 XControl：

换句话说：

XControl = CloudNeutral 的 AWS Console / GCP Console。
但世界里只有 CloudNeutral 的概念。

4. 最小 MVP 要素（你现在就能运行）

必须组件：

XLogin
XCloudFlow
XPlane
XScopeHub
XControl

必须定义：

Tenant
Project
Environment
Region
Service

必须动作：

XLogin → 发 JWT
XCloudFlow → 虚拟 YAML → Terraform → GitOps
XPlane → DNS/GSLB 控制
XScopeHub → 聚合 Prom/Loki
XControl → 提供统一 UI

最终结果：

底层变成节点，上层变成“统一的虚拟云”。

你不是替代 AWS/GCP，
你是把它们抽象成 CloudNeutral 背后的资源池。
