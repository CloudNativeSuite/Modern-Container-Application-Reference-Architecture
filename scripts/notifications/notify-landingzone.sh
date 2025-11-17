#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# SMTP CONFIG (from GH secrets)
# -----------------------------
SMTP_HOST="${SMTP_HOST:-smtp.qq.com}"
SMTP_PORT="${SMTP_PORT:-465}"
SMTP_USERNAME="${SMTP_USERNAME:-manbuzhe2009@qq.com}"
SMTP_PASSWORD="${SMTP_PASSWORD:?SMTP_PASSWORD missing from GitHub secrets}"
SMTP_FROM="${SMTP_FROM:-XControl Account <manbuzhe2009@qq.com>}"
SMTP_REPLY_TO="${SMTP_REPLY_TO:-no-reply@svc.plus}"

TO_EMAIL="${TO_EMAIL:-manbuzhe2009@qq.com}"
SUBJECT="AWS LandingZone Baseline Deployment Completed"

# -----------------------------
# EMAIL BODY (HTML)
# -----------------------------
BODY_HTML=$(cat <<EOF
<html>
<body>
  <h2>🚀 AWS LandingZone Baseline Rollout Completed</h2>
  <p>The baseline deployment for <b>LandingZone Minimal</b> has successfully finished.</p>
  <p><b>Environment:</b> dev-landingzone<br/>
     <b>Workdir:</b> iac-template/terraform-standard</p>

  <p>This includes:</p>
  <ul>
    <li>IAM Baseline Group</li>
    <li>Deny Root (Partial IAM enforcement)</li>
    <li>MFA Enforcement</li>
    <li>Disable Console Write</li>
    <li>Restrict RI/SP Purchases</li>
  </ul>

  <p>Regards,<br/>XControl CI/CD</p>
</body>
</html>
EOF
)

# -----------------------------
# BUILD RAW MESSAGE
# -----------------------------
MESSAGE=$(cat <<EOF
From: ${SMTP_FROM}
To: ${TO_EMAIL}
Reply-To: ${SMTP_REPLY_TO}
Subject: ${SUBJECT}
MIME-Version: 1.0
Content-Type: text/html; charset=UTF-8

${BODY_HTML}
EOF
)

# -----------------------------
# SEND VIA IMPLICIT TLS (465)
# -----------------------------
echo "📨 Sending LandingZone Email Notification..."

(
  echo "EHLO smtp.qq.com"
  echo "AUTH LOGIN"
  echo -ne "$(printf '%s' "${SMTP_USERNAME}" | base64)\r\n"
  echo -ne "$(printf '%s' "${SMTP_PASSWORD}" | base64)\r\n"
  echo "MAIL FROM:<${SMTP_USERNAME}>"
  echo "RCPT TO:<${TO_EMAIL}>"
  echo "DATA"
  echo "${MESSAGE}"
  echo "."
  echo "QUIT"
) | openssl s_client -quiet -crlf -connect "${SMTP_HOST}:${SMTP_PORT}"

echo "✅ Notification sent."
