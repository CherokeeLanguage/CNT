# SC-2 GREEN capture — divergent build through the committed gate (CNT#11)

executing account: mconrad@vhost-58.cherokeedictionary.net (ssh, unprivileged)
date: 2026-11-05 UTC
pinned commit: 542341c44e3e727a18d597dec4dde9dfafc6b829
context: scratch (never committed) — tampered cntdata/website.tar.gz (010000.png
one byte flipped at EOF; the tarball bytes differ, so its own manifest entry
mismatches too) + served-tree-manifest.md5 + deploy/{Dockerfile,verify-bake.sh,Caddyfile}

## marker: gate's own comparison output (the discriminator — not a COPY/stage error)
#10 1.160 MISMATCH: 010000.png want=832945e3e6bccc269e1e2c5546249722 got=44a92fb29bb154fbca32954ea5238117
#10 15.76 MISMATCH: website.tar.gz want=e41315255fe967650fe61bc48ebef404 got=6de34a252d6f4d0b8eea684aa1008e62
#10 15.76 FATAL: 2 manifest entries failed (absent or mismatched)
#10 15.76 bake verification: 8551/8553 matched
#10 ERROR: process "/bin/sh -c tar -xzf /srv/website.tar.gz -C /srv  && sh /tmp/verify-bake.sh /srv /tmp/served-tree-manifest.md5" did not complete successfully: exit code: 1

## marker: non-zero build
docker build exit code: 1

## marker: pre/post docker images diff — no new tag of any name
pre-build image list (cnt-*):  cnt-web:542341c4... 81f384a5d0ce
post-build image list (cnt-*): cnt-web:542341c4... 81f384a5d0ce   (unchanged; scratch tag absent)

## marker: legitimate tag image ID unchanged (a gate-less run would have clobbered it)
before: sha256:81f384a5d0cec1f429f1a08683e421558a846bd7862efd375fea50e67834772a
after:  sha256:81f384a5d0cec1f429f1a08683e421558a846bd7862efd375fea50e67834772a
IMAGE ID UNCHANGED: yes
