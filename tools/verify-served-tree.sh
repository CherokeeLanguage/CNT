#!/usr/bin/env bash
# verify-served-tree.sh — verify the served /cnt tree manifest against this
# repository's tracked bytes.
#
# The manifest (cntdata/served-tree-manifest.md5) is the deployment artifact
# of record for the flat /cnt served tree. Each line is "md5  served-name";
# the served name maps to its repo path by the rule documented in
# docs/SERVED-TREE.md:
#   BBCCVV.png      -> cnt/BBCCVV.png
#   BB.html (01-27), index.html -> cnt/<name>
#   BBCC.html       -> cntdata/BBCC.html
#   website.tar.gz  -> cntdata/website.tar.gz
#
# For website.tar.gz the script additionally extracts the tarball to a temp
# directory and verifies every extracted member's md5 against the manifest.
# Exits non-zero on any mismatch, absence, or count discrepancy.
#
# Usage: tools/verify-served-tree.sh [repo-root]   (default: script's repo)
set -euo pipefail

root="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
manifest="$root/cntdata/served-tree-manifest.md5"
tarball="$root/cntdata/website.tar.gz"

if [ ! -f "$manifest" ]; then echo "FATAL: manifest missing: $manifest" >&2; exit 1; fi
if [ ! -f "$tarball" ]; then echo "FATAL: tarball missing: $tarball" >&2; exit 1; fi

md5_of() { md5sum "$1" | cut -d' ' -f1; }

total=0; matched=0; failed=0
fail() { echo "MISMATCH: $*" >&2; failed=$((failed+1)); }

map_repo_path() {
  local n="$1"
  case "$n" in
    *.png)              echo "cnt/$n" ;;
    [0-9][0-9].html|index.html) echo "cnt/$n" ;;
    [0-9][0-9][0-9][0-9].html)  echo "cntdata/$n" ;;
    website.tar.gz)     echo "cntdata/website.tar.gz" ;;
    *)                  echo "" ;;
  esac
}

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

while read -r hash name; do
  [ -n "$name" ] || continue
  total=$((total+1))
  repo="$(map_repo_path "$name")"
  if [ -z "$repo" ]; then fail "$name does not match the mapping rule"; continue; fi
  if [ ! -f "$root/$repo" ]; then fail "$name -> $repo absent"; continue; fi
  if [ "$(md5_of "$root/$repo")" != "$hash" ]; then fail "$name -> $repo md5 mismatch"; continue; fi
  matched=$((matched+1))
  if [ "$name" = "website.tar.gz" ]; then
    tar -xzf "$root/$repo" -C "$tmp"
    while read -r thash tname; do
      [ "$tname" = "website.tar.gz" ] && continue
      if [ ! -f "$tmp/$tname" ]; then fail "tarball member $tname absent after extraction"; continue; fi
      if [ "$(md5_of "$tmp/$tname")" != "$thash" ]; then fail "tarball member $tname md5 mismatch"; fi
    done < "$manifest"
  fi
done < "$manifest"

echo "$matched/$total matched"

# tree→manifest sweep (additive, CNT#14 R4): every served-surface file must
# carry a manifest entry. Scope = the served surfaces per the mapping rule:
# all of cnt/ (published tree), cntdata/'s four-digit chapter HTMLs, and the
# committed tarball. cntdata/ holds ~15,900 non-served files (verse-level
# data, auxiliary working files) that an unscoped walk would falsely flag.
sweep_files="$(mktemp)"
{
  find "$root/cnt" -maxdepth 1 -type f -printf '%f\n'
  for f in "$root"/cntdata/[0-9][0-9][0-9][0-9].html; do [ -e "$f" ] && basename "$f"; done
  echo "website.tar.gz"
} | LC_ALL=C sort -u > "$sweep_files"
awk '{print $2}' "$manifest" | LC_ALL=C sort -u > "$tmp/manifest-names"
orphans=$(LC_ALL=C comm -23 "$sweep_files" "$tmp/manifest-names" | wc -l)
if [ "$orphans" -gt 0 ]; then
  LC_ALL=C comm -23 "$sweep_files" "$tmp/manifest-names" | sed 's/^/orphan: /'
fi
rm -f "$sweep_files"
echo "orphans: $orphans"

if [ "$failed" -ne 0 ] || [ "$matched" -ne "$total" ] || [ "$orphans" -ne 0 ]; then
  echo "FAILED: $failed mismatch(es)/absence(s), $orphans orphan(s)" >&2
  exit 1
fi
echo "OK: served-tree manifest verified"
