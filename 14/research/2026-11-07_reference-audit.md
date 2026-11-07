# Reference audit — referenced-but-missing PNGs across the served chapter pages (CNT#14)

executing account: OpenCode (huggingface/zai-org/GLM-5.3-Flash) for michael-conrad (local session, /home/muksihs/git/CNT)
date: 2026-11-07 UTC
checkout state: master @ 981512ef54d8782e0311e4125ae4e552c347c4ae (pre-#15); post-#15 state verified against git objects at d6d60c26 (origin/master)

## marker: audit command
for each of the 260 cntdata/*.html chapter pages: every quoted .png reference extracted; each checked for existence in cnt/ (the served-tree image source). Totals, the missing set with referrers, and the identity checks below.

## marker: audit totals
chapter pages audited: 260
distinct .png references found: 8737
referenced-but-missing files: 8; broken references: 23; referencing pages: 20

## marker: missing references (file -> referrer pages)
07_.png -> 0701 0702 0703 0704 0705 0706 0707 0708 0709 0710 0711 0712 0713 0714 0715 0716
180100.png -> 1801
18_.png -> 1801
240100.png -> 2401
24_.png -> 2401
250100.png -> 2501
25_.png -> 2501
260100.png -> 2601

## marker: universe identity — the two website.tar.gz copies byte-identical
e41315255fe967650fe61bc48ebef404  cntdata/website.tar.gz
e41315255fe967650fe61bc48ebef404  cnt/website.tar.gz (extracted from git object d6d60c26)

## marker: tarball HTML == cntdata HTML (the 6 affected pages, byte comparison)
0702.html IDENTICAL
0703.html IDENTICAL
1901.html IDENTICAL
2501.html IDENTICAL
2601.html IDENTICAL
2701.html IDENTICAL

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

