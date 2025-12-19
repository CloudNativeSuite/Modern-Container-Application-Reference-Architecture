from __future__ import annotations

"""Compatibility shim that re-exports config helpers from render_provider_backend."""

from pathlib import Path
from typing import Tuple

import yaml

from render_provider_backend import (  # noqa: F401
    deep_merge,
    load_merged_config,
    load_provider_backend_config,
)

__all__ = [
    "deep_merge",
    "load_account_credentials",
    "load_merged_config",
    "load_provider_backend_config",
]


def load_account_credentials(account_file: str | Path) -> Tuple[str, str]:
    """Load AWS region and role from an account YAML file."""

    path = Path(account_file).expanduser()
    if not path.exists():
        raise FileNotFoundError(f"Account config file not found: {path}")

    with path.open("r", encoding="utf-8") as handle:
        cfg = yaml.safe_load(handle) or {}

    try:
        region = cfg["region"]
        role_arn = cfg["role_to_assume"]
    except KeyError as exc:  # noqa: PERF203
        raise KeyError(f"Missing required key in account config: {exc.args[0]}") from exc

    return region, role_arn
