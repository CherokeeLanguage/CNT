# Cherokee New Testament (CNT)

A data-only archive of the **Cherokee New Testament**: page scans of the
printed edition paired with verse-level transcriptions and their English
source lines. There is nothing to build or run here — the repository is a
dataset.

## Repository layout

| Path | Contents |
|---|---|
| `cnt/` | Page-scan images, one PNG per page, named `BBCCVV.png` |
| `cntdata/` | Verse-level transcription text, English source lines, chapter HTML pages, and auxiliary working files |
| `.issues/` | Local issue store (separate `issues-data` branch) |
| `.opencode/` | Agent deck (configuration, skills, tooling) |

## The `BBCCVV` naming key

Every data file is named by a six-digit key `BBCCVV` — book, chapter, and
verse, two digits each:

- `BB` — book number, `01`–`27` (Matthew through Revelation, in canonical
  order)
- `CC` — chapter number within the book
- `VV` — verse number within the chapter

So `010101` is Matthew chapter 1, verse 1.

## Data surfaces

For each verse key `BBCCVV`:

| File | Contents |
|---|---|
| `cnt/BBCCVV.png` | Scan of the printed page containing that verse |
| `cntdata/BBCCVV.txt` | The verse in Cherokee, written in **Latin transliteration** — not Cherokee syllabary. Searching for syllabary characters will not match these files. |
| `cntdata/BBCCVV.eng` | The English source line for that verse |

Book-header files use `BB0000`: `cntdata/BB0000.txt` carries the book-title
line. There is no `.eng` book-header form.

Chapter pages are rendered as `cntdata/BBCC.html` (chapter-level key with the
verse digits dropped). These HTML files reference the scan images by bare
filename (e.g. `src="010000.png"`) — the PNGs themselves live in `cnt/`, not
`cntdata/`, so the HTML will not resolve its images in place.

## Auxiliary files in `cntdata/`

Besides the per-verse data, `cntdata/` holds auxiliary working files that are
**not** per-verse data:

- `book.txt`, `combined.txt`, `output.txt` — working/aggregate text files
- `proofread*.txt`, `proofread_list*.txt` — proofreading lists
- `cnt_data.tar.gz`, `website.tar.gz` — archived snapshots

See [docs/DATA.md](docs/DATA.md) for per-file-type detail and the data
conventions observed in the transcriptions.
