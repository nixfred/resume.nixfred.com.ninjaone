# PRD: n1.nixfred.com (resume.nixfred.com.ninjaone)

> Hardened 2026-08-02 per factory `PRD_HARDENING.md`. This document, not the original prompt, is the implementation contract. Readiness: **READY TO BUILD**.

## 1. Mission

A single-page resume variant of resume.nixfred.com, targeted at one audience: the NinjaOne hiring loop for an Enterprise SE (Solutions Engineer) role in the Southeast. It presents Fred's real career record, reframed for endpoint management presales, and leads with proof of platform study: ninjaone.nixfred.com, the NinjaOne field guide he built before ever being trained by them.

## 2. Audience

1. NinjaOne SE leadership and hiring managers evaluating an Enterprise SE candidate.
2. NinjaOne enterprise reps who may team with him.
3. Fred himself, as the print artifact he hands over (Cmd/Ctrl+P clean paper resume).

## 3. Scope and release boundary

In scope:

1. One page at `https://n1.nixfred.com/`, plain static HTML/CSS/JS, dark design derived from the main resume's visual system with a lime (NinjaOne-adjacent) accent.
2. Print stylesheet producing a clean single-color paper resume.
3. Sections: hero with role target; why NinjaOne; proof of work (ninjaone.nixfred.com); what he brings to the SE chair; career timeline; skills grid; recognition and education; AI-assisted delivery (Larry); footer.
4. Fleet metadata contract: title, description, canonical, OG 1200x630, twitter card, SVG + 32px + 180px favicons, theme-color, skip link, `_headers` security headers.
5. Gates: link, copy (no dashes), canonical, safety/privacy, contrast. GitHub Actions deploy on push to main. `./deploy.sh` manual escape hatch.
6. Fleet presence: apex alias `nixfred.com/n1` 301 to `n1.nixfred.com` via apex-router; spikenix mirror spot check.

Out of scope (deferred, see section 12):

1. `resume.nixfred.com/ninjaone/` as a serving path (superseded by Fred's n1.nixfred.com ruling).
2. Homepage portfolio card (explicit Fred override).
3. Any backend, form, tracking, or analytics.

## 4. Content rulings

1. Every career fact mirrors the public main resume (nixfred/resume v9.0) verbatim in substance: roles, dates, achievements, education, recognition. No new unverifiable claims.
2. Employer naming mirrors the main resume exactly: BlueAlly and Pure Storage appear (already public there); other employers stay role-only. No new employer names.
3. No private individuals are named anywhere (Law 7). Internal NinjaOne contacts, reps, and mutual acquaintances from the application context are excluded by design.
4. NinjaOne company facts on the page (Customer count, HQ, founding, product scope) are few, modest, and each links to its ninjaone.com source. Nothing sourced from private conversation appears on the page.
5. ninjaone.nixfred.com is presented as self-directed platform study, linked prominently, with its real module counts taken from the live site.
6. Copy rules: no em dashes, no en dashes, no spaced hyphens as clause separators. Capital-C Customer. Direct voice, no corporate filler.

## 5. Design law (summary; full version in CLAUDE.md)

Theme: Japanese ninja, per Fred ruling 2026-08-02 (NinjaOne culture is, in his words, very ninja). Sumi ink dark only. Background #0a0a0f, text #e6e1d5 (bone), primary accent vermillion #d43d2a, secondary accent gold #d4b55a. Orbitron display (Latin), Inter body, JetBrains Mono for labels and data, Shippori Mincho B1 subset for kanji, all self-hosted woff2 (OFL licensed), no CDN fonts. Decorative kanji section marks with romaji captions: 忍 nin (hero), 志 kokorozashi (resolve), 修行 shugyō (training, proof of work), 術 jutsu (technique, SE craft), 道 michi (the way, career), 印 shirushi (mark, recognition), 学 gaku (learning), 影 kage (shadow, the AI partner), 縁 enishi (connection, contact). Custom SVG motifs from tokens: shuriken markers, enso ring, thin vermillion rules. Kanji never carries information alone; every mark has a romaji or English caption. Motion: restrained fade/slide reveals only, all decorative, disabled under prefers-reduced-motion. The theme is the skin and the section language; the copy stays a professional resume, no cosplay. Print: light, single color, stacks cleanly.

## 6. Acceptance criteria

Every criterion is checkable true/false.

1. `curl -sI https://n1.nixfred.com/` returns 200 and serves the page over HTTPS.
2. `https://n1.nixfred.com/` renders the hero with Fred's name, the Enterprise SE targeting, and a visible link to ninjaone.nixfred.com above the fold at 1440px.
3. `tests/check-links.sh` passes: every internal and external href resolves (no dead links).
4. `tests/check-copy.sh` passes: zero em/en dashes and zero spaced-hyphen clause separators in copy; each gate was fed known-bad input once and fired.
5. `tests/check-canonical.sh` passes: canonical is `https://n1.nixfred.com/`, never localhost, never `.html`.
6. Footer contains a link to nixfred.com, a link to the public repo, and a version string `v<yyyymmdd>-<shortsha>` matching the deployed commit. Local builds render `dev-local`.
7. Full git history privacy scan passes: no `/Users/` paths, no machine names, no secrets, no private individuals' names in any commit.
8. `tests/check-contrast.mjs` passes WCAG AA on all text/background pairs.
9. Browser verification at 390, 820, and 1440 px widths shows no horizontal overflow and no overlapping content, with screenshots saved as the artifact.
10. Print emulation produces a clean single-color resume with all sections stacked and no dark background.
11. The proof-of-work section links `https://ninjaone.nixfred.com/` and that link returns 200.
12. Every NinjaOne factual claim on the page carries a clickable source link to a ninjaone.com (or official) page.
13. `https://nixfred.com/n1` returns 301 to `https://n1.nixfred.com/` after the apex-router table update.
14. `https://n1.spikenix.com/` returns 200 (wildcard mirror, zero per-site work expected).
15. Push to main triggers the Actions workflow which runs the gates and deploys; repo secret `CLOUDFLARE_API_TOKEN` is set.
16. OG image exists at a public URL at 1200x630 before any link is shared.
17. The main resume at `https://nixfred.com/resume/` is untouched by this work (no commits to nixfred/resume, no DNS or redirect changes on resume.nixfred.com).

## 7. Stack, hosting, deployment

1. Plain static HTML/CSS/JS per STACK.md ladder rung 1 (resume sites named explicitly).
2. Cloudflare Pages project `n1-nixfred-com`, direct upload via `npx wrangler@latest` with the env token (Law 3).
3. Custom domain `n1.nixfred.com` on the project; DNS CNAME `n1` to `n1-nixfred-com.pages.dev`, proxied, on the nixfred.com zone.
4. Repo `github.com/nixfred/resume.nixfred.com.ninjaone`, PUBLIC (Fred ruling 2026-08-02), default branch main.
5. Push to main is the deploy: Actions workflow runs gates then wrangler direct upload. Repo secret `CLOUDFLARE_API_TOKEN` set once.

## 8. Data, integrations, secrets

No live data, no APIs, no user input, no scheduled jobs, no analytics. The only secret in play is the deploy token, stored as a GitHub Actions repo secret, never in git.

## 9. Freshness and failure behavior

Static content; freshness target not applicable. Failure behavior: if an external link rots, the link gate fails the next deploy and the link gets fixed or cut. No runtime dependencies means no runtime failure paths beyond DNS/Pages availability.

## 10. SEO and metadata

Indexable (no noindex). Canonical `https://n1.nixfred.com/`. One h1. Semantic sections with ordered headings. Alt text or aria-labels on every visual. OG card ships before the URL is handed to anyone.

## 11. Ownership

Fred owns content and the Cloudflare/GitHub accounts. This site changes only through the repo. Lessons learned during the build flow back to factory.nixfred.com the same day (Law 10).

## 12. Deferred items and future decision points

1. `resume.nixfred.com/ninjaone/` serving: requires editing an account-level Cloudflare redirect the current token cannot touch. Superseded by the n1.nixfred.com ruling; revisit only if Fred wants the nested path back.
2. Homepage portfolio card: override recorded. Fred may add one later by the standard portfolio.json ritual.
3. Additional pages (deeper role-specific detail): only if the hiring loop asks; returns the affected sections to Stage 0.

## 13. Risks

1. Pages custom domain + DNS timing: mitigated by API-driven setup and curl verification before browser pass.
2. Font files: OFL licensed (Orbitron, Inter, JetBrains Mono), self-hosted copies committed; no license risk.
3. Overfitting content to private conversation: mitigated by Content ruling 4 (public sources only) and the privacy scan.
4. The apex-router catch-all hijacking `/n1`: mitigated by adding the explicit redirect entry before verification, per the 2026-07-12 /resume bug lesson.
