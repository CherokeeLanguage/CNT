# Toolkit probe — kraken CLI and Ollama OCR service (CNT#14 research store)

executing account: OpenCode (huggingface/zai-org/GLM-5.3-Flash) for michael-conrad (local session)
date: 2026-11-07 UTC
purpose: record the OCR/HTR toolkit facts the developer designated (kraken; OCR service via LAN host), probed live this session

## marker: kraken local CLI

$ kraken --version
kraken, version 7.1.1
(ketenos binaries at ~/.local/bin/kraken and ~/.local/bin/ketos; system python3 cannot import kraken — venv/pipx install; no trained recognition model on disk — only an unrelated blla.mlmodel test file in ../algonquian-library/tmp/kraken-test/)

## marker: ollama service at 192.168.1.163:11434

$ OLLAMA_HOST=http://192.168.1.163:11434 ./.opencode/tools/ollama-probe list
glm-ocr:bf16                      2.47GB  glm4
richardyoung/unlimited-ocr:Q8_0   3.68GB  deepseek2-ocr
deepseek-ocr:3b                   6.23GB  deepseekocr
glm-ocr:latest                    2.47GB  glm4
service reachable; four OCR models installed (developer-designated OCR host)

## marker: 192.168.1.162 unreachable (the first-named host)

ping 192.168.1.162: 100% packet loss; no response on probed ports 22, 80, 8000, 8080, 5000, 7860, 8888, 11434, 445 (curl + nc, 2-3s timeouts). The developer later corrected the Ollama service to 192.168.1.163 (probed above).

## marker: reading

kraken 7.1.1 runs locally with no Cherokee-trained model; the designated Ollama OCR service lives at 192.168.1.163:11434 with four OCR models. Neither is required by CNT#14's plan (the copies' content verification is byte-identity); recorded for future OCR efforts alongside 2026-11-07_ocr-model-landscape.md.
