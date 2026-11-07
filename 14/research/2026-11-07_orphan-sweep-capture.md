# Orphan sweep RED/GREEN capture — verify-served-tree.sh extension (CNT#14)

executing account: OpenCode (huggingface/zai-org/GLM-5.3-Flash) for michael-conrad (local session)
date: 2026-11-07 UTC
scratch: repo-root-shaped copy at /tmp/opencode/gate-scratch (manifest + tarball + mapped cnt/ and cntdata/ surfaces)

## marker: RED — current script (manifest-to-tree only), scratch tree with orphan cnt/999999.png
8553/8553 matched
OK: served-tree manifest verified
exit: 0  <- orphan undetected

## marker: GREEN — extended script, scratch tree with orphan cnt/999999.png
8553/8553 matched
orphan: 999999.png
orphans: 1
FAILED: 0 mismatch(es)/absence(s), 1 orphan(s)
exit: 1

## marker: GREEN — extended script, unmodified scratch root
orphans: 0
OK: served-tree manifest verified
exit: 0

## marker: regression — extended script, real repo root
8553/8553 matched
orphans: 0
OK: served-tree manifest verified
exit: 0  (41s wall, tarball member re-verification dominates)
