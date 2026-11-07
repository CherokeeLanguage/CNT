# Manifest + stated counts — RED/GREEN capture (CNT#14 Item 5)

executing account: OpenCode (huggingface/zai-org/GLM-5.3-Flash) for michael-conrad (local session)
date: 2026-11-07 UTC

## marker: RED — extended gate over the post-image tree with the stale manifest
MISMATCH: website.tar.gz -> cntdata/website.tar.gz md5 mismatch
8552/8553 matched
orphan: 07_.png / 180100.png / 18_.png / 240100.png / 24_.png / 250100.png / 25_.png / 260100.png
orphans: 8
FAILED: 1 mismatch(es)/absence(s), 8 orphan(s)
exit: 1

## marker: GREEN — manifest regenerated (8,561 entries), extended gate
8561/8561 matched
orphans: 0
OK: served-tree manifest verified
exit: 0

## marker: composition (manifest census)
8,561 entries: 8,272 png (six-digit 8,245, of which 00-suffixed 287 = 256 BBCC00 + 27 BB0000; BB_ 27), 288 html (27 BB.html + index.html + 260 BBCC.html), 1 tarball

## marker: stated-count surfaces updated
docs/SERVED-TREE.md: 8,561-entry universe / 8,272 page scans / 27 BB_ files / 8,560 tarball members
deploy/Dockerfile bake-stage comment: 8,561-file served universe
SC-9 artifact parse: PASS (see chat record; historical 8,553 lines in the doc's dated verification section left as point-in-time history)
