#!/usr/bin/env bash
# Internal + external link integrity gate (factory: no dead links).
# Internal hrefs must resolve to a file in dist/. External hrefs are
# probed: 2xx/3xx pass; 403 passes with a warning (some vendors, for
# example ninjaone.com, block non-browser agents while the page is
# live); 404 and connection failures fail the build.
set -euo pipefail
cd "$(dirname "$0")/.."

if [ ! -d dist ]; then
  echo "dist/ missing. Run scripts/build.sh first." >&2
  exit 2
fi

python3 - <<'EOF'
import os, re, subprocess, sys

DIST = 'dist'
internal, external = set(), set()
for root, _, files in os.walk(DIST):
    for name in files:
        if not name.endswith('.html'):
            continue
        html = open(os.path.join(root, name), encoding='utf-8', errors='ignore').read()
        for m in re.finditer(r'(?:href|src|content)="([^"#?]+)', html):
            h = m.group(1)
            if h.startswith('https://n1.nixfred.com/'):
                h = h[len('https://n1.nixfred.com'):]
            if h.startswith('/') and not h.startswith('//'):
                internal.add(h.rstrip('/') or '/')
            elif h.startswith('https://'):
                external.add(h)

def resolves(h):
    if h == '/':
        return os.path.exists(f'{DIST}/index.html')
    p = h.lstrip('/')
    return (os.path.exists(f'{DIST}/{p}')
            or os.path.exists(f'{DIST}/{p}.html')
            or os.path.exists(f'{DIST}/{p}/index.html'))

dead_internal = sorted(h for h in internal if not resolves(h))
print(f'internal refs checked: {len(internal)}')
for h in dead_internal:
    print(f'  DEAD internal: {h}')

UA = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0 Safari/537.36'
dead_ext, warned = [], []
for url in sorted(external):
    try:
        out = subprocess.run(
            ['curl', '-sIL', '-o', '/dev/null', '-w', '%{http_code}',
             '--max-time', '20', '-A', UA, url],
            capture_output=True, text=True)
        code = out.stdout.strip()[-3:] if out.stdout.strip() else '000'
    except Exception:
        code = '000'
    if code.startswith(('2', '3')):
        pass
    elif code == '403':
        warned.append(url)
    else:
        dead_ext.append((url, code))

print(f'external links checked: {len(external)}')
for url in warned:
    print(f'  WARN 403 (bot-blocked, presumed live): {url}')
for url, code in dead_ext:
    print(f'  DEAD external ({code}): {url}')

if dead_internal or dead_ext:
    print('LINKS: FAILED')
    sys.exit(1)
print('LINKS: CLEAN')
EOF
