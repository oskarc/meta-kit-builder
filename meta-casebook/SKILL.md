---
name: meta-casebook
description: Use before drawing a contract's tiers or locking a spec, to check for binding precedents on the situation; when a contract departs from a precedent and must say how the facts differ; and when corrections are clerked into precedents or scenario cards. Governs CASEBOOK.yaml — layer 4, the cases that give the standard's rules their meaning.
---

> **Map:** M-04, M-05, M-26, M-31 · **Load:** retrieved on trigger by moment tag · **Recognise it by:** "we have decided a situation like this before" — or the milestone in REBUILD.yaml has been reached · **Not when:** the question is what the rule says (that is the node) rather than how it was applied

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

### The launch rebuild (M-31)

The reconstruction test turned on the product. At a milestone the pioneer named at install, an agent in an **empty folder** — blind to the original code and its transcripts, with a deny-path on the original repository — builds what `CONTRACT-LOG.yaml` says, reading `DRIFTLOG.yaml` as its list of pitfalls, and the result is measured against the original. It is the one test the kit cannot grade for itself: the original's Tier 4 acceptance tests and the contracts' guarantees score the rebuild, and neither cares who built it.

The plan lives in `REBUILD.yaml`, seeded by bootstrap from `templates/REBUILD.template.yaml` and **frozen** from its `frozen_on` date — written before the first contract, so that what counts as a fair test is decided before anyone knows what got built. Three fields, none of which changes afterwards:

- **milestone** — the event that triggers the rebuild, in the pioneer's words, or `deferred` until they give one.
- **oracle** — every Tier 4 test and every guarantee of every contract, and every drift entry marked hit or avoided. Per entry, the drift log's value becomes testable: a pitfall the rebuild avoided was carried by the record; one it hit was not.
- **arms** — what each rebuilding agent gets: contracts only; contracts + driftlog; both + casebook. A rebuild that matches from contracts alone says the driftlog carried nothing, which is a result worth having.

When the milestone arrives (M-31): run each arm in its own empty folder; score mechanically first; then, and only then, write the prose comparison — what the rebuild lacked that the original had, the residue the records did not carry — and mark it `self_graded: true` when the original builder wrote it. Append each arm to `runs`. A change to milestone, oracle or arms after `frozen_on` is drift (M-18). The mechanics of running an arm are not fixed by this node yet; the freeze is, because it cannot be added later.

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
