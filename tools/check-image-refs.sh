#!/bin/sh
# check-image-refs.sh — reference-integrity instrument for the served /cnt tree.
#
# Enumerates every double-quoted .png reference (src=/href=) in the served
# tree's HTML pages and reports each referenced-but-missing file with its
# referrer pages. Exits 0 when every reference resolves.
#
# tier: pr-validation — CNT#14 ticket validation (CNT#14 R5/SC-2);
# dispositioned at merge per the test-discipline card.
#
# usage: check-image-refs.sh [served-tree-root]     (default: cnt)
set -eu

root=${1:-cnt}
[ -d "$root" ] || { echo "FATAL: served-tree root '$root' not found" >&2; exit 2; }

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
broken=0

for f in "$root"/*.html; do
    page=$(basename "$f" .html)
    for ref in $(grep -o '"[^"]*\.png"' "$f" | tr -d '"' | sort -u); do
        if [ ! -f "$root/$ref" ]; then
            printf '%s %s\n' "$ref" "$page" >> "$tmp"
            broken=$((broken + 1))
        fi
    done
done

if [ "$broken" -gt 0 ]; then
    sort "$tmp" | awk '{a[$1]=a[$1]" "$2} END {for (r in a) print r" ->"a[r]}' | sort
fi
printf 'broken references: %d\n' "$broken"
[ "$broken" -eq 0 ]
