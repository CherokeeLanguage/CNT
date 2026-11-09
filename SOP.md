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

🤖 Co-authored with AI: OpenCode (huggingface/zai-org/GLM-5.3-Flash)
