<!-- SPDX-FileCopyrightText: 2026 Michael Conrad -->
<!-- SPDX-License-Identifier: MIT -->

# Spec — Sync repo to the published /cnt live state on vhost-175 before switch-over (CNT#3)

## Problem

This repository is the archive of record for the Cherokee New Testament data.
Its data content was seeded in commit `5243dee` (2020-04-01, "posterity initial
checkin") from `cntdata/cnt_data.tar.gz` — Timothy Legg's data archive, member
timestamps 2011-06-09 — plus a PNG set matching the pre-migration site. Master
has since gained CNT#1's repo-hygiene remediation (merged 2026-11-04, PR #2:
root `AGENTS.md`, committed `.gitignore`, `.DS_Store` files untracked), which
touched none of the data files — the data content still does not reflect what
the published site serves today.

The published site is served from the old system: vhost-175.cherokeedictionary.net
(host `ced1`), a Grails/Tomcat deployment whose `/cnt` webapp lives at
`/opt/tomcat/webapps/cnt`. The public hostnames `cherokeedictionary.net` and
`www.cherokeedictionary.net` serve byte-identical `/cnt/` content from that same
deployment (verified 2026-11-04: same md5s for index and chapter pages, same
uniform Last-Modified `22 Aug 2019 03:12:28 GMT`). The new system,
vhost-58.cherokeedictionary.net (Docker), serves no `/cnt/` yet (HTTP 404 as of
2026-11-04).

Investigation (recorded in
`.issues/research-cards/cnt-vhost-175-deployment-divergence.yaml`, confidence
0.95) verified exactly three divergences between the repo and the deployed
tree, and nothing else:

1. **Syllabary normalization, all 260 chapter pages.** The repo's
   `cntdata/BBCC.html` files carry Private-Use-Area syllabary codepoints
   (18,158 chars, U+E3A0–U+E3F4 — a uniform +0xD000 shift of the Cherokee
   block U+13A0–U+13F4) mixed with true Unicode, plus a blank line after each
   verse row. Every deployed copy is pure Unicode Cherokee (0 PUA chars across
   all 260 files) with those blank lines removed. After applying the inverse
   remap and blank-line strip to the repo copies, all 260 are byte-identical
   to the deployed copies (SequenceMatcher: zero non-equal opcodes) — there
   are no content edits, no verse-text changes, no structural changes.
2. **One missing scan.** `100406.png` (Ephesians 4:6 scan, 8,156 B) is
   deployed but absent from the repo, while the repo holds that verse's text
   data (`cntdata/100406.txt`, `cntdata/100406.eng`).
3. **The migration bundle exists only on the old system.** `website.tar.gz`
   (69,559,190 B) sits inside the deployed webapp directory and contains
   exactly the deployed tree (8,553 entries: 8,264 PNGs + 288 HTMLs +
   the directory entry), already normalized, including `100406.png`. It is
   tracked nowhere — not in this repo, not in any git repo on the server —
   and would be lost on switch-over.

The other 8,291 common files (8,263 verse/cover PNGs, 27 book pages
`01.html`–`27.html`, `cnt/index.html`) are already md5-identical to the
deployment. The deployed tree has been untouched since 2019-08-21 22:12:28
-0500 (uniform file mtimes; directory mtime unchanged — no additions,
replacements, or in-place edits since). The staging copy
`/home/cdrchops/cnt` is byte-identical to the live webapp.

With the switch-over to vhost-58 pending, the old system's published state is
the only live source. If it is not captured now, the normalization, the
missing scan's deployed form, and the migration bundle are lost.

## Developer directives (traceability sources)

| # | Directive | Date |
|---|---|---|
| D1 | "analyze and report" (vhost-175 CNT divergence) | 2026-11-04 |
| D2 | "create a spec and import all these updates so the repo correctly reflects the deployed site's state. then create a PR." | 2026-11-04 |
| D3 | "include any artifacts that will be lost on switch-over" | 2026-11-04 |
| D4 | "for reference: old: vhost-175.cherokeedictionary.net; new: vhost-58.cherokeedictionary.net via docker" | 2026-11-04 |
| D5 | "the repo shall reflect the live state of the deployed /cnt site on the old system"; "the repo needs to reflect what the actually published site has" | 2026-11-04 |

## Scope

| Surface | Change | Source of bytes |
|---|---|---|
| `cntdata/0101.html` … `cntdata/2722.html` (260 files) | replaced in place with deployed copies | `/opt/tomcat/webapps/cnt/<name>.html` via SSH |
| `cnt/100406.png` | added (new tracked file) | `/opt/tomcat/webapps/cnt/100406.png` via SSH |
| `cntdata/website.tar.gz` | added (new tracked file, 69,559,190 B) | `/opt/tomcat/webapps/cnt/website.tar.gz` via SSH |

Mapping note: the deployment is flat (one directory); the repo splits it
(`cnt/` for scans + book pages, `cntdata/` for chapter pages and archives).
Chapter pages and the archive land in `cntdata/` per the repo's established
convention (`cnt_data.tar.gz` already lives there); the scan lands in `cnt/`
beside its 8,263 siblings. Name-keyed mapping is unique for every deployed
file — verified against the full deployed manifest.

## Requirements

- **R1** — Every file in the deployed webapp tree that has a repo counterpart
  under `cnt/` or `cntdata/` is byte-identical to its deployed copy after this
  change. The deployed universe is the 8,553-file md5 manifest captured from
  `/opt/tomcat/webapps/cnt` (8,264 PNGs + 288 HTMLs + `website.tar.gz`);
  a repo counterpart that is absent counts as a mismatch.
- **R2** — `cnt/100406.png` exists in the repo, md5-identical to the deployed
  copy.
- **R3** — `cntdata/website.tar.gz` is committed to the repo, md5-identical to
  the deployed bundle.
- **R4** — No other tracked file changes: the import is a byte copy of
  deployed state — no regeneration, re-encoding, line-ending conversion, or
  normalization performed by the import itself. Repo-only surfaces (`.txt`,
  `.eng`, aux working files, `cnt_data.tar.gz`, `.DS_Store` files) are
  untouched.
- **R5** — The work lands on one feature branch carrying one squashed commit,
  opened as a PR against `master`; the agent performs no merge.

## Success criteria

| ID | Criterion | Class | Instrument |
|---|---|---|---|
| SC-1 | All 8,553 deployed-file names md5-match their repo counterparts (absence = mismatch) | structural | manifest comparison script executed post-import: deployed md5 manifest vs repo files keyed by name → prints per-class counts and exits non-zero on any mismatch |
| SC-2 | The diff vs `master` touches exactly 260 modified + 2 added files and nothing else | structural | `git diff --name-status master...HEAD` — 260 `M` entries, all `cntdata/<BBCC>.html`, plus 2 `A` entries exactly `cnt/100406.png` and `cntdata/website.tar.gz` |
| SC-3 | A sample re-pulled over the public serving path md5-matches the repo working tree | behavioral | after import, fetch 30 randomly selected deployed names from `https://cherokeedictionary.net/cnt/` and md5-compare against the repo → 30/30 match |
| SC-4 | One open PR against `master` from the feature branch, one squashed commit, no agent merge | structural | `gh pr view` shows the open PR; `git log` on the PR branch shows exactly one commit ahead of `master`; no merge performed |

## Out of scope

- Any content change to `.txt`/`.eng` files, aux working files
  (`book.txt`, `combined.txt`, `output.txt`, `proofread*`), or
  `cnt_data.tar.gz` — repo-only material, served nowhere.
- `.DS_Store` hygiene and `AGENTS.md` — CNT#1's scope, already merged to
  master (PR #2, 2026-11-04); nothing further here.
- Any change on either server: the import is read-only against vhost-175;
  the vhost-58 deployment is not built here.
- Unpacking or re-bundling `website.tar.gz` — imported as the exact bytes.
- The dictionary app's database/app surfaces on either host.

## Approach

1. Capture the deployed universe once: full md5 manifest of
   `/opt/tomcat/webapps/cnt` over SSH (already captured this session;
   re-capture at import time to confirm nothing changed between analysis and
   import — the tree has been static since 2019, but the check is cheap and
   the import must reflect live state).
2. Pull the exact bytes: tar-stream the 260 chapter HTMLs + `100406.png` +
   `website.tar.gz` from the server; md5-verify each pulled file against the
   manifest **before** placing it in the repo. No transform is applied at any
   step — placement is a byte copy. Alternative weighed: regenerating the
   normalized files locally (inverse remap + blank-line strip on the repo
   copies) reproduces the same bytes but re-implements the normalization with
   its own failure modes; the direct byte copy from the source of truth,
   gated by hash verification, is simpler and independently checkable, so it
   was chosen.
3. Place into the repo: 260 in-place replacements, 2 additions.
4. Verify: SC-1 manifest comparison, SC-2 diff audit, SC-3 live-path sample.
5. One squashed commit on a feature branch; PR against `master`; halt for
   human merge.

Verification evidence records executed hash output and command transcripts,
not assertions. Failure of any pre-placement md5 check halts the import (a
changed server state would contradict the verified analysis and require
re-analysis, not a partial import). All repo-side changes are ordinary git
working-tree changes — fully recoverable via git before commit — and no
server state is modified at any step, so the change has no irreversible
failure mode.

## Traceability

| Directive | Requirement(s) |
|---|---|
| D2 "import all these updates so the repo correctly reflects the deployed site's state" | R1 |
| D2 + analysis finding 2 (missing scan) | R2 |
| D3 + D5 (artifacts lost on switch-over; live published state) | R3 |
| D5 "the repo needs to reflect what the actually published site has" (byte-fidelity intent) | R1, R4 |
| D2 "then create a PR" | R5 |
| D4 "old: vhost-175 …; new: vhost-58 … via docker" | defines the source system R1 measures against (the deployed webapp on vhost-175) and the switch-over context that makes R3 urgent |
| D1 "analyze and report" | delivered as the investigation record the spec builds on — `.issues/research-cards/cnt-vhost-175-deployment-divergence.yaml`; carries no implementation requirement |

Root-cause coverage: divergence 1 (normalization) → R1; divergence 2 (missing
scan) → R1, R2; divergence 3 (migration bundle) → R1, R3. Every verified
divergence is covered by at least one requirement; no orphan criteria.

🤖 Co-authored with AI: OpenCode (huggingface/zai-org/GLM-5.3-Flash)
