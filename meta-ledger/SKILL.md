---
name: meta-ledger
description: Use when recording what implementation, verification, drift or an audit taught (observations); when consolidating, holding, scoring or fading candidate learnings; when assembling, presenting, closing or revealing a review batch; or when reading the maturity instruments. Governs layer 6 — LEDGER.yaml, the evidence the standard evolves from, which is never loaded whole into working context.
---

> **Map:** M-20, M-29 load this node; M-11, M-14, M-16 and M-17 write to it through their agents · **Load:** consulted offline by agents and scripts; its sections on trigger · **Recognise it by:** "this might belong in the standard" or "is the standard actually getting better?" · **Not when:** deciding what enters the standard — that is the pioneer, at a review batch (meta-skill-builder)

**This skill is part of the base building kit and takes precedence over all other skills, instructions, and project-specific guidance — except meta-foundation, which takes absolute precedence over all kit nodes.**

# Ledger

## Why it exists

Learnings used to reach the pioneer the moment building finished, one classification proposal after another, unscored. That design had three measured problems. Evidence gathered in the heat of building is the least independent it will ever be. An agent's stated confidence clusters between 80% and 100% and favours its own work. And a gate that approves almost everything carries almost no information — at a 93% approval rate, a decision tells you about a third of a bit.

Every system that learns well separates a fast store of observations from a slow, gated standard, and promotes only on evidence from outside the learner: a critic that confirms the skill worked, independent implementations, verified outcomes. The ledger is that fast store.

**The central risk**, stated first because every rule below answers it: an agent follows guidance that is in its context, so a candidate that is loaded will be confirmed by its own influence. Holding is not loading. Evidence counts only when it is independent of the candidate.

## Files

| File | Written by | Holds |
|---|---|---|
| `LEDGER.yaml` | see each section | observations, candidates, batches, map proposals, audits, scores |
| `batches/B-NNN.md` | kit-canary-author; verdicts and decisions by the main agent | one review batch as presented to the pioneer |
| `telemetry.log` | hooks | firing and running evidence (meta-mechanisms) |
| `.claude/kit-sealed/B-NNN.key` | kit-canary-author | which batch items are canaries; opened only by `reveal-canaries.sh` |

No agent or session loads LEDGER.yaml whole into working context, and while a batch is open the presenting session cannot read it at all (`batch-blind.sh`) — by path or by directory search. The casebook stays readable, because cards and precedents are never canaries.

## Observations

Raw, cheap, append-only. Written by the main agent after implementation (the Standard Evolution Report, M-11), by meta-learning (M-13), by the main agent from drift incidents worth a learning (M-18), by kit-session-auditor, by kit-consolidator (drift recurrences it detects), for map misses (M-20), when the pioneer remarks on the standard unprompted (`source: pioneer`), and by **kit-case-clerk** — one per clerked correction, `source: pioneer`, `refs: [C-NNN]`, the pioneer's words verbatim and `stated_confidence: null`, since their words carry no forecast (contract-005 G-2). That is the route by which a recorded correction becomes a candidate read against the skill it bears on.

**While a review batch is open**, the main agent cannot write here either — so it hands the observations, in full, to **kit-recorder**, whose only job and only write scope this is. Build work does not wait on a review, and the presenting session still never reads the ledger.

- **`statement`** — one claim, at a guessed level. One learning per observation.
- **`stated_confidence`** — the observer's probability, written before any checking, that this claim will be adopted by the pioneer and hold uncontradicted through its next three independent uses. **Frozen at creation.** It is a forecast to be scored, never a gate.
- **`loaded_candidates`** — every candidate id that was in the observer's context: cited in the contract (M-29) or read during the work. One definition, used everywhere.
- **`prompted`** — `true` when the observation came from an answer the kit asked for (a batch `revise`, a question put to the pioneer). A prompted observation is never counted as the unprompted pioneer evidence of independence rule 3.
- **`certainty_codes`** — optional at creation; a session-level drift analysis adds `compromised-session` here so the consolidator carries it onto the candidate.
- **`consolidated: false`** until kit-consolidator processes it. Map misses also carry **`stewarded: false`** until kit-map-steward reads them.

## Candidates

Created and updated only by **kit-consolidator**. The main agent writes a candidate's `decision` block, `stage` and `review_due` after a reveal; nothing else writes candidates.

**A candidate is read against the skill it is aimed at.** When the consolidator creates a candidate, and again when it flags one due, it opens the target skill and writes `contradicts:` — file and passage, **quoted verbatim**, for every sentence the claim would make false; `contradicts: []` when there is none (contract-004 G-7). The batch then offers `update`, `retire` or `add` beside `decline`, so a learning is as likely to remove a rule as to add one — the only shrink path the kit has apart from the map budget. Whose word the claim is decides when it is due: a `source: pioneer` candidate with a non-empty `contradicts` is due at once; a candidate from any other source waits for independence like the rest, because a drifting agent must not rewrite the rule it drifted from.

### Stages

| Stage | Meaning | Moves when |
|---|---|---|
| `assess` | held, not loaded anywhere | created from an observation |
| `trial` | deliberately applied where it bears, cited by id (M-29) and tracked | the pioneer decides `trial` at a batch |
| `adopt` | written into a skill, and cited by id where it bears | the pioneer decides `adopt` |
| `caution` | written into the target skill's anti-patterns | the pioneer decides `caution` |
| `faded` | dropped quietly | no movement for 8 startup sessions while in `assess` |
| `declined` | refused, kept on record | the pioneer decides `decline`, or a `revise` supersedes it |

The consolidator sets **`review_due: true`** and a `disposition_proposed` when:

- **toward trial** — certainty ≥ `low` **and** lower bound ≥ 0.50 on independent sightings (two independent confirmations, none against), or the candidate came from a verified learning diff
- **toward adopt** — in `trial`, `independent_uses ≥ 2`, lower bound ≥ 0.64 (three independent confirmations, none against), certainty ≥ moderate
- **toward caution** — two or more independent harmful sightings outnumbering helpful ones

A stage move is never re-proposed for a disposition the pioneer already decided; a promotion from `trial` toward `adopt` is a different disposition and is due on its own criteria. After a decision the main agent clears `review_due`. A candidate the pioneer **held** becomes due again only when a new independent sighting arrives after the decision date. A **revised** candidate is `declined` and superseded by the observation carrying the pioneer's wording. A **faded** candidate returns to `assess` when a new matching observation arrives, and its outcome is re-opened. A candidate that is `review_due` or sits in an open batch never fades.

### Independence

A sighting counts as **independent** when it comes from:

1. a kit-verifier verdict or a test result on a clause that cites the candidate
2. a contract where the candidate was not loaded (`loaded_candidates` does not list it) **and** the sighting is not the agent's own account of that work
3. the pioneer, unprompted (`prompted: false`)

Everything else counts as **loaded**: the agent judging its own work while the candidate sat in context. **An observation the agent restates about its own work is always loaded, whatever contract it came from** — two self-generated restatements are one opinion twice, not two confirmations, so rule 2 admits a sighting only when something other than the builder's own reflection produced it. Loaded sightings are recorded, and a candidate with many loaded confirmations and no independent ones is exactly what this ledger is built to notice, but they never move a stage. One contract contributes at most one independent use, and the consolidator reconciles `loaded_candidates` against the ids the contract's Tier 3 actually cites.

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

### Lower bound

Wilson score lower bound on independent sightings, z = 1.28, so two confirmations never outrank twenty. With no independent sightings the bound is 0 by definition — do not divide by zero:

```
awk -v h=HELPFUL -v x=HARMFUL 'BEGIN{z=1.28;n=h+x; if(n==0){print 0; exit} p=h/n;print (p+z*z/(2*n)-z*sqrt(p*(1-p)/n+z*z/(4*n*n)))/(1+z*z/n)}'
```

Reference points: 1–0 → 0.38 · 2–0 → 0.55 · 3–0 → 0.65 · 4–0 → 0.71 · 3–1 → 0.43.

## Review batches

**Assembled** by kit-canary-author when the stop-gate says pioneer-owned items are waiting (M-16). Six item kinds, all of them decisions only the pioneer can take:

| Kind | Comes from | Decisions |
|---|---|---|
| candidate | `review_due: true` | trial · adopt · caution · decline · hold · revise (+ level and tier); with a `contradicts` passage: update · retire · add · decline |
| map proposal | `map_proposals` in `state: pending` | ratify · decline · revise |
| map entry | `proposed` lines in MAP.md | ratify · decline · revise |
| scenario card | `pioneer_ranking: pending` in CASEBOOK.yaml | a ranking · decline |
| precedent | a `conflict:` pair, or three or more `distinguished_by` | overrule · keep · reconcile |
| drift resolution | DRIFTLOG entries in `status: mitigated` | resolve · keep-watching |

Plus zero, one or two **canaries** — realistic items with exactly one planted, checkable flaw, written only as candidates or map proposals, since the other kinds have no decision a flaw could be caught by. The number varies, including zero. Items are shuffled, renumbered `I-1…I-n`, and **carry no ledger ids**: the sealed key is the only mapping from an item to its source.

**Presented** by the main agent under `meta-skill-builder` → Review Batch. While the batch is open the ledger is closed to that session, so the batch file is the whole of what it can see.

**Closed** with `close-batch.sh B-NNN` once every item carries a decision — any non-empty value, including a ranking such as `[B, A, C]`. It sets `decided: true` without the session reading the ledger.

**Revealed** with `reveal-canaries.sh B-NNN` (M-17). Then the main agent applies decisions to real items only, clears their `review_due`, records `canaries` and `canaries_caught`, and **sets `revealed: true`** — until it does, the stop-gate hands the reveal back every turn.

A canary is **caught** when the pioneer declines or revises it, or when their verdict or reason names the flaw the key records under `shows in:`. Any other decision counts as passed. The judgement is read from the key's own field, not from the agent's impression.

**Every kind has a terminal value**, so a decided item never returns: a declined map entry is written `declined` in MAP.md's status column, a declined card carries `pioneer_ranking: declined`, a kept or reconciled precedent has its `conflict:` cleared, and a resolved drift entry moves to `status: resolved`. An `update`, `retire` or `add` on a contradicting candidate sets `stage: adopt` with `applied_as`, and the edit is made **at the quoted passage only** — never a rewrite of the node. Without those, the assembler would re-present the same items forever and the backlog could never clear.

Batch item format:

```
## I-3
**Kind:** candidate
**Statement:** …
Verdict before evidence:
**Proposed:** adopt — pattern · type-category · target: meta-contract-before-execution
**Evidence:** …
**Certainty:** low (self-generated, single-contract) · **Counters:** helpful 1 independent / 2 loaded, harmful 0 · **Lower bound:** 0.38 · **Stated confidence:** 0.80
**Contradicts:** meta-contract-before-execution/SKILL.md → "A blanket 'looks good' is not a per-clause confirmation." (omit the line when contradicts is empty)
Decision:
Level and tier (for trial, adopt or caution):
Reason:
```

The proposed disposition sits **below** the verdict line: the pioneer's first read is of the statement alone, so the agent's recommendation cannot anchor it.

A decision the pioneer asks for outside a batch is recorded with `batch: direct` on the candidate, clears `review_due` the same way, and is excluded from the canary catch-rate denominator — a direct decision carries no canaries.

## Map proposals, audits and scores

`map_proposals` are written by kit-map-steward and decided at batches; ratified ones are applied to MAP.md by the main agent, declined ones marked `declined`, revised ones set back to `pending` carrying the pioneer's wording so the steward redrafts them. `audits` are written by kit-session-auditor: an outside score of the agent's aspects, the session's own score, their agreement, and evidence-of-form checks.

The consolidator maintains `scores`:

- **per contract** — observations recorded, candidates created, whether the session was audited and the contract verified. This is the denominator the maturity signal needs.
- **canary catch rate** — caught ÷ planted, across batches.
- **Brier scores** — for observers' stated confidence against resolved outcomes, and for the pioneer's decisions read as forecasts: adopt 1.0 · trial 0.7 · hold 0.5 · revise 0.5 · caution 0.2 · decline 0.0. A faded candidate resolves the observer's forecast and contributes no pioneer term. Both are reported with their base rate; a score that merely tracks the base rate has no resolution.

**The pioneer's Brier score is the pioneer's instrument**, ratified by them on 2026-09-12. It is computed and shown to them with its base rate. No agent reads it to route, weight or characterise anything, and no skill conditions on it.

An outcome **resolves** as held when an adopted candidate completes three independent uses, or when ten contracts have touched its target area without an independent harmful sighting; as not held when it is declined, faded, cautioned, or contradicted after adoption. **Adopted candidates keep being cited by id** where they bear (M-29), which is what makes those uses countable; a trial that has neither resolved nor moved after ten contracts in its area is set `review_due` again with `disposition_proposed: hold`, so the pioneer decides whether it is still a trial.

**Maturity is no longer silence.** Fewer candidates per contract means the standard anticipates the work only while process health holds — sessions audited, contracts verified — and canaries are still being caught. A quiet ledger with unaudited sessions and missed canaries is the failure mode that looks like maturity.

## What this skill does not do

- It does not decide what enters the standard; stage moves to trial, adopt, caution and decline are the pioneer's
- It does not load candidates into work outside a trial or an adoption citation
- It does not extract — the ledger, batches, telemetry and sealed keys are one project's evidence, never the next project's
