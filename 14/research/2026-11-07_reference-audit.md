# Reference audit — referenced-but-missing PNGs across the served tree (CNT#14)

executing account: OpenCode (huggingface/zai-org/GLM-5.3-Flash) for michael-conrad (local session, /home/muksihs/git/CNT)
date: 2026-11-07 UTC
checkout state: master @ 981512ef54d8782e0311e4125ae4e552c347c4ae (pre-#15); post-#15 state verified against git objects at d6d60c26 (origin/master)
audit surface: the website.tar.gz extraction at /tmp/opencode/wt14 (the served tree) — every .html file, every quoted .png reference, checked against the extraction root

## marker: audit totals
html files audited: 288 (260 chapter pages + 28 book-level/top-level pages)
page-unique .png references found (a name counted once per page): 8737
referenced-but-missing files: 8; broken references: 23; referencing pages: 20

## marker: missing references (file -> referrer pages)
07_.png -> 0701.html 0702.html 0703.html 0704.html 0705.html 0706.html 0707.html 0708.html 0709.html 0710.html 0711.html 0712.html 0713.html 0714.html 0715.html 0716.html
180100.png -> 1801.html
18_.png -> 1801.html
240100.png -> 2401.html
24_.png -> 2401.html
250100.png -> 2501.html
25_.png -> 2501.html
260100.png -> 2601.html

## marker: cntdata/ chapter-page copies byte-identical to the extraction (all 260, per-page cmp)
compared: 260 cntdata/*.html vs the same paths in the extraction — identical: 260, differs: 0

## marker: post-#15 cnt/ html copies byte-identical to the extraction (all, via git archive of d6d60c26)
compared: 288 cnt/*.html at d6d60c26 vs the same paths in the extraction — identical: 288, differs: 0

## marker: universe identity — the two website.tar.gz copies byte-identical
e41315255fe967650fe61bc48ebef404  cntdata/website.tar.gz
e41315255fe967650fe61bc48ebef404  cnt/website.tar.gz (extracted from git object d6d60c26)

## marker: the 8 files absent from the post-#15 published tree (git objects at d6d60c26)
absent post-#15: cnt/07_.png
absent post-#15: cnt/18_.png
absent post-#15: cnt/180100.png
absent post-#15: cnt/240100.png
absent post-#15: cnt/24_.png
absent post-#15: cnt/250100.png
absent post-#15: cnt/25_.png
absent post-#15: cnt/260100.png

## marker: post-#15 page references are own-book (cnt/1801.html, cnt/1901.html at d6d60c26)
1801.html: 180000.png 180100.png 180101.png 180102.png 180103.png 180104.png
1901.html: 190000.png 190100.png 190101.png 190102.png 190103.png 190104.png

