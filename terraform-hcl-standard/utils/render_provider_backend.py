from __future__ import annotations

"""Render provider/backend Terraform files for a single component."""

import argparse
import os
from collections.abc import Mapping
from pathlib import Path
from typing import Iterable, Tuple

import yaml

from renderer import render_file

DEFAULT_IGNORE_FILES = {"vpn-keys.yaml"}


def deep_merge(dict1: dict, dict2: Mapping) -> dict:
    """Recursively merge ``dict2`` into ``dict1`` and return a new dict."""
    result = dict1.copy()
    for key, value in dict2.items():
        if key in result and isinstance(result[key], dict) and isinstance(value, Mapping):
            result[key] = deep_merge(result[key], value)
        elif key in result and isinstance(result[key], list) and isinstance(value, list):
            result[key] = result[key] + value
        else:
            result[key] = value
    return result


def _iter_yaml_files(path: Path, ignore_files: set[str]) -> Iterable[Path]:
    if path.is_file():
        if path.suffix in {".yaml", ".yml"} and path.name not in ignore_files:
            yield path
        return

    patterns = ["**/*.yaml", "**/*.yml"]
    seen: set[Path] = set()
    for pattern in patterns:
        for file_path in sorted(path.glob(pattern)):
            if file_path.name in ignore_files or file_path in seen:
                continue
            seen.add(file_path)
            yield file_path


def _normalize_inputs(config_inputs: list[str] | str | Path | None) -> list[str]:
    if config_inputs is None:
        env_paths = os.environ.get("CONFIG_PATHS") or os.environ.get("CONFIG_PATH")
        config_inputs = env_paths.split(os.pathsep) if env_paths else ["config"]

    if isinstance(config_inputs, (Path, os.PathLike)):
        config_inputs = [config_inputs]

    if isinstance(config_inputs, str):
        config_inputs = [value for value in config_inputs.split(os.pathsep) if value]

    return [str(Path(path).expanduser()) for path in config_inputs]


def load_merged_config(config_inputs: list[str] | str | Path | None = None, ignore_files: list[str] | None = None) -> dict:
    """
    Load and deep-merge YAML content from multiple files or directories.

    ``config_inputs`` accepts:
    - A single path string or Path-like
    - A list of path strings
    - ``None`` (defaults to environment variable ``CONFIG_PATHS`` / ``CONFIG_PATH`` or ``config``)
    """

    ignore = DEFAULT_IGNORE_FILES | set(ignore_files or [])
    merged: dict = {}

    resolved_inputs = _normalize_inputs(config_inputs)
    if not resolved_inputs:
        raise ValueError("No configuration inputs provided")

    loaded_paths: list[str] = []
    for raw_path in resolved_inputs:
        path = Path(raw_path)
        if not path.exists():
            raise FileNotFoundError(f"❌ 配置路径不存在: {path}")

        loaded_paths.append(str(path))
        for file_path in _iter_yaml_files(path, ignore):
            with open(file_path, "r", encoding="utf-8") as handle:
                content = yaml.safe_load(handle) or {}
                merged = deep_merge(merged, content)

    merged["__config_paths__"] = loaded_paths
    return merged


def _load_yaml_file(path: Path) -> dict:
    if not path.exists():
        raise FileNotFoundError(f"Config file not found: {path}")

    with open(path, "r", encoding="utf-8") as handle:
        return yaml.safe_load(handle) or {}


def _resolve_component_config(component: str, modules: Mapping) -> tuple[str, Mapping]:
    if component in modules:
        return component, modules[component]

    for name, module_cfg in modules.items():
        if module_cfg.get("component_dir") == component:
            return name, module_cfg

    raise ValueError(f"Component '{component}' not found in provider_backend.yaml")


def load_provider_backend_config(component: str, config_dir: str | Path) -> Tuple[dict, dict]:
    """Load provider/backend variables for a single component.

    Returns a tuple of (provider_vars, backend_vars).
    """

    config_dir_path = Path(config_dir).expanduser().resolve()
    provider_backend_path = config_dir_path / "provider_backend.yaml"
    config = _load_yaml_file(provider_backend_path)

    modules = config.get("modules") or {}
    defaults = config.get("defaults") or {}

    module_name, module_cfg = _resolve_component_config(component, modules)
    account_name = module_cfg.get("account")
    if not account_name:
        raise ValueError(f"Account is required for component '{module_name}'")

    account_cfg_path = config_dir_path / "accounts" / f"{account_name}.yaml"
    account_cfg = _load_yaml_file(account_cfg_path)

    provider_vars = {
        "TF_VERSION": module_cfg.get("terraform_required_version")
        or defaults.get("terraform_required_version"),
        "AWS_provider_version": module_cfg.get("aws_provider_version")
        or defaults.get("aws_provider_version"),
        "session_name": module_cfg.get("session_name") or defaults.get("session_name"),
        "region": module_cfg.get("region") or account_cfg.get("region"),
    }

    backend_cfg = {}
    backend_cfg.update(account_cfg.get("backend") or {})
    backend_cfg.update(module_cfg.get("backend") or {})
    backend_cfg.setdefault("region", provider_vars.get("region"))
    backend_cfg.setdefault("key", f"{account_name}/{component}/terraform.tfstate")

    if not provider_vars["TF_VERSION"]:
        raise ValueError(f"Terraform required_version is required for component '{module_name}'")
    if not provider_vars["AWS_provider_version"]:
        raise ValueError(f"AWS provider version is required for component '{module_name}'")
    if not backend_cfg.get("bucket"):
        raise ValueError(f"Backend bucket is required for component '{module_name}'")
    if not backend_cfg.get("region"):
        raise ValueError(f"Backend region is required for component '{module_name}'")

    return provider_vars, backend_cfg


def detect_component(component_dir: Path) -> str:
    try:
        return Path.cwd().resolve().relative_to(component_dir.resolve()).parts[0]
    except Exception as exc:  # noqa: BLE001
        raise ValueError("Component could not be detected automatically. Please pass --component.") from exc


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Render Terraform provider/backend files")
    parser.add_argument("--config-dir", required=True, help="Path to the config directory")
    parser.add_argument(
        "--template-dir",
        required=True,
        help="Path to the directory containing provider/backend templates",
    )
    parser.add_argument(
        "--component-dir",
        required=True,
        help="Root directory containing component folders",
    )
    parser.add_argument(
        "--component",
        help="Component name; if omitted we attempt auto-detection based on CWD",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()

    component_dir = Path(args.component_dir).resolve()
    component = args.component or detect_component(component_dir)

    provider_vars, backend_vars = load_provider_backend_config(component, args.config_dir)

    target_dir = component_dir / component
    template_dir = Path(args.template_dir)

    render_file(template_dir, "provider.tf.j2", provider_vars, target_dir / "provider.tf")
    render_file(template_dir, "backend.tf.j2", {"backend": backend_vars}, target_dir / "backend.tf")

    optional_templates = [
        ("variables.tf.j2", target_dir / "variables.tf"),
        ("outputs.tf.j2", target_dir / "outputs.tf"),
    ]
    for template_name, target in optional_templates:
        template_path = template_dir / template_name
        if template_path.exists():
            render_file(template_dir, template_name, provider_vars | {"backend": backend_vars}, target)

    print(f"Rendered provider/backend for component '{component}'")


if __name__ == "__main__":
    main()
