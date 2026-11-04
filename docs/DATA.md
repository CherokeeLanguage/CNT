# CNT data conventions

Detail on the file types in `cntdata/` and the conventions observed in the
data. The repository overview and naming key live in the
[README](../README.md); this document covers the data itself.

## File inventory (observed on trunk, 2026-11)

| Type | Count | Naming |
|---|---|---|
| Verse transcription (`cntdata/BBCCVV.txt`) | 7,989 | verse key, including 27 book headers |
| English source line (`cntdata/BBCCVV.eng`) | 7,937 | verse key |
| Page scans (`cnt/BBCCVV.png`) | 8,264 | verse key |
| Book-title lines (`cntdata/BB0000.txt`) | 27 | `BB0000` |
| Chapter HTML (`cntdata/BBCC.html`) | 260 | chapter key |
| Auxiliary working files | 10 | free-form names (see below) |

Counts differ because coverage is not uniform: every book has a title line,
not every verse has an English line yet, and pages can carry several verses
per scan.

## Verse transcription files (`BBCCVV.txt`)

One verse per file, one line of text. The Cherokee is written in Latin
transliteration, one hyphenated word-group per Cherokee word, syllable by
syllable. Examples:

- `cntdata/010101.txt` (Matthew 1:1):
  `Hi-a go-we-li ka-no-he-ha tsu-ne-tlv-ta-nv-sv Tsi-sa Ga-lo-ne-dv, De-wi u-we-tsi, E-qua-ha-mi u-we-tsi.`
- Punctuation and capitalization follow the English source line's shape.

## Book-header files (`BB0000.txt`)

`cntdata/BB0000.txt` holds the book-title line as printed, e.g.
`cntdata/010000.txt`: `O-S-Dv Ka-No-He-Dv, Ma-Du U-Wo-We-La-Nv-Hi.` — the
transliterated Cherokee book title for Matthew. There is no
`.eng` book-header form: English book titles appear only in the chapter HTML
and aggregate files.

## English source lines (`BBCCVV.eng`)

One line per verse, the English text the Cherokee translation follows, e.g.
`cntdata/010101.eng`: `The book of the generation of Jesus Christ, the son of
David, the son of Abraham.`

## Chapter HTML (`BBCC.html`)

Rendered chapter pages titled "Cherokee New Testament Online". Each embeds
the chapter's page scans by **bare filename** (`src="010000.png"`), while the
PNGs live in `cnt/` — the HTML does not resolve its images from its own
directory.

## Aggregate file (`book.txt`)

`cntdata/book.txt` interleaves Cherokee and English in a tagged record
format, one verse per record pair — an `@` line followed by a `#` line:

```
@01#01#02#Abraham begat Isaac; and Isaac begat Jacob; ...
#E-qua-ha-mi E-si-gi u-de-ne-le-i; E-si-gi-no Tse-ga-qui u-de-ne-le-i, ...
```

- `@` lines carry the verse key and English: `@BB#CC#VV#<english>`.
- The `#` line that follows carries the Cherokee transliteration of that
  same verse.
- Exception observed in the data: the file's very first line
  (`01#01#01#The book of the generation of …`) lacks the leading `@`.

## Auxiliary working files

Not per-verse data; working artifacts of the transcription effort:

- `book.txt`, `combined.txt`, `output.txt` — aggregate/working text
- `proofread02.txt`, `proofread04.txt`, `proofread05.txt`,
  `proofread_list.txt`, `proofread_list2.txt` — proofreading lists
- `cnt_data.tar.gz`, `website.tar.gz` — archived snapshots
