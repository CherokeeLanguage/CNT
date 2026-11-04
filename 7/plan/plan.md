# Plan — Timothy Legg acknowledgment and README provenance (CNT#7)

Spec: `.issues/7/spec.md` (validated PASS, zero findings).

## Item 1 — docs/LEGG.md (SC-1 → R-1, R-2)

- **Deliverable:** acknowledgment document honoring Timothy Legg: 2006
  initiation; hand transcription in vi on Ubuntu Linux over ~3 years; two
  full proofreading passes; the 2011 data archive seeding this repo; the 2015
  edition credit. Every claim carries a cited source from the research card
  (`../CherokeeNewTestament.org` narrative, cherokeedictionary.net/cnt/, the
  2015 PDF, CrossWire Che1860).
- **RED:** `test -f docs/LEGG.md` fails (absent on trunk).
- **GREEN:** author from `.issues/research-cards/timothy-legg-cnt-provenance.yaml`
  verified facts; present-perfect phrasing only (R-3).
- **Instrument:** existence check + claim-by-claim source read-through.

## Item 2 — naming and living-status guard (SC-2 → R-3, R-4)

- **Deliverable:** the change's files free of "Leggett" and of any
  living/deceased or memorial assertion.
- **RED:** grep over the working tree change-set shows no Legg document yet —
  guard passes only once Item 1's text exists and is checked.
- **GREEN:** write per R-3/R-4; grep the changed files (`git diff --name-only`
  set) for "Leggett" and memorial phrasing (`in memory of`, `in memoriam`,
  `passed away`, `19\d\d–\d{4}` birth–death dash patterns).
- **Instrument:** executed grep with zero hits + read-through.

## Item 3 — README provenance updates (SC-3 → R-5, R-6)

- **Deliverable:** README.md provenance paragraph (descends from Legg's
  2006–2019 project; seed archive `cntdata/cnt_data.tar.gz`; live site down,
  local `../CherokeeNewTestament.org` and mirrored sources are the
  references) + link to `docs/LEGG.md`. Depends on Item 1 (link target).
- **RED:** README contains no Legg/provenance mention (grep confirms).
- **GREEN:** edit README.md; verify stated facts against the repo
  (tarball exists, seed commit) and the research card.
- **Instrument:** diff read-through against R-5/R-6 + claim verification.

## Dependencies

Item 1 → Item 2 → Item 3 (guard checks the final text set; README links the
document).

## Traceability

Item 1 → SC-1 → R-1/R-2; Item 2 → SC-2 → R-3/R-4; Item 3 → SC-3 → R-5/R-6.
No items beyond the spec's SCs.

## Documentation sources

`.issues/research-cards/timothy-legg-cnt-provenance.yaml`;
`../CherokeeNewTestament.org/content/cherokee-new-testament/index.md`;
`AGENTS.md`.
