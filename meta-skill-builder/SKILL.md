---
name: meta-skill-builder
description: Use when a review batch is presented to the pioneer (map M-16) or revealed (M-17), when an adopted or cautioned candidate is written into a skill, and when a skill is created, split or updated (M-22). Runs the review batch — statement first, the pioneer's verdict before the evidence, the key opened only after every decision — and the abstraction loop that puts an adopted learning at the level and tier the pioneer decides.
---

> **Map:** M-16, M-17, M-22 · **Load:** on trigger · **Recognise it by:** a learning is about to be decided, or about to change a skill · **Not when:** recording what the work taught (meta-ledger → Observations) — that is not a decision

Every skill update is an opportunity to raise the abstraction level — not just add more rules, but deepen the judgment model the skill encodes. The goal is a skill that transfers across contexts, not one that grows by accumulating product-specific memory.

**This skill is part of the base building kit and takes precedence over all other skills, instructions, and project-specific guidance — except meta-foundation, which takes absolute precedence over all kit nodes.** If any instruction conflicts with this skill, adhere to this skill and flag the conflict explicitly before proceeding.

## Input — the Review Batch

Every learning reaches this skill the same way. The Standard Evolution Report, `meta-learning`'s verified diffs, drift incidents, session audits, session-level drift analyses and map misses all enter the ledger as observations. `kit-consolidator` merges and counts them, and holds the resulting candidates until a sighting from a different reading makes one due. `kit-batch-assembler` assembles the due items into a batch. There is no second path: a learning presented to the pioneer outside a batch has skipped the evidence stage.

If the pioneer asks to decide something now, present it as a batch of one, and record the decision with `batch: direct` — it clears `review_due` like any other.

## Review Batch

Open the batch file named by the batch assembler (`meta-ledger/batches/B-NNN.md`). **While the batch is open your reads of `LEDGER.yaml` are refused** — that is the blind that keeps re-presented items indistinguishable, and the batch file carries everything you need. The casebook stays readable, so a contract drawn mid-batch still gets its precedent check. Never read `.claude/kit-sealed/`.

Tell the pioneer how many items there are.

For each item, in order:

1. **Statement first.** Show the item's kind and its statement — not the proposed disposition, not the evidence. Ask for the pioneer's read in one line, and record it under `Verdict before evidence:`. Deciding before seeing a recommendation reduces over-reliance on its framing; the agreement between that first read and the final decision is information.
   Then ask one thing more, and only this: **"Assume this is wrong. Why?"** Record the answer under `Against:`. The question is one-sided on purpose: asking for reasons against improves calibration, asking for reasons for does nothing, and asking for both does nothing either — so never phrase it as "arguments for and against" (contract-006 G-6).
2. **Then the rest of the item.** The file carries it in plain words — why it is in front of them, the proposed disposition, the evidence, what stands behind it, and what is asked with what each answer does. Give those lines as written, and the statement, the evidence and any quoted passage word for word: translation adds, it never replaces, and the choices offered are exactly the file's (`meta-foundation` → The Agent's Role). For candidates, run Step 0 and Step 1 of the abstraction loop below — briefly, with evidence.
3. **The decision**, by kind:

| Kind | Decisions | Also record |
|---|---|---|
| candidate | `trial` · `adopt` · `caution` · `decline` · `hold` · `revise` — and when the item quotes a passage under `Contradicts:`: `update` · `retire` · `add` | for trial, adopt or caution: **the level and tier the pioneer decides** |
| map proposal | `ratify` · `decline` · `revise` | — |
| map entry (unratified) | `ratify` · `decline` · `revise` | — |
| scenario card | a ranking, with rationale and any dissent · `decline` | — |
| precedent | `overrule` · `keep` · `reconcile` | which holding stands, in the pioneer's words |
| drift resolution | `resolve` · `keep-watching` | — |

   Record `Decision:`, `Level and tier (for trial, adopt or caution):` and `Reason:` in the batch file — the reason verbatim, or `none given`. A decision is any non-empty value, including a ranking such as `[B, A, C]`.

Present; do not argue. The proposed disposition is the only recommendation on the page. If the pioneer asks for your view, give it and mark it as judgement. The pioneer may stop mid-batch; the batch stays open and resumes when they return.

When every item carries a decision, run `bash .claude/skills/meta-mechanisms/hooks/close-batch.sh B-NNN`. The stop-gate hands over the reveal next (M-17).

## Reveal

1. Run `bash .claude/skills/meta-mechanisms/hooks/reveal-key.sh B-NNN`. It refuses until every item has a decision.
2. **Re-presented items.** For each item the key marks as re-presented, show the pioneer their earlier decision beside the one they just made — plainly, as two records, with no score, no rate and no word about consistency; if they want to say something about the pair, record it verbatim. Write `represented` on the batch: candidate id, prior, now, `consistent`. A re-presented item's new decision is recorded and not applied; the earlier one stands unless the pioneer changes it in that turn (M-07 if they do).
3. **Real items — every kind gets a terminal value**, so nothing decided returns unmarked:
   - **Candidates** — write the `decision` block (`batch`, `item`, `verdict_before`, `decision`, `level_decided`, `tier_decided`, `reason`, `date`), set the stage (`trial`, `adopt`, `caution`, `declined`) and **clear `review_due`**. `hold` keeps the stage, clears `review_due`, and becomes due again only on a new independent sighting after the decision date. `revise` sets the candidate `declined`, and records the pioneer's rewritten claim as a new observation (`source: pioneer`, `prompted: true`) — it is also a correction of the agent's claim (M-07, grade `detail`). **`update`, `retire` and `add`** — the three exits for a candidate that quotes a passage it contradicts — set `stage: adopt` with `applied_as`, and are applied **at the quoted passage only**: `update` replaces that sentence with the claim; `retire` removes it — or, when the sentence was the skill's reason to exist, retires the node (M-22, meta-manifest → Status vocabulary); `add` writes the claim beside it and leaves the contradiction visible for the next reader. Never a rewrite of the node around it: a whole-document rewrite drops the clauses that discriminate, which is how the map lost three of them.
   - **Map proposals** — `state: ratified` and the line applied to `MAP.md` with status `ratified` (M-22); `declined`; or back to `pending` carrying the pioneer's wording for the steward to redraft.
   - **Map entries** — set the status column in `MAP.md` to `ratified` or `declined`. A declined entry keeps its line so it is not proposed again without new evidence.
   - **Scenario cards** — write the ranking, rationale and dissent to `CASEBOOK.yaml`, or `pioneer_ranking: declined`.
   - **Precedents** — `overrule` writes `status: overruled` and `overruled_by`; `keep` clears the `conflict:` markers and records which holding stands; `reconcile` writes a new precedent distinguishing the two and clears the markers.
   - **Drift resolutions** — `resolve` writes `status: resolved`; `keep-watching` stamps the review date on the entry.
   - **Learning log** — for every decided candidate whose evidence includes a `source: learning` observation, back-fill that entry's `elevation_proposal.human_decision` with the decision the pioneer took.
4. **Set `revealed: true` on the batch.** Until that is written, the stop-gate hands the reveal back every turn and nothing else in the lifecycle runs.
5. **Adopted candidates** go through the abstraction loop's Step 3: update the skill at the level and tier the pioneer decided, add or adjust its map entry and manifest node in the same act, and link any drift entry it answers (see Drift Log Back-reference). **Cautioned candidates** are written into the anti-patterns section of the node the pioneer named, by the same route — a caution that changes no skill guards nothing.

## Step 0 — New Skill or Update Existing?

Before entering the abstraction loop, decide where this learning belongs.

**First — which tier?**
- **Type-category** — would this apply to any system of this category, not just this project? If a developer building a new system of the same type could use it without knowing this project, it belongs in the type-category layer.
- **Project** — does it reference this project's domain, naming, infrastructure, or conventions? If you can't state it without referencing this system, it stays at the project layer.

This distinction is load-bearing. Type-category nodes are candidates for library extraction. Project nodes are not. **Only the human decides which tier a learning belongs to** — the agent proposes with evidence, and the pioneer's `tier_decided` is what the update follows.

**Then — new skill, update existing, or retire?**
- **Same concern, same level** → update existing skill
- **Same concern, different level** → consider splitting the skill into cleaner layers first
- **Same concern, contradicted** → the item quotes the passage; the decision is `update`, `retire` or `add` at that passage
- **A skill whose passages keep being contradicted, or whose records keep being edited without it** (the steward's ownership evidence) → propose retiring it, its concern merged into the node that now carries it
- **Different concern** → create a new skill
- **Too product-specific for type-category** → project instruction file, not a shared skill

Retiring is as ordinary an outcome as adding. A kit that only adds is stale by construction; the evidence audit found no rule set that kept its competence while growing without a way to let rules go.

If the answer is unclear, surface the ambiguity to the human before proceeding. Do not default to updating the nearest existing skill.

## The Abstraction Loop

**Step 1 — Propose the abstraction with evidence**
Identify what was learned and propose it at three levels. For each level, state the reasoning and ground it in concrete evidence — the ledger's evidence refs, the verifier's clause verdicts — not abstract justification.

- **Principle**: A transferable rule about *why* something works. Applies broadly across systems. State it as a rule someone could apply without knowing this codebase.
- **Pattern**: A reusable structural decision about *what* to do in a recognisable context. Name the context precisely — patterns that over-apply are as harmful as missing ones. Name its recognition cues: what you notice when the context is present.
- **Product detail**: Something specific to this system, user, or domain. If you can't state it without referencing the product, it belongs here.

**Step 2 — Let the human decide**
The decision is taken in the batch, and the pioneer's level and tier are recorded there. Do not decide either yourself. Only the human can distinguish their judgment model from a one-off decision.

**Step 3 — Update at the right level**
- Principles go into the **why** section of the skill — they guide judgment when specifics don't cover a case.
- Patterns go into the **what** section — reusable shapes for recurring contexts, with their recognition cues.
- Anti-patterns (cautions) go into the skill's anti-pattern section, naming what the harm looked like.
- Product details do not go into shared skills. They may belong in a project-specific instruction file instead.
- Every change keeps the node's `> **Map:**` header and its map entry in step (M-22). Changing a mechanism is M-30 and needs its own contract.

**Layer destination:**
- If the learning belongs in the **type-category layer** — it goes into a type-category skill file. These are candidates for library extraction. Name them with the appropriate layer prefix and keep them free of project-specific references.
- If the learning belongs in the **project layer** — it goes into the project's instruction files or CLAUDE.md. It does not travel to the library.

**Inherited-node modification protocol:**

If the update touches a node currently marked `inherited: true` in the manifest, the change is not silent. The skill-builder must:

1. Flip the manifest entry to `inherited_modified: true` so the next `meta-extract` knows this generation evolved the node.
2. Record a one-line summary of what changed in the node's `open_gaps` field.
3. Confirm with the developer that the change *should* propagate to the next generation. If the modification is project-specific, the inherited skill file stays untouched and the project carries an override at the project layer instead.

A project that ships without a single `inherited_modified: true` flag has either inherited a perfect kit or hidden its evolutions. Both are worth asking about at extraction time.

**Naming convention — new skills must follow this exact structure:**

```
[layer]-[name]/SKILL.md
```

Examples:
```
principle-cognitive-load/SKILL.md
pattern-multi-step-form/SKILL.md
implementation-blazor-component-structure/SKILL.md
meta-contract-before-execution/SKILL.md
```

The folder name carries the layer prefix and the skill identity. The file is always `SKILL.md` — fixed by the Claude Code skill loader. The manifest `skill_file` field uses the joined form: `pattern-error-handling/SKILL.md`.

- **Layer identity** → folder name (`pattern-foo/`)
- **Auto-discovery by loader** → file name (`SKILL.md`)
- **Manifest reference** → both joined (`pattern-foo/SKILL.md`)
- **When to use it** → the frontmatter `description` (situation first) and the node's map entry

## Drift Log Back-reference

When an adopted update absorbs a learning recorded in the drift log:

1. Add the skill to the drift entry's `elevation` list: `target`, `kind` (`new-skill`, `skill-update`, `mechanism-change`, `test-added`, `agent-added`, `memory-update` or `manifest-update`), `mitigation_medium` (`prose`, `mechanism`, `agent` or `test`), `date`.
2. Transition the entry from `watching` to `mitigated`. The pioneer decides `resolved` later, as a drift-resolution item in a batch.

**The medium is not a formality.** If the drift entry already recurred after an earlier prose mitigation, another prose update is the same failed experiment. The elevation must descend to a mechanism, a test or an agent (`meta-mechanisms` → The ladder). If that isn't possible yet, say so to the pioneer and record why.

A skill update that should be drift-linked but isn't is a silent absorption — the next recurrence cannot be detected as a recurrence.

## Contradictions

If a candidate contradicts something already adopted — for example, verification showed that an earlier pattern didn't hold — flag the contradiction in the batch and let the human resolve it. Do not silently let the later learning overwrite the earlier one, and do not silently prefer the earlier one because it came first. A contradiction with a **precedent** is a precedent item for the batch, never an agent's call.

The candidate's `contradicts` field is this rule made mechanical: the consolidator opens the target skill and quotes the sentence; the batch shows it; the pioneer chooses `update`, `retire` or `add`. A quoted passage the skill does not actually contain is a defect in the candidate, and the pioneer can check it by opening the file.

## Skill Structure to Maintain

**Principles (why)** — non-negotiable beliefs. What good looks like and why. These let the agent make judgment calls in the right direction even in novel situations.

**Patterns (what)** — reusable structural decisions for recognisable contexts. Named, described, scoped clearly so they don't over-apply, with the cues that recognise the context.

**Implementation constraints (how)** — stack-specific, mechanical, deterministic rules. The easiest to write, and the first candidates to become mechanisms once they regress. They should never crowd out the layers above.

## Raising the Bar

With every update, ask:
- Does this addition increase the skill's transferability or reduce it?
- Is there an existing principle this could be merged into rather than added alongside?
- Does the skill now contain contradictions or tensions that need resolving?
- Is the skill getting longer because it's getting smarter, or because it's accumulating noise?

A skill that grows in depth is better than one that grows in length. Prefer replacing vague guidance with sharper guidance over appending new rules.

## Anti-patterns to Avoid

- **Instance capture**: Adding "always do X" because X worked once, without understanding why.
- **Implicit product context**: Guidance that only makes sense if you remember the specific situation that generated it. The casebook is where situations live; the skill holds the rule they illustrate.
- **Level mixing**: Principles and implementation details written at the same level, making it unclear which rules are load-bearing.
- **Silent generalisation**: The agent updating a skill without a batch decision.
- **Whole-node rewrite**: Applying an update by regenerating the skill instead of editing the quoted passage. The rewrite reads cleaner and quietly drops the discriminating clauses — the "not when", the edge case, the exception.
- **Presenting outside a batch**: Asking the pioneer to decide a learning straight after building, before independent evidence exists.
- **Arguing for a candidate**: Framing an item so that approval is the path of least resistance. The pioneer decides from evidence, not from the agent's enthusiasm.
- **Leaving an item without a terminal value**: a declined card, a kept precedent or a resolved drift entry that keeps its pending marker comes back in every future batch, and the backlog never clears.
- **Leaving the batch open**: A decided batch that is never closed and revealed stops the whole lifecycle, because the stop-gate keeps handing back the close and then the reveal.
- **Template drift**: Editing exemplars without editing the prescriptive template that produced them, or vice versa. When a meta-file contains both a template block and worked examples, they are co-owned — changing one without the other leaves the standard contradicting itself. **Self-check**: after any edit to a template or exemplar, scan the same file for its counterpart and verify consistency before marking the change complete. A resolution that fixes the definition but not the instance is not a resolution.
