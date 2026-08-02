# resume.nixfred.com.ninjaone

The NinjaOne edition of Fred Nix's resume, live at **https://n1.nixfred.com**.

One page, plain static HTML/CSS/JS, Japanese ninja theme: sumi ink, vermillion, gold, kanji section marks. Built by the rules in the private factory repo (github.com/nixfred/factory.nixfred.com): Stage 0 hardening docs live in `docs/`.

## Work on it

```bash
scripts/build.sh        # assemble dist/ (version dev-local, OG card, favicon rasters)
tests/check-links.sh    # gates
tests/check-copy.sh
tests/check-canonical.sh
tests/check-safety.sh
bun tests/check-contrast.mjs
./deploy.sh             # gates + wrangler direct upload (manual escape hatch)
```

Push to `main` deploys via GitHub Actions (gates, then wrangler direct upload to the `n1-nixfred-com` Pages project).

The general (company-neutral) resume lives at https://nixfred.com/resume/ and is never touched by this repo.
