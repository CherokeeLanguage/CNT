# Instrument RED capture — check-image-refs.sh over the pre-work tree (CNT#14)

executing account: OpenCode (huggingface/zai-org/GLM-5.3-Flash) for michael-conrad (local session)
date: 2026-11-07 UTC
command: ./tools/check-image-refs.sh cnt (exit 1 — defect present)

## marker: instrument output
07_.png -> 0701 0702 0703 0704 0705 0706 0707 0708 0709 0710 0711 0712 0713 0714 0715 0716
180100.png -> 1801
18_.png -> 1801
240100.png -> 2401
24_.png -> 2401
250100.png -> 2501
25_.png -> 2501
260100.png -> 2601
broken references: 23

## marker: comparison vs audit
output identical to the 2026-11-07 audit enumeration (8 files, 23 broken references, per-file referrer lists) — verified by parse
