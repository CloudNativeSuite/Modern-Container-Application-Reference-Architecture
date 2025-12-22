#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${ROOT_DIR}"

RUN_TERRAFORM=false
if [[ ${1:-} == "--terraform-validate" ]]; then
  RUN_TERRAFORM=true
fi

status=0

if [[ -d envs ]]; then
  ORPHANS=$(find envs -maxdepth 1 -type d -name 'dev-*' ! -path 'envs')
  if [[ -n "${ORPHANS}" ]]; then
    echo "[FAIL] Orphan environment directories detected under envs/:"
    echo "${ORPHANS}" | sed 's/^/  - /'
    status=1
  else
    echo "[OK] No orphaned envs/dev-* directories remain."
  fi
else
  echo "[WARN] envs/ directory not found; skipping orphan check."
fi

python <<'PY'
import pathlib
import re
import sys

root = pathlib.Path(__file__).resolve().parents[1]
instance_dir = root / "instance"
issues = []

file_pattern = re.compile(r'file\("\$\{path\.root\}/([^"}]+)"\)')
source_pattern = re.compile(r'source\s*=\s*"([\.\./][^"]+)"')
rel_hint_pattern = re.compile(r'(\.\./\.\./[^"\s]+)')

for tf in instance_dir.rglob("*.tf"):
    text = tf.read_text()

    for match in file_pattern.finditer(text):
        rel = match.group(1)
        target = (tf.parent / rel).resolve()
        if not target.exists():
            issues.append(f"{tf}: missing YAML target -> {target}")

    for match in source_pattern.finditer(text):
        rel = match.group(1)
        target = (tf.parent / rel).resolve()
        if not target.exists():
            issues.append(f"{tf}: module source not found -> {target}")

    for match in rel_hint_pattern.finditer(text):
        rel = match.group(1)
        target = (tf.parent / rel).resolve()
        if not target.exists():
            issues.append(f"{tf}: relative path hint not found -> {target}")

if issues:
    print("[FAIL] Broken paths detected:")
    for issue in issues:
        print(f"  - {issue}")
    sys.exit(1)
else:
    print("[OK] Terraform files reference existing relative paths.")
PY

if [[ ${RUN_TERRAFORM} == true ]]; then
  if command -v terraform >/dev/null 2>&1; then
    for DIR in instance/*; do
      if [[ -d ${DIR} ]]; then
        echo "Running terraform validate in ${DIR}" \
          && (cd "${DIR}" && terraform validate) || status=1
      fi
    done
  else
    echo "[WARN] terraform binary not found; skipping validate step."
  fi
else
  echo "[INFO] Terraform validate skipped (enable with --terraform-validate)."
fi

exit ${status}
