#!/bin/bash
# deploy-cnt-web.sh — build and deploy the CNT product's static image onto
# the vhost-58 stack (CNT#11: product self-deployment; the #29/#CNT#11 seam
# contract). Runs ON the host from a checkout of this repository at the
# pinned content commit (the bytes the image bakes).
#
# What it does:
#   1. records the pinned commit (git HEAD; the tracked tree must be clean)
#   2. builds cnt-web:<commit> via deploy/Dockerfile — the in-build manifest
#      gate must pass or no tag is produced
#   3. first deploy (no /srv/cnt/compose.yaml): invokes devops#29's staged
#      host-config script (STAGE_SCRIPT, default /srv/cnt/cnt-vhost-58-stage.sh)
#      with CNT_IMAGE=cnt-web:<commit> — the slot's image line is that pinned
#      reference — then brings the service up; route activation rides the
#      #29 update window (caddy validate + dated reload, after the service
#      is up)
#      redeploy (compose.yaml present): repoints ONLY the image line to the
#      new pinned tag and brings the service up; routing is untouched and
#      nothing is reloaded
#   4. appends a dated deployment record (tag, commit hash, image ID, date)
#      to the record file
#
# No env delivery, no secrets, no volume mounts — the tree is baked in.
#
# Usage: deploy/deploy-cnt-web.sh [--stage-script PATH] [--record PATH]
set -euo pipefail

TREE=/srv/cnt
STAGE_SCRIPT=/srv/cnt/cnt-vhost-58-stage.sh
REPO=$(cd "$(dirname "$0")/.." && pwd)
RECORD="$REPO/deploy/deployment-record.txt"

while [ $# -gt 0 ]; do
  case "$1" in
    --stage-script) STAGE_SCRIPT="$2"; shift 2 ;;
    --record)       RECORD="$2"; shift 2 ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
done

# --- 1. pin the commit ---
cd "$REPO"
if [ -n "$(git status --porcelain --untracked-files=no)" ]; then
  echo "FATAL: tracked tree is not clean; deploy from a clean pinned checkout" >&2
  exit 1
fi
COMMIT=$(git rev-parse HEAD)
TAG="cnt-web:$COMMIT"
echo "pinned commit: $COMMIT"

# --- 2. build (the manifest gate is inside the build) ---
echo "building $TAG ..."
docker build -t "$TAG" -f deploy/Dockerfile .
IMG_ID=$(docker image inspect -f '{{.Id}}' "$TAG")
echo "image id: $IMG_ID"

# --- 3. slot: stage or repoint ---
FIRST_DEPLOY=0
if [ ! -f "$TREE/compose.yaml" ]; then
  FIRST_DEPLOY=1
  echo "first deploy: staging the host config (devops#29 source of truth)"
  [ -f "$STAGE_SCRIPT" ] || { echo "FATAL: stage script not found: $STAGE_SCRIPT" >&2; exit 1; }
  CNT_IMAGE="$TAG" bash "$STAGE_SCRIPT"
else
  echo "redeploy: repointing the slot's image line (routing untouched)"
  sed -i -E "s|^(\s*image:).*|\1 $TAG|" "$TREE/compose.yaml"
  docker compose -f "$TREE/compose.yaml" config >/dev/null && echo "compose: parses"
fi
docker compose -f "$TREE/compose.yaml" up -d
sleep 2
STATE=$(docker inspect cnt --format '{{.State.Status}}')
echo "cnt service: $STATE"
[ "$STATE" = "running" ] || { echo "FATAL: cnt service not running" >&2; exit 1; }

# --- first-deploy route activation: the #29 update window ---
if [ "$FIRST_DEPLOY" -eq 1 ]; then
  echo "update window: validating and reloading Caddy ($(date -u +%Y-%m-%dT%H:%M:%SZ))"
  docker exec caddy caddy validate --config /etc/caddy/Caddyfile >/dev/null
  docker exec caddy caddy reload --config /etc/caddy/Caddyfile >/dev/null
  echo "route activated through the update window"
else
  echo "redeploy: no reload — routing unchanged"
fi

# --- 4. the deployment record ---
cat >> "$RECORD" <<EOF

## deployment $(date -u +%Y-%m-%dT%H:%M:%SZ)

- image tag: $TAG
- CNT content commit: $COMMIT
- image content identity: $IMG_ID
- deploy mode: $([ "$FIRST_DEPLOY" -eq 1 ] && echo "first deploy (slot staged + route activated through the update window)" || echo "redeploy (slot image line repointed, routing untouched)")
EOF
echo "--- deployment record ---"
cat "$RECORD"
