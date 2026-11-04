# Plan — README and data-conventions documentation (CNT#5)

Spec: `.issues/5/spec.md` (validated PASS, zero findings).

## Item 1 — README.md (SC-1 → R-1, R-2, R-3)

- **Deliverable:** root `README.md` covering: what the repo is; directory
  layout (`cnt/`, `cntdata/`, `.issues/`, `.opencode/`); the `BBCCVV` naming
  key (`01`–`27` = Matthew–Revelation) and the surface map
  (`cnt/BBCCVV.png`, `cntdata/BBCCVV.txt` transliteration-not-syllabary,
  `cntdata/BBCCVV.eng`, `BB0000` book-header convention, no `.eng`
  book-header form); the chapter-HTML bare-filename image-reference note and
  the auxiliary-working-files caveat.
- **RED:** `test -f README.md` fails (file absent on trunk).
- **GREEN:** author the README from `AGENTS.md` facts cross-checked by direct
  inspection of representative files before each claim is written.
- **Instrument:** `test -f README.md` + read-through against R-1..R-3.

## Item 2 — docs/DATA.md (SC-2 → R-4)

- **Deliverable:** `docs/DATA.md` (new `docs/` directory) giving per-type
  detail: verse-file layout (one line per verse keyed by `BBCCVV`),
  transliteration conventions as observed in the data, book-header file role,
  chapter-HTML/scan relationship. Depends on Item 1's inspection pass.
- **RED:** `test -f docs/DATA.md` fails.
- **GREEN:** author after a data survey (sample verses across several books,
  book-header files, one chapter HTML, auxiliary files) so every convention
  stated is observed, not assumed.
- **Instrument:** `test -f docs/DATA.md` + read-through against R-4.

## Item 3 — claim-inventory verification (SC-3 → R-5)

- **Deliverable:** executed verification evidence for both documents.
- **RED:** claim inventory does not exist / contains unverified claims.
- **GREEN:** enumerate every factual assertion in the finished documents;
  verify each against the repository; record executed output under
  `.issues/5/evidence/`.
- **Instrument:** the claim-inventory line-by-line check, zero unverified
  claims.

## Dependencies

Item 1 and Item 2 share the data-inspection pass; Item 3 runs after both
files are final.

## Traceability

Item 1 → SC-1 → R-1..R-3; Item 2 → SC-2 → R-4; Item 3 → SC-3 → R-5.
No items beyond the spec's SCs.

## Documentation sources

`AGENTS.md` (repo facts); direct file inspection (`cntdata/010000.txt`,
`cntdata/010101.txt`/`.eng`, `cntdata/0101.html`, `cnt/010000.png`,
auxiliary files).
