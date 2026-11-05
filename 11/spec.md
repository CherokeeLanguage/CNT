<!-- SPDX-FileCopyrightText: 2026 Michael Conrad -->
<!-- SPDX-License-Identifier: MIT -->

# Spec — Product self-deployment on the vhost-58 stack: image build + deploy tooling (the /cnt static image) (CNT#11)

## Problem

The repository is the single source of truth for the served `/cnt` tree —
CNT#3 (merged, PR #4, 2026-11-04) reconciled it to the deployed state and
CNT#9 (merged, PR #10, 2026-11-04) committed the served-tree manifest and
its verification instrument — but the product has no deployment path onto
the replacement stack: nothing turns this repo's tracked bytes into the
running static file server on vhost-58. The consuming stack spec
(cherokeelanguage-devops#29) stages the host-side system config — the
compose service slot consuming a published image reference, the Caddyfile
route, the posture — and that spec's deployment leg is halt-gated on this
product's published image, which does not exist.

Developer direction 2026-11-04 (separation of concerns): devops sets up the
host system config; the product self-deploys as needed. This spec is the
product side of that split: the deploy tooling lives in this repository,
builds the image from the tracked bytes, and deploys it onto the stack
without requiring devops-side work per deployment.

## Dependency position

- **Blocks:** cherokeelanguage-devops#29's deployment leg (service up, route
  activation through the update window, dev-tier verification) — that
  spec's R-8 sequences the leg on this product's published image; the
  host-config staging there proceeds independently.
- **Depends on:** CNT#3 (delivered — the repo is the verified archive of
  record); CNT#9 (delivered — the manifest `cntdata/served-tree-manifest.md5`
  and `tools/verify-served-tree.sh` this build gates on).
- **Sequenced by:** devops#29's staged host config for the deploy execution
  — the compose service slot must exist before this spec's deploy tooling
  can bring the service up into it; the build and tag legs proceed
  independently of #29's state.
- **The seam contract** (recorded by devops#29's separation-of-concerns
  dependency; this spec implements the producing side): the consumed image
  carries the baked served tree — the full 8,553-file universe of CNT#9's
  manifest (the extracted `website.tar.gz` members plus the tarball itself
  at the tree root) — no volume mounts, no env, no secrets, published at a
  pinned tag carrying the CNT content commit hash as its provenance,
  serving the tree over internal HTTP :80 reachable from Caddy over the
  `proxy` network; redeploys swap the tag with no routing change.
- Boundary discipline: this spec directs work ONLY in this repository (plus
  the execution of its own tooling against the vhost-58 host). The
  host-side system config is devops#29's scope entirely; this spec neither
  directs nor modifies any of it.

## Facts (verified this pass)

- The served universe is 8,553 files: the 8,552 members extracted from
  `cntdata/website.tar.gz` (8,264 PNGs + 28 top-level + 260 chapter HTMLs)
  plus the tarball itself at the tree root — `tools/verify-served-tree.sh`
  over a fresh `master` checkout prints 8,553/8,553 and exits 0 (executed
  in the devops#29 round-7 validation, 2026-11-05 UTC).
- The repo's layout is split (`cnt/` scans, `cntdata/` text/HTML) — an
  archive convention; the served shape is the tarball extraction, never the
  repo directories as-is.
- The stack consumes images two ways today: pinned upstream pulls
  (`caddy:2.11.7`) and host-local builds (`aqv:1.1.0`, built on the host —
  devops#13's delivered pattern). No private registry exists on the stack;
  no org registry-publish precedent is established.
- vhost-58 carries the Docker engine + compose + buildx (devops#10
  delivered) with established outbound HTTPS reachability to upstream image
  registries.

## Scope

- **Image build:** a committed image build in this repository (Dockerfile +
  baked file-server config under `deploy/`) producing a pinned static
  file-server image carrying the full 8,553-file served universe, with the
  manifest comparison executed inside the build before tagging — a mismatch
  fails the build and no tag is produced.
- **Deploy tooling:** a committed deploy script in this repository that
  takes a built image to the running service on vhost-58 through
  devops#29's staged host config — the repo's bytes at the pinned commit,
  build, tag, slot repoint + service up — re-runnable as needed; a redeploy
  is the same path at a new pinned tag with no routing change.
- **Provenance:** the tag ↔ commit-hash mapping and the image's content
  identity (image ID for a host-local build; registry digest under a
  registry mechanism) recorded per deployment — the deployment record.
- **Evidence:** dated captures under this store's `.issues/{N}/research/`
  in the standing probe-SOP family form (executing account in each capture
  header, marker-labeled sections).

## Requirements

- **R1** — The image build SHALL bake the full 8,553-file served universe —
  the `cntdata/website.tar.gz` members extracted at the tree root plus the
  tarball itself placed at the tree root — from the repo's tracked bytes at
  a pinned content commit, serving the tree over internal HTTP :80, and
  SHALL verify the bake against CNT#9's committed manifest inside the build
  before the image is tagged (8,553/8,553, `tools/verify-served-tree.sh`
  semantics); a comparison failure SHALL fail the build and produce no tag.
- **R2** — The image SHALL be tagged content-addressed to the CNT content
  commit (the commit hash is the provenance record); the deployed reference
  SHALL be pinned, with the tag and the image's content identity recorded
  at first acquisition.
- **R3** — The deploy tooling SHALL deploy through devops#29's staged host
  config without requiring any devops-repo change per deployment: the
  slot's image line repoints to the new pinned tag and the service comes
  up; routing, posture, and the rest of the slot definition stay untouched.
- **R4** — The image and the tooling SHALL deliver no env, no secrets, no
  volumes, no host-state mounts — the tree is baked into the image.
- **R5** — The deploy path SHALL be self-contained in this repository: the
  tooling required to build and deploy is committed here, and its execution
  requires no artifact from the devops repository beyond #29's
  already-staged host config.
- **R6** — The work lands on a feature branch as PR(s) against `master`
  per the deck's git-workflow cards; the agent performs no merge.

## Success criteria

| ID | Criterion | Class | Instrument |
|---|---|---|---|
| SC-1 | A clean build of the committed image definition executes the in-build manifest comparison and records 8,553/8,553 before tagging; the image is tagged content-addressed to the build commit | structural | executed build capture (comparison output + tag) |
| SC-2 | A build over a divergent tree fails before tagging (the gate gates): non-zero build, no image tag produced | structural | executed divergent-build capture |
| SC-3 | Executing the deploy tooling against devops#29's staged slot brings the service up, and `/cnt/` serves 200 through the dev-hostname edge tier (bare `/cnt` → 302 → `/cnt/`, #29's route) — sequenced on #29's staged host config | behavioral | recorded deploy run + probe capture |
| SC-4 | The deployment record carries the provenance: tag ↔ CNT commit hash, image content identity, date | structural | artifact parse of the deployment record |
| SC-5 | Dated captures from the runs sit under `.issues/{N}/research/` in the standing probe-SOP family form (executing account in each capture header, marker-labeled sections) | structural | artifact existence + completeness parse |
| SC-6 | One open PR against `master`; no agent merge | structural | `gh pr view` |

## Impact

Consumers: devops#29's deployment leg (this spec's published image unblocks
it), the `/cnt` serving surface and every inbound link to
`cherokeedictionary.net/cnt/...` downstream of it, and the dictionary nav's
`/cnt` item (devops-side #136) downstream of #29's delivery. Sibling
tickets: CNT#3 and CNT#9 (delivered inputs), devops#29 (the seam spec — its
host config is this tooling's deployment target). Blast radius: repo-local
tooling + one image; deployments touch only #29's staged slot (image line +
service state); no apex/DNS involvement. The repository's self-description
(`AGENTS.md`'s "data-only archive" statement) gains the deployment-tooling
fact when this lands. Rollback: redeploying the prior pinned tag through
the same tooling restores the prior content state.

## Out of scope

- Any change to the archive data (`cnt/`, `cntdata/` content) — the build
  consumes tracked bytes and changes none.
- Regenerating or re-bundling `website.tar.gz` (CNT#9's boundary holds).
- Content authoring or regeneration (CNT-diglot and friends).
- The CherokeeNewTestament.org Zola site (separate host, separate concern).
- Any host-side system config — devops#29's scope (compose slot, Caddyfile
  route, posture, activation mechanism, stack-side verification).
- CI-based publishing — the chosen path is operator-run tooling.

## Approach

- **Build:** the image base is `caddy:2.11.7` (the stack's pinned
  file-server-class image, already in the stack's trust set) with a minimal
  baked Caddyfile serving the tree over internal :80 — the container needs
  no TLS (the edge proxy terminates) and no published port. The build is
  multi-stage: extract the tarball into the served root, place the tarball
  at the root, run the manifest comparison in a build stage, and only on
  success produce the final tagged image. Alternatives weighed: nginx —
  different config dialect, no advantage over the already-pinned caddy;
  busybox httpd — thinner but off the stack's precedent.
- **Publish mechanism (the recorded decision):** host-side build from this
  repository's bytes on vhost-58 — the deploy script secures the tracked
  bytes at the pinned commit on the host (checkout/fetch or transferred
  bundle — the exact mechanism is the plan's record), builds, tags
  `cnt-web:<commit>`, repoints the slot's image line, and brings the
  service up. The registry-publish alternative is weighed and rejected for
  now: no stack precedent, a new credential surface, an external dependency
  at deploy time, and no second consumer to benefit; re-openable at
  developer direction. The host config devops#29 delivers is identical
  under either mechanism (its recorded seam statement).
- **Deploy:** the script re-runs per content update: new commit → new
  pinned tag → slot repoint + service up; rollback is the same path at the
  prior commit. The route activation rides devops#29's update-window
  mechanism (that spec's deliverable); the deploy tooling consumes it per
  the procedure that spec records.

## Traceability

The requirement source is the developer's 2026-11-04 direction (the CNT
repo contains its own deploy scripts for the new docker/caddy system; the
product self-deploys as needed) and the consuming stack spec's recorded
seam contract (devops#29's separation-of-concerns dependency). Every
requirement implements one side of that contract or the product-side
autonomy it names; the build-side manifest gate is CNT#9's instrument
applied as the producer's proof.

🤖 Co-authored with AI: OpenCode (huggingface/zai-org/GLM-5.3-Flash)
