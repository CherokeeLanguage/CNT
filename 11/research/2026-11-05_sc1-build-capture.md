# SC-1 capture — image build at the pinned commit, in-build manifest gate (CNT#11)

executing account: mconrad@vhost-58.cherokeedictionary.net (ssh, unprivileged)
date: 2026-11-05 UTC
pinned commit: 542341c44e3e727a18d597dec4dde9dfafc6b829 (feature branch tip; served-tree bytes identical to trunk c032281b)
command: docker build -t cnt-web:<commit> -f deploy/Dockerfile .

## marker: in-build manifest comparison output
#10 15.09 bake verification: 8553/8553 matched
#10 DONE 15.4s

## marker: tag produced
tag exists; image id: sha256:81f384a5d0cec1f429f1a08683e421558a846bd7862efd375fea50e67834772a

## marker: baked content spot-check (tree root + tarball + Caddyfile)
01.html
010000.png
0101.html
-rw-rw-r--    1 root     root           226 Nov  5 04:37 /etc/caddy/Caddyfile
-rw-rw-r--    1 root     root      69559190 Nov  5 04:36 /srv/website.tar.gz
