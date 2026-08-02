#!/usr/bin/env bash
# House style gate (adapted from the SiteFactory seed for plain static).
#   1. No em dashes, no en dashes, no spaced hyphens as punctuation.
#   2. No curly quotes.
#   3. Capital C on Customer (standalone word).
#   4. Tokens are law: no raw hex or rgba() outside tokens.css.
# Feed this gate known-bad input once before trusting it (negative control).
set -euo pipefail
cd "$(dirname "$0")/.."

fail=0
SCAN=(index.html og.html styles.css print.css tokens.css README.md CLAUDE.md docs)

report() {
  local label="$1" hits="$2"
  if [ -n "$hits" ]; then
    echo "VIOLATION [$label]:"
    echo "$hits" | head -12
    echo
    fail=1
  fi
}

# 1a. Em dash and en dash.
report "em dash or en dash" \
  "$(grep -rn $'—\|–' "${SCAN[@]}" 2>/dev/null || true)"

# 1b. Spaced hyphen as punctuation in prose lines.
spaced_hyphen=$(python3 - <<'PYEOF'
import os, re

TARGETS = ['index.html', 'og.html', 'styles.css', 'print.css', 'tokens.css', 'README.md', 'CLAUDE.md', 'docs']
EXTS = ('.html', '.css', '.md')
PROSE = re.compile(r'(<!--|"[^"]*$|^\s*[^<\s].*\w)')
SKIP_LINE = re.compile(r'^\s*(---+$|[-|:+ ]+$|[-*] |#|\||//|\.)')
ARITH = re.compile(r'[\w)\].] - [\w(]')
CSS_DECL = re.compile(r'^\s*(--[a-z-]+|[a-z-]+)\s*:')

hits = []
def scan(path):
    try:
        lines = open(path, encoding='utf-8', errors='ignore').read().split('\n')
    except OSError:
        return
    for i, raw in enumerate(lines, 1):
        if ' - ' not in raw:
            continue
        s = raw.strip()
        if SKIP_LINE.search(s):
            continue
        if CSS_DECL.search(raw):
            continue
        if ARITH.search(raw):
            continue
        hits.append('%s:%d:%s' % (path, i, s[:120]))

for t in TARGETS:
    if os.path.isdir(t):
        for base, _d, files in os.walk(t):
            for n in files:
                if n.endswith(EXTS):
                    scan(os.path.join(base, n))
    elif os.path.isfile(t):
        scan(t)

print('\n'.join(hits))
PYEOF
)
report "spaced hyphen used as punctuation" "$spaced_hyphen"

# 2. Curly quotes.
report "curly quote" \
  "$(grep -rn $'‘\|’\|“\|”' "${SCAN[@]}" 2>/dev/null | grep -v 'check-copy:allow-curly' || true)"

# 3. Capital C on Customer, standalone word only.
report "lowercase customer" \
  "$(grep -rnw 'customer' "${SCAN[@]}" 2>/dev/null || true)"

# 4. Raw color literals outside tokens.css.
color_scan=$(python3 - <<'PYEOF'
import os, re

COLOR = re.compile(r'#(?:[0-9a-fA-F]{8}|[0-9a-fA-F]{6}|[0-9a-fA-F]{4}|[0-9a-fA-F]{3})(?![0-9a-zA-Z_-])|rgba?\(\s*[0-9]')
TARGETS = ['index.html', 'og.html', 'styles.css', 'print.css']

hits = []
for path in TARGETS:
    if not os.path.isfile(path):
        continue
    for i, raw in enumerate(open(path, encoding='utf-8', errors='ignore').read().split('\n'), 1):
        if not COLOR.search(raw):
            continue
        # one documented exception, same as the seed: the theme-color meta
        if path == 'index.html' and 'theme-color' in raw:
            continue
        hits.append('%s:%d:%s' % (path, i, raw.strip()[:120]))

print('\n'.join(hits))
PYEOF
)
report "raw color literal outside tokens.css" "$color_scan"

if [ "$fail" -eq 1 ]; then
  echo "HOUSE STYLE: FAILED"
  exit 1
fi
echo "HOUSE STYLE: CLEAN"
