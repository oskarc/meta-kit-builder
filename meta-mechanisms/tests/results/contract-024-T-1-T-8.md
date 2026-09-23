# contract-024 — the review batch fits the pioneer who reads it (T-1 to T-8)

**Date:** 2026-09-23. Drawn from the seventh downstream report — the first review batch any project held, twenty
items in one sitting, five corrections drawn by the review itself — and from the pioneer's sharpening at the gate:
*"The kit should present to a pioneer in a way that assumes no prior knowledge of the practice, it should tell the
pioneer why it is seeing something, and it should tell it concise, it cannot be 2000 words and ask 12-15 things.
that is information overload."* The pioneer took four of the report's six repairs and left two.

## How the live tests were run

Three tests run a real session of the program the kit lives inside (Claude Code 2.1.170, unattended), each in a
throwaway folder under the session's scratch space that holds a copy of this working tree's kit. Every run was
isolated as the ruling of 21 September requires: no user-level settings loaded, a guard hook refusing any tool call
outside the folder, the folder's absolute path in the prompt — and the guard was seen refusing a read of this
repository from inside the first folder before any agent ran. The sealed folder carries the same stand-in refusal
of the file tools as contract-023's tests, so the assembler had to seal through the script.

**One guard refusal in three runs**, and it is worth its own line: the case clerk, told the ledger's project-relative
path, resolved it one folder *above* the project on its first try, was refused by the test guard, and then used the
right path. The kit's own write guard matches a piece of a path and would have let that write through — the same
thing the roadmap already names, seen a second time. The two assembler runs were refused nothing.

## T-1 (G-1) — a deferred card is counted by no reader

`walk-007` state 216. One card deferred beside one pending: the session-start line, the gate and the waiting list
all say one item waits. Both deferred: all three say nothing does. The counting was already through the one shared
function (contract-023); a card at `deferred` was never `pending`, so no reader had to change — the state holds
that this stays true. The return after one batch is agent behaviour, tested in T-4.

## T-2 (G-2) — live candidates by target

State 217. Six candidates across three targets, two of them declined or faded: `records-index.sh <root> candidates`
prints four lines, grouped by target — the contract skill's one, then the ledger's two, then the map's — and each
line's number opens the ledger at that candidate's `cand_id`. `all` prints three section headers. An unknown
selection is refused naming the four.

## T-3 (G-3) — one form per kind, the two questions on the candidate only

State 218. Read from the ledger skill itself: every kind in the table (candidate, scenario card, map proposal — with
the map entry sharing its form — precedent, drift resolution) has a form; each form carries the kind line, *Why you
are seeing this* and *What is asked*; the decisions in each form's ask line match the kinds table (trial, adopt,
caution, decline, hold, revise, update, retire, add · a ranking, defer, decline · ratify, decline, revise · overrule,
keep, reconcile · resolve, keep-watching). `Verdict before evidence:` and `Against:` occur once each in the forms
region, inside the candidate form. The skill-builder says "for candidates only"; the assembler says "Only a
candidate carries `Verdict before evidence:`". Both tables offer `defer` on a card.

## T-4 (G-1, G-3, G-6) — the assembler, live

| fixture | what was due | what it wrote |
|---|---|---|
| nine due items (3 candidates, 3 pending cards, 1 map proposal, 1 proposed map line, 1 mitigated drift entry) and a card deferred at the last revealed batch | more than one sitting | **B-002 with 6 items** — the three candidates, the map proposal, the map line and one card, in the table's order; the deferred card absent; every item in its kind's form; `Verdict before evidence:` and `Against:` under the three candidates only; a 5-sentence preamble; 1,171 words; `G7-batch` run by the agent before sealing and passing; the key sealed through the script; the batch registered `decided: false, revealed: false`; its final message ended `More items wait for a later batch.` with no number |
| one due candidate, one proposed map line, and the same deferred card with two batches revealed since the deferral | three items | **B-003 with 3 items** — the deferred card back, in its form; 643 words; the check passing; nothing said about items waiting |

Both runs: opus, one attempt each, no guard refusal. What the first run also shows: the batch came out 29 words
under the bound. The bound is where the agent writes to.

## T-5 (G-4) — the clerk carries a changed mind

Three corrections, the first two already clerked with precedents, the third naming the first in `supersedes` and
saying *"stay true to the skill"*. After the run: the first correction's precedent reads `status: overruled`,
`overruled_by: C-003`; the second precedent is untouched; the third correction is clerked as usual — a precedent of
its own, a card, a ledger observation in the pioneer's words. The clerk's message named the overruling and said
nothing was deleted. One sample, sonnet.

Seen on the side, not this contract's: the clerk wrote the card's options with `id:` where the template says
`key:`.

## T-6 (G-4) — the three texts

State 219. The correction-log skill carries "An override is not an error"; the clerk's file carries "A changed
mind" and the reworded never-line; three replaced wordings stand on the retired list and the retired check passes.
A candidate whose decision reason is a block scalar holding a colon is still indexed with its stage; a card whose
rationale holds a colon still leaves the pending card beside it counted. (The kit has no YAML parser; "parses" here
means the flat-key readers read past the scalar, which is what broke downstream.)

## T-7 (G-5) — nothing else broke

- `walk-007`: 187 passed, 0 failed (states 216 to 221 are this contract's; state 216 failed on its first run on its own wrong expectation, and state 160 - contract-014's - failed on two phrases the assembler rewrite had dropped, both repaired). The three walks and every check: the travelling walk 78 of 78 states, walk-004 51 of 51.
- The always-loaded files: `INTENT.md` grew by one clause to 5,082 bytes of its 5,120 allowance; the map and the
  founding statement are unchanged.
- Ten checks exit 0; the migration check passes on the log with the new entry. The hook self-test runs in a project's root, not in this repository; no hook changed.

## T-8 (G-6) — the batch check

State 220, on fixtures the walk writes itself: a six-item file under the bound holds; a twenty-item file of over
2,000 words is refused naming both counts; a card asked the two questions and an item missing its why line are each
named. State 221: the check has its inventory row, its README row and its refusals registered — the refusal check
caught the five item-level messages as unregistered the moment the script was written, which is that check doing
its job.

## The red test

The item cap was taken out of the batch check and the removal confirmed - a different checksum. `walk-007` state 220 failed as it should: *"big=1/n"* - the twenty-item file was still refused, for its words, and no longer for its count. The line was put back; the checksum matched the one taken before the break; the state passed again.

## What this does not establish

- **How a real pioneer meets the new forms.** The forms are the pioneer's own, drawn downstream mid-review; whether
  they hold for a pioneer who is not them is the thing they were drawn for and has not been tried.
- **Whether six and 1,200 are the right numbers.** They are read from the pioneer's words; the first live batch
  came out at 1,171, so the bound is where the agent will write to. If it is too tight for a candidate with a long
  quoted passage, the check will say so and the pioneer decides.
- **One sample each** for the assembler's two fixtures and the clerk.
- **Report-007's repairs 1 and 3** (re-checking a quoted passage at assembly; the export question at assembly) were
  declined by the pioneer and are not here.
