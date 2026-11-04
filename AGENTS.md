# AGENTS.md — repository facts

Agent operating rules live in [.opencode/floor.md](.opencode/floor.md) (the
OpenCode deck). This file carries only facts about this repository.

## What this repository is

- Data-only archive of the **Cherokee New Testament**: page scans in `cnt/`,
  verse-level text in `cntdata/`. There is nothing to build, test, or run at
  the repo root — no manifests, no test suite, no CI.
- The naming key `BBCCVV` (book/chapter/verse, two digits each; `01`–`27` =
  Matthew–Revelation) ties the surfaces together:
  - `cnt/BBCCVV.png` — page scan image
  - `cntdata/BBCCVV.txt` — Cherokee transcription in **Latin
    transliteration** (not syllabary — searching for ᏣᎳᎩ script will not
    match these files)
  - `cntdata/BBCCVV.eng` — English source line
- Book-header files use `BB0000`: `cntdata/BB0000.txt` carries the book-title
  line, and there is no `.eng` book-header form.
- `cntdata/*.html` render chapter pages but reference scan images by bare
  filename — the PNGs live in `cnt/`, not `cntdata/`.
- `cntdata/` also holds auxiliary working files (`book.txt`, `combined.txt`,
  `output.txt`, `proofread*` lists, a 2019 `cnt_data.tar.gz` snapshot) —
  these are not per-verse data.

## Git layout

- Trunk is `master`; work runs through the deck's git-workflow cards
  (feature branch → PR).
- **`.opencode/` is a separate nested git repository** (the OpenCode deck:
  floor, skills, guidelines, tools, its own tests and git hooks). It is
  gitignored here — commit deck changes inside `.opencode/` against its own
  remote, never in this repository.
- `.issues/` is the local issue store — a linked worktree on the orphan
  `issues-data` branch managed by `./.opencode/tools/local-issues`
  (mutations auto-commit and push on that branch). Its content never belongs
  in a `master` commit.
- OS metadata (`.DS_Store` and friends) is gitignored — keep it that way.
