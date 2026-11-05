# cnt image build — the CNT product's self-deployment artifact (CNT#11).
#
# Bakes the served /cnt tree from this repository's tracked bytes: the
# members of cntdata/website.tar.gz extracted flat at the tree root plus the
# tarball itself at the root — the full 8,553-file served universe of
# cntdata/served-tree-manifest.md5 — served over internal HTTP :80 by the
# stack's pinned file-server image (caddy:2.11.7; no TLS — the edge proxy
# terminates; no published port; no env; no volumes; no secrets).
#
# The manifest gate runs INSIDE the build (stage "bake"): a mismatch, an
# absent file, or a count discrepancy fails the build, and no image tag is
# produced from a divergent tree.
#
# Build (from a checkout at the pinned content commit):
#   docker build -t cnt-web:<commit> -f deploy/Dockerfile .
# Deploy: deploy/deploy-cnt-web.sh

FROM caddy:2.11.7 AS bake
WORKDIR /srv
COPY cntdata/website.tar.gz /srv/website.tar.gz
COPY cntdata/served-tree-manifest.md5 /tmp/served-tree-manifest.md5
COPY deploy/verify-bake.sh /tmp/verify-bake.sh
RUN tar -xzf /srv/website.tar.gz -C /srv \
 && sh /tmp/verify-bake.sh /srv /tmp/served-tree-manifest.md5

FROM caddy:2.11.7
COPY --from=bake /srv /srv
COPY deploy/Caddyfile /etc/caddy/Caddyfile
