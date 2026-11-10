# Plan — CNT#23

Source: .issues/23/spec.md (CNT#23).

## Item 1 — SOP.md gains the container-check section (R-1 / SC-1)
- GREEN: a "Container checks (pre-flight/post-flight)" section in SOP.md states
  when the check runs in this repo's deploy flow (pre-flight exit-0 before any
  deploy/container-work step; post-flight re-run after it), the exit-0 gate
  semantics, capture-with-work, and links the devops master page
  (docs/runbooks/container-sop-checks.md) without restating definitions.
- Content-read verification.

## Item 2 — inventory statement (R-2 / SC-2)
- GREEN: the section states the inventory — `cnt` static file server behind the
  `/cnt` route (with its legacy 302) on cherokeedictionary.net — and the live
  comparison evidence (edge-level: `/cnt/` 200 non-empty, body in the Cherokee
  New Testament family; legacy `/cnt` 302) captured in this session.
- Gap to record: host-side container-Up state not verifiable from this session
  (no SSH to vhost-58 configured).

## Verification
- execute structural content read (SC-1/SC-2); record live curl output; then
  fresh-context verify; then git-workflow-pr.
