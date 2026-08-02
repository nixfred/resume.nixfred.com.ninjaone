#!/usr/bin/env bash
# build.sh — assemble the deployable site into dist/, stamp the footer
# version, and render the OG card + favicon rasters.
#
# Version stamping: the repo keeps "dev-local" in index.html; dist gets
# v<yyyymmdd>-<shortsha> so the footer always names the deployed commit
# (factory Law 11 / STANDARDS section 3.5).
set -euo pipefail
cd "$(dirname "$0")/.."

VERSION="${1:-dev-local}"
[ "$VERSION" = "dev-local" ] || true
if [ "$VERSION" = "auto" ]; then
  VERSION="v$(date +%Y%m%d)-$(git rev-parse --short HEAD 2>/dev/null || echo nogit)"
fi

rm -rf dist
mkdir -p dist/assets

# static site files
cp index.html tokens.css styles.css print.css favicon.svg robots.txt sitemap.xml _headers dist/
cp assets/fonts/*.woff2 dist/assets/

# version stamp (footer span carries the only copy of the string)
sed -i '' "s|<span class=\"version\">dev-local</span>|<span class=\"version\">${VERSION}</span>|" dist/index.html

# favicon rasters from the same SVG (factory metadata contract)
rsvg-convert -w 32 -h 32 favicon.svg -o dist/assets/favicon-32.png
rsvg-convert -w 180 -h 180 favicon.svg -o dist/assets/favicon-180.png

# OG card: render og.html at exactly 1200x630
CHROME=""
for c in "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
         "$(command -v google-chrome || true)" \
         "$(command -v chromium || true)" \
         "$(command -v chromium-browser || true)"; do
  [ -n "$c" ] && [ -x "$c" ] && CHROME="$c" && break
done
if [ -z "$CHROME" ]; then
  echo "no Chrome found for OG render" >&2
  exit 1
fi
"$CHROME" --headless --disable-gpu --hide-scrollbars \
  --window-size=1200,630 --screenshot=dist/assets/og.png \
  "file://$PWD/og.html" >/dev/null 2>&1

echo "built dist/ with version ${VERSION}"
