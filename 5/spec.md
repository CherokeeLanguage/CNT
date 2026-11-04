# Spec — README and data-conventions documentation (CNT#5)

Remote: https://github.com/CherokeeLanguage/CNT/issues/5

## Problem

The repository is a data-only archive of the Cherokee New Testament — page
scans in `cnt/`, verse-level transcriptions in `cntdata/` — with no README or
user-facing documentation. A newcomer (human or agent) landing on the repo
root cannot learn what the data is, how the `BBCCVV` naming key ties the
surfaces together, or that `cntdata/` text is Latin transliteration rather
than syllabary. `AGENTS.md` carries these facts but addresses agents, not
readers.

Developer request: "setup a proper README and other docs."

## Scope

Two additive documentation files: `README.md` at the trunk root and
`docs/DATA.md` in a new `docs/` directory. No data files are modified, no
existing file is reorganized.

| Surface | Change |
|---|---|
| `README.md` (new) | repo overview, layout, naming key |
| `docs/DATA.md` (new) | per-file-type data conventions |

## Requirements

- **R-1** — `README.md` SHALL state what the repository is (Cherokee New
  Testament page-scan and transcription archive) and describe the directory
  layout: `cnt/` (page scans), `cntdata/` (verse text, English lines, chapter
  HTML, auxiliary working files), `.issues/`, `.opencode/`.
- **R-2** — The README SHALL document the `BBCCVV` naming key (book/chapter/
  verse, two digits each; `01`–`27` = Matthew–Revelation) and map each
  surface: `cnt/BBCCVV.png` (scan image), `cntdata/BBCCVV.txt` (Cherokee in
  Latin transliteration — explicitly not syllabary), `cntdata/BBCCVV.eng`
  (English source line), and the `BB0000` book-header convention
  (`cntdata/BB0000.txt` carries the book-title line; no `.eng` book-header
  form exists).
- **R-3** — The README SHALL note that `cntdata/*.html` chapter pages
  reference scan images by bare filename while the PNGs live in `cnt/`, and
  that `cntdata/` also holds auxiliary working files (`book.txt`,
  `combined.txt`, `output.txt`, `proofread*`, `cnt_data.tar.gz`) that are not
  per-verse data.
- **R-4** — `docs/DATA.md` SHALL give per-file-type detail: verse-file
  content (one line per verse, keyed by `BBCCVV`), the transliteration
  conventions as observed in the actual data, the book-header file's role,
  and the chapter-HTML/scan relationship — all stated from verified
  inspection of real files, never invented.
- **R-5** — All documentation SHALL be accurate against trunk as of writing;
  every stated fact is checkable against repository contents.

## Success criteria

| ID | Criterion | Class | Instrument |
|---|---|---|---|
| SC-1 | `README.md` exists at repo root and covers R-1, R-2, R-3 | structural | `test -f README.md` plus read-through of its sections against R-1..R-3 |
| SC-2 | `docs/DATA.md` exists and covers R-4 | structural | file-existence check plus read-through against R-4 |
| SC-3 | Every factual claim in both documents matches the repository | structural | after drafting: build a claim inventory — enumerate every factual assertion in the finished documents — then verify each enumerated claim against the repository (file existence, naming-key mapping, conventions) line-by-line; zero unverified claims |

## Out of scope

- Modifying any data file (`cnt/`, `cntdata/` per-verse content).
- Fixing the chapter-HTML bare-filename image references.
- Syllabary conversion or transliteration tooling.
- Reorganizing or removing auxiliary working files in `cntdata/`.

## Approach

Write both documents from the facts recorded in `AGENTS.md`, cross-checked by
direct inspection of representative files before any claim is written. A
single feature branch carries both files; one PR.

## Evidence

Executed verification output (SC-1..SC-3 instrument results) is recorded by
the implement/verify stages and attached under this folder (`evidence/`).
