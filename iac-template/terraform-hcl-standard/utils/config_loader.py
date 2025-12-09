from __future__ import annotations

import os
from collections.abc import Mapping
from pathlib import Path
from typing import Iterable

import yaml

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
