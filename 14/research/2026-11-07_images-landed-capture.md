# Images landed — RED/GREEN capture (CNT#14 Item 4)

executing account: OpenCode (huggingface/zai-org/GLM-5.3-Flash) for michael-conrad (local session)
date: 2026-11-07 UTC

## marker: RED (pre-work)
./tools/check-image-refs.sh cnt -> 8 files / 23 broken references, exit 1 (see 2026-11-07_instrument-red-capture.md)

## marker: import md5 gates (D2)
d0b670c796b20120111bc881a2a165e3  cnt/07_.png
97370b7e6510f5181bad04ba8224f9c3  cnt/18_.png
22d5756e30c1832a9fb651aefd3627ff  cnt/24_.png
3da963b9f30aa42a89fb060522b4a591  cnt/25_.png
all four match the sibling census exactly

## marker: copy identity gate (D1)
2a3b40399f16c2fcfc1226b8b3c228bf
1 distinct md5 across the exemplar and the four copies (byte-identical)

## marker: GREEN — instrument over the updated tree
./tools/check-image-refs.sh cnt -> broken references: 0, exit 0

## marker: tarball twins (D5)
461461c565841810e6bddf1b7739bc52  cnt/website.tar.gz
461461c565841810e6bddf1b7739bc52  cntdata/website.tar.gz
regenerated once, copied twice; members: ./ entry + 8,560 files (8,552 + 8)

## marker: SC-8 (zero HTML edits)
git diff d6d60c26 -- cnt/*.html cntdata/*.html: empty; 0 html files changed

## marker: extraction spot-check
07_.png, 180100.png, 260100.png: tree == tarball extraction (cmp)
