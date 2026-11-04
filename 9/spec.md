<!-- SPDX-FileCopyrightText: 2026 Michael Conrad -->
<!-- SPDX-License-Identifier: MIT -->

# Spec — Commit the served-tree manifest + deployment mapping (the /cnt deployment artifact of record) (CNT#9)

## Problem

The repository is now the verified archive of record for the served `/cnt`
tree: CNT#3 (merged, PR #4, 2026-11-04) imported the deployed webapp state,
and the import was re-verified against the live source on 2026-11-04 — the
full 8,553-file deployed manifest over SSH (`/opt/tomcat/webapps/cnt` on
ced1) md5-matches the repo tree 8,553/8,553, and a live sample fetched over
`https://cherokeedictionary.net/cnt/` matches byte-for-byte.

But the served tree exists in the repo only implicitly. The deployment is
FLAT — every file (8,264 PNGs, 28 top-level HTMLs, 260 chapter HTMLs,
`website.tar.gz`) sits in one directory — while the repo splits it across
`cnt/` and `cntdata/` with a name-keyed mapping that lives only in analysis
records and this store's research cards. And the byte-level truth of the
served tree is re-derivable only by re-approaching ced1, a host that retires
at the dictionary cutover.

The consuming deployment (cherokeelanguage-devops#29 — baking the tree into
a static file-server image) needs a self-contained, locally verifiable
integrity instrument: a committed manifest of the served tree and its
mapping into this repo, generated from tracked bytes alone, so the image
build can prove what it bakes without any access to the old host.

## Dependency position

- **Blocks:** cherokeelanguage-devops#29 — its content-provenance and
  checksum verification instruments (SC-1/SC-3 of that spec) consume this
  manifest. That spec's implementation SHALL NOT begin before this one's
  deliverable is merged to this repo's trunk.
- **Depends on:** CNT#3 (delivered — the byte-level sync this manifest
  describes).
- Boundary discipline: this spec directs work ONLY in this repository. The
  deployment that consumes the manifest is devops#29's scope entirely; this
  spec neither directs nor depends on any work outside this repo.

## Requirements

- **R1** — A committed md5 manifest of the served tree exists in the repo
  (path: `cntdata/served-tree-manifest.md5`), one line per served file in
  `md5sum` format, covering exactly the 8,553-entry served universe
  (8,264 PNGs + 28 top-level HTMLs + 260 chapter HTMLs + `website.tar.gz`).
- **R2** — Each manifest line's name maps to its repo path by the documented
  rule, and the manifest is generated from the repo's tracked bytes only —
  never from the server: `BBCCVV.png` → `cnt/BBCCVV.png`;
  `BB_.png` (book-header images, 23 files) → `cnt/BB_.png`;
  `BB.html` (01–27) and `index.html` → `cnt/<name>`;
  `BBCC.html` (chapter pages) → `cntdata/BBCC.html`;
  `website.tar.gz` → `cntdata/website.tar.gz`.
- **R3** — The mapping rule and the manifest's role as the deployment
  artifact of record are documented in `docs/` (one short page), so the
  consuming deployment's provenance record can cite repo paths, not analysis
  chat.
- **R4** — A verification script (committed, e.g. `tools/verify-served-tree.sh`)
  executes the check against a fresh checkout: it verifies every manifest
  entry against the repo file at its mapped path (for `website.tar.gz`, the
  check runs against the tarball AND its extracted members' md5s, extracted
  to a temp dir) and exits non-zero on any mismatch or absence.
- **R5** — The work lands on a feature branch as PR(s) against `master` per
  the deck's git-workflow cards; the agent performs no merge.

## Success criteria

| ID | Criterion | Class | Instrument |
|---|---|---|---|
| SC-1 | `tools/verify-served-tree.sh` over a fresh clone of `master` prints 8,553/8,553 matched and exits 0 | structural | executed script output |
| SC-2 | The manifest carries exactly 8,553 lines; every name matches the mapping rule; `docs/` page states the mapping and the artifact-of-record role | structural | line count + scripted name-rule audit |
| SC-3 | One open PR against `master`; no agent merge | structural | `gh pr view` |

## Out of scope

- Any data-file content change (the manifest describes tracked bytes; it
  changes none).
- Any deployment, container, or routing work — devops#29's repo and scope.
- Any server access — ced1 is not touched; the manifest's authority derives
  from CNT#3's delivered and re-verified sync.
- Regenerating or re-bundling `website.tar.gz`.

## Traceability

The requirement source is the consuming deployment's verification need
(devops#29 SC-1/SC-3 instruments) plus the observed fact that the served
tree's flat layout and repo mapping exist only in analysis records. Every
requirement traces to making that verification self-contained in this repo.

🤖 Co-authored with AI: OpenCode (huggingface/zai-org/GLM-5.3-Flash)
