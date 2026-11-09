# Plan — CNT#19: cnt-web switchover SoP section in SOP.md

Spec: `.issues/19/spec.md`. Single deliverable
surface: `SOP.md` — one new section. No script change in this ticket.

## Open-item decision (spec "Open items", decided here per the spec)

`deploy/deploy-cnt-web.sh` gains **no** first-class blue-green mode in this
ticket. The switchover sequence stays an **operator-executed wrap** around the
script's redeploy path: the script's repoint+up remains the canonical-recreate
step's tooling, and the SOP.md section documents the full operator sequence
(stage alongside → gate → flip → recreate → flip back → drain → gate) the
operator runs around it. Grounds: the spec's Scope states "No script change in
this ticket"; a script change would also be a behavior change to a delivered
deployment seam (CNT#11) beyond this ticket's blast radius ("one documentation
file").

## Dependency note

The org runbook the section conforms to is cherokeelanguage-devops#42 — at
plan time that ticket is an approved-for-work spec (sequence fully recorded in
its spec body: 8-step blue-green, continuity bar, per-class rollback); its
runbook file is not yet on devops trunk. The section is written against the
recorded sequence and names devops#42; if the merged runbook diverges in
naming, a one-line reconciliation edit lands with the diverging change.

## Item 1 — SOP.md switchover section (SC-1, SC-2)

- **Deliverable:** one new `## Switchover (blue-green, zero connection loss)`
  section in `SOP.md`, carrying every R-1 element (cnt-next alongside with
  slot's compose networks, no env/secrets/volumes/host ports; HTTP-200 content
  health gate on a known baked path; direct-serve verify; atomic Caddy flip of
  `reverse_proxy cnt:80` → `cnt-next:80` in `/srv/caddy/caddy/Caddyfile` with
  `caddy validate` exit 0 then graceful reload; canonical `cnt` recreation
  with `cnt-web:<commit>`; flip back; drain; full gate), R-2 (continuity bar —
  edge request loop, zero failed requests; rollback = repoint to the prior
  pinned tag, prior image retained until the full gate passes), and R-3 (the
  mapping onto `deploy-cnt-web.sh`'s redeploy path; the deployment record
  gains the switchover's flip evidence line for SoP-executed deploys).
- **RED:** `grep -c "Switchover" SOP.md` → 0 (section absent; criterion
  unmet against current file).
- **GREEN:** add the section per R-1/R-2/R-3, in the file's existing voice and
  structure (facts-dense prose/bullets, cross-references to the deploy
  section, byline footer untouched).
- **Instrument:** file parse against an R-1/R-2/R-3 element checklist — each
  element located in the section text by grep with line output; every element
  present = pass.

## Item 2 — SC-3 disposition (not an implementation item)

SC-3 (first SoP-executed redeploy's continuity capture on the issue) is
pending work by the spec's own form: it is an executed operational event on
the prod host, not implementable in a branch and not executable without
explicit developer instruction (production access). No RED/GREEN item is
authored for it. It rides the first redeploy executed under the SoP after
merge; the PR body and the issue record state this pending form.
