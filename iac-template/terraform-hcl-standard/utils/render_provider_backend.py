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
ENVS_DIR = CURRENT_DIR / "component"

sys.path.append(str(PROJECT_ROOT / "utils"))
from config_loader import load_merged_config  # noqa: E402


def merge_var(config_files: list[str | Path]) -> Dict:
    if not config_files:
        raise ValueError("At least one config file is required")

    config_inputs: list[str] = []
    for config_file in config_files:
        path = Path(config_file)
        if not path.is_absolute():
            path = CONFIG_DIR / path
        if not path.exists():
            raise FileNotFoundError(f"Config file not found: {path}")
        config_inputs.append(str(path))

    return load_merged_config(config_inputs)


def detect_target_component() -> str | None:
    """Return the component directory name if running inside one, otherwise None."""

    try:
        rel_path = Path.cwd().resolve().relative_to(ENVS_DIR)
    except ValueError:
        return None

    return rel_path.parts[0] if rel_path.parts else None


def render_templates():
    config_files = sys.argv[1:] or [CONFIG_DIR / "provider_backend.yaml"]
    provider_backend_cfg = merge_var(config_files)
    defaults = provider_backend_cfg.get("defaults") or {}
    modules = provider_backend_cfg.get("modules") or {}

    if not modules:
        raise ValueError("No modules found in configuration")

    env = Environment(loader=FileSystemLoader(TEMPLATE_DIR), keep_trailing_newline=True)
    provider_template = env.get_template("provider.tf.j2")
    backend_template = env.get_template("backend.tf.j2")

    target_component = detect_target_component()

    for module_name, module_config in modules.items():
        module_dir_name = module_config.get("component_dir") or module_name.split("-", 1)[
            -1
        ]
        module_dir = ENVS_DIR / module_dir_name

        if target_component and module_dir_name != target_component:
            continue
        if not module_dir.exists():
            print(f"⚠️  Skipping {module_name}: {module_dir} not found")
            continue

        account_name = module_config.get("account")
        if not account_name:
            raise ValueError(f"Account is required for module {module_name}")

        account_config_inputs = [CONFIG_DIR / "accounts" / f"{account_name}.yaml"]
        account_config_inputs.extend(
            CONFIG_DIR / path for path in module_config.get("config_inputs", [])
        )
        account_config = merge_var(account_config_inputs)

        region = module_config.get("region") or account_config.get("region")
        if not region:
            raise ValueError(f"Region is required for module {module_name}")

        tf_version = module_config.get("terraform_required_version") or defaults.get(
            "terraform_required_version"
        )
        aws_provider_version = module_config.get("aws_provider_version") or defaults.get(
            "aws_provider_version"
        )
        if not tf_version:
            raise ValueError(f"Terraform required_version is required for module {module_name}")
        if not aws_provider_version:
            raise ValueError(f"AWS provider version is required for module {module_name}")

        backend_overrides = module_config.get("backend", {})
        backend_bucket = backend_overrides.get("bucket") or account_config.get("backend", {}).get(
            "bucket"
        )
        backend_key = backend_overrides.get("key")
        backend_region = backend_overrides.get("region") or account_config.get("region")
        dynamodb_table = backend_overrides.get("dynamodb_table") or account_config.get(
            "backend", {}
        ).get("dynamodb_table")

        if not backend_bucket:
            raise ValueError(f"Backend bucket is required for module {module_name}")
        if not backend_key:
            raise ValueError(f"Backend key is required for module {module_name}")
        if not backend_region:
            raise ValueError(f"Backend region is required for module {module_name}")

        provider_config = {
            "TF_VERSION": tf_version,
            "AWS_provider_version": aws_provider_version,
            "region": region,
        }
        backend_config = {
            "bucket": backend_bucket,
            "key": backend_key,
            "region": backend_region,
            "dynamodb_table": dynamodb_table,
        }

        provider_content = provider_template.render(**provider_config)
        backend_content = backend_template.render(backend=backend_config)

        (module_dir / "provider.tf").write_text(provider_content, encoding="utf-8")
        (module_dir / "backend.tf").write_text(backend_content, encoding="utf-8")
        print(f"✅ Rendered provider/backend for {module_name}")


if __name__ == "__main__":
    render_templates()
