# Plan — CNT#21 (SOP logging paradigm section)

Spec: `.issues/21/spec.md` (verified PASS round 2). Repo has no build/test
framework (data-only archive); the sole verification instrument is the spec's
own content read.

## Item 1 — SC-1 (structural): SOP.md Logging section

- **Deliverable:** a `## Logging` section in `SOP.md`, index voice, stating
  the three R-1 elements:
  1. the container's log mirror `/var/log/containers/cnt/current.log` on
     vhost-58 (prod host per the SOP's own host-roles section) — the
     `vector` stream shipper (cherokeelanguage-devops#48) captures
     stdout/stderr verbatim, one event per line, surviving recreation and
     daily rotation (30-day history, dated copies);
  2. the console-first contract in one line: stdout/stderr capture needs no
     per-repo config; a future file-based log instrument must mount under
     the `/var/log/containers/` tree to inherit the rotation;
  3. the org runbook of record: cherokeelanguage-devops
     `docs/runbooks/logging-vhost-58.md` (cherokeelanguage-devops#48) —
     deploy, probe, rollback live there.
- **RED:** `grep -i "logging\|/var/log/containers" SOP.md` returns nothing
  against the current `SOP.md` (verified 2026-11-10: no match).
- **GREEN:** add the section after the existing `## Switchover` section
  (placement follows the SOP's host-roles → deploy → switchover flow; one
  file touched, no other edits).
- **Instrument:** direct content read of the committed `SOP.md` (SC-1's
  stated instrument): `grep -n "/var/log/containers/cnt/current.log" SOP.md`
  (mirror path); `grep -n "console-first" SOP.md` (contract clause);
  `grep -n "logging-vhost-58" SOP.md` (runbook pointer) — each must match in
  the committed artifact, and a read of the section confirms the index voice.

Tier note: the instrument is a scratch structural check (ephemeral), not an
authored test — nothing to mark into any test file.
