# BBCC00 form inspection — exemplar crops + IA page correspondence (CNT#14)

executing account: OpenCode (huggingface/zai-org/GLM-5.3-Flash) — dispatched read-only image-inspection subagent per the multimodal-dispatch card
date: 2026-11-07 UTC
sources: local exemplars cnt/190000.png, cnt/190100.png, cnt/200100.png, cnt/180000.png; layout cntdata/1901.html; remote IA per-page render n340 of item itsekanohedvdatl00worc
method: visual inspection; dimensions via file(1); ink-band geometry via PIL/numpy; glyph zooms via ImageMagick; scratch under /tmp/opencode only

## marker: exemplar findings (executed report, verbatim structure)

"cnt/190000.png": {role: "BB0000 book-title scan — Hebrews", pixels: {width: 1017, height: 305}, format: "PNG, 1-bit colormap", depicts: "book-opening title block: small centered two-glyph line (Quo-La = Paul) above large centered line (A-Ni-Qui-Lu Tsu-Wo-We-La-Ne-Lv-Hi), no rules or page furniture"}
"cnt/190100.png": {role: "BBCC00 chapter-heading crop — Hebrews chapter 1 (primary exemplar)", pixels: {width: 385, height: 105}, format: "PNG, 1-bit colormap", depicts: "single-line chapter heading: fixed Cherokee word for 'chapter' (four glyph clusters) + chapter numeral, centered display-size line; no rule, folio, book name, or trailing period", glyphs: "serif D-form, small c-curl, plain v-form, T-form with c-curl, then bold old-style numeral 1"}
"cnt/200100.png": {role: "BBCC00 chapter-heading crop — James chapter 1 (second exemplar)", pixels: {width: 389, height: 93}, format: "PNG, 1-bit colormap", depicts: "same form as 190100: centered display-size line, chapter word + numeral", glyphs: "identical word form to 190100; numeral '1'; heavier/bolder inking than 190100"}
"cnt/180000.png": {role: "BB0000 book-title scan — Philemon (its BBCC00 crop is missing)", pixels: {width: 1021, height: 285}, depicts: "Philemon title block, same structure as 190000; trailing period present on the large line"}
layout: {ordering: "line 8 = BB0000.png width=400 (book title); line 9 = BBCC00.png width=200 (chapter heading); verse tables follow; line 123 = NN_.png width=200 (book-tail ornament)", single_chapter_pages: "1801/2401/2501/2601.html all carry the identical heading row at line 9 referencing the four absent PNGs"}
ia_page_n340: {identity: "Philemon opening, printed p. 337", structure: "show-through top; title block (Paul line + title line + short rule); NO chapter-heading line — verse 1 begins directly beneath the rule; two columns, book complete on the page", correspondence: "NO BBCC00-matching segment on this page"}

## marker: form summary (from the executed report)

A correct BBCC00 segment is a single-line strip: the fixed Cherokee word for "chapter" (four glyph clusters) + a space and the chapter number in bold old-style Arabic numerals, no trailing period in the existing crops, display type ~2x body size, centered, one text line tall (ink 62-66px in 93-105px strips, content 349-379px wide), no rule/folio/book name. Cut from a chapter-OPENING page — never from a running head. The decisive complication: the 1860 printing gives single-chapter books NO chapter-heading line at all (Philemon's opening verified on IA n340), so no authentic BBCC00 segment exists on those books' own pages; since the heading word and numeral ("1") are identical across books, a visually correct segment could only be borrowed from another book's chapter-1 opening line (glyph-identical content, foreign page provenance), omitted, or synthesized.
