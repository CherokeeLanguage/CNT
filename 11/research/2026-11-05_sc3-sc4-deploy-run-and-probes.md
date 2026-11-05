# SC-3 / SC-4 capture — deploy run, service up, edge probes, deployment record (CNT#11)

executing account: mconrad@vhost-58.cherokeedictionary.net (ssh, unprivileged);
probes re-executed from the developer workstation (curl) after the host-side
busybox-wget binary transport proved unreliable for md5 sampling
date: 2026-11-05 UTC
tool: deploy/deploy-cnt-web.sh (committed), run from /tmp/cnt-red-clone at the pinned commit

## marker: first-deploy run (staging through devops#29's source-of-truth script)
pinned commit: ea8458a16d215ea2823c30ed608f89cf8a733de9
first deploy: staging the host config (devops#29 source of truth)
CNT_IMAGE=cnt-web:ea8458a16d215ea2823c30ed608f89cf8a733de9
Caddyfile: /cnt route added before the catch-all
compose: parses
Caddyfile: valid
staged; NOT reloaded — route activation follows the cnt service coming up (devops#29 update window)
 Container cnt Created / Started
cnt service: running
update window: validating and reloading Caddy (2026-11-05T04:39:25Z)
route activated through the update window

## marker: redeploy run after the baked-Caddyfile prefix fix (redeploy path exercised)
pinned commit: ef45e643c26f0fa9bd84c6e43372ac22a30213f9
redeploy: repointing the slot's image line (routing untouched)
compose: parses
 Container cnt Recreated / Started
cnt service: running
redeploy: no reload — routing unchanged
image id: sha256:f934ce213f93114326960934e40dc7eaf0a30671eabeb4c03478266bb3837859

## marker: probe — legacy pair through the dev-hostname edge tier
bare /cnt: 302 -> https://dev.cherokeedictionary.net/cnt/
/cnt/:     200

## marker: probe — checksummed sampled walk against CNT#9's committed manifest
(index.html, 01.html, 010101.png, 030216.png, 032136.png, 2722.html,
272216.png, 050101.png, 012301.png, website.tar.gz — all MATCH http=200;
manifest-exact bytes. Two invalid sample names in an early pass — 010101.html,
272816.png — are not manifest names (verse HTMLs are chapter-level BBCC.html;
Rev has 22 chapters), not serving defects. The full 8,553-file universe is
verified inside the build (SC-1 capture); the exhaustive served-tree walk at
the phase's run is devops#29's SC-1 instrument.)

## marker: probe — apex untouched (pre-flip: apex still resolves to the old host)
apex https://cherokeedictionary.net/ : 200 (old host, unchanged)

## marker: deployment record (SC-4) — deploy/deployment-record.txt (committed)
## deployment 2026-11-05T04:39:25Z
- image tag: cnt-web:ea8458a16d215ea2823c30ed608f89cf8a733de9
- CNT content commit: ea8458a16d215ea2823c30ed608f89cf8a733de9
- image content identity: sha256:81f384a5d0cec1f429f1a08683e421558a846bd7862efd375fea50e67834772a
- deploy mode: first deploy (slot staged + route activated through the update window)
## deployment 2026-11-05T04:40:23Z
- image tag: cnt-web:ef45e643c26f0fa9bd84c6e43372ac22a30213f9
- CNT content commit: ef45e643c26f0fa9bd84c6e43372ac22a30213f9
- image content identity: sha256:f934ce213f93114326960934e40dc7eaf0a30671eabeb4c03478266bb3837859
- deploy mode: redeploy (slot image line repointed, routing untouched)

## note: provenance reachability
The deployed tag pins the pre-squash branch tip; after the PR merges, a
redeploy at the squashed master tip through the same tooling re-pins the
provenance to a permanent commit (the redeploy path, cached build, no routing
change).
