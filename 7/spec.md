# Spec — Timothy Legg acknowledgment document and README provenance (CNT#7)

Remote: https://github.com/CherokeeLanguage/CNT/issues/7

## Problem

The repository's entire data content descends from Timothy Legg's "Cherokee
New Testament Online" project — initiated 2006, the full New Testament
transcribed by hand over ~3 years, two complete proofreading passes — yet
nothing in the repository acknowledges him or states that lineage. The
developer requested a special additional document honoring his tireless work,
researched exhaustively online, plus README updates.

## Research basis (recorded)

`.issues/research-cards/timothy-legg-cnt-provenance.yaml` — verified facts:

- Name: **Timothy Legg** ("Tim Legg"); "Leggett" appears in no source.
- First-person project history lives locally at
  `../CherokeeNewTestament.org/content/cherokee-new-testament/index.md`
  (authors: Timothy Legg, Michael Conrad); mirrored at
  cherokeedictionary.net/cnt/. Book from Ryan Mackey (Kenwood, OK); the late
  George Pumpkin suggested comparing texts; English per-line text from the
  University of Virginia; audio attempt with Louise Lacey and Betty
  Sixkiller; November 2014 PDF e-book by Michael Conrad.
- 2015 PDF edition credit: "Timothy Legg — Data entry and proofing.
  / Michael Joyner — Typesetting." (todaysnative.org/.../cnts.pdf, verified
  by text extraction; CC0 1.0, ISBN 978-1-312-94393-3).
- Independent third-party attributions: CrossWire SWORD module Che1860;
  bible-discovery.com/bible-license-che1860.
- This repo's seed is Legg's 2011 data archive (`cntdata/cnt_data.tar.gz`,
  owner legg/legg).
- Live cherokeenewtestament.org is down (HTTP 522); the developer directed
  that the local `../CherokeeNewTestament.org` checkout is the referenced
  source.
- Living status: unresolvable from public sources — no memorial or
  posthumous language found anywhere.

## Scope

One new document plus README edits; no data files modified.

| Surface | Change |
|---|---|
| `docs/LEGG.md` (new) | acknowledgment of Timothy Legg's work, with cited sources |
| `README.md` (edit) | provenance paragraph + link to the acknowledgment |

## Requirements

- **R-1** — The acknowledgment document SHALL honor Timothy Legg's work:
  project initiation in 2006; the hand transcription in vi on Ubuntu Linux
  over ~3 years; the two full proofreading passes; the 2011 data archive that
  seeds this repository; and the 2015 edition credit ("Data entry and
  proofing").
- **R-2** — Every factual claim in the document SHALL carry a cited source
  (local CherokeeNewTestament.org narrative; cherokeedictionary.net/cnt/;
  the 2015 PDF; CrossWire SWORD Che1860). No invented claims.
- **R-3** — The document SHALL NOT assert Legg's living or deceased status,
  birth/death dates, or biography beyond the project narrative; phrasing
  honors the work in present-perfect terms safe in either case.
- **R-4** — The name SHALL be "Timothy Legg"/"Tim Legg" everywhere;
  "Leggett" appears nowhere in the change.
- **R-5** — `README.md` SHALL gain a provenance paragraph (the repository
  descends from Legg's 2006–2019 project; seed archive
  `cntdata/cnt_data.tar.gz`) and a link to the acknowledgment document.
- **R-6** — References SHALL use the local `../CherokeeNewTestament.org`
  checkout and archived/mirrored sources; no claim that the live
  cherokeenewtestament.org is up.

## Success criteria

| ID | Criterion | Class | Instrument |
|---|---|---|---|
| SC-1 | `docs/LEGG.md` exists and covers R-1 content with every factual claim source-cited (R-1, R-2) | structural | existence check + read-through against R-1/R-2, claim-by-claim source check |
| SC-2 | No living/deceased assertion and no "Leggett" spelling anywhere in the change (R-3, R-4) | structural | grep the changed files for "Leggett" and memorial phrasing; read-through of the honor phrasing |
| SC-3 | `README.md` updated per R-5 and R-6 | structural | read-through of the diff against R-5/R-6 + claim verification against the repo |

## Out of scope

- Modifying data files; changes inside the CherokeeNewTestament.org repo;
  memorial framing; new research beyond the recorded card.

## Approach

Author `docs/LEGG.md` from the research card's verified facts; extend
`README.md` with provenance and the link; run the claim-inventory check; one
PR.

## Evidence

Executed verification output is recorded under `.issues/7/evidence/`.
