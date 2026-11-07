<!--
SPDX-FileCopyrightText: 2026 Michael Conrad
SPDX-License-Identifier: MIT
-->

# Spec — disposition the 8 referenced-but-missing `/cnt` scan images (23 broken references, 20 chapter pages) (CNT#14)

## Problem

Twenty chapter pages of the served `/cnt` tree reference eight PNG files that
exist nowhere: 404 on the live deployment (verified 2026-11-07) and absent
from the repository, both committed `website.tar.gz` copies, and the deployed
image. Found 2026-11-06 by the exhaustive site crawl probe
(cherokeedictionary `tests/crawl_probe.py`, 300 pages) against the new-stack
deployment; the report verified the defects are pre-existing content gaps —
not migration losses (the published tree, the repo, and the deployed image all
lack the files). Twenty pages currently render broken images to every visitor.

## Facts (verified this pass)

Captures for every check below sit under `.issues/14/research/` (dated
2026-11-07).

- **The defect set (exhaustive audit):** every quoted `.png` reference across
  all 260 served chapter pages (`cntdata/*.html`, byte-identical to the
  tarball members and to the post-#15 `cnt/` copies) checked against the
  served-tree image source — 8,737 distinct references found; exactly 8 files
  are referenced but missing; 23 broken references across 20 pages:
  - `07_.png` ← all sixteen 1 Corinthians chapter pages (`0701`–`0716`)
  - `180100.png`, `18_.png` ← `1801` (Philemon 1)
  - `240100.png`, `24_.png` ← `2401` (2 John 1)
  - `250100.png`, `25_.png` ← `2501` (3 John 1)
  - `260100.png` ← `2601` (Jude 1; its `26_.png` exists)
- **Live confirmation:** the 8 names return 404 on
  `cherokeedictionary.net/cnt/`; sibling controls (`190100.png`, `19_.png`,
  `26_.png`, `27_.png`, `270100.png`) return 200. File presence at the
  referenced path therefore predicts live serving exactly on this tree —
  which grounds the structural instruments below.
- **The originating report's referrer table is corrected:** its four
  single-chapter rows pair each missing file with the *next* book's page
  (`1901`, `2501`, `2601`, `2701`); the audited pages and the live-served
  pages reference their *own* book's names (`1801`, `2401`, `2501`, `2601`),
  and `07_.png` has sixteen referrers, not two. The defect set itself — the
  8 missing files — is exactly as reported.
- **Naming structure:** each chapter page references `BB0000.png` (book-title
  scan — all exist), `BBCC00.png` (chapter-heading scan — exists for every
  multi-chapter book, e.g. `190100.png` 385×105; missing for exactly the four
  single-chapter books), the `BBCCVV.png` verse scans, and an `NN_.png`
  book-thumbnail strip at the page bottom (exists for most books; missing for
  books 07, 18, 24, 25).
- **Cross-repo observation (CherokeeNewTestament.org, audited 2026-11-07):**
  the same four `BBCC00.png` files are referenced-but-missing there (one page
  each: `philemon/1801`, `2-john/2401`, `3-john/2501`, `jude/2601`), while
  every `NN_.png` file exists in that repo — including the four CNT lacks
  (`07_.png` 1693×109 in every 1-Corinthians chapter dir; `18_.png` 1021×285;
  `24_.png` 909×285). The four `BBCC00` scans exist in neither repo —
  consistent with the report's hypothesis that they were never generated.
  Dimensional mismatches between the Zola `NN_` copies and CNT's existing
  `NN_` siblings (e.g. CNT `19_.png` 713×89, CNT `08_.png` 1233×125) leave
  copy-equivalence unverified. This is a sibling defect in another
  repository — out of scope here (single-repo scope rule), recorded for the
  developer's disposition.
- **CNT#13 (closed; PR #15 merged 2026-11-07T04:31Z)** committed the
  published tree at `cnt/` (8,553 files) and the in-webapp
  `cnt/website.tar.gz`; the two tarball copies are byte-identical (md5
  `e41315255fe967650fe61bc48ebef404`). #13's provenance question (whether the
  `NNNN.html` pages are CNT-diglot-generated or hand-maintained) was recorded
  there without a delivered verdict; the committed pages are the working
  surface either way.
- **Served-truth topology:** the deployed image bakes the `website.tar.gz`
  extraction (CNT#11 R1), gated by CNT#9's manifest
  (`tools/verify-served-tree.sh`, 8,553 files). Chapter-page content lives in
  three reconciled surfaces: `cntdata/*.html` (working copies), `cnt/*.html`
  (published-tree copies), and the tarball members. Redeploys swap the pinned
  tag with no routing change (CNT#11 R3).

## Scope

- Disposition each of the 8 missing-file references using the report's stated
  outcomes — restore/regenerate the image, correct the page's reference
  (drop/replace), or accept the broken reference with a recorded reason —
  with the disposition (outcome + reason) recorded per reference.
- Implemented dispositions propagate to every surface the served tree draws
  from (`cntdata/`, `cnt/`, the tarball members), and the resolved state
  reaches the live deployment through CNT#11's redeploy loop.
- A committed reference-integrity instrument over the served chapter pages,
  plus the dated execution captures.

## Requirements

- **R1** — A committed disposition record SHALL cover every
  referenced-but-missing image reference in the served chapter pages (the
  8 files / 23 references / 20 pages of the 2026-11-07 audit), assigning each
  reference exactly one outcome — restore, correct, or accept — with a
  recorded reason.
- **R2** — Post-work, the only unresolved image references in the served
  chapter pages SHALL be the accept-dispositioned ones (each carried with its
  recorded reason); every restore-dispositioned reference SHALL have its image
  present at the referenced path in the served tree, and every
  correct-dispositioned reference SHALL have its referencing page carrying a
  resolvable or removed reference.
- **R3** — Content changes SHALL land on every surface the served tree draws
  from — `cntdata/*.html`, `cnt/*.html`, and the `website.tar.gz` members
  (both committed copies regenerated identically) — with the surfaces
  reconciled after the change; edits to chapter pages SHALL be confined to
  the image references (no other content change).
- **R4** — If the served-tree file universe changes (files added or removed),
  CNT#9's served-tree manifest SHALL be regenerated to match, and
  `tools/verify-served-tree.sh` over the post-work tree SHALL report
  0 missing / 0 orphans.
- **R5** — A reference-integrity instrument SHALL be committed in the repo's
  `tools/` family: it enumerates every `.png` reference in the served chapter
  pages and reports each referenced-but-missing file with its referrer pages;
  its output is the reconciliation basis for SC-2.
- **R6** — The work lands on a feature branch as PR(s) against `master`; the
  agent performs no merge.
- **R7** — The resolved state SHALL reach the live `/cnt` tree: a redeploy
  through CNT#11's deploy tooling at a new pinned content commit, riding the
  existing loop with no routing change.
- **Constraint (the report's CNT#13 coordination point):** if the diglot
  pipeline later regenerates the chapter pages, the disposition record and the
  instrument are the regeneration's reconciliation inputs — both must be
  readable without this ticket's context.

## Success criteria

| ID | Criterion | Class | Instrument |
|---|---|---|---|
| SC-1 | The disposition record exists, is committed, and covers all 8 files / 23 references / 20 pages of the 2026-11-07 audit, each reference carrying exactly one outcome (restore / correct / accept) and a reason | structural | artifact parse of the record against the audit enumeration captured under `.issues/14/research/` |
| SC-2 | The committed instrument (R5) executed over the post-work served tree flags exactly the accept-dispositioned references and nothing else — every restore/correct disposition shows resolved | structural | executed instrument output reconciled 1:1 against the disposition record |
| SC-3 | The surfaces are reconciled post-work: every touched chapter page is identical across `cntdata/`, `cnt/`, and the extracted tarball members, and the two tarball copies remain byte-identical to each other | structural | executed byte-diff of the touched files across surfaces + md5 comparison of the two tarballs |
| SC-4 | The manifest gate holds post-work: `tools/verify-served-tree.sh` over the post-work tree reports 0 missing / 0 orphans against the manifest (regenerated per R4 if the universe changed) | structural | executed script capture |
| SC-5 | Dated captures of this work's executed evidence (audit, instrument runs, surface reconciliation, deploy probe) sit under `.issues/14/research/` in the standing probe-SOP family form (executing account in each capture header, marker-labeled sections) | structural | artifact existence + completeness parse |
| SC-6 | One open PR against `master`; no agent merge | structural | `gh pr view` |
| SC-7 | Post-redeploy, the live `/cnt` tree reflects the dispositions: restored/corrected references return 200 and accept-dispositioned references return 404, exactly as the disposition record states | behavioral | live HTTP probe capture of the affected reference paths, compared against the record |

## Approach

- **The instrument** joins the repo's existing tools family (beside
  `tools/verify-served-tree.sh`): a POSIX-shell script enumerating `.png`
  `src=`/`href=` references from the served chapter pages and checking each
  against the served-tree root, printing `missing-file -> referrer pages`
  lines. It reports; the disposition record carries the decisions.
- **Per-reference disposition** is decided at implementation from the
  recorded outcomes, with the investigation paths the report names: the four
  `NN_` strips have a candidate source (the CherokeeNewTestament.org
  co-located copies — equivalence verified before adoption, since dimensions
  differ from CNT's existing `NN_` siblings); the four single-chapter
  `BBCC00` scans exist nowhere, so restore means regeneration from the source
  scans or the diglot artwork pipeline, with correct/accept as the report's
  fallbacks. The disposition record is where each decision lands with its
  reason.
- **Propagation** follows the existing reconcile-and-redeploy loop: content
  lands on all surfaces, the tarball regenerates if members change, the
  manifest regenerates if the universe changes, and a redeploy at a new
  pinned tag (CNT#11's tooling, no routing change) carries the state live;
  SC-7's probe closes the loop.

## Impact

Consumers: the twenty affected `/cnt` chapter pages (currently rendering
broken images), every inbound link to them, the dictionary suite's
dead-reference sweep family (the cherokeedictionary#136 disposition surface),
and any future diglot page regeneration (the disposition record as its
reconciliation input). Blast radius: repo content files (HTML, PNG, tarball,
manifest) plus one redeploy through the delivered tooling — no code paths, no
devops-repo surfaces, no routing change. Rollback: revert the content commit
and redeploy the prior pinned tag through the same tooling.

## Out of scope

- The CherokeeNewTestament.org Zola repository's identical four `BBCC00`
  defects — separate repository, separate issue store (single-repo scope
  rule); recorded in Facts as a sibling observation for the developer's
  disposition.
- CNT-diglot pipeline changes or wholesale page regeneration in this ticket.
- Editorial content work on the pages (text corrections are not this defect).
- The legacy ced1 host's state — devops' retirement surface, not this repo's.
- Host-side or devops-repo changes (cherokeelanguage-devops#29's scope).

## Traceability

The requirement source is the developer's report (this record's
pre-conversion body, 2026-11-06): "Disposition each of the 8 references:
regenerate/scan the missing image, or correct the page's reference
(drop/replace), or accept the broken image with a recorded reason," plus its
CNT#13 coordination note. The observed failures are the report's crawl
findings and this session's verification — the 2026-11-07 exhaustive audit
(8 files / 23 references / 20 pages) and the live spot-check, both captured
under `.issues/14/research/`. R1/R2 implement the disposition requirement
verbatim; R3/R4 are the fix's reconciliation obligations toward the served
tree and CNT#9's delivered gate; R5 commits the audit that found the defect
as the standing instrument; R7 closes the loop to the surface the failure was
observed on; R6 is the deck's PR boundary.

> Full spec and plan artifacts: https://github.com/CherokeeLanguage/CNT/tree/issues-data/14

Full spec and artifacts (AI-facing): `.issues/14/`

🤖 Co-authored with AI: OpenCode (huggingface/zai-org/GLM-5.3-Flash)
