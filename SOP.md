# SOP — the cnt-web container (CNT)

The Cherokee New Testament static product's containerized serving form:
the `/cnt` route on the delivered stack (the baked `cnt-web:<commit>`
image; the devops#29 slot staging / CNT#11 self-deployment seam). This
file is the container's operating index — the procedures live in the
artifacts that execute them.

## Host roles (2026-11-09, operator directive — CNT#17)

- **vhost-58.cherokeedictionary.net (104.251.216.58)** — the **prod
  host**: the delivered Docker serving stack this container deploys onto
  (the `/cnt` route through the update window; devops#29 staged the slot,
  CNT#11 delivered self-deployment).
- **vhost-175.cherokeedictionary.net (63.142.255.175, = ced1)** — the
  **dev host**: where dev-stack work lands going forward.
- Org-side fact record: cherokeelanguage-devops
  `docs/infrastructure/host-roles-vhost-58-vhost-175.md`.

## Deploy

`deploy/deploy-cnt-web.sh` — from a clean checkout of this repository at
the pinned content commit: builds `cnt-web:<commit>` via
`deploy/Dockerfile` (the in-build manifest gate must pass or no tag is
produced), first-deploys through devops#29's staged slot script
(`CNT_IMAGE=cnt-web:<commit>`, route activation rides the update window)
or redeploys by repointing only the slot's image line, and appends the
dated deployment record to `deploy/deployment-record.txt`. No env
delivery, no secrets, no volume mounts — the tree is baked into the
image. The tracked tree is the published state (reconciled in CNT#13).

## Switchover (blue-green, zero connection loss) — SoP (2026-11-09, CNT#19)

Every cnt-web redeploy runs the blue-green switchover: at no point is there a
moment without a healthy `/cnt` upstream behind Caddy. This is the
static-image class instance of the org runbook of record
(cherokeelanguage-devops#42, `docs/runbooks/container-switchover-vhost-58.md`)
— the sequence below conforms to it. Continuity bar: a request loop through
the edge across the whole flip window (≤1 s interval) reports **zero failed
requests**. The sequence is an operator-executed wrap around
`deploy/deploy-cnt-web.sh` (the script has no first-class blue-green mode; its
redeploy path is the sequence's canonical-recreate step — see the mapping
below).

1. **Stage alongside.** From the checkout at the new pinned commit, build
   `cnt-web:<new-commit>` (the in-build manifest gate must pass) and boot
   `cnt-next` — same networks as the slot's compose, no env, no secrets, no
   volumes (the tree is baked into the image), no host ports: zero conflict
   by design.
   `docker run -d --name cnt-next --network <slot-network> cnt-web:<new-commit>`
2. **Health gate** (static class — no boot marker): HTTP-200 content check
   against the next container directly, on a known baked path, e.g.
   `curl -fsS http://<cnt-next-ip>:80/01.html`.
3. **Direct-serve verify.** Confirm the served content is the new tree's.
4. **Atomic flip.** Edit the `/cnt` handle block's `reverse_proxy cnt:80`
   token to `cnt-next:80` in `/srv/caddy/caddy/Caddyfile`;
   `docker exec caddy caddy validate --config /etc/caddy/Caddyfile` must exit
   0, then `docker exec caddy caddy reload --config /etc/caddy/Caddyfile` —
   the graceful reload preserves in-flight requests.
5. **Canonical recreate.** Run `deploy/deploy-cnt-web.sh`'s redeploy path at
   the new pinned commit (image-line repoint + `up -d` recreates `cnt`).
   Traffic is on `cnt-next` throughout; routing is untouched.
6. **Flip back.** Repoint the Caddyfile token to `cnt:80`; `caddy validate`
   exit 0, graceful reload.
7. **Drain.** `docker rm -f cnt-next` — the spare serves nothing by then.
8. **Full gate.** The `/cnt` route's content checks through the edge
   (devops#29's probe).

**Rollback rule.** The `cnt-web:<commit>` pinned-tag convention gives exact
rollback: repoint back to the prior pinned tag (the slot's image line or the
Caddyfile token, per where the failure sits) and recreate. The prior image is
retained until the full gate passes. Never manual server surgery.

**Deploy-script mapping.** The script's redeploy path (repoint-only image
line → `up -d`) is the sequence's canonical-recreate step; the first-deploy
path is unchanged (route activation rides the update window per CNT#11 — no
flip applies to a first deploy). Any deploy executed under this SoP appends
the switchover's flip evidence line to the dated deployment record:
flip-out and flip-back timestamps and the continuity loop's result (zero
failed requests).

## Logging (2026-11-10, devops#48)

- **Log mirror:** `/var/log/containers/cnt/current.log` on vhost-58 — the
  `vector` stream shipper (cherokeelanguage-devops#48) captures the
  container's stdout/stderr verbatim, one event per line; the mirror
  persists across container recreation and daily rotation (30-day history,
  dated copies).
- **Contract:** console-first — stdout/stderr stream capture needs no
  per-repo configuration; a future file-based log instrument must mount
  under the `/var/log/containers/` tree to inherit the rotation.
- **Runbook of record:** cherokeelanguage-devops
  `docs/runbooks/logging-vhost-58.md` (cherokeelanguage-devops#48) —
  deploy, probe, and rollback live there.

🤖 Co-authored with AI: OpenCode (huggingface/zai-org/GLM-5.3-Flash)
