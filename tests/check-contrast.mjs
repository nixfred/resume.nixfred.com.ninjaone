/**
 * WCAG contrast gate for n1.nixfred.com (adapted from tools.nixfred.com).
 *
 * Parses tokens.css (dark :root plus the @media print :root), resolves
 * the semantic text and UI pairs below from the ACTUAL token values,
 * and computes WCAG 2.1 contrast ratios from the sRGB luminance formula.
 * Thresholds: 4.5 normal text, 3.0 large text, 3.0 non-text UI.
 * Run: bun tests/check-contrast.mjs
 */

import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

const ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');
const src = readFileSync(join(ROOT, 'tokens.css'), 'utf8').replace(/\/\*[\s\S]*?\*\//g, '');

function parseScope(source, label) {
  const scope = {};
  for (const m of source.matchAll(/(--[a-z0-9-]+)\s*:\s*([^;]+);/gi)) {
    scope[m[1]] = m[2].trim();
  }
  if (!Object.keys(scope).length) {
    console.log(`no tokens parsed for scope ${label}`);
    process.exit(1);
  }
  return scope;
}

const darkMatch = src.match(/:root\s*\{([^}]*)\}/);
const printMatch = src.match(/@media print\s*\{\s*:root\s*\{([^}]*)\}/);
const scopes = { dark: parseScope(darkMatch[1], 'dark') };
if (printMatch) scopes.print = parseScope(printMatch[1], 'print');

/* semantic pairs asserted at their WCAG role threshold:
   [foreground token, background token, role] */
const PAIRS = [
  ['--bone', '--ink', 'normal'],
  ['--bone', '--ink-2', 'normal'],
  ['--bone-dim', '--ink', 'normal'],
  ['--bone-dim', '--ink-2', 'normal'],
  ['--bone-faint', '--ink', 'normal'],
  ['--vermillion-text', '--ink', 'normal'],
  ['--vermillion-text', '--ink-2', 'normal'],
  ['--gold', '--ink', 'normal'],
  ['--gold', '--ink-2', 'normal'],
  ['--ink', '--gold', 'normal'],
  ['--kanji-mark', '--ink', 'large'],
  ['--vermillion', '--ink', 'ui'],
];

/* decorative hairlines: reported, never asserted (WCAG 1.4.11 exemption) */
const ADVISORY = [
  ['--vermillion-border', '--ink-2'],
  ['--gold-border', '--ink-2'],
  ['--bone-border', '--ink-2'],
];

function hexToRgb(v) {
  const h = v.trim().replace('#', '');
  const n = h.length === 3 ? h.split('').map(c => c + c).join('') : h;
  return [0, 2, 4].map(i => parseInt(n.slice(i, i + 2), 16) / 255);
}

function parseColor(v) {
  v = v.trim();
  if (v.startsWith('#')) {
    const [r, g, b] = hexToRgb(v);
    return { r, g, b, a: 1 };
  }
  const m = v.match(/rgba?\(\s*([\d.]+)[,\s]+([\d.]+)[,\s]+([\d.]+)(?:[,\s/]+([\d.]+))?\s*\)/);
  if (!m) return null;
  return { r: m[1] / 255, g: m[2] / 255, b: m[3] / 255, a: m[4] === undefined ? 1 : parseFloat(m[4]) };
}

function composite(fg, bg) {
  const a = fg.a + bg.a * (1 - fg.a);
  if (a === 0) return { r: 0, g: 0, b: 0 };
  return {
    r: (fg.r * fg.a + bg.r * bg.a * (1 - fg.a)) / a,
    g: (fg.g * fg.a + bg.g * bg.a * (1 - fg.a)) / a,
    b: (fg.b * fg.a + bg.b * bg.a * (1 - fg.a)) / a,
  };
}

function luminance({ r, g, b }) {
  const f = c => (c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4));
  return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b);
}

function ratio(fg, bg) {
  const l1 = luminance(fg), l2 = luminance(bg);
  const [hi, lo] = l1 >= l2 ? [l1, l2] : [l2, l1];
  return (hi + 0.05) / (lo + 0.05);
}

const THRESHOLD = { normal: 4.5, large: 3.0, ui: 3.0 };
let failures = 0;

for (const [scopeName, tokens] of Object.entries(scopes)) {
  for (const [fgTok, bgTok, role] of PAIRS) {
    const fgV = tokens[fgTok], bgV = tokens[bgTok];
    if (!fgV || !bgV) continue;
    const fg = parseColor(fgV), bg = parseColor(bgV);
    if (!fg || !bg) {
      console.log(`UNPARSED [${scopeName}] ${fgTok}=${fgV} ${bgTok}=${bgV}`);
      failures++;
      continue;
    }
    const r = ratio(composite(fg, bg), bg);
    const need = THRESHOLD[role];
    const ok = r >= need;
    if (!ok) failures++;
    console.log(
      `${ok ? 'PASS' : 'FAIL'} [${scopeName}] ${fgTok} on ${bgTok} (${role}): ${r.toFixed(2)} (need ${need})`
    );
  }
  for (const [fgTok, bgTok] of ADVISORY) {
    const fgV = tokens[fgTok], bgV = tokens[bgTok];
    if (!fgV || !bgV) continue;
    const fg = parseColor(fgV), bg = parseColor(bgV);
    if (!fg || !bg) continue;
    const r = ratio(composite(fg, bg), bg);
    console.log(`INFO [${scopeName}] decorative ${fgTok} on ${bgTok}: ${r.toFixed(2)} (advisory)`);
  }
}

console.log(failures ? `CONTRAST: FAILED (${failures})` : 'CONTRAST: CLEAN');
process.exit(failures ? 1 : 0);
