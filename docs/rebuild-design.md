# The rebuild — a design note, not a mechanism

Status: withdrawn from the map by contract-006 (G-7). It returns as a mechanism only when the conditions
below hold, and it will be drawn as its own contract then. This note records what it is for, why it was
taken out, and what the field says a rebuild can and cannot show.

## What it is for

The founding statement's goal is kits that travel and reproduce the same standard of development. The
test of that is not "rebuild this product from its own records" — that measures transcription, and the
first design of the rebuild handed every arm the file its oracle lived in, so it could not fail. The test
is **build a different API against the same standard, and score it with the standard's own checks**, which
nobody in the loop wrote for that product.

## Why it was withdrawn

- Its oracle was inside its input. The arms received the contract log; the contract log held the Tier 4
  tests and guarantees the arms were scored on.
- A rebuild by the same model family is not an independent version. Independently written versions fail
  on the same inputs: Knight & Leveson showed it for 27 human versions in 1986; a June 2026 replication
  with 48 agent-built versions across five harnesses, 23 models and three languages showed it again, with
  81 of 146 cross-language pairs failing on exactly the same inputs. Varying only the session buys nothing.
- The more complete the records, the more the rebuild is forced to converge, and the less its agreement
  means. Fidelity and independence pull against each other.
- It was frozen at install. A frozen plan that cannot fail is the one dangerous thing in a kit that is
  otherwise merely wrong.

## Conditions for its return (stage 2 of the plan)

1. **A standard exists as checks** — `meta-mechanisms/checks/` holds checks that fail, written by the clerk
   from the pioneer's corrections, and they have caught at least one thing a correction would otherwise
   have caught.
2. **The oracle is held out.** The rebuilding agent receives the skills and the checks' *names*, never the
   checks' bodies or the Tier 4 tests of any contract. Scoring runs afterwards.
3. **Three or more versions, voted, not two compared.** Majority voting over three agent-built versions cut
   mean failures by two-thirds in the 2026 experiment even though independence failed. One rebuild compared
   to one original is a pseudo-oracle with no vote.
4. **Disagreement is the evidence.** Where versions disagree on an input, one of them is wrong — that is
   proof. Where all agree, error remains (in the measured case, roughly halved, not removed): report
   agreement as an unquantified floor on the error that remains, never as a pass.
5. **A near-transfer control beside the far one.** A rebuild of a different product, months later, by a
   different session, from files, is far transfer on five dimensions at once. A low score cannot separate
   "the standard did not travel" from "the distance was too far" unless the same standard is also tried
   close to home.
6. **Not frozen.** The plan is a contract like any other, revisable before its verifier reports.

## What it would record

Per version: checks passed of total, guarantees met / not met / unassessable, pitfalls from the drift log
hit or avoided. Across versions: the disagreement set, with the input and the versions on each side. And
`not_carried`: what every version lacked that the standard has — the residue the records did not carry —
written by someone other than the standard's author where that is possible, and marked self-graded where
it is not.
