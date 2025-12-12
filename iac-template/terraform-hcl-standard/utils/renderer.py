"""Minimal rendering helpers for Terraform templates.

These helpers stay cloud-agnostic: callers provide the template directory,
the template name, and a variables mapping. Only two entrypoints are
exposed so higher-level orchestration can remain declarative.
"""
from __future__ import annotations

from pathlib import Path
from typing import Mapping

from jinja2 import Environment, FileSystemLoader, StrictUndefined


def _environment(template_dir: Path) -> Environment:
    return Environment(
        loader=FileSystemLoader(str(template_dir)),
        autoescape=False,
        keep_trailing_newline=True,
        undefined=StrictUndefined,
    )


def render_string(template_dir: str | Path, template_name: str, variables: Mapping) -> str:
    """Render a template to a string."""

    env = _environment(Path(template_dir))
    template = env.get_template(template_name)
    return template.render(**variables)


def render_file(
    template_dir: str | Path,
    template_name: str,
    variables: Mapping,
    target_path: str | Path,
) -> Path:
    """Render a template directly to disk."""

    content = render_string(template_dir, template_name, variables)
    target = Path(target_path)
    target.write_text(content, encoding="utf-8")
    return target
