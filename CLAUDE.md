# CLAUDE.md - resume.nixfred.com.ninjaone (n1.nixfred.com)

> **Fleet law lives in the factory: github.com/nixfred/factory.nixfred.com (PRIVATE).**
> LAWS.md, PRD_HARDENING.md, STACK.md, DEPLOY.md, CONTENT.md, and OPERATIONS.md there govern this site. This file holds only what is specific to THIS site. If this file conflicts with the factory, the factory wins unless Fred overrode it here explicitly (mark overrides with "FACTORY OVERRIDE:").

## Stage 0 status

1. **Hardened PRD:** docs/PRD.md
2. **Factory Compliance Matrix:** docs/FACTORY_COMPLIANCE.md
3. **Decision log:** docs/DECISIONS.md
4. **Risk register:** docs/PRD.md section 13
5. **Readiness:** READY TO BUILD (2026-08-02)
6. **Approved scope:** single-page NinjaOne-targeted resume at n1.nixfred.com, per PRD section 3
7. **Last hardening review:** 2026-08-02

## Site facts

| Property | Value |
|----------|-------|
| **URL** | https://n1.nixfred.com |
| **Repo** | github.com/nixfred/resume.nixfred.com.ninjaone (PUBLIC) |
| **Pages project** | n1-nixfred-com |
| **Primary class** | static publication |
| **Stack** | plain static HTML/CSS/JS |
| **Output dir** | . (repo root) |
| **Deploy** | `npx wrangler@latest pages deploy . --project-name n1-nixfred-com` (Actions on push to main; ./deploy.sh manual) |
| **Mission** | A NinjaOne-targeted resume variant: Fred's real record reframed for an Enterprise SE role, led by proof of platform study (ninjaone.nixfred.com). |
| **Depth target** | 1 primary page plus print view, parity with sibling nixfred/resume v9.0 (Law 12) |
| **Motion direction** | restrained, decorative only |
| **External dependencies** | none at runtime (self-hosted fonts, no CDN, no analytics) |
| **Freshness target** | not applicable (static) |

## Design law (settled, never re-interview)

- Theme: Japanese ninja (Fred ruling 2026-08-02). NinjaOne culture is very ninja; the site wears it.
- Palette: NinjaOne brand colors pulled from the live ninjaone.com CSS custom properties (Fred ruling 2026-08-02). Dark navy ink #0d2d44, card #09344f, bone text #f4f8f8, vivid green brand #04ff88, green text #48e275, sky cyan accent #55ebff. All color from tokens.css, no raw hex downstream.
- Typeface trio: Orbitron (Latin display), Inter (body), JetBrains Mono (labels, numbers, badges). Shippori Mincho B1 subset for kanji marks. All self-hosted woff2, OFL licensed, no CDN.
- Kanji section marks with romaji captions: 忍 nin hero, 志 kokorozashi resolve, 修行 shugyō training (proof of work), 術 jutsu technique (SE craft), 道 michi the way (career), 印 shirushi mark (recognition), 学 gaku learning, 影 kage shadow (Larry), 縁 enishi connection (contact). Kanji never carries information alone.
- Motifs: inline SVG shuriken markers, enso ring, thin vermillion rules. Every visual role="img" with aria-label, viewBox based, token colors.
- Tone: direct professional resume copy. The ninja theme is skin and section language only; no cosplay in the words.
- Motion: restrained fades/slides on reveal, all decorative, off under prefers-reduced-motion.
- Print: light, single color, stacked, no dark background.

## Motion model

1. **Decorative motion:** section reveal fades and slides; may stop entirely under reduced motion.
2. **Functional motion:** none.
3. **Essential motion:** none. All content is available statically with JS disabled.
4. **Interaction rule:** no animation traps input, hides controls, or gates content.

## Operational model

1. **Source and provenance:** career facts mirror nixfred/resume v9.0; NinjaOne facts link ninjaone.com at point of claim.
2. **Stored versus derived:** all content is source; the only derived value is the footer version stamp v<date>-<shortsha> from the deployed commit.
3. **Secrets:** CLOUDFLARE_API_TOKEN lives only as a GitHub Actions repo secret; never in git.
4. **Cost and quota:** none (no metered services).
5. **Freshness and stale state:** not applicable.
6. **Failure paths:** external link rot fails the link gate at next deploy.
7. **User input and transmission:** none.
8. **Scheduled systems:** none.
9. **Named-person authority:** Fred Nix publishes his own resume. No other person is named on the site.
10. **Archive policy:** the general resume remains at nixfred.com/resume/ and is canonical for general audiences; this site is a targeted variant, not an archive.

## Site-specific rules

- FACTORY OVERRIDE (2026-08-02, Fred): Law 4 homepage card waived. This site ships without a portfolio.json card.
- No private individuals named anywhere: no NinjaOne employees, reps, or mutual contacts (Law 7, strict reading).
- Employer naming mirrors nixfred/resume v9.0: BlueAlly and Pure Storage appear; all other employers stay role-only.
- Nothing from private conversations may appear on the page; NinjaOne facts require a public ninjaone.com source link.
- The main resume (nixfred/resume repo, GitHub Pages) is never touched by work on this site.

## Content model

Single index.html with anchored sections: hero (role target), why NinjaOne, how I learn your platform (ninjaone.nixfred.com), SE craft, career timeline, skills grid, recognition and education, contact/footer. print.css produces the paper artifact. New content enters only through PRD change control.

## Ship checklist (factory Laws 4, 6, 11, 13, 14 plus OPERATIONS.md)

- [x] Mandatory Stage 0 completed under PRD_HARDENING.md
- [x] Factory Compliance Matrix has no unresolved MISSING or CONFLICT items
- [x] Hardened PRD contains measurable acceptance criteria and reports READY TO BUILD
- [x] AskUserQuestions resolutions and Fred rulings recorded in docs/DECISIONS.md
- [ ] n1.nixfred.com live on the Pages project
- [ ] nixfred.com/n1 apex alias in apex-router table.json (collision-checked, dated)
- [ ] spikenix mirror spot-checked (zero work expected)
- [x] Homepage card: FACTORY OVERRIDE, waived by Fred 2026-08-02
- [ ] Footer: nixfred.com link, repo link, version tied to deployed commit
- [ ] Link gate, copy gate (no dashes), canonical gate, safety gate, contrast gate green; full-history privacy scan clean
- [ ] Browser-verified at 390/820/1440 with screenshots, not just curl
- [ ] Motion verified with ordered frames; reduced-motion choreography checked
- [ ] Print emulation verified: clean single-color resume
- [ ] Production build contains no secret, localhost, development credential, private path, or hidden user content
- [ ] OG image 1200x630 exists and resolves before the URL is shared

A change is done when: committed, pushed, deployed, browser-verified live, and every applicable gate is green. Report the URL and the evidence.
