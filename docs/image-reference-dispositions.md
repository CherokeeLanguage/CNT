<!--
SPDX-FileCopyrightText: 2026 Michael Conrad
SPDX-License-Identifier: MIT
-->

# Image-reference disposition record — the served `/cnt` tree (CNT#14)

Every referenced-but-missing image reference in the served chapter pages
(the 2026-11-07 exhaustive audit: 288 HTML pages, 8,737 page-unique
references — 8 files referenced but missing, 23 broken references across
20 pages) carries exactly one disposition outcome below, with its reason.
Outcomes: **restore** (the image is present at the referenced path in the
served tree), **correct** (the referencing page carries a resolvable or
removed reference), **accept** (the broken reference remains with a
recorded reason).

Source facts the reasons cite:

- The 2026-11-07 exhaustive audit of all 288 served HTML pages (8,737
  page-unique `.png` references; 8 files referenced but missing, 23 broken
  references across 20 pages) — executed during CNT#14's triage; its
  per-file referrer lists are the inventory below.
- Developer direction 2026-11-07 (a): the four `NN_` strips restore by
  import from the sibling project CherokeeNewTestament.org, which holds
  each strip as a single distinct file (md5 census verified per file at
  import).
- Developer direction 2026-11-07 (b): copies into the per-chapter files are
  acceptable; the remainder of the HTML is fixed to not reference images
  that aren't possible. The 1860 ABS edition the scans came from carries no
  chapter-heading line for the four single-chapter books — verified on all
  four openings (Philemon p. 337, 2 John p. 377, 3 John p. 378, Jude
  p. 379) in the Smithsonian scribe scan of the edition (archive.org item
  `itsekanohedvdatl00worc`) — so no authentic segment exists to extract and
  the copy of a glyph-identical chapter-1 heading crop (`200100.png`) is
  the sanctioned restore.
- The drop/correct fallback was **not exercised**: after the eight restores
  below, every reference resolves; no HTML file is edited.

| missing file | referenced by | outcome | reason |
|---|---|---|---|
| `07_.png` | `0701` `0702` `0703` `0704` `0705` `0706` `0707` `0708` `0709` `0710` `0711` `0712` `0713` `0714` `0715` `0716` | restore | import from CherokeeNewTestament.org (direction 2026-11-07a; the sibling holds the strip — md5 `d0b670c796b20120111bc881a2a165e3` — while this repo's 2020 posterity checkin never carried it) |
| `180100.png` | `1801` | restore | copy of `200100.png` (direction 2026-11-07b; the 1860 edition prints no chapter-heading line for Philemon's opening — IA leaf n340 verified — so no authentic segment exists; the chapter-1 crop is glyph-identical in word and numeral) |
| `18_.png` | `1801` | restore | import from CherokeeNewTestament.org (direction 2026-11-07a; md5 `97370b7e6510f5181bad04ba8224f9c3`) |
| `240100.png` | `2401` | restore | copy of `200100.png` (direction 2026-11-07b; 2 John's opening verified heading-less — IA leaf n380) |
| `24_.png` | `2401` | restore | import from CherokeeNewTestament.org (direction 2026-11-07a; md5 `22d5756e30c1832a9fb651aefd3627ff`) |
| `250100.png` | `2501` | restore | copy of `200100.png` (direction 2026-11-07b; 3 John's opening verified heading-less — IA leaf n381) |
| `25_.png` | `2501` | restore | import from CherokeeNewTestament.org (direction 2026-11-07a; md5 `3da963b9f30aa42a89fb060522b4a591`) |
| `260100.png` | `2601` | restore | copy of `200100.png` (direction 2026-11-07b; Jude's opening verified heading-less — IA leaf n382) |

Totals: 8 files, 23 references (16 + 2 + 2 + 2 + 1), 20 referencing pages
(16 + 4). Outcome counts: restore 8, correct 0, accept 0.
