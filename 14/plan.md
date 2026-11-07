<!--
SPDX-FileCopyrightText: 2026 Michael Conrad
SPDX-License-Identifier: MIT
-->

# Plan — CNT#14: disposition the 8 referenced-but-missing `/cnt` scan images

Consumes the validated spec at `.issues/14/spec.md` (validation rounds 1–6,
terminal PASS). Spec context the items rely on: the 2026-11-07 exhaustive
audit (8 files / 23 references / 20 pages, captured under
`.issues/14/research/`), the served-truth topology (tarball extraction baked
by the CNT#11 image, gated by the CNT#9 manifest), and the two developer
directions of 2026-11-07: the four `NN_` strips restore by import from the
sibling project, and copies into the four per-chapter files are acceptable
for the four `BBCC00` chapter-heading images, with drops as the fallback for
any reference no available image can resolve.

## Decision record (locked before the items)

- **D1 — copy source for the four `BBCC00` restores:** `200100.png` (James
  chapter 1, 389×93, the bolder-inked exemplar). Grounds: glyph-identical
  heading word and numeral across the chapter-1 exemplars, and
  `200100.png`'s heavier inking relative to `190100.png` — both verified by
  the 2026-11-07 BBCC00 form inspection
  (`.issues/14/research/2026-11-07_bbcc00-form-inspection.md`); within the
  exemplar dimension family (93–105 px strips); and the edition itself
  carries no chapter-heading line for the four single-chapter books
  (`.issues/14/research/2026-11-07_single-chapter-openings-verification.md`).
  Copied byte-identically to `180100.png`,
  `240100.png`, `250100.png`, `260100.png`.
- **D2 — import sources for the four `NN_` strips** (read-only reads from
  the developer-named sibling checkout
  `/home/muksihs/git/CherokeeNewTestament.org`, md5-verified at import
  against the census capture):
  - `07_.png` ← `content/cherokee-new-testament/1-corinthians/0701/07_.png`
    (md5 `d0b670c796b20120111bc881a2a165e3`)
  - `18_.png` ← `content/cherokee-new-testament/philemon/1801/18_.png`
    (md5 `97370b7e6510f5181bad04ba8224f9c3`)
  - `24_.png` ← `content/cherokee-new-testament/2-john/2401/24_.png`
    (md5 `22d5756e30c1832a9fb651aefd3627ff`)
  - `25_.png` ← `content/cherokee-new-testament/3-john/2501/25_.png`
    (md5 `3da963b9f30aa42a89fb060522b4a591`)
- **D3 — disposition record location:** `docs/image-reference-dispositions.md`
  (the repo's docs family already carries the served-tree documentation).
- **D4 — zero HTML edits.** All 23 references become resolvable (4 imports +
  4 copies); no drop is needed, so no chapter page is edited and SC-8's
  comparison is vacuously satisfied — recorded, not skipped.
- **D5 — tarball determinism:** the regenerated archive is tarred once and
  copied to both committed locations (`cnt/website.tar.gz` and
  `cntdata/website.tar.gz`), guaranteeing byte-identical twins; members are
  the flat served-tree set plus the 8 new PNGs (8,560 members; the tarball
  never contains itself).
- **D6 — deploy sequencing:** the redeploy runs from the feature-branch tip
  (CNT#11's own SC-1/SC-3 precedent: branch-tip bytes, tag
  `cnt-web:<branch-tip-commit>`, deployment record pins that commit); the
  PR merges afterwards by human action, and a squash merge preserves the
  deployed bytes.

## Items

### Item 1 — the disposition record (SC-1)

- **Deliverable:** `docs/image-reference-dispositions.md` (D3) covering all
  8 files / 23 references / 20 pages of the 2026-11-07 audit; every
  reference carries exactly one outcome — restore — and a reason: the four
  `NN_` strips restore by import (D2, developer direction 2026-11-07, census
  capture cited); the four `BBCC00` files restore by copy (D1, developer
  direction 2026-11-07, the image-inspection grounds cited: the 1860
  printing gives single-chapter books no chapter-heading line — verified on
  all four openings (Philemon IA leaf n340, 2 John n380, 3 John n381,
  Jude n382; capture under `.issues/14/research/
  2026-11-07_single-chapter-openings-verification.md`); copies sanctioned by
  the developer's same-day direction). No accept entries; the drop fallback
  is recorded as not exercised (D4).
- **RED:** the file does not exist; a parse of
  `docs/image-reference-dispositions.md` fails against the audit
  enumeration (8 files / 23 references / 20 pages).
- **GREEN:** author the record; its reference inventory equals the audit's
  enumeration 1:1 (file → referrer pages → outcome → reason).
- **Instrument:** parse the record and compare against the audit
  enumeration captured in `.issues/14/research/2026-11-07_reference-audit.md`
  (counts and per-file referrer lists must match exactly).

### Item 2 — the reference-integrity instrument (SC-2 instrument side, SC-5)

- **Deliverable:** `tools/check-image-refs.sh` — POSIX shell beside
  `tools/verify-served-tree.sh`; takes the served-tree root as its first
  argument (default `cnt`); enumerates every double-quoted `.png` reference
  (`src=`/`href=`) in every `*.html` under the root; prints
  `missing-file -> referrer pages` lines for every referenced-but-missing
  file; exits 0 when none. Tier mark in the script header:
  `tier: pr-validation` (dispositioned at merge per the test-discipline
  card).
- **RED:** the script does not exist — running it fails; the assertion "the
  instrument reports the served tree's referenced-but-missing files" cannot
  be satisfied.
- **GREEN:** author the script; run it over the current tree: its output
  MUST reproduce the audit's enumeration exactly (8 files, 23 references,
  the same per-file referrer lists) — that run is also the defect's
  reproduction evidence, captured under `.issues/14/research/`.
- **Instrument:** executed run of `tools/check-image-refs.sh` over the
  current tree, output diffed against the audit enumeration.

### Item 3 — the orphan sweep in the gate script (SC-4 sweep side)

- **Deliverable:** `tools/verify-served-tree.sh` extended additively with a
  tree→manifest sweep scoped to the served surfaces: after the existing
  manifest→tree check, enumerate the served tree's files — all of `cnt/`,
  plus `cntdata/`'s four-digit HTML files, plus the committed tarball file —
  and report each served file absent from the manifest (`orphan: <path>`
  lines + an orphan count line); a detected orphan fails the script's exit.
  The enumeration is NOT a whole-directory walk of `cntdata/` (it holds
  ~15,900 non-served files — the verse-level data and auxiliary working
  files — which an unscoped sweep would falsely flag). The existing output
  lines and their semantics are unchanged (additive extension per the
  spec's R4).
- **RED:** the current script is manifest→tree only — demonstrated on a
  repo-root-shaped scratch copy (the script's interface takes a repo root:
  it reads `cntdata/served-tree-manifest.md5` and `cntdata/website.tar.gz`
  from it and maps served names to the `cnt/` and `cntdata/` surfaces):
  copy the manifest, the tarball, and the mapped surfaces into a scratch
  repo-root shape, add a scratch file to a mapped surface, and run the
  current script — it reports matched/OK and no orphan complaint (the
  assertion "the gate detects served files absent from the manifest"
  fails).
- **GREEN:** implement the scoped sweep; re-run the scratch demonstration:
  the scratch file is reported as an orphan and the exit fails; re-run over
  the unmodified scratch root: `8553/8553 matched` + `0 orphans`, exit 0.
- **Instrument:** executed before/after captures of both scratch runs and
  the unmodified-tree run, captured under `.issues/14/research/`.

### Item 4 — the 8 images into the served tree (SC-2 resolution, SC-3, SC-8, SC-5)

- **Deliverable:** the 8 PNGs at the served-tree root in `cnt/` — 4 imported
  per D2 (md5-verified against the census capture at import), 4 copied per
  D1 (`cp cnt/200100.png cnt/180100.png` and the three siblings) — and the
  regenerated archive per D5: the served tree (tarball extraction + the 8
  new files) tarred once into `website.tar.gz`, copied to both
  `cnt/website.tar.gz` and `cntdata/website.tar.gz`.
- **RED:** running `tools/check-image-refs.sh` over the current tree flags
  the 8 files with 23 references (Item 2's run).
- **GREEN:** the files land; the archive regenerates; a re-run over the
  updated tree reports zero missing references; the two archive copies are
  byte-identical (same md5); no HTML file is touched (D4).
- **Instrument:** executed instrument run (zero flags) + md5 comparison of
  the two tarball copies + the import md5 checks; the pre/post HTML
  comparison set is empty (no HTML file differs from the base commit) —
  recorded as SC-8's vacuous satisfaction; captures under
  `.issues/14/research/`.

### Item 5 — manifest and stated counts (SC-4 both directions, SC-9, SC-5)

- **Deliverable:** `cntdata/served-tree-manifest.md5` regenerated from the
  post-work tree (8,553 → 8,561 entries: the six-digit PNG family
  8,241 → 8,245 — within it the `00`-suffixed sub-family (`BBCC00` chapter
  headings and `BB0000` book titles) 283 → 287, while the disjoint
  verse-scan family stays 7,958 — and the two-digit `BB_` strips 23 → 27;
  PNG total 8,264 → 8,272; the manifest covers the tarball file itself as
  before); `docs/SERVED-TREE.md` and the
  `deploy/Dockerfile` bake-stage comment updated to the reconciled counts
  (8,561; composition as the doc's own structure states it).
- **RED:** with Item 4 landed and Item 3's sweep in place, the extended gate
  over the post-work tree reports 8 orphans (the new PNGs are absent from
  the 8,553-entry manifest) — the assertion "the manifest reconciles to the
  tree" fails.
- **GREEN:** manifest regenerated; the extended gate reports
  `8561/8561 matched` + `0 orphans`, exit 0; the two stated-count surfaces
  carry 8,561 and the reconciled composition.
- **Instrument:** executed gate capture (both direction lines) + artifact
  parse of `docs/SERVED-TREE.md` and the Dockerfile comment against the
  manifest census; captures under `.issues/14/research/`.

### Item 6 — redeploy and live verification (SC-7, SC-5)

- **Deliverable:** one redeploy through `deploy/deploy-cnt-web.sh` at the
  feature-branch tip (D6) — build, tag `cnt-web:<branch-tip-commit>`, slot
  repoint, service up, no routing change; the deployment record
  (`deploy/deployment-record.txt` per the CNT#11 pattern) updated with the
  tag ↔ commit ↔ date. Then the live verification: HTTP status of the 8
  reference paths and a fetch of the 20 affected chapter pages confirming
  each served page's reference set now resolves (restored/replaced present
  + 200; no drops exist, so no absent-branch entries; no accepts, so no
  404-branch entries).
- **RED:** the live state captured 2026-11-07 — all 8 paths return 404
  (`.issues/14/research/2026-11-07_live-probe.md`); the assertion "the live
  tree reflects the dispositions" fails.
- **GREEN:** post-deploy, all 8 paths return 200 and the 20 pages' served
  reference sets match the disposition record 1:1.
- **Instrument:** live capture — per-path status matrix + per-page fetch of
  the 20 affected pages, compared against the disposition record; captured
  under `.issues/14/research/` in the standing probe-SOP form.

### Item 7 — the pull request (SC-6, SC-5)

- **Deliverable:** one open PR against `master` from the feature branch,
  one squashed commit carrying Items 1–5's changes (the record, the
  instrument, the sweep, the 8 PNGs, both archives, the manifest, the two
  stated-count surfaces) plus `deploy/deployment-record.txt` (appended by
  Item 6's deploy — the deployed commit cannot contain the record of its
  own deploy, so the record update lands after Item 6 and rides the PR);
  the PR body carries the summary and the executed
  evidence (RED/GREEN captures, the live probe). No agent merge — the
  human merges.
- **RED:** `gh pr list` shows no open PR for the branch.
- **GREEN:** the PR is open with the squashed commit and the evidence body.
- **Instrument:** `gh pr view <n> --json state,title,body` parse.

## Dependencies

1 → 2 → 3 → 4 → 5 → 6 → 7, strictly linear: the record's inventory (1) is
the baseline the instrument's output is diffed against (2); the sweep (3)
must exist before the manifest reconciliation can be evidenced (5); the
images (4) create the orphans the manifest regeneration (5) resolves; the
deploy (6) requires the reconciled tree; the PR (7) carries the squashed
result of 1–5. Item 6's deploy runs from the branch tip after Items 1–5 are
committed to the branch.

## Traceability

- Item 1 → SC-1 (R1). Item 2 → SC-2's instrument (R5), SC-5. Item 3 →
  SC-4's sweep (R4). Item 4 → SC-2's resolution (R2), SC-3 (R3), SC-8 (D4's
  zero-edit note), SC-5. Item 5 → SC-4 both directions (R4), SC-9, SC-5.
  Item 6 → SC-7 (R7), SC-5. Item 7 → SC-6 (R6), SC-5.
- Every SC is covered by at least one item; every item traces to the SCs
  named above. No item implements anything the spec does not call for: the
  sibling reads stay read-only (the developer-named target), no HTML is
  edited (D4), no OCR/training work is included (the copies' content is
  verified by byte-identity to the exemplar and the imports by md5 to the
  census — no additional verification instrument is required by the spec).

## Documentation sources

- `.issues/14/spec.md` (the consumed spec) and its research captures
  (`2026-11-07_reference-audit.md`, `2026-11-07_live-probe.md`,
  `2026-11-07_zola-crosscheck.md`,
  `2026-11-07_import-source-verification.md`).
- `docs/SERVED-TREE.md`, `cntdata/served-tree-manifest.md5`,
  `tools/verify-served-tree.sh` (the CNT#9 delivered gate).
- `deploy/Dockerfile`, `deploy/verify-bake.sh`, `deploy/deploy-cnt-web.sh`,
  `deploy/deployment-record.txt` (the CNT#11 delivered tooling).
- `docs/LEGG.md` (edition provenance for the record's reasons).

## Enforcement gate

The PR is the review boundary: the body carries the executed RED/GREEN
evidence per item; the agent performs no merge (R6/SC-6). The instrument
(`tools/check-image-refs.sh`, pr-validation tier) is dispositioned at merge
per the test-discipline card.

## Cost frame

One feature branch, one squashed commit, one PR, one redeploy. Repo deltas:
1 new doc, 1 new tool script, 1 modified tool script, 8 new PNGs, 2
regenerated archives (byte-identical twins), 1 regenerated manifest, 2
edited stated-count surfaces (docs + Dockerfile comment), and 1 updated
deployment record (appended by the deploy, riding the PR). No build-system
change; the repo has no build framework at its root (data-only archive) —
all checks run as direct script executions per the repo's own tools
convention.

## Edge cases

- Tar regeneration must preserve the flat member layout exactly (the served
  tree's shape is the tarball extraction, never the repo's directory
  split); D5's tar-once-copy-twice rule prevents twin drift.
- The gate script's interface takes a repo root (manifest + tarball +
  mapped surfaces), not a flat extraction — Item 3's scratch demonstration
  and any local gate run must use a repo-root-shaped tree.
- The orphan sweep must stay scoped to the served surfaces: `cntdata/`
  holds ~15,900 non-served files (verse-level data, auxiliary working
  files) that an unscoped walk would falsely flag — Item 5's real-tree run
  would be unreachable with an over-broad sweep.
- The manifest's line format must match the existing file's format exactly
  (the gate parses it); regenerate with the same command shape the current
  manifest was produced with, verified by Item 3's sweep + Item 5's
  both-direction run.
- The deploy is a production action on a live site; rollback is the prior
  pinned tag through the same tooling (the spec's Impact section); the
  deploy script's own procedure is followed as delivered (no new
  deployment mechanics invented here).
- The sibling reads are read-only from the developer-named checkout; no
  sibling file is modified.

## Not included

- Any change to the CherokeeNewTestament.org repository (its four `BBCC00`
  defects remain recorded as a sibling observation).
- HTML edits of any kind (D4 — the audit's references all resolve).
- OCR model training, kraken model acquisition, or OCR-service work (the
  kraken 7.1.1 CLI and the Ollama OCR models at 192.168.1.163:11434 are
  recorded in the issue's research store as available toolkit; no item
  requires them — the copies' content verification is byte-identity).
- The superseded extraction-from-scan effort (locate/download a scanned
  1860 copy, kraken/OCR extraction) — resolved by the developer's
  copies-and-fixes direction of 2026-11-07; the research findings remain in
  the issue's research store should a future effort need them.
- Editorial content work on the pages; devops-repo surfaces; the legacy
  ced1 host.
