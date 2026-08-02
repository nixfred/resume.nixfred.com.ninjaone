#!/usr/bin/env bash
# Static safety + privacy gate (adapted from the SiteFactory seed).
# No forms, payments, credentials, external scripts or styles, and no
# private exposure: no /Users/ paths, no machine names, no local URLs,
# no private individuals (site rule: no NinjaOne people named).
set -euo pipefail
cd "$(dirname "$0")/.."

if [ ! -d dist ]; then
  echo "dist/ missing. Run scripts/build.sh first." >&2
  exit 2
fi

fail=0

check() {
  local label="$1" pattern="$2"
  local hits
  hits=$(grep -rInE "$pattern" dist --include='*.html' --include='*.js' --include='*.css' || true)
  if [ -n "$hits" ]; then
    echo "VIOLATION [$label]:"
    echo "$hits" | head -8
    fail=1
  fi
}

check "form action" '<form[^>]+action='
check "card fields" 'autocomplete="cc-|name="card|name="cvv|name="cvc|placeholder="[^"]*card number'
check "password input" 'type="password"'
check "payment processors" 'stripe|paypal|braintree|checkout\.com|squareup'
check "external script" '<script[^>]+src="https?://'
check "external style" '<link[^>]+href="https?://[^"]+\.css'
check "local path leak" '/Users/|/home/[a-z]'
check "localhost leak" 'localhost|127\.0\.0\.1'
check "private individuals" 'McCallum|Heller|Hebner|Babson|Chapman|Scott Lewis'

if [ "$fail" -eq 1 ]; then
  echo "STATIC SAFETY: FAILED"
  exit 1
fi
echo "STATIC SAFETY: CLEAN"
