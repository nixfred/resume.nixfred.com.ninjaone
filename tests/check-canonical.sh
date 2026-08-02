#!/usr/bin/env bash
# Canonical URL integrity gate (adapted from the SiteFactory seed).
# Canonical and og:url must be https://n1.nixfred.com/, extensionless,
# never localhost, never a .html path.
set -euo pipefail
cd "$(dirname "$0")/.."

if [ ! -d dist ]; then
  echo "dist/ missing. Run scripts/build.sh first." >&2
  exit 2
fi

python3 - <<'PYEOF'
import os, re, sys

DIST = 'dist'
ORIGIN = 'https://n1.nixfred.com'
fail = []
checked = 0

CANON = re.compile(r'<link rel="canonical" href="([^"]+)"')
OGURL = re.compile(r'<meta property="og:url" content="([^"]+)"')

for root, _dirs, files in os.walk(DIST):
    for name in files:
        if not name.endswith('.html'):
            continue
        path = os.path.join(root, name)
        html = open(path, encoding='utf-8', errors='ignore').read()
        rel = os.path.relpath(path, DIST)
        checked += 1

        canon = CANON.search(html)
        if not canon:
            fail.append(f'{rel}: missing canonical')
            continue
        c = canon.group(1)
        if 'localhost' in c or '127.0.0.1' in c:
            fail.append(f'{rel}: canonical points at localhost: {c}')
        if c.endswith('.html'):
            fail.append(f'{rel}: canonical carries .html: {c}')
        if not c.startswith(ORIGIN):
            fail.append(f'{rel}: canonical not on {ORIGIN}: {c}')

        og = OGURL.search(html)
        if og and og.group(1) != c:
            fail.append(f'{rel}: og:url {og.group(1)} != canonical {c}')

        expected = ORIGIN + ('/' if rel == 'index.html' else '/' + rel[:-5] + '/')
        if c != expected:
            fail.append(f'{rel}: canonical {c} does not match its route {expected}')

print(f'pages checked: {checked}')
if fail:
    print('\n'.join(fail))
    print('CANONICAL: FAILED')
    sys.exit(1)
print('CANONICAL: CLEAN')
PYEOF
