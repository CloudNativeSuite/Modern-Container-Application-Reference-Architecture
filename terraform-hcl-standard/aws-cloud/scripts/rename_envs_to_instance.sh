#!/usr/bin/env bash
set -euo pipefail

# Move environment-specific stacks from envs/ into instance/ with environment-less names.
# Run from any directory; the script will change into the aws-cloud root automatically.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${ROOT_DIR}"

declare -A RENAMES=(
  ["envs/dev-vpc"]="instance/vpc"
  ["envs/dev-rds"]="instance/rds"
  ["envs/dev-redis"]="instance/redis"
  ["envs/dev-kafka"]="instance/kafka"
  ["envs/dev-nlb"]="instance/nlb"
  ["envs/dev-alb"]="instance/alb"
  ["envs/dev-object"]="instance/s3"
  ["envs/dev-role"]="instance/role"
  ["envs/dev-ec2"]="instance/ec2"
  ["envs/dev-landingzone"]="instance/landingzone"
)

mkdir -p instance

for FROM in "${!RENAMES[@]}"; do
  TO="${RENAMES[${FROM}]}"
  if [[ -d "${FROM}" ]]; then
    echo "Moving ${FROM} -> ${TO}"
    git mv "${FROM}" "${TO}"
  else
    echo "Skipping ${FROM}; not found" >&2
  fi
done

# Show the resulting structure for quick confirmation
printf "\nCurrent instance layout:\n"
find instance -maxdepth 2 -type d | sed 's/^/  /'
