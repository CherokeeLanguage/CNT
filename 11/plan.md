# Plan — product self-deployment on the vhost-58 stack: image build + deploy tooling (CNT#11)

Spec: `.issues/11/spec.md` (approved for PR 2026-11-04 — carries through plan and implement).
Execution target facts (verified 2026-11-05): vhost-58 reachable as `ssh mconrad@vhost-58.cherokeedictionary.net`
(unprivileged, docker 29.9.3 present); `/srv/cnt/` created by devops#29's `[privileged]` setup
(empty — staging is #29's stage script executed with `CNT_IMAGE`); `cnt-vhost-58-stage.sh` is the
committed source of truth for the slot + route and validates without reloading; route activation
rides #29's update window after the service is up.

## Conventions (single-sourced here)

- Repo paths: image definition under `deploy/` (`Dockerfile`, `Caddyfile`, `verify-bake.sh`,
  `deploy-cnt-web.sh`). No changes to `cnt/`, `cntdata/` content; no changes to `tools/verify-served-tree.sh`.
- The manifest gate inside the build is `deploy/verify-bake.sh` — an md5 walk of the **baked flat
  tree** (every `cntdata/served-tree-manifest.md5` line checked against the baked file at the tree
  root, plus the tarball itself at the root, count asserted 8,553). `tools/verify-served-tree.sh`
  verifies the repo's split layout; the bake is the flat served shape, so the gate needs the flat
  walk. Both instruments consume the same committed manifest.
- Image tag: `cnt-web:<full-40-char-commit-hash>` (R2 — content-addressed provenance).
- The deploy script runs **on vhost-58** from a checkout of this repository at the pinned commit;
  it invokes the staged host config (`cnt-vhost-58-stage.sh`) on first deploy and repoints the
  slot's image line on redeploy; routing stays untouched (R3).
- Evidence captures land under `.issues/11/research/` in the probe-SOP family form (executing
  account in header, marker-labeled sections, dated).

## Items

### Item 1 — the image definition (SC-1)

- **Deliverable:** `deploy/Dockerfile` (multi-stage: bake stage extracts `cntdata/website.tar.gz`
  to the served root, places the tarball at the root, runs `deploy/verify-bake.sh` — failure aborts
  the build so no tag is produced; final stage `FROM caddy:2.11.7` with `deploy/Caddyfile` baked,
  serving the tree on internal :80, no ports published, no env, no volumes) and
  `deploy/verify-bake.sh` + `deploy/Caddyfile`.
- **RED:** `docker build -f deploy/Dockerfile .` on vhost-58 fails (no such file); no image tagged.
- **GREEN:** add the three files; commit on the feature branch.
- **Instrument:** executed build on vhost-58 at the pinned commit printing the 8,553/8,553
  comparison and tagging `cnt-web:<commit>`; capture saved under `.issues/11/research/`.

### Item 2 — the gate gates (SC-2)

- **Deliverable:** none (verification item for Item 1's gate).
- **RED:** none — this item is the proof the RED of Item 1's gate exists: a divergent tree must
  fail before tagging.
- **GREEN:** execute a divergent build — a scratch build context whose `website.tar.gz` carries one
  tampered member — and capture the non-zero build and the absence of the tag.
- **Instrument:** executed divergent-build capture (non-zero exit; `docker image inspect` on the
  tag fails) under `.issues/11/research/`.

### Item 3 — the deploy tooling (SC-3, SC-4)

- **Deliverable:** `deploy/deploy-cnt-web.sh` — runs on vhost-58 from a checkout at the pinned
  commit: (a) records the pinned commit; (b) builds the image (`cnt-web:<commit>`, image ID
  captured); (c) first deploy: invokes the staged host config script (path parameter, default the
  host's staged copy) with `CNT_IMAGE=cnt-web:<commit>` — the slot's image line is that pinned
  reference; `docker compose up -d` brings the service up; (d) redeploy: repoints only the image
  line in the staged `/srv/cnt/compose.yaml` and brings the service up; (e) first-deploy route
  activation: `docker exec caddy caddy validate` + dated reload through the update window (the
  #29 ordering: after the service is up); redeploy reloads nothing; (f) prints the deployment
  record — tag, full commit hash, image ID, date — as its final output.
- **RED:** the script does not exist; `/srv/cnt/compose.yaml` absent; `/cnt/` unreachable.
- **GREEN:** write and commit the script; execute it against the staged config on vhost-58.
- **Instrument:** recorded deploy run (the script's own output capture) + probe capture:
  `https://dev.cherokeedictionary.net/cnt` → 302 → `/cnt/` → 200, and a sampled verse HTML + PNG
  checksummed against the manifest — under `.issues/11/research/`.

### Item 4 — the deployment record (SC-4)

- **Deliverable:** the deployment record artifact — the deploy run's recorded output (tag ↔
  commit hash, image ID, date) stored as a dated capture under `.issues/11/research/`.
- **RED:** no record exists.
- **GREEN:** store the capture produced by Item 3's execution.
- **Instrument:** artifact parse of the record — the three fields present and mutually consistent
  (tag embeds the commit hash; image ID matches `docker image inspect`).

### Item 5 — evidence set completeness (SC-5)

- **Deliverable:** the dated capture set under `.issues/11/research/` covering every instrument
  output from Items 1–4, in the probe-SOP family form.
- **RED:** the folder does not exist.
- **GREEN:** the captures from Items 1–4 land there, header-complete.
- **Instrument:** artifact existence + completeness parse (every SC's instrument output present
  and datemarked).

### Item 6 — the PR (SC-6)

- **Deliverable:** one open PR against `master` from `feature/CNT-11-self-deploy-tooling`,
  carrying the squashed work commit; no agent merge.
- **RED:** no PR exists for the branch.
- **GREEN:** push the branch, open the PR with summary + executed-test evidence, halt for human merge.
- **Instrument:** `gh pr view` shows one open PR against `master`.
