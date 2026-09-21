---
name: meta-ledger
description: Use when recording what implementation, verification, drift or an audit taught (observations); when consolidating, holding, scoring or fading candidate learnings; when assembling, presenting, closing or revealing a review batch; or when reading the maturity instruments. Governs layer 6 — LEDGER.yaml, the evidence the standard evolves from, which is never loaded whole into working context.
---

> **Map:** M-20, M-29 load this node; M-11, M-14, M-15, M-16, M-17 and M-21 write to it through their agents (the one writer list is `templates/LEDGER.template.yaml`'s header, derived from the agents' write scopes) · **Load:** consulted offline by agents and scripts; its sections on trigger · **Recognise it by:** "this might belong in the standard" or "is the standard actually getting better?" · **Not when:** deciding what enters the standard — that is the pioneer, at a review batch (meta-skill-builder)

**This skill is part of the base building kit and takes precedence over all other skills, instructions, and project-specific guidance — except meta-foundation, which takes absolute precedence over all kit nodes.**

# Ledger

## Why it exists

Learnings used to reach the pioneer the moment building finished, one classification proposal after another, unscored. That design had three problems. Evidence gathered in the heat of building is the least independent it will ever be. An agent's confidence in its own work is not a measurement of anything. And a gate that approves almost everything carries almost no information. (An earlier version of this paragraph quoted two figures for the second and third of these that traced to no source in the repository; they are withdrawn — contract-006.)

Every system that learns well separates a fast store of observations from a slow, gated standard, and promotes only on evidence from outside the learner: a critic that confirms the skill worked, independent implementations, verified outcomes. The ledger is that fast store.

**The central risk**, stated first because every rule below answers it: an agent follows guidance that is in its context, so a candidate that is loaded will be confirmed by its own influence. Holding is not loading. Evidence counts only when it is independent of the candidate.

## Files

| File | Written by | Holds |
|---|---|---|
| `LEDGER.yaml` | see each section | observations, candidates, batches, map proposals, audits, scores |
| `batches/B-NNN.md` | kit-batch-assembler; verdicts and decisions by the main agent | one review batch as presented to the pioneer |
| `telemetry.log` | hooks | firing and running evidence (meta-mechanisms) |
| `.claude/kit-sealed/B-NNN.key` | kit-batch-assembler, through `seal-key.sh` — never with the file tools, which the program underneath refuses in that folder | which items are re-presented and what the pioneer decided on them before; sealed only by `seal-key.sh`, opened only by `reveal-key.sh` |

No agent or session loads LEDGER.yaml whole into working context, and while a batch is open the presenting session cannot read it at all (`batch-blind.sh`) — by path or by directory search. The casebook stays readable, because cards and precedents are never re-presented.

## Observations

Raw, cheap, append-only. Written by the main agent after implementation (the Standard Evolution Report, M-11), by meta-learning (M-13), by the main agent from drift incidents worth a learning (M-18), by kit-session-auditor, by kit-consolidator (drift recurrences it detects), for map misses (M-20), when the pioneer remarks on the standard unprompted (`source: pioneer`), and by **kit-case-clerk** — one per clerked correction, `source: pioneer`, `refs: [C-NNN]`, the pioneer's words verbatim and `stated_confidence: null`, since their words carry no forecast (contract-005 G-2). That is the route by which a recorded correction becomes a candidate read against the skill it bears on.

**While a review batch is open**, the main agent cannot write here either — so it hands the observations, in full, to **kit-recorder**, whose only job and only write scope this is. Build work does not wait on a review, and the presenting session still never reads the ledger.

- **`statement`** — one claim, at a guessed level. One learning per observation.
- **`stated_confidence`** — the observer's probability, written before any checking, that this claim will be adopted by the pioneer and hold uncontradicted through its next three independent uses. **Frozen at creation.** It is kept as the forecast it was and is not scored (contract-006); it is never a gate.
- **`loaded_candidates`** — every candidate id that was in the observer's context: cited in the contract (M-29) or read during the work. One definition, used everywhere.
- **`prompted`** — `true` when the observation came from an answer the kit asked for (a batch `revise`, a question put to the pioneer). A prompted observation is never counted as the unprompted pioneer evidence of independence rule 3.
- **`certainty_codes`** — optional at creation; a session-level drift analysis adds `compromised-session` here so the consolidator carries it onto the candidate.
- **`consolidated: false`** until kit-consolidator processes it. Map misses also carry **`stewarded: false`** until kit-map-steward reads them. Either takes `blocked`, with `blocked_since`, `blocked_reason` and `blocked_waiting_for` beside it, when the agent cannot take the observation at all (meta-mechanisms → Blocked tasks).

## Candidates

Created and updated only by **kit-consolidator**. The main agent writes a candidate's `decision` block, `stage` and `review_due` after a reveal; nothing else writes candidates.

**A candidate is read against the skill it is aimed at.** When the consolidator creates a candidate, and again when it flags one due, it opens the target skill and writes `contradicts:` — file and passage, **quoted verbatim**, for the sentences the claim would make false — at most three, the most consequential, with a note when there are more; `contradicts: []` when there is none (contract-004 G-7). The batch then offers `update`, `retire` or `add` beside `decline`, so a learning is as likely to remove a rule as to add one — the only shrink path the kit has apart from the map budget. Whose word the claim is decides when it is due: a `source: pioneer` candidate with a non-empty `contradicts` is due at once; a candidate from any other source waits for independence like the rest, because a drifting agent must not rewrite the rule it drifted from.

### Stages

| Stage | Meaning | Moves when |
|---|---|---|
| `assess` | held, not loaded anywhere | created from an observation |
| `trial` | deliberately applied where it bears, cited by id (M-29) and tracked | the pioneer decides `trial` at a batch |
| `adopt` | written into a skill, and cited by id where it bears | the pioneer decides `adopt` |
| `caution` | written into the target skill's anti-patterns | the pioneer decides `caution` |
| `faded` | dropped quietly | no movement for 8 startup sessions while in `assess` |
| `declined` | refused, kept on record | the pioneer decides `decline`, or a `revise` supersedes it |

The consolidator sets **`review_due: true`** and a `disposition_proposed` when (contract-006 G-1 — no computed bound; the counts are shown, the pioneer weighs them):

- **toward trial** — one helpful sighting from a *different reading* (see Independence) beyond the founding observation, none harmful; or the candidate came from a verified learning diff; or the candidate is a pioneer correction that contradicts a skill (due at once)
- **toward adopt** — in `trial`, and one further helpful sighting from a different reading since the trial began, none harmful
- **toward caution** — any harmful sighting from a different reading

An earlier version gated these moves on a computed confidence bound over "independent" sightings. The kit's own research found three sightings from one person, one model and one codebase are worth about one and a half, and that a bound computed over them is noise; the gate was removed rather than tuned.

A stage move is never re-proposed for a disposition the pioneer already decided; a promotion from `trial` toward `adopt` is a different disposition and is due on its own criteria. After a decision the main agent clears `review_due`. A candidate the pioneer **held** becomes due again only when a new independent sighting arrives after the decision date. A **revised** candidate is `declined` and superseded by the observation carrying the pioneer's wording. A **faded** candidate returns to `assess` when a new matching observation arrives, and its outcome is re-opened. A candidate that is `review_due` or sits in an open batch never fades.

### Independence

**Two sightings are independent to the degree a single misreading of the contract could not have produced both.** That is the definition (contract-006 G-4) — the reason the verification standards give for requiring a second reader, in one sentence. It replaces "who reported" with "what varied". A sighting comes from a *different reading* when:

1. it is a **check that can fail** — a test, a hook, a script under `meta-mechanisms/checks/` — run on the work (the strongest kind: no reading is involved at all)
2. it is a **kit-verifier verdict** on a clause that cites the candidate — recorded with the grade `same-family-different-inputs`, because the verifier is the builder's own model family reading the same repository with different inputs; it counts, and the grade travels with it so nobody mistakes it for an outside reader
3. it is a **contract where the candidate was not loaded** (`loaded_candidates` does not list it) **and** the sighting is not the agent's own account of that work
4. it is **the pioneer**, unprompted (`prompted: false`) or as a recorded correction

Everything else is the **same reading**: the agent judging its own work while the candidate sat in context. **An observation the agent restates about its own work is always the same reading, whatever contract it came from** — two self-generated restatements are one opinion twice. Same-reading sightings are recorded, and a candidate with many of them and none from a different reading is exactly what this ledger is built to notice, but they never move a stage. One contract contributes at most one sighting, and the consolidator reconciles `loaded_candidates` against the ids the contract's Tier 3 actually cites.

**The definition is testable, and the consolidator tests it.** For any two sources the kit calls different readings, it records how often they agree on candidates where at least one was later contradicted. Two sources that almost always agree are one reading wearing two names, and the consolidator says so in `scores.coincidence` rather than counting them twice. (The keys `helpful.independent` / `helpful.loaded` keep their names in the schema; "independent" there means "from a different reading" as defined here.)

**Each verdict is counted once, by the consolidator.** meta-learning names the confirmation in its diff; it does not add a sighting.

### Certainty

GRADE-style, with named reasons the pioneer can dispute:

| Source | Starts at |
|---|---|
| `ser` (the agent's own reflection) | `very-low` |
| `drift`, `auditor` | `low` |
| `learning`, `verification`, `pioneer` | `moderate` |

- **Down:** `self-generated` · `single-contract` · `loaded-only` · `contradicted` · `indirect` · `compromised-session`
- **Up:** `verified-outcome` · `prevented-defect` · `pioneer-unprompted` · `independent-uses>=2`

Down codes apply from creation; a `ser` observation therefore starts at `very-low` with `self-generated`, and cannot reach the trial threshold on restatements alone.

### Counts, not bounds

A candidate shows its counts — helpful and harmful, by reading — and the pioneer reads them. No score is computed over them: at the numbers this ledger will ever hold, a computed bound says nothing the counts do not, and it gave a false sense of a threshold having been crossed.

## Review batches

**Assembled** by kit-batch-assembler when the stop-gate says pioneer-owned items are waiting (M-16). A batch that cannot be assembled has no entry to say so on, so the ledger says it for itself: `assembly: blocked` at the top level, beside `observations:` and `candidates:`, with the same three `blocked_*` lines at the same column. The gate then holds the batch step, puts it to the pioneer once a sitting, and the session writes `assembly: false` when what it waited for exists (contract-023). Seven item kinds, all of them decisions only the pioneer can take:

| Kind | Comes from | Decisions |
|---|---|---|
| candidate | `review_due: true` | trial · adopt · caution · decline · hold · revise (+ level and tier); with a `contradicts` passage: update · retire · add · decline |
| map proposal | `map_proposals` in `state: pending` | ratify · decline · revise |
| map entry | `proposed` lines in MAP.md | ratify · decline · revise |
| scenario card | `pioneer_ranking: pending` in CASEBOOK.yaml | a ranking · decline |
| precedent | a `conflict:` pair, or three or more `distinguished_by` | overrule · keep · reconcile |
| drift resolution | DRIFTLOG entries in `status: mitigated` | resolve · keep-watching |
| re-presented candidate | a candidate the pioneer already decided, shown again as if new (from the fourth batch on; at most two) | the same decisions as a candidate |

**Re-presented items** (contract-006 G-3) replace the planted canaries an earlier version carried. A re-presented item is a real candidate the pioneer decided at an earlier batch, shown again with nothing to mark it; the sealed key records which items they are and what was decided before. After the reveal the pioneer is shown their earlier decision beside the new one. What is recorded is the pair — prior, now, and whether they agree — per item, on the batch. **It is never pooled into a rate**: a rate over items of different kinds and difficulty measures the mix of items, not the judge. The first three batches carry none, because early feedback on a new task is where feedback does harm. Real declined items were chosen over planted flaws because hand-seeded faults are known not to stand in for real ones, and because the kit has real decided items and does not need to invent any.

Items are shuffled, renumbered `I-1…I-n`, and **carry no ledger ids**: the sealed key is the only mapping from an item to its source.

**Presented** by the main agent under `meta-skill-builder` → Review Batch. While the batch is open the ledger is closed to that session, so the batch file is the whole of what it can see.

**Closed** with `close-batch.sh B-NNN` once every item carries a decision — any non-empty value, including a ranking such as `[B, A, C]`. It sets `decided: true` without the session reading the ledger.

**Revealed** with `reveal-key.sh B-NNN` (M-17). Then the main agent applies decisions to items that were not re-presented, clears their `review_due`, writes the `represented` record on the batch — per item: candidate id, prior decision, decision now, `consistent: true|false` — shows the pioneer their earlier decision beside the new one without comment, and **sets `revealed: true`** — until it does, the stop-gate hands the reveal back every turn. A re-presented item's new decision is recorded and not applied; the earlier decision stands unless the pioneer says otherwise in that turn.

**Every kind has a terminal value**, so a decided item never returns: a declined map entry is written `declined` in MAP.md's status column, a declined card carries `pioneer_ranking: declined`, a kept or reconciled precedent has its `conflict:` cleared, and a resolved drift entry moves to `status: resolved`. An `update`, `retire` or `add` on a contradicting candidate sets `stage: adopt` with `applied_as`, and the edit is made **at the quoted passage only** — never a rewrite of the node. Without those, the assembler would re-present the same items forever and the backlog could never clear.

Batch item format:

```
## I-3
**Kind:** candidate — a learning that may belong in the standard
**Statement:** … (as recorded, word for word)
Verdict before evidence:
**Proposed:** adopt — pattern · type-category · target: meta-contract-before-execution
**Evidence:** … (what was seen, where, and by what kind of reading — in words; never an observation's or a correction's id)
**Why you are seeing this:** it has been confirmed once from a different reading since it was first noted, and nothing has spoken against it — the point at which the kit asks whether to try it.
**What stands behind it:** certainty low — it began as the agent's own reflection (self-generated) and has been seen in one contract only (single-contract). Confirmations: 1 from a different reading, 2 from the same reading, none against. The observer's forecast that you would adopt it: 0.80 — a recorded guess, never scored. Nothing is asked of you about these figures; they are here so you can weigh how much stands behind the claim.
Against: (the pioneer's answer to "assume this is wrong — why?", one line, recorded before the decision)
**Contradicts:** meta-contract-before-execution/SKILL.md → "A blanket 'looks good' is not a per-clause confirmation." (omit the line when contradicts is empty)
**What is asked:** one of — trial: applied where it bears and tracked, not yet written into a skill · adopt: written into the target skill · caution: written into the target's anti-patterns · decline: refused, kept on record · hold: comes back only when new evidence from a different reading arrives · revise: your wording replaces it, and the old one is declined. (With a quoted passage the ask is instead — update: the quoted sentence is rewritten so the claim holds · retire: the quoted sentence is removed and nothing is put in its place · add: the claim is written in at that passage and the quoted sentence stays · decline: refused, kept on record, the skill left as it is. Each edit is made at that passage only.)
Decision:
Level and tier (for trial, adopt or caution):
Reason:
```

The proposed disposition sits **below** the verdict line: the pioneer's first read is of the statement alone, so the agent's recommendation cannot anchor it. *Why you are seeing this* sits below it too, because it tells how the evidence stands.

**Every item is written for a reader who has not seen the ledger** (contract-014; `meta-foundation` → The Agent's Role). The kind is named in plain words, the statement and any quoted passage stay word for word, every code is followed by what it means, and two lines are never omitted — *Why you are seeing this* and *What is asked*, which lists exactly the decisions the kind allows, no more and no fewer, each with what it does. The plain words sit beside the record's; they never replace it. **A figure is copied as the record gives it, under the record's own meaning of the field** — a count is never re-derived, rounded or put as a different count (a drift entry's `recurrence_count: 2` is "it has recurred twice since it was first recorded", never "it happened twice"); where the meaning of a field is not certain, the field's name and value are given as they stand. Terms that recur — a different reading, the same reading, the certainty word, the observer's forecast — are explained once, under *How to read these items* at the top of the batch file, so each item stays short.

| Kind | In plain words | Why it arrives | What each decision does |
|---|---|---|---|
| candidate | a learning that may belong in the standard | it gathered the evidence *Stages* names, or it is the pioneer's own correction contradicting a skill | as in the format above |
| map proposal | a change to what the always-loaded map loads, and when | the map steward found an entry misfiring, never firing, or missing | ratify: the map is changed as proposed · decline: kept on record, not proposed again · revise: redrafted from the pioneer's wording |
| map entry | a drafted line of the map that is not the pioneer's yet | it is still `proposed` | ratify: it becomes theirs as written · decline: marked declined, stops loading · revise: their wording replaces it |
| scenario card | a hard case with options to rank | the case clerk wrote it from a correction | a ranking: becomes the casebook's guidance for cases like it · decline: the card is set aside |
| precedent | two past rulings that disagree, or one set aside three times | contracts that meet it cannot cite it cleanly | overrule: the ruling stops deciding · keep: it stands, the conflict is cleared · reconcile: the pioneer says which holding stands, in their words |
| drift resolution | a recorded drift whose fix has been in place | its status reached `mitigated` | resolve: closed · keep-watching: stays open and counted |

A re-presented item is written exactly as a first-time candidate is — its *Why you are seeing this* reads as it did when it was first presented — so nothing in these lines can mark it (G-2).

A decision the pioneer asks for outside a batch is recorded with `batch: direct` on the candidate and clears `review_due` the same way.

## Map proposals, audits and scores

`map_proposals` are written by kit-map-steward and decided at batches; ratified ones are applied to MAP.md by the main agent, declined ones marked `declined`, revised ones set back to `pending` carrying the pioneer's wording so the steward redrafts them. `audits` are written by kit-session-auditor: an outside score of the agent's aspects, the approvals the agent acted on that the pioneer never gave in words, its deviations with no authorising statement, and evidence-of-form checks. There is no score of the session's own to compare with: the agent stopped scoring itself in contract-020.

The consolidator maintains `scores`:

- **per contract** — observations recorded, candidates created, whether the session was audited and the contract verified, and the contract's `cost`. This is the denominator the maturity signal needs.
- **coincidence** — for each pair of sources the kit treats as different readings (checks, verifier, pioneer, unloaded contracts), how often they agreed on candidates later contradicted. This is the test of the independence definition, not a score of anyone.
- **corrections by source** — per contract, how many verifier corrections came from a red test and how many from reading. The practice wants the second falling.

**Nothing here scores the pioneer.** An earlier version computed a forecast score over the pioneer's decisions, and a rate of planted items caught. Both were retired by contract-006: the decision score was minimised by declining everything, because a decline created the outcome it was scored against; the rate pooled items of different difficulty and could not be read at the batch sizes the kit has. Decisions and outcomes are kept as records and shown to the pioneer as records. Observers' `stated_confidence` is kept as the forecast it was, unscored.

An outcome **resolves** as held when an adopted candidate is cited in three contracts from a different reading without a harmful sighting, or when ten contracts have touched its target area without one; as not held when it is contradicted after adoption or draws a harmful sighting from a different reading. **A declined or faded candidate's outcome is `unobserved`** — it was never run, so nothing about it is known; a decline does not create its own outcome. **Adopted candidates keep being cited by id** where they bear (M-29), which is what makes those uses countable; a trial that has neither resolved nor moved after ten contracts in its area is set `review_due` again with `disposition_proposed: hold`, so the pioneer decides whether it is still a trial.

**Maturity is no longer silence.** Fewer candidates per contract means the standard anticipates the work only while process health holds — sessions audited, contracts verified, corrections increasingly caught by tests rather than reading, re-presented decisions consistent. A quiet ledger with unaudited sessions is the failure mode that looks like maturity.

## What this skill does not do

- It does not decide what enters the standard; stage moves to trial, adopt, caution and decline are the pioneer's
- It does not load candidates into work outside a trial or an adoption citation
- It does not extract — the ledger, batches, telemetry and sealed keys are one project's evidence, never the next project's
