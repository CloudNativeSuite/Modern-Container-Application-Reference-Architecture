from __future__ import annotations

"""Compatibility shim that re-exports config helpers from render_provider_backend."""

from render_provider_backend import (  # noqa: F401
    deep_merge,
    load_merged_config,
    load_provider_backend_config,
)

__all__ = [
    "deep_merge",
    "load_merged_config",
    "load_provider_backend_config",
]
