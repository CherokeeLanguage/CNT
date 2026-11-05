# SC-2 RED capture — divergent-tree build over a gate-less reference (CNT#11)

executing account: mconrad@vhost-58.cherokeedictionary.net (ssh, unprivileged)
date: 2026-11-05 UTC (session 2026-11-04 EST)
state: pre-gate — no committed deploy/Dockerfile exists; throwaway scratch-only
Dockerfile (extract + tag, no verification), never committed.

## marker: tamper
tamper: 010000.png size=4027  (one byte flipped at EOF, then tarball re-created)

## marker: reference build (gate-less) — SUCCEEDS
#8 writing image sha256:de1b80c01fbec2cef292a3309df7dea20c127ecd98f8b43786e8942d22685674 done
#8 naming to docker.io/library/cnt-web-red:c032281b done
#8 DONE 1.0s

## marker: tag landed (the forbidden outcome, pre-gate)
RED TAG EXISTS: sha256:de1b80c01fbec2cef292a3309df7dea20c127ecd98f8b43786e8942d22685674

## marker: scratch cleanup
scratch tag removed
