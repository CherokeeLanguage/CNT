# OCR/HTR model landscape for 1860 Worcester-type Cherokee syllabary (CNT#14 research store)

executing account: OpenCode (huggingface/zai-org/GLM-5.3-Flash) — dispatched web-research subagent
date: 2026-11-07 UTC
purpose: the developer's question — better models to pull and make available; superseded for CNT#14's own scope (copies direction), retained for future OCR efforts

## marker: bottom line

No option is verified to handle the 1860 Worcester-type syllabary at production quality. Tesseract chr is a real but flawed baseline (~65% word-exact on a spot-checked chapter of this very book via the archive.org CHRCNT_DBS_HS OCR run); kraken has no Cherokee model anywhere findable; the strongest pullable Ollama candidates (qwen3-vl:8b, refreshed glm-ocr, dots.mocr) are unproven on any syllabary; Google Cloud Vision lists Cherokee (chr) as an experimental language — the only production-grade Cherokee OCR known to exist, account-gated.

## marker: tesseract chr

traineddata exists in tessdata/tessdata_fast/tessdata_best (+ script/Cherokee); trained 2017 from synthetic font-rendered data of modern fonts (Noto Sans Cherokee etc.), not the 1860 face. Direct evidence: the archive.org CHRCNT_DBS_HS item was OCR'd with tesseract 5.0.0 -l chr; Matthew 1 spot-check vs the proofread HF text (k-mktr/cherokee_new_testament_1860_chr): 65.3% word-exact, characteristic 19th-century glyph confusions.

## marker: kraken

no Cherokee recognition or segmentation model found on the open web (zenodo/htrmomo/GitHub/HF). Durable path if ever needed: train a recognition model from the repo's own corpus (cnt/ scans) aligned with the HF verse-level syllabary text by BBCCVV, transliteration mapping as needed, synthetic font bootstrap.

## marker: ollama pull candidates (to 192.168.1.163)

1. qwen3-vl:8b (6.2 GB; 2b/4b/30b/32b variants) — largest vision encoder among candidates, explicit rare/ancient-character emphasis; best unproven prior.
2. glm-ocr re-pull — the registry copy updated ~3 weeks after the installed one (OmniDocBench V1.5 94.62 claimed); zero-cost refresh of the installed 0.9B doc-OCR specialist.
3. richardyoung/dots.mocr (Q8 4.4 GB) — multilingual document OCR claim, new.
4. second tier: richardyoung/olmocr2 (9.5 GB), kahnwong/nanonets-ocr2:3b (4.6 GB) — Western-document lineages. deepseek-ocr:3b (installed) — token compression makes it the lowest prior for rare glyph detail.

## marker: dedicated Cherokee OCR work

Cherokee Nation + Google: Cloud Vision chr = experimental tier (2021 Phoenix corroboration); no public weights. PAI LAB CSD dataset: planned, nothing released. Transkribus: app-gated, absence unverified.

## marker: gaps

no Cherokee-syllabary benchmark exists anywhere (all rankings prior-based); the 163 server's VRAM unknown; actual behavior of any candidate on the local 1-bit crops untested; kraken list --script Cher not run locally (one-command definitive check, deferred); CherokeeTrainingData/CherokeeDictionary corpora not accessed.
