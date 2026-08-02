#!/usr/bin/env bash
# deploy.sh — manual escape hatch (factory: push to main IS the deploy;
# this is for when Actions is down). Gates first, then direct upload.
set -euo pipefail
cd "$(dirname "$0")/.."

scripts/build.sh auto

tests/check-links.sh
tests/check-copy.sh
tests/check-canonical.sh
tests/check-safety.sh
bun tests/check-contrast.mjs

npx wrangler@latest pages deploy dist --project-name n1-nixfred-com --branch main
echo "deployed. verify: https://n1.nixfred.com/"
