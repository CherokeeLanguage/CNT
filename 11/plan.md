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
- **RED:** a divergent-tree build produces a tag — executed before Item 1's GREEN, using a
  throwaway gate-less reference Dockerfile (scratch-only, never committed: extract + tag, no
  verification) over a scratch build context whose `website.tar.gz` carries one tampered member,
  tagged with a scratch-only reference (`cnt-web-red:<commit>` — a namespace the committed
  definition never uses, so the tag is independently inspectable); it succeeds and lands the
  tag, which the spec forbids; the scratch tag is removed from the host after the RED capture.
- **GREEN:** Item 1's gate in place, execute the divergent build again — the tampered scratch
  context now assembled to carry everything the committed definition consumes (the tampered
  `cntdata/website.tar.gz`, the manifest, `deploy/verify-bake.sh`, `deploy/Caddyfile`) — through
  the committed `deploy/Dockerfile`. Capture: the build's non-zero exit with the gate's own
  comparison output reporting the mismatch (not a COPY/stage error — the discriminator against
  any other build failure), a pre/post `docker images` diff showing no new tag of any name, and
  the legitimate `cnt-web:<commit>` image ID unchanged (a gate-less divergent run would have
  clobbered it).
- **Instrument:** executed divergent-build capture (non-zero exit; `docker image inspect` on the
  tag fails) under `.issues/11/research/`.

### Item 3 — the deploy tooling and its deployment record (SC-3, SC-4)

- **Deliverable:** `deploy/deploy-cnt-web.sh` — runs on vhost-58 from a checkout at the pinned
  commit: (a) records the pinned commit; (b) builds the image (`cnt-web:<commit>`, image ID
  captured); (c) first deploy: invokes the staged host config script (path parameter, default the
  host's staged copy) with `CNT_IMAGE=cnt-web:<commit>` — the slot's image line is that pinned
  reference; `docker compose up -d` brings the service up; (d) redeploy: repoints only the image
  line in the staged `/srv/cnt/compose.yaml` and brings the service up; (e) first-deploy route
  activation: `docker exec caddy caddy validate` + dated reload through the update window (the
  #29 ordering: after the service is up); redeploy reloads nothing; (f) writes the deployment
  record as a dedicated artifact (`deploy/deployment-record.txt` on the host run, captured into
  `.issues/11/research/`): tag, full commit hash, image ID, date — one line per field.
- **RED:** the script does not exist; `/srv/cnt/compose.yaml` absent; `/cnt/` unreachable.
- **GREEN:** write and commit the script; execute it against the staged config on vhost-58.
- **Instrument:** recorded deploy run (the script's own output capture) + probe capture:
  `https://dev.cherokeedictionary.net/cnt` → 302 → `/cnt/` → 200, and a sampled verse HTML + PNG
  checksummed against the manifest — under `.issues/11/research/`; the deployment record parse
  (tag embeds the commit hash; image ID matches `docker image inspect`; date present) runs over
  the record artifact the run produced.

### Item 4 — evidence set completeness (SC-5)

- **Deliverable:** the executed completeness check over the capture set: every instrument output
  from Items 1–3 present and datemarked in `.issues/11/research/` (capture location and form per
  the Conventions clause; SC-6's `gh pr view` output is Item 5's own and is out of this check's
  scope). The verifiable act is the check itself; its result is recorded in the issue's
  validation record.
- **RED:** the check run with a deliberately incomplete expectation — the check's expected-capture
  manifest is authored first and names a capture entry that does not yet exist (the Item 5 PR
  evidence), so the first execution fails on that named entry, demonstrating the check can fail.
- **GREEN:** the injected out-of-scope entry is removed from the expectation after the RED
  capture (the manifest then names exactly the Items 1–3 captures), and the check executes over
  those in-place captures — all present and datemarked; the check passes.
- **Instrument:** artifact existence + completeness parse (Items 1–3's outputs present and
  datemarked; absence of any one is a failure).

### Item 5 — the PR (SC-6)

- **Deliverable:** one open PR against `master` from `feature/CNT-11-self-deploy-tooling`,
  carrying the squashed work commit; no agent merge.
- **RED:** no PR exists for the branch.
- **GREEN:** push the branch, open the PR with summary + executed-test evidence, halt for human merge.
- **Instrument:** `gh pr view` shows one open PR against `master`.
