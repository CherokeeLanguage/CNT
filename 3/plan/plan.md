<!-- SPDX-FileCopyrightText: 2026 Michael Conrad -->
<!-- SPDX-License-Identifier: MIT -->

# Plan — CNT#3: import deployed /cnt live state (vhost-175)

Derives entirely from `.issues/3/spec.md` (validated PASS, 2026-11-04).
Every item traces to one spec SC; no item adds scope the spec does not name.

## Execution order and precondition

Strictly sequential: Item 1 → Item 2 → Item 3 → Item 4; each item's
verification builds on the prior item's verified state.

Precondition (not an SC item — pipeline setup per the git-workflow-branch
card, which runs before the first file modification): a feature branch cut
from `origin/master`'s current tip (`29f2c8e1`) exists, with the work record
written at `git rev-parse --git-path work-record.md` recording trunk tip,
branch, and base tip. All items below operate on that branch's working tree.

## Item 1 — Import deployed bytes (SC-1; carries R1, R2, R3)

- **Deliverable:** the working tree holds the deployed bytes for all 262
  changed names — the 260 `cntdata/<BBCC>.html` chapter pages replaced in
  place, plus new files `cnt/100406.png` and `cntdata/website.tar.gz`.
- **RED (fails now):** the SC-1 instrument run against the pre-change tree
  reports 262 mismatches: 260 chapter-HTML content mismatches (PUA-mangled
  copies + blank lines), `cnt/100406.png` absent, `cntdata/website.tar.gz`
  absent.
- **GREEN:** re-capture the full deployed md5 manifest of
  `/opt/tomcat/webapps/cnt` over SSH (freshness gate — the import must
  reflect live state, and a manifest differing from the 2026-11-04 analysis
  capture halts for re-analysis); tar-stream the 262 files from the server;
  md5-verify every pulled file against the manifest **before** placement
  (any mismatch halts the import); place as byte copies — no transform at
  any step.
- **Instrument (spec SC-1):** manifest comparison script — deployed md5
  manifest vs repo files keyed by name, absence counts as mismatch —
  executed post-placement; exit non-zero on any mismatch, else print
  per-class counts (expect 8,553 matched / 0 mismatched).

## Item 2 — Diff audit (SC-2; carries R4)

- **Deliverable:** the branch's diff against `master` contains exactly the
  spec's affected set and nothing else.
- **RED (fails now):** pre-import, `git diff --name-status` vs `master`
  reports 0 changes — the SC-2 assertion (exactly 260 `M` + 2 `A`) fails.
- **GREEN:** after Item 1, audit the diff: exactly 260 `M` entries, all
  `cntdata/<BBCC>.html`, plus exactly 2 `A` entries — `cnt/100406.png` and
  `cntdata/website.tar.gz`.
- **Instrument (spec SC-2):** `git diff --name-status master...HEAD` (and,
  pre-commit, `git status --short` for the same set) — count and classify;
  any third class or unexpected path fails the audit.

## Item 3 — Live serving-path sample (SC-3; behavioral confirmation)

- **Deliverable:** 30 deployed names, selected deterministically at random
  (fixed seed) from the md5 manifest and always including at least 5 chapter
  HTMLs and `100406.png`, re-fetched over the public serving path
  (`https://cherokeedictionary.net/cnt/`) and md5-matched against the working
  tree.
- **RED (fails now):** the pre-import sample mismatches — every sampled
  chapter HTML differs (PUA + blank lines) and `100406.png` is absent from
  the tree.
- **GREEN:** post-import re-fetch of the same 30 names → 30/30 match.
- **Instrument (spec SC-3):** fetch + md5-compare script with fixed seed;
  any mismatch fails.

## Item 4 — Squashed commit and PR (SC-4; carries R5)

- **Deliverable:** one feature branch carrying one squashed commit whose
  content is exactly Items 1–3's verified diff; one open PR against
  `master` whose body states the summary and the executed verification
  evidence (hash-verification transcripts); no merge performed — the agent
  halts at the PR boundary.
- **RED (fails now):** no feature branch or PR for this work exists.
- **GREEN:** stage exactly the 262 paths; commit (repo convention: short
  imperative subject); push; open the PR against `master`.
- **Instrument (spec SC-4):** `gh pr view` shows the open PR with base
  `master`; `git log origin/master..HEAD` shows exactly one commit;
  `git status` clean.

## Safety and rollback

All repo-side changes are git working-tree changes on a feature branch —
recoverable via `git checkout -- <paths>` / branch deletion before commit and
`git reset` afterward. Server access is read-only throughout; no server
state is modified. Any pre-placement hash mismatch or manifest drift halts
the flow for re-analysis (per the spec's Approach), never a partial import.
