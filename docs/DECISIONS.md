# DECISIONS: resume.nixfred.com.ninjaone

> One decisions home for this site (factory STANDARDS.md section 8). Newest last.

## 2026-08-02 URL ruling: n1.nixfred.com

Original brief asked for `resume.nixfred.com/ninjaone/`. Investigation found resume.nixfred.com is a path-dropping 301 (account-level Cloudflare redirect, not editable with the available token) to www.nixfred.com/resume, which itself 301s to nixfred.com/resume. Fred ruled: go with `n1.nixfred.com`, built with wrangler. The nested path is deferred, not abandoned (PRD section 12).

## 2026-08-02 Repo visibility: PUBLIC

Factory internal conflict: DEPLOY.md section 1 defaults new repos to PRIVATE; STACK.md and NEWSITE.md make site repos PUBLIC by default with a mandatory full-history privacy scan. Fred ruled PUBLIC, matching nixfred/resume and ninjaone.nixfred.com. Full-history privacy scan is mandatory before first push.

## 2026-08-02 FACTORY OVERRIDE: no homepage portfolio card

Fleet Law 4 requires a homepage card on nixfred.com for a shipped site. Fred ruled this site ships WITHOUT the card: it is a targeted page for one company, not a fleet showcase. Override applies to this site only, dated today.

## 2026-08-02 Theme ruling: Japanese ninja

Fred: make the theme Japanese ninja; the company culture is very ninja. Design law updated: sumi ink, vermillion, gold, kanji section marks with romaji captions, shuriken and enso SVG motifs. Copy remains a professional resume; the theme is skin and section language only.

## 2026-08-02 Stack: plain static HTML/CSS/JS

STACK.md ladder rung 1 names resume sites explicitly. No framework. Output dir is the repo root. Deploy by wrangler direct upload; push to main deploys via GitHub Actions.

## 2026-08-02 Employer and people naming

Career facts mirror nixfred/resume v9.0 exactly. BlueAlly and Pure Storage appear (already public there); other employers stay role-only. No private individuals named anywhere (Law 7): no NinjaOne employees, reps, or mutual contacts. NinjaOne company facts come only from public ninjaone.com pages, each linked at point of claim.

## 2026-08-02 Fonts: self-hosted OFL only

Orbitron, Inter, JetBrains Mono (fontsource woff2, latin), Shippori Mincho B1 subsetted to the kanji used plus macron vowels. No runtime CDN font dependencies (STANDARDS.md section 5).

## 2026-08-02 Fred review round 4: Larry section removed

Fred: remove the part about Larry, the entire section. The 影 shadow section (The shadow that works beside me) is out, along with its nav entry and the shadow-box styles in styles.css and print.css. The general resume keeps its Larry content; this site does not mention the system. Section kanji sequence now 志 修行 術 道 印 縁.

## 2026-08-02 Fred review round 3: print keeps the ninja, breaks and spacing tuned

Fred: keep the little ninja in the PDF, page breaks must look good, and printed pages waste no vertical space. Print stylesheet now keeps the hero ninja as a small line-art figure at the header's top right (screen filters removed), adds break-inside avoid to every card, timeline row, skill column, and the proof box, break-after avoid on section heads and headings, and tightens print rhythm (12mm pages, 16pt section gaps, smaller card padding). In-card kanji badges hidden on paper as redundant decoration. Verified against a real generated PDF, five Letter pages, no split cards and no stranded headings.

## 2026-08-02 Fred review round 2: NinjaOne brand colors

Fred: go to ninjaone.com and use their colors. Palette extracted from the live site's CSS custom properties with a real browser (ninjaone.com blocks non-browser GETs): vivid green #04ff88, hover green #48e275, sky cyan #55ebff, dark navy steps #0d2d44 / #09344f / #053856, blue-gray #bccad4. Tokens renamed vermillion to brand and gold to sky across tokens.css, styles.css, index.html, og.html, and the contrast gate. Sumi ink and vermillion retired. Japanese ninja structure (kanji marks, shuriken, hood figure) stays; only the colors changed. bone-faint derived at #89a3b3 to hold AA on navy (4.45 fail caught by the contrast gate).

## 2026-08-02 Fred review round 1: tone, ninja figure, print modal, 2x2 contact

Fred reviewed the live site and ordered: (1) training section retitled "How I learn your platform", dropping the "proof of work, not claims" framing; the message is that building a field guide is how he learns and the guide now belongs to the team, not a challenge to other candidates. (2) The hero enso ring read as a broken circle; replaced with an original ninja head SVG in the NinjaOne spirit (hood, gold eyes, vermillion bandana tails), not a copy of the trademarked logo. (3) Contact cards locked to a 2x2 grid on desktop, single column under 640px. (4) PRINT control in the nav and hero opens a glowing modal (vermillion glow, backdrop blur, ESC and backdrop close, focus returned) that calls window.print(). Print and mobile behavior re-verified after the round.
