#!/usr/bin/env bash
set -euo pipefail

# Normalize relative paths inside Terraform stacks after moving envs/* to instance/*.
# The script uses BSD sed on macOS or gsed if available.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${ROOT_DIR}"

SED_CMD="$(command -v gsed || command -v sed)"

FILES=$(find instance -type f \( -name "main.tf" -o -name "outputs.tf" -o -name "Makefile" \))

for FILE in ${FILES}; do
  echo "Rewriting paths in ${FILE}"
  # Point any lingering envs/dev-* references to the new instance layout
  ${SED_CMD} -i'' -e 's|envs/dev-[a-zA-Z0-9_-]*/|instance/|g' "${FILE}"

  # Ensure YAML lookups target the config folder two levels up
  ${SED_CMD} -i'' -e 's|file("${path.root}/../../config/|file("${path.root}/../../config/|g' "${FILE}"

  # Keep module sources anchored on the shared modules directory
  ${SED_CMD} -i'' -e 's|source = "../../modules/|source = "../../modules/|g' "${FILE}"
done

echo "Path normalization complete. Review git diff for any updates."
