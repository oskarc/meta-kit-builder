# contract-009 T-6 and T-2 evidence, 2026-09-17

## T-6 - the backfill of contracts 001-005 changed nothing but added lines
`diff` of meta-contract-before-execution/CONTRACT-LOG.yaml against the copy taken before the backfill:
0 lines removed, 21 lines added - `disappointment: legacy`, `premortem: legacy`, `red_test: legacy`, `cost: legacy`
on each of the five entries (20), and `led_to: contract-009` on contract-008 (1). Corrections C-001 to C-007 then gained the three probe fields as `not asked` (42 lines added, none removed; revision 2). G2-migration.sh now exits 0 on
the base tree, with cost exempt at status: approved (revision 1, O-037).

## T-2 - the coverage column on the fork's tree
`G2-migration.sh <the fork's .claude/skills> templates/MANIFEST.template.yaml` exits 0: all 26 base coverage lines of
the 0.16 template are present after the 0.16 upgrade. walk-007 state 128b: the same manifest with `base-ledger`'s
coverage line removed exits 1 naming MANIFEST.yaml and the id.

## Red test
G-4 broken (the DRIFTLOG template header made to say "This file is a template"): state 130 red; restored: green.
