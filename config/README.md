# Configuration Layout

This repository keeps environment-specific infrastructure configuration under the `config/` directory. The layout follows a consistent project → environment → cloud/provider → resource-module hierarchy so that each stack can be managed independently.

## Recommended standard layout

```
config/
└── <project>/
    └── <env>/
        └── <cloud>/
            ├── base.yaml
            ├── identity.yaml
            ├── network.yaml
            ├── security.yaml
            ├── storage.yaml
            ├── compute.yaml
            ├── observability.yaml
            └── <feature>.yaml
```

- **Project**: top-level application or platform (for example `modern-container-app`, `cloudneutral-platform`, or `ai-infra-lab`).
- **Environment**: fully isolated deployment stages such as `dev`, `sit`, `uat`, and `prod`.
- **Cloud/Provider**: clear provider identifiers such as `aws-cloud`, `gcp-cloud`, or `vultr-vps`.
- **Resource modules**: YAML slices for base settings, identity, network, security, storage, compute, observability, and feature-specific needs.

## Applied layout for this repository

The current repo uses the `xzerolab` project with a `sit` environment. Provider-specific configurations are organized per cloud alongside shared assets for future environments.

```
config/
├── bootstrap.yaml
└── xzerolab/
    └── sit/
        ├── aws-cloud/
        │   ├── accounts/
        │   │   ├── bootstrap.yaml
        │   │   ├── dev-landingzone.yaml
        │   │   └── dev.yaml
        │   ├── provider_backend.yaml
        │   └── resources/
        │       ├── dev-alb/alb.yaml
        │       ├── dev-kafka/msk.yaml
        │       ├── dev-nlb/nlb.yaml
        │       ├── dev-object/bucket.yaml
        │       ├── dev-rds/rds.yaml
        │       ├── dev-redis/redis.yaml
        │       ├── ec2/dev.yaml
        │       └── vpc/dev.yaml
        ├── gcp-cloud/
        │   ├── accounts/
        │   │   ├── bootstrap.yaml
        │   │   ├── dev-landingzone.yaml
        │   │   └── dev.yaml
        │   └── resources/
        │       ├── dev-alb/alb.yaml
        │       ├── dev-kafka/msk.yaml
        │       ├── dev-nlb/nlb.yaml
        │       ├── dev-object/bucket.yaml
        │       ├── dev-rds/rds.yaml
        │       ├── dev-redis/redis.yaml
        │       ├── ec2/dev.yaml
        │       └── vpc/dev.yaml
        └── vultr-vps/
            ├── accounts/
            │   └── .gitkeep
            └── resources/
                └── .gitkeep
```

Use this layout to keep each environment and provider self-contained, making it easy for CI/CD workflows to target the exact configuration needed for a deployment.
