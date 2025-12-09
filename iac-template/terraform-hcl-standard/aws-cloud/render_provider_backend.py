from __future__ import annotations

import os
import sys
from pathlib import Path
from typing import Dict

from jinja2 import Environment, FileSystemLoader

CURRENT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = CURRENT_DIR.parent
CONFIG_DIR = Path(
    os.environ.get("AWS_CLOUD_CONFIG_PATH", PROJECT_ROOT / "aws-cloud" / "config")
)
TEMPLATE_DIR = CURRENT_DIR / "templates"
ENVS_DIR = CURRENT_DIR / "envs"

sys.path.append(str(PROJECT_ROOT / "utils"))
from config_loader import load_merged_config  # noqa: E402


def build_provider_config(module_name: str, module_config: Dict, account_config: Dict, defaults: Dict) -> Dict:
    region = module_config.get("region") or account_config.get("region")
    if not region:
        raise ValueError(f"Region is required for module {module_name}")

    return {
        "terraform": {
            "required_version": module_config.get("terraform_required_version")
            or defaults.get("terraform_required_version", ">= 1.2"),
            "aws_provider_version": module_config.get("aws_provider_version")
            or defaults.get("aws_provider_version", "~> 5.92.0"),
        },
        "region": region,
        "assume_role_arn": module_config.get("assume_role_arn")
        or account_config.get("role_to_assume"),
        "session_name": module_config.get("session_name")
        or defaults.get("session_name", "TerraformSession"),
    }


def build_backend_config(module_name: str, module_config: Dict, account_config: Dict) -> Dict:
    backend_overrides = module_config.get("backend", {})
    backend_bucket = backend_overrides.get("bucket") or account_config.get("backend", {}).get(
        "bucket"
    )
    dynamodb_table = backend_overrides.get("dynamodb_table") or account_config.get(
        "backend", {}
    ).get("dynamodb_table")
    backend_key = backend_overrides.get("key")
    backend_region = backend_overrides.get("region") or account_config.get("region")

    if not backend_bucket:
        raise ValueError(f"Backend bucket is required for module {module_name}")
    if not backend_key:
        raise ValueError(f"Backend key is required for module {module_name}")
    if not backend_region:
        raise ValueError(f"Backend region is required for module {module_name}")

    return {
        "bucket": backend_bucket,
        "key": backend_key,
        "region": backend_region,
        "dynamodb_table": dynamodb_table,
    }


def load_account_config(account_name: str, additional_inputs: list[str] | None = None) -> Dict:
    account_config_path = CONFIG_DIR / "accounts" / f"{account_name}.yaml"
    config_inputs = [str(account_config_path)] + [str(CONFIG_DIR / path) for path in additional_inputs or []]
    return load_merged_config(config_inputs)


def render_templates():
    provider_backend_cfg = load_merged_config(CONFIG_DIR / "provider_backend.yaml")
    defaults = provider_backend_cfg.get("defaults", {})
    modules = provider_backend_cfg.get("modules", {})

    env = Environment(loader=FileSystemLoader(TEMPLATE_DIR), keep_trailing_newline=True)
    provider_template = env.get_template("provider.tf.j2")
    backend_template = env.get_template("backend.tf.j2")

    for module_name, module_config in modules.items():
        module_dir = ENVS_DIR / module_name
        if not module_dir.exists():
            print(f"⚠️  Skipping {module_name}: {module_dir} not found")
            continue

        account_name = module_config.get("account")
        if not account_name:
            raise ValueError(f"Account is required for module {module_name}")

        account_config = load_account_config(account_name, module_config.get("config_inputs"))

        provider_config = build_provider_config(module_name, module_config, account_config, defaults)
        backend_config = build_backend_config(module_name, module_config, account_config)

        provider_content = provider_template.render(provider=provider_config)
        backend_content = backend_template.render(backend=backend_config)

        (module_dir / "provider.tf").write_text(provider_content, encoding="utf-8")
        (module_dir / "backend.tf").write_text(backend_content, encoding="utf-8")
        print(f"✅ Rendered provider/backend for {module_name}")


if __name__ == "__main__":
    render_templates()
