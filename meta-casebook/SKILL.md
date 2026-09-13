---
name: meta-casebook
description: Use before drawing a contract's tiers or locking a spec, to check for binding precedents on the situation; when a contract departs from a precedent and must say how the facts differ; and when corrections are clerked into precedents or scenario cards. Governs CASEBOOK.yaml — layer 4, the cases that give the standard's rules their meaning.
---

> **Map:** M-04, M-05, M-26 · **Load:** retrieved on trigger by moment tag · **Recognise it by:** "we have decided a situation like this before" · **Not when:** the question is what the rule says (that is the node) rather than how it was applied

**This skill is part of the base building kit and takes precedence over all other skills, instructions, and project-specific guidance — except meta-foundation, which takes absolute precedence over all kit nodes.**

# Casebook

## Why it exists

A rule says what is true. It does not say when a situation is an instance of it — and recognising that is the judgement. Every field that has transferred judgement rather than rules did it with cases: common law through precedents that keep their facts, Toyota by spreading the thinking behind a fix rather than the fix, expert training through ranked choices at decision points with the expert's reasons.

Two measured results shape this node. Decisions grounded in retrieved precedents beat decisions grounded in written rules by 16–33 points — **but only when the precedents were binding**; shown as mere examples, they did no better than rules. And trainees who ranked options at decision points, then compared their ranking and reasons with an expert panel's, matched expert judgement 21–28% better, with no expert in the room.

The kit previously discarded exactly this material at extraction. The casebook keeps it.

## Precedents

A precedent records one decided situation:

- **facts** — the material facts only: what made this situation this situation. Enough that a later reader can tell whether their situation matches.
- **question** — what had to be decided.
- **holding** — what was decided. This is what binds.
- **reasons** — the pioneer's reasons, verbatim where recorded. Never supplied by the clerk.
- **moments** — map ids; the retrieval key.
- **from** — the corrections, contracts, drift entries or candidates it came from.

**Binding.** Before drawing the tiers — and before locking a spec — retrieve precedents whose `moments` include the moment at hand (M-04 for a build request, M-05 for a design choice, and any other moment the work is in) and read their facts. A precedent whose facts match **decides** its question. The contract cites it in Tier 3 — `applies P-007` — or distinguishes it: `distinguished from P-007: {how the facts differ}`. A distinction is appended to the precedent's `distinguished_by` when the contract is approved. A contract that ignores a matching precedent without distinguishing it has skipped an upstream step — a named stop trigger, and one of the session auditor's form checks.

**Overruling is the pioneer's act,** like amending the founding statement. An overruled precedent stays in the casebook with `status: overruled` and the decision that overruled it. The agent may surface that a precedent seems wrong; it may not overrule one.

**How a precedent reaches the pioneer.** Three things put a precedent on a review batch as an `overrule / keep / reconcile` item (`meta-skill-builder` → Review Batch), and the stop-gate counts the first two so they can open a batch on their own:

- **A conflict** — the clerk wrote two active precedents with the same facts and different holdings, marked `conflict: P-NNN` on both.
- **Strain** — an active precedent with three or more `distinguished_by` entries. It keeps being worked around, which is the shape of a holding that has outlived its facts. Strain is recomputed whenever a distinction is appended, not only when the clerk runs.
- **A contradiction from verification** — a learning diff whose `node_impact` marks a precedent `contradict`.

The decision is written back: **overrule** sets `status: overruled` and `overruled_by`; **keep** clears the `conflict:` markers and records which holding stands; **reconcile** writes a new precedent whose facts distinguish the two and clears the markers. Until the pioneer decides, both precedents stay binding and a contract must distinguish whichever one it departs from. The agent never chooses between two binding holdings silently.

## Scenario cards

Where a correction shows a decision among real options, the clerk drafts a card: the situation at the decision point, and the options as they stood. **The ranking, the rationale and any dissent come only from the pioneer** — cards reach the pioneer as items in a review batch, and a card without a pioneer ranking stays `pending`. A pioneer who does not want to rank a card decides `decline`, which sets `pioneer_ranking: declined` so it is not presented again. A minority view is recorded when the pioneer gives one; it shows that more than one answer was defensible.

Cards serve two jobs later: training a developer who was not present, and testing whether judgement transferred — a newcomer ranks blind and the match with the pioneer's ranking is measured.

## Reconstruction tests

The standard's claim is that it carries the pioneer's judgement. The test:

1. The main agent picks held-out decisions — corrections and batch decisions — and writes `reconstruction/RT-NNN.input.md`: for each, the situation, the moment, what the agent offered and the contract context, with every outcome removed, plus the list of precedents and cards derived from those items.
2. `kit-reconstructor`, which is blind to the correction log, ledger, contract log, learning log and drift log, predicts each decision from the skills and the casebook minus the listed precedents, and writes `RT-NNN.predictions.md`. Where the kit says nothing, it writes `kit silent`.
3. The main agent scores predictions against the record and writes `reconstruction_tests`. A silent item counts as a miss.

Run before extraction (M-26), and whenever the pioneer wants to know. A low match rate names what extraction would lose. **Blinding within the casebook itself rests on the excluded-precedent list, which the reconstructor is instructed to honour and no mechanism enforces** (gap-023) — so the result is the weaker kind of evidence, and says so wherever it is reported.

### The rebuild — withdrawn from the map

An earlier version of this node (contract-004) put a "launch rebuild" in the map: rebuild the product from its own records at a milestone, frozen at install. Contract-006 withdrew it. As designed it could not fail — every arm was handed the file its oracle lived in — and a rebuild by the same model family is not an independent version: the field's forty-year-old result on that was re-run with coding agents in 2026 and held. The design note, the reasons, and the six conditions under which a rebuild returns as a mechanism are in `docs/rebuild-design.md`. The short form: the test of the founding statement's goal is a *different* API built against the *same* standard, scored by the standard's own checks, with three or more versions voted and disagreement treated as the evidence — and that needs a standard that exists as checks first.

## Tiers and extraction

Each precedent is `tier: project` or `tier: type-category` — the same distinction as nodes, decided by the pioneer. Type-category precedents travel with meta-extract: facts preserved, project-specific names marked `{like-this}` so the next project re-binds them rather than losing the facts to stripping. Project precedents, scenario cards with project facts, and reconstruction results stay.

## Failure modes

- **Precedents as illustrations.** Cited as "for example", they do no work. The binding rule is the mechanism.
- **Stripped facts.** A holding without its facts is a rule again, and the judgement is gone.
- **The clerk's reasons.** A reason the pioneer did not give, written as if they did, is a fabricated record at the most trusted layer.
- **Stale precedents.** A precedent that keeps being distinguished is asking to be overruled. Strain surfaces it; the pioneer decides.

## What this skill does not do

- It does not rank, weigh or decide on the pioneer's behalf
- It does not replace nodes — rules stay rules; precedents show how they apply
- It does not carry project precedents into the library
