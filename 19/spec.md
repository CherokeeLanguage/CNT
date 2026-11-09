# Spec — cnt-web switchover SoP: zero-connection-loss image replacement behind Caddy

> Ticket CNT#19. The org-level SoP is cherokeelanguage-devops#42 (sibling ticket). This ticket puts the cnt-web container's own switchover procedure in this repository's SOP.md, conforming to the org runbook.

## Problem

`deploy/deploy-cnt-web.sh`'s redeploy path repoints the slot's image line and brings the service up — the `cnt` container is recreated in place, so the `/cnt` upstream is down for the recreate window (short for a static image, but nonzero: the old container stops before the new one binds). The org SoP (devops#42) makes zero-connection-loss switchover the standard for every container on the stack, with the blue-green sequence as the app-container class's procedure.

Developer directive (2026-11-09, to all container repos): the switchover-without-connection-issues procedure becomes SoP here too — "this needs to be a rule for *ALL* containers", with the goal shape stated as the executed blue-green sequence ("At no point is there a moment without a healthy upstream behind Caddy").

## Decision

**SOP.md gains the cnt-web switchover section** — the blue-green sequence adapted to the static image class, conforming to the org runbook (devops#42).

## Developer statements (traceability base)

1. "setting up the switch over without causing connection issues needs to become SoP in this repo and all the container repos. file specs as needed across all repos." (2026-11-09)
2. "this needs to be a rule for *ALL* containers" (2026-11-09, in-session clarification)
3. The blue-green goal shape stated by the developer (2026-11-09): boot alongside → health gate → atomic flip + graceful reload → canonical recreate → flip back → drain → full gate.

## Scope

- `SOP.md` — one new section (the switchover procedure for this container).
No script change in this ticket; the deploy-script integration question is R-3's recorded mapping plus the open item.

## Requirements

- **R-1** `SOP.md` SHALL carry the cnt-web switchover section — the blue-green sequence with this container's specifics: `cnt-next` alongside the serving container (same networks as the slot's compose; no env, no secrets, no volumes — the tree is baked into the image; no host ports), the health gate against the next container (an HTTP-200 content check on a known baked path — static class, no boot marker), the direct-serve verify, the atomic Caddy flip of the `/cnt` handle block's `reverse_proxy cnt:80` token to `cnt-next:80` in `/srv/caddy/caddy/Caddyfile` with `caddy validate` exit 0 then the graceful reload preserving in-flight requests, the canonical `cnt` recreation with the new `cnt-web:<commit>` image, the flip back, the drain, and the full gate (the `/cnt` route's content checks).
- **R-2** The section SHALL state the continuity bar and the rollback rule: a request loop through the edge across the flip window shows zero failed requests; rollback = repoint back to the prior pinned tag (the `cnt-web:<commit>` pinned-tag convention gives exact rollback) and the prior image is retained until the full gate passes.
- **R-3** The section SHALL map the sequence onto `deploy/deploy-cnt-web.sh`'s redeploy path (repoint-only image line → the sequence's canonical-recreate step; the first-deploy path stays as recorded in CNT#11) — and the dated deployment record (the script's convention) SHALL gain the switchover's flip evidence line for any deploy executed under the SoP.

## Success criteria

| ID | Criterion | Class | Instrument |
|---|---|---|---|
| SC-1 | `SOP.md` carries the switchover section with every R-1 element | structural | file parse against R-1 |
| SC-2 | The section states the continuity bar, the pinned-tag rollback rule (R-2), and the deploy-script mapping (R-3) | structural | file parse |
| SC-3 | The first cnt-web redeploy executed under the SoP carries the continuity capture — a request loop through the edge across the flip window reporting zero failed requests, recorded on this issue (until that redeploy occurs, this criterion is pending work) | behavioral | executed continuity loop + capture on the issue |

## Out of scope

- The org runbook's content (devops#42's deliverable — this section conforms to it and names it).
- Making `deploy-cnt-web.sh` execute the blue-green sequence natively — open item for this ticket's plan.
- The other containers' procedures (their own repos or the org runbook).
- Route activation for a *first* deploy (rides the update window per CNT#11/#29 — unchanged).

## Open items

- Whether `deploy-cnt-web.sh` gains a first-class blue-green mode (script change) or the sequence stays an operator-executed wrap — decided at this ticket's plan stage.

## Done state

SC-1…SC-3 all green; the continuity capture from the first SoP-executed redeploy recorded on the issue (until that redeploy, SC-3 is pending work).

## Consumers / blast radius

cnt-web operators and future redeploys (the recreate gap on the `/cnt` route is retired); the org runbook consumes this section as the cnt instance of the pattern. Blast radius: one documentation file in this repo; the evidence event is the flip window of an executed redeploy — no separate rehearsal surface exists or is created by this ticket.
