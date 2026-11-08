# Served-tree manifest — the /cnt deployment artifact of record

This repository is the verified archive of record for the served `/cnt`
tree (Cherokee New Testament webapp). The deployment is **flat**: every
file sits in one directory on the web server. The repository, by contrast,
splits the same content across `cnt/` and `cntdata/`, tied together by a
name key. The manifest `cntdata/served-tree-manifest.md5` records the
served tree's byte-level truth as md5s computed **from this repo's tracked
bytes only** — never from the server — so the deployment's integrity can be
proven locally, without access to the retired host.

## The manifest

- Path: `cntdata/served-tree-manifest.md5`
- Format: `md5sum` — one line per served file, `<md5>  <served-name>`
- Coverage: exactly the 8,561-entry served universe:
  - 8,272 page scans (`BBCCVV.png`, the `BBCC00.png` chapter-heading
    crops, and the `BB_.png` book-header strips)
  - 28 top-level HTMLs (`01.html`–`27.html`, `index.html`)
  - 260 chapter HTMLs (`BBCC.html`)
  - `website.tar.gz` (the tarball of the served tree itself; its 8,560
    extracted members are the other entries)

## Name-mapping rule (served name → repo path)

| Served name | Repo path |
|---|---|
| `BBCCVV.png` (BB=book 01–27, CC=chapter, VV=verse) | `cnt/BBCCVV.png` |
| `BB_.png` (book-header images, 27 files) | `cnt/BB_.png` |
| `BB.html` (01–27), `index.html` | `cnt/<name>` |
| `BBCC.html` (chapter pages) | `cntdata/BBCC.html` |
| `website.tar.gz` | `cntdata/website.tar.gz` |

## Verification

Run `tools/verify-served-tree.sh` against any checkout (default: its own
repository root; pass an alternate repo root as argument 1 for a fresh
clone). It verifies every manifest entry against the repo file at its
mapped path — for `website.tar.gz`, against the tarball **and** every
extracted member's md5 in a temp directory — prints `8561/8561 matched`
plus the tree→manifest orphan sweep's `orphans: 0` line,
and exits 0 only on a full match with zero orphans. Any mismatch, absence,
mapping-rule violation, or orphan exits non-zero.

## Provenance

The manifest's authority derives from the byte-level sync delivered by
CNT#3 (merged 2026-11-04, PR #4) and re-verified against the live source
on 2026-11-04: the full 8,553-file deployed manifest over SSH
(`/opt/tomcat/webapps/cnt`) md5-matched the repo tree 8,553/8,553, and a
live sample fetched over `https://cherokeedictionary.net/cnt/` matched
byte-for-byte. The consuming deployment (cherokeelanguage-devops#29)
cites this manifest and its repo paths as its content-provenance record.

🤖 Co-authored with AI: OpenCode (huggingface/zai-org/GLM-5.3-Flash)
