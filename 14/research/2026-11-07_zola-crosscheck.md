# Cross-repo audit — ../CherokeeNewTestament.org content pages (CNT#14 scope question)

executing account: OpenCode (huggingface/zai-org/GLM-5.3-Flash) for michael-conrad (local session)
date: 2026-11-07 UTC
surface audited: content/cherokee-new-testament/*/*/index.md — every markdown image reference plus every HTML src=/href= reference inside the markdown, each checked against its page's co-located directory

## marker: referenced-but-missing files (file -> page directories)
180100.png -> 1801
240100.png -> 2401
250100.png -> 2501
260100.png -> 2601

## marker: the four BBCC00 names' existence across both repos
180100.png: CNT cnt/ ABSENT; post-#15 tree ABSENT; Zola tree ABSENT
240100.png: CNT cnt/ ABSENT; post-#15 tree ABSENT; Zola tree ABSENT
250100.png: CNT cnt/ ABSENT; post-#15 tree ABSENT; Zola tree ABSENT
260100.png: CNT cnt/ ABSENT; post-#15 tree ABSENT; Zola tree ABSENT

## marker: dimensions of the Zola NN_ copies vs CNT's existing NN_ siblings (file(1))
1693 x 109  CherokeeNewTestament.org/content/cherokee-new-testament/1-corinthians/0701/07_.png
1021 x 285  CherokeeNewTestament.org/content/cherokee-new-testament/philemon/1801/18_.png
909 x 285  CherokeeNewTestament.org/content/cherokee-new-testament/2-john/2401/24_.png
1233 x 125  CNT/cnt/08_.png
713 x 89  CNT/cnt/19_.png
385 x 105  CherokeeNewTestament.org/content/cherokee-new-testament/hebrews/1901/190100.png

## marker: Zola public/ build state for the four names
180100.png: absent from public/
240100.png: absent from public/
250100.png: absent from public/
260100.png: absent from public/

