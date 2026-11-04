# Cherokee New Testament (CNT)

A data-only archive of the **Cherokee New Testament**: page scans of the
printed edition paired with verse-level transcriptions and their English
source lines. There is nothing to build or run here — the repository is a
dataset.

## Provenance

This data descends from the **Cherokee New Testament Online** project,
initiated by **Timothy Legg** in 2006: the printed edition was digitized on a
flatbed scanner and the full New Testament transcribed by hand over about
three years, with two complete proofreading passes. The project ran
2006–2019; this repository was seeded from Legg's own 2011 data archive
(`cntdata/cnt_data.tar.gz`). See [docs/LEGG.md](docs/LEGG.md) for the full
acknowledgment of his work. The original site (cherokeenewtestament.org) is
no longer reachable; the project content is preserved in the
[CherokeeNewTestament.org repository](https://github.com/CherokeeLanguage/CherokeeNewTestament.org)
and mirrored at [cherokeedictionary.net/cnt/](https://cherokeedictionary.net/cnt/).

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
