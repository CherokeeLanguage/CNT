<!-- SPDX-FileCopyrightText: 2026 Michael Conrad -->
<!-- SPDX-License-Identifier: MIT -->

# Plan — Root AGENTS.md and repo-hygiene remediation (CNT#1)

Derives entirely from `.issues/1/spec.md` (validated, round 2 PASS). Every item traces to a spec SC; no item enlarges the spec's scope.

## Route

Branch first (per `.opencode/skills/git-workflow-branch/SKILL.md` — trunk-freshness check, feature branch, provenance + scope statement into the work record), then the items in order (`.opencode/skills/implement/SKILL.md`, commits per `.opencode/skills/git-workflow-commit/SKILL.md`), then fresh-context verification (`.opencode/skills/verify/SKILL.md`), then the PR boundary (`.opencode/skills/git-workflow-pr/SKILL.md`). All five card paths existence-checked against this repo's deck copy on 2026-11-04. Terminal authorization ("implement for PR") carries the work through the PR boundary; merge stays human.

## Items

### Item 1 — Commit the expanded `.gitignore` (SCs: SC-4, SC-5, SC-10)

- **Deliverable:** `/.gitignore` tracked in git, containing the preserved `/.opencode/` entry plus `/.issues/` and the six unanchored OS-junk patterns `.DS_Store`, `._*`, `.Spotlight-V100`, `.Trashes`, `Thumbs.db`, `desktop.ini`.
- **RED:** `git ls-files --error-unmatch .gitignore` exits non-zero (file is untracked today); `git check-ignore -v .issues` outputs nothing; `git check-ignore -v cntdata/.DS_Store` outputs nothing. All three verified against the current tree on 2026-11-04.
- **GREEN:** append the new entries to the pending `.gitignore` (existing entry preserved verbatim); stage and commit the file.
- **Instrument:** `git ls-files --error-unmatch .gitignore && git check-ignore -v .opencode .issues` prints a matching rule for each of the two workspace paths; `git show HEAD:.gitignore` contains each of the eight entries R3 names. (`git check-ignore` does not report tracked files by default, so the `.DS_Store` activation probe runs in Item 2, after the untrack — SC-5 verifies there.)

### Item 2 — Untrack the `.DS_Store` files (SCs: SC-5, SC-6, SC-7)

- **Deliverable:** `.DS_Store` and `cntdata/.DS_Store` removed from the git index; the on-disk files remain.
- **RED:** `git ls-files | grep -c .DS_Store` prints 2 (verified today).
- **GREEN:** `git rm --cached .DS_Store cntdata/.DS_Store` — index-only removal; commit rides with the branch's work.
- **Instrument:** `git ls-files | grep -c .DS_Store` prints 0; `test -f .DS_Store && test -f cntdata/.DS_Store` succeeds; `git check-ignore -v cntdata/.DS_Store` now reports the matching rule (SC-5's behavioral probe is only observable once the file is untracked).
- **Dependency:** runs after Item 1 — the on-disk files must already be ignored when they leave the index, or they resurface as untracked noise.

### Item 3 — Write the root `AGENTS.md` (SCs: SC-1, SC-2, SC-3)

- **Deliverable:** `/AGENTS.md` — compact (short sections and bullets), containing only facts verified in this session, covering R2's minimum set (a)–(f), with a pointer to `.opencode/floor.md` as the agent-rule surface rather than restating deck rules.
- **RED:** `test -f AGENTS.md` fails (no root AGENTS.md exists today).
- **GREEN:** draft the file with a three-section skeleton: what the repository is (data-only archive; the `BBCCVV` key — verse files `BBCCVV.txt`/`BBCCVV.eng` plus book-header files `BB0000.txt`; transliteration-not-syllabary scoped to the verse transcription files); git layout (nested `.opencode/` deck repo, gitignored; tool-managed `.issues/` store); where the buildable toolchain lives (inside `.opencode/` only). Every claim is verified before it is written; the claim→evidence mapping is recorded in the implementation evidence for SC-1's audit. State the naming structure, not precise file counts — counts are stale-prone and fail the "would an agent miss this?" filter (verified for the plan's own accuracy, not for the doc: numeric six-digit `.txt` files number 7,981, of which 27 are `BB0000.txt` book headers; numeric six-digit `.eng` files number 7,937 with no book-header form).
- **Instrument:** SC-1 fact audit (each claim mapped to a checked fact); SC-2/SC-3 via the verify stage's fresh-context reviewer scan and coverage check.

### Item 4 — Squash, push, open the PR (SCs: SC-8, SC-9)

- **Deliverable:** the feature branch squashed to one commit containing exactly the four scoped path changes; PR opened against `master`; the agent halts at the PR boundary.
- **RED:** `git branch --list` shows only `master` and the tool-managed `issues-data` worktree branch — no feature branch for this work exists; `gh pr view` fails (no PR).
- **GREEN:** per the PR card — squash the branch's work to one reviewable commit, push, `gh pr create` with a body carrying the summary and executed-instrument evidence; stop (merge is human).
- **Instrument:** `git show --stat` on the squashed commit lists exactly `AGENTS.md`, `.gitignore`, `.DS_Store` (deletion), `cntdata/.DS_Store` (deletion); `gh pr view` shows the open PR; `git log origin/master` shows no agent-made merge.

## Dependencies

Item 1 → Item 2 (ignore-before-untrack, rationale in Item 2) → Item 3 → Item 4 (PR carries the completed work; the PR card's readiness gate needs the verified state).

## Traceability

| Item | SCs | Spec requirement |
|---|---|---|
| 1 | SC-4, SC-10 | R3 |
| 2 | SC-5, SC-6, SC-7 | R3 (pattern activation), R4 |
| 3 | SC-1, SC-2, SC-3 | R1, R2 |
| 4 | SC-8, SC-9 | R5 |

## Documentation Sources

Verified repo facts gathered 2026-11-04: `git ls-files` (tracked set, 24,480 files; two `.DS_Store` paths), root listing (no README/manifests/CI), `cnt/01.html` + `cnt/27.html` (Matthew, Revelation), `cntdata/010101.txt` / `.eng` / `0101.html` samples (BBCCVV keying, transliteration, bare-filename image references), `.opencode/` tree (nested repo, own remote, deck layout), `.issues/` worktree state, pending `.gitignore` content.

## Enforcement Gate

The verify card's fresh-context reviewer measures the delivered state against the spec's SC-1..SC-10 instruments before any PR-readiness claim; a FAIL remediates and re-reviews until a zero-finding verdict.

## Cost Frame

Four small items, one session; the only shared-resource step is the remote push in Item 4. No long-running jobs, no external service dependencies.

## Edge Cases

- `git check-ignore` probes use paths that exist on disk (`.opencode/`, `.issues/`, `cntdata/.DS_Store`) so the command reports matches rather than silent non-matches on nonexistent paths.
- The unanchored junk patterns are intentional: `cntdata/.DS_Store` proves second-level instances exist; root-anchoring would miss them.
- If the PR body edit hits the GitHub Projects-classic deprecation error, the gh-cli card's REST fallback (`gh api -X PATCH repos/{owner}/{repo}/pulls/{N} -F body=@<file>`) applies.

## Not Included

Everything in the spec's out-of-scope list: `.opencode/` interior changes, `cnt/`/`cntdata/` data changes, on-disk `.DS_Store` deletion, history rewriting.

🤖 Co-authored with AI: OpenCode (huggingface/zai-org/GLM-5.3-Flash)
