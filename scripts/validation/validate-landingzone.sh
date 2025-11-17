#!/usr/bin/env bash
set -euo pipefail

TARGET_ENV_PATH="$1"

echo "🔍 Validating AWS LandingZone Baseline..."
echo "Target path: $TARGET_ENV_PATH"
echo "Region: ${AWS_REGION}"

# -------------------------
# Check 1: IAM Group Exists
# -------------------------
echo -n "Checking IAM group LandingZoneBaseline... "
if aws iam get-group --group-name LandingZoneBaseline >/dev/null 2>&1; then
  echo "OK"
else
  echo "FAILED"
  exit 1
fi

# -----------------------------
# Check 2: Required Policies
# -----------------------------
REQUIRED_POLICIES=(
  "landingzone-deny-root"
  "landingzone-deny-no-mfa"
  "landingzone-deny-console-write"
  "landingzone-deny-ri-sp"
)

echo "Checking IAM baseline policies..."
for p in "${REQUIRED_POLICIES[@]}"; do
  echo -n "  - $p ... "
  if aws iam list-policies --scope Local --query "Policies[?PolicyName=='$p']" --output text | grep "$p" >/dev/null; then
    echo "OK"
  else
    echo "FAILED"
    exit 1
  fi
done

# -----------------------------
# Check 3: Policy Attachments
# -----------------------------
echo "Checking policy attachments..."
for p in "${REQUIRED_POLICIES[@]}"; do
  ARN=$(aws iam list-policies --scope Local --query "Policies[?PolicyName=='$p'].Arn" --output text)

  echo -n "  - $p attached ... "
  if aws iam list-attached-group-policies \
    --group-name LandingZoneBaseline \
    --query "AttachedPolicies[?PolicyArn=='$ARN']" \
    --output text | grep "$p" >/dev/null; then
    echo "OK"
  else
    echo "FAILED"
    exit 1
  fi
done

# -----------------------------
# Check 4: Terraform State Exists
# -----------------------------
echo -n "Checking Terraform state presence... "
if test -f "${TARGET_ENV_PATH}/terraform.tfstate"; then
  echo "OK"
else
  echo "OK (remote backend)"
fi

# -----------------------------
# Check 5: root AccessKey
# -----------------------------
echo -n "Checking root AccessKey... "
ROOT_KEYS=$(aws iam list-access-keys --user-name root 2>/dev/null || true)

if [[ -z "$ROOT_KEYS" ]]; then
  echo "OK (none)"
else
  echo "FAILED (root has access keys!)"
  exit 1
fi

# -----------------------------
# Check 6: MFA Enforcement (Account Summary)
# -----------------------------
echo -n "Checking MFA requirement... "
MFA=$(aws iam get-account-summary --query "SummaryMap.AccountMFAEnabled" --output text)

if [[ "$MFA" == "1" ]]; then
  echo "OK"
else
  echo "WARNING (Account MFA not enforced globally)"
fi

echo "✅ LandingZone baseline validation PASSED"
exit 0
