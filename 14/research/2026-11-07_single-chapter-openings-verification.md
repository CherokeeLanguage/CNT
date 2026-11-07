# Single-chapter openings verification — the 1860 edition carries no chapter-heading lines (CNT#14)

executing account: OpenCode (huggingface/zai-org/GLM-5.3-Flash) — dispatched read-only image-inspection subagent per the multimodal-dispatch card
date: 2026-11-07 UTC
sources: archive.org item itsekanohedvdatl00worc (Smithsonian scribe scan), per-page renders n340/n341 (baselines) + n380/n381/n382 (the three remaining single-chapter openings)
method: full-page visual read; 2x-4x zoom crops of title/heading regions; contrast-stretched Jude title area to rule out hidden print under show-through; pixel-level ink-extent measurement; cross-checked against repo transliterations cntdata/{240000,250000,260000,190000,180000}.txt

## marker: per-book findings

- 2 John — leaf n380 (printed p. 377; footer "II. JOHN."): title block (small author line + large title line matching "Tsa-Ni Ta-Li-Ne U-Wo-We-La-Nv-Hi." + short centered rule) -> verse 1 directly; complete book on the page (13 vv); chapter_heading_present: NO
- 3 John — leaf n381 (printed p. 378; footer "III. JOHN."): same three-part title block ("Tsa-Ni Tso-I-Ne U-Wo-We-La-Nv-Hi.") -> verse 1 directly; complete book on the page (14 vv); chapter_heading_present: NO
- Jude — leaf n382 (printed p. 379; footer "JUDE."): large title line ("Tsu-Da-Si U-Wo-We-La-Nv-Hi.") + rule -> verse 1 directly; small author line ABSENT (contrast-stretched zoom confirms no printed ink above the large line); book continues on p. 380 with body text (show-through); chapter_heading_present: NO
- Philemon — leaf n340 (printed p. 337; footer "PHILEMON. 22"): re-inspection confirms the prior baseline (title block -> rule -> verse 1); chapter_heading_present: NO

## marker: Hebrews n341 heading (the form that exists — multi-chapter chapter openings)

heading present: chapter-word (4 glyph clusters) + numeral on one display line at the Hebrews ch. 1 opening (p. 338); croppable with caveats — centered over the LEFT COLUMN ONLY (not the page), right-column body text at the same horizontal band (a wide crop would capture it), opening is mid-page, slight skew

## marker: reading

none of the four single-chapter books (Philemon, 2 John, 3 John, Jude) carries a "chapter + numeral" heading line of the BBCC00 display form anywhere in the scanned edition; the four missing BBCC00 files were never croppable from the edition — consistent with the defect's exact shape (missing for exactly these four books). The developer-directed resolution (copies of an existing chapter-1 crop into the four per-chapter paths) stands on this verified ground.

## marker: uncertainties

wording of the small title lines not decodable at w400; ghost numerals' origins (show-through vs offset) unresolved; direct folios for pp. 377-379 not legible (page numbers rest on the n341-anchored mapping); chapter numeral glyph form (Arabic old-style 1 vs Roman I) unresolved at w400
