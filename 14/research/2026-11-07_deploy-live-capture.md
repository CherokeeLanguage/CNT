# Redeploy + live verification capture (CNT#14 Item 6 / SC-7)

executing account: mconrad@vhost-58.cherokeedictionary.net (ssh, unprivileged) for the deploy; OpenCode (huggingface/zai-org/GLM-5.3-Flash) for the live probe
date: 2026-11-07 UTC
pinned commit: 4d475568d2275cd1a75c1c84a8bd1b7f0f1286f2 (feature branch tip; deployed pre-merge per the CNT#11 precedent)
command: bash deploy/deploy-cnt-web.sh (on the host, from /tmp/cnt-deploy-14 — a clean pinned checkout of the branch tip fetched from origin)

## marker: deploy output (tail)
redeploy: repointing the slot's image line (routing untouched)
compose: parses
cnt service: running
redeploy: no reload — routing unchanged

## marker: deployment record entry (appended)
## deployment 2026-11-07T17:28:55Z
- image tag: cnt-web:4d475568d2275cd1a75c1c84a8bd1b7f0f1286f2
- CNT content commit: 4d475568d2275cd1a75c1c84a8bd1b7f0f1286f2
- image content identity: sha256:566892d3753d035b5867ae970be09227dd1d42914c8f99cbc94c12123d952432
- deploy mode: redeploy (slot image line repointed, routing untouched)

## marker: live per-path status (the 8 restored + controls)
200 07_.png | 200 18_.png | 200 24_.png | 200 25_.png
200 180100.png | 200 240100.png | 200 250100.png | 200 260100.png
200 190100.png | 200 19_.png | 200 270100.png (controls)

## marker: the 20 affected pages — every served .png reference resolves
pages checked: 20 (0701-0716, 1801, 2401, 2501, 2601); pages with unresolved references: 0

## marker: comparison against the disposition record
restored references: 23/23 present in the served pages and returning 200 — matches the record 1:1 (no drops, no accepts)
