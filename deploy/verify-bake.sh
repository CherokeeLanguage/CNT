#!/bin/sh
# verify-bake.sh — verify the BAKED served tree inside the image build against
# CNT#9's committed served-tree manifest (cntdata/served-tree-manifest.md5).
#
# The manifest's served names map directly onto the baked flat tree: every
# line is "md5  served-name" and the baked tree carries each served-name at
# the tree root (the tarball members extracted flat plus website.tar.gz
# itself at the root). Exits non-zero on any absence, mismatch, or count
# discrepancy — a failure inside the build aborts the build, so no image tag
# is produced from a divergent tree.
#
# Usage: verify-bake.sh <baked-tree-root> <manifest>
set -eu

root="$1"
manifest="$2"

[ -f "$manifest" ] || { echo "FATAL: manifest missing: $manifest" >&2; exit 1; }
[ -d "$root" ] || { echo "FATAL: baked root missing: $root" >&2; exit 1; }

total=0; matched=0; failed=0
while read -r want name; do
  [ -n "$name" ] || continue
  total=$((total + 1))
  if [ ! -f "$root/$name" ]; then
    echo "MISS: $name" >&2
    failed=$((failed + 1))
    continue
  fi
  got=$(md5sum "$root/$name" | cut -d' ' -f1)
  if [ "$got" = "$want" ]; then
    matched=$((matched + 1))
  else
    echo "MISMATCH: $name want=$want got=$got" >&2
    failed=$((failed + 1))
  fi
done < "$manifest"

echo "bake verification: $matched/$total matched"
if [ "$failed" -ne 0 ]; then
  echo "FATAL: $failed manifest entries failed (absent or mismatched)" >&2
  exit 1
fi
if [ "$total" -eq 0 ]; then
  echo "FATAL: manifest is empty" >&2
  exit 1
fi
