<!-- SPDX-FileCopyrightText: 2026 Michael Conrad -->
<!-- SPDX-License-Identifier: MIT -->

# Spec — Root AGENTS.md and repo-hygiene remediation (CNT#1)

## Problem

Three verified defects in the repository's current state:

1. **No agent instructions at the root.** An OpenCode session landing in `/home/muksihs/git/CNT` finds a 24,480-file data tree with no root `AGENTS.md`, no README, and no manifests — nothing explains what the repo is, where the buildable toolchain lives, or which paths must never be committed here. The only instruction surface (`.opencode/floor.md`) covers agent process, not this repo's facts.
2. **Pending `.gitignore` uncommitted.** The working tree carries an untracked `.gitignore` whose sole entry is `/.opencode/`. It was authored but never committed, so the ignore rule exists only in this checkout.
3. **OS metadata tracked in git.** `.DS_Store` (repo root) and `cntdata/.DS_Store` are tracked. They surface as modified noise on macOS checkouts and normalize re-adding Finder metadata.

## Scope

| Surface | Change |
|---|---|
| `/AGENTS.md` | created (new file) |
| `/.gitignore` | committed; entries added |
| `.DS_Store`, `cntdata/.DS_Store` | removed from index (files remain on disk) |
| Feature branch → PR | carries the above as one squashed commit |

No other surface is touched: no changes inside `.opencode/` (separate repository with its own pipeline), no content changes to `cnt/` or `cntdata/` data files, no on-disk deletion of the `.DS_Store` files.

## Requirements

- **R1** — `AGENTS.md` exists at the repo root and states only verified, repo-specific, high-signal facts. Every line passes the developer's filter: "would an agent likely miss this without help?". Excluded content classes: generic software advice, long tutorials or exhaustive file trees, obvious language conventions, speculative claims, and content better stored in another instruction file. Compact form: short sections and bullets; this is a simple repository, so the file stays simple.
- **R2** — `AGENTS.md` covers, at minimum, these verified facts: (a) the repo is a data-only archive of the Cherokee New Testament — page scans in `cnt/`, verse-level text in `cntdata/`, nothing to build, test, or run at the root; (b) the `BBCCVV` naming key (book/chapter/verse, two digits each; books 01–27 = Matthew through Revelation) ties `cnt/BBCCVV.png` scans to `cntdata/BBCCVV.txt` Cherokee text and `cntdata/BBCCVV.eng` English source; (c) Cherokee text is stored as Latin transliteration, not syllabary; (d) `.opencode/` is a nested, independent git repository (the agent deck) that is gitignored from this repo — deck changes are committed inside it, never here; (e) `.issues/` is the local issue store — a tool-managed worktree on the `issues-data` branch whose content is committed by the tooling on that branch, never on master; (f) `cntdata/*.html` reference scan images by bare filename while the PNG files live in `cnt/`.
- **R3** — the committed `.gitignore` contains the existing `/.opencode/` entry, adds `/.issues/`, and adds the standard OS-junk defaults: `.DS_Store`, `._*`, `.Spotlight-V100`, `.Trashes`, `Thumbs.db`, `desktop.ini`.
- **R4** — `.DS_Store` and `cntdata/.DS_Store` are untracked (`git rm --cached`); the on-disk files remain.
- **R5** — the work lands on one feature branch carrying one squashed commit, opened as a PR against `master`; the agent performs no merge.

## Success criteria

| ID | Criterion | Class | Instrument |
|---|---|---|---|
| SC-1 | Every factual claim in `AGENTS.md` verifies against the repository | structural | fact audit — each claim in the file is mapped to a checked repo fact; a claim with no verified backing fails |
| SC-2 | Every line of `AGENTS.md` passes the R1 filter ("would an agent likely miss this without help?") and no excluded content class from R1 appears | structural | fresh-context reviewer scan of the file against R1's filter and exclusion list |
| SC-3 | `AGENTS.md` covers every topic in R2's minimum set | structural | reviewer coverage check of R2 topics (a)–(f) against the file |
| SC-4 | The workspace paths `/.opencode/` and `/.issues/` are ignored by git via the committed `.gitignore` | behavioral | `git ls-files --error-unmatch .gitignore && git check-ignore -v .opencode .issues` — the tracked-file check makes the criterion fail if the rule was never committed |
| SC-5 | The OS-junk patterns are active — `.DS_Store` matches at any depth | behavioral | `git check-ignore -v cntdata/.DS_Store` reports a match |
| SC-6 | No `.DS_Store` path remains in the tracked set | structural | `git ls-files \| grep -c .DS_Store` prints 0 |
| SC-7 | The untracked `.DS_Store` files still exist on disk | structural | `test -f .DS_Store && test -f cntdata/.DS_Store` |
| SC-8 | The PR diff contains exactly the scoped surfaces and nothing else | structural | `git show --stat` on the squashed commit lists exactly: `AGENTS.md`, `.gitignore`, `.DS_Store` (deletion), `cntdata/.DS_Store` (deletion) |
| SC-9 | One feature branch → one open PR against `master`; no merge performed by the agent | structural | `gh pr view` shows the open PR; `git log origin/master` shows no agent-made merge |
| SC-10 | The committed `.gitignore` contains every pattern R3 names | structural | for each of the eight entries in R3's list, `git show HEAD:.gitignore` contains a matching line |

## Out of scope

- Any change inside `.opencode/` (deck repository, own pipeline)
- Content changes to any file in `cnt/` or `cntdata/`
- Deleting the on-disk `.DS_Store` files
- Git history rewriting (untrack is forward-looking; the blobs remain in history)

## Approach

- Full pipeline path: spec → plan → implement → verify → PR (the developer named the spec stage and the PR boundary).
- `.gitignore` entries are unanchored for the OS-junk patterns so they match at any depth (verified need: `cntdata/.DS_Store` exists); workspace paths stay root-anchored (`/.opencode/`, `/.issues/`) matching the pending file's existing convention.
- Untrack via `git rm --cached` rather than on-disk deletion — conservative, reversible, and the ignore rule prevents re-add.
- `AGENTS.md` content is drafted only from facts verified during implementation; each line's fact is recorded in the implementation evidence for SC-1's audit.

## Traceability

| Developer statement | Requirement(s) |
|---|---|
| "Create or update `AGENTS.md`… compact… every line should answer: would an agent likely miss this without help?" | R1, R2 |
| Investigation + writing rules (verify before writing; exclude generic/speculative content) | R1 (SC-1, SC-2) |
| "create a spec for this and any other pending changes" | R3 (the pending `.gitignore` is the pending change) |
| "implement for PR" | R5 |
| "also remediate things like .DS_Store etc that should be in the gitignore by default" | R3 (ignore set), R4 (untrack) |

Root-cause coverage: defect 1 → SC-1/SC-2/SC-3; defect 2 → SC-4 (and SC-5, SC-8, SC-10 carry the expansion); defect 3 → SC-5/SC-6/SC-7. Every stated cause is covered; no orphan criteria.

🤖 Co-authored with AI: OpenCode (huggingface/zai-org/GLM-5.3-Flash)
