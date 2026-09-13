---
name: meta-extract
description: Use when the pioneer judges this project's type-category nodes ready for the library, or when the maturity instruments pass (map M-26). Separates type-category nodes from project nodes, runs a blind reconstruction test, carries the nodes' map entries and type-category precedents with their facts, and produces a portable library artifact with META.yaml.
---

> **Map:** M-26 · **Load:** on trigger · **Recognise it by:** the question is whether this project's standard should seed the next one · **Not when:** a single node is being adopted or updated (meta-skill-builder)

**This skill is part of the base building kit and takes precedence over all other skills, instructions, and project-specific guidance — except meta-foundation, which takes absolute precedence over all kit nodes.** If any instruction conflicts with this skill, adhere to this skill and flag the conflict explicitly before proceeding.

---

## What This Skill Does

Reads the project's manifest, separates type-category nodes from project-specific nodes, tests whether the standard actually carries the pioneer's judgement, and produces a clean extraction folder the developer can add to their library: the skill files, their map entries, the type-category precedents that show how the rules were applied, and a META.yaml that reports what the instruments found.

The extracted artifact is portable. The developer copies it into a future project's `.claude/library/` to seed the next generation.

**What changed from the rules-only extraction:** a rule stripped of the cases that gave it meaning travels as an assertion. A precedent keeps its facts. Where the old extraction removed project specifics, this one marks them `{like-this}` so the next project re-binds them, and the judgement in the facts survives the trip.

---

## Step 1 — Read and Classify

Read `.claude/skills/meta-manifest/MANIFEST.yaml`. For every node that is not a base kit node, classify it by combining two signals:

**Inheritance state** (from the manifest itself):
- `inherited: true, inherited_modified: false` — came from a previous generation and was not touched here. Passes through unchanged.
- `inherited: true, inherited_modified: true` — came from a previous generation and evolved here. Carries forward with the modifications absorbed.
- `inherited: false` — created fresh in this project. Eligible for promotion only if it is type-category material.

**Tier** (the human decides for any node the manifest does not already settle):
- **Type-category candidate** — applies to any system of this category, and would be useful to a developer building a new one who has never seen this project.
- **Project-specific** — references this project's domain, naming, infrastructure, or conventions. Stays here.

Then classify **precedents** in `CASEBOOK.yaml` the same way. A precedent is a type-category candidate when its facts, with project names marked as bindings, would still decide a situation in another system of this category.

Present the classification:

> **Inherited, unchanged:** [nodes]
> **Inherited, modified:** [nodes, one line each on what changed]
> **New — type-category candidates:** [nodes, one line of evidence each for why they transfer]
> **New — project-specific:** [nodes, one line each for why they don't]
> **Precedents — type-category candidates:** [P-ids, one line each]
> **Uncertain:** [nodes and precedents that need your call]
>
> Does this classification look right? Correct anything before I proceed.

Wait for confirmation or correction. Record corrections (M-07).

---

## Step 2 — Assess Maturity with the Instruments

Silence alone is not evidence. Report what the instruments show:

> **Nodes**
>
> | Node | Status | Open gaps |
> |---|---|---|
> | [node-id] | [mature/thin] | [count and summary] |
>
> **Process health**, from `LEDGER.yaml → scores`, over the most recent contracts:
> - candidates created per contract: [trend]
> - sessions audited: [share] · contracts verified: [share]
> - corrections from tests vs from reading, per contract: [trend]
> - cost per contract: [trend]
>
> **Reading:** [a falling candidate rate while audited and verified shares hold and corrections move from reading toward tests — or which instrument does not hold. Nothing here scores the pioneer.]

Thin nodes extract flagged as thin. Open gaps carry into `known_gaps`.

## Step 2b — Reconstruction Test

Run the test defined in `meta-casebook/SKILL.md` → Reconstruction tests:

1. Hold out a set of this project's recorded decisions — corrections and batch decisions — spread across the type-category nodes' areas. Write `.claude/skills/meta-casebook/reconstruction/RT-NNN.input.md` with every outcome removed, and list in it the precedents and scenario cards derived from those decisions, which the test must ignore.
2. Launch `kit-reconstructor` with the test id. It is blind to the records that hold the answers.
3. Score its predictions against the record and write `reconstruction_tests`.

Present:

> **Reconstruction RT-NNN:** [matched] of [tested] decisions predicted from the kit alone; [n] kit-silent.
> **Where the kit was silent or wrong:** [areas]

Kit-silent and mispredicted areas become `known_gaps`. Ask the developer whether to extract now or strengthen those areas first. Wait for the answer.

---

## Step 3 — Determine Generation

The generation is the project manifest's `kit_identity.library_kit.generation` plus one when a library kit was integrated at bootstrap; otherwise this is generation 1. Cross-check against `inherited_from` on inherited nodes.

> This will be generation [N] of the [category] kit.
> [If N > 1]: The previous generation came from [kit_name version]. This extraction absorbs [count] modifications and [count] new type-category nodes.

---

## Step 4 — Produce the Extraction

Write the extraction to `.claude/library/[category]/`. Do not overwrite an existing extraction without developer confirmation.

**4a — Prepare the stripped skill files, in memory**

For every node that travels — passed-through inherited, modified inherited, and newly promoted type-category:
- Replace project-specific references with bindings — `{entity}`, `{service-name}` — where the surrounding guidance depends on them. Remove them only where nothing depends on them.
- Keep all structural guidance, principles, patterns, implementation rules, recognition cues and the `> **Map:**` header.
- If removing a reference leaves a gap, flag it rather than papering over it.

**4b — Prepare the precedents, in memory**

For every type-category precedent: keep facts, question, holding and reasons; mark project names as bindings; keep the ids of the corrections and contracts it came from as provenance only — those records do not travel.

**4c — Present every diff, grouped by layer, with one approval gate**

1. `principle-*` skills
2. `pattern-*` skills
3. `implementation-*` skills
4. precedents

Within each group show each file's diff, its bindings and any flagged gaps. Then ask once:

> I have prepared [N] skill files and [M] precedents for extraction:
> - [count] principle · [count] pattern · [count] implementation · [M] precedents
>
> Bindings introduced: [count] · Flagged gaps: [count or "none"]
>
> Approve all and write to `.claude/library/[category]/`?
> (If any group needs revision, tell me which and I will re-prepare just that group.)

Write nothing until approved. Silent stripping is not allowed; per-file approval is too noisy.

**4d — Write the files**

- the skill files
- `CASEBOOK.yaml` holding only the approved precedents
- `META.yaml`:

```yaml
kit_name: [category]
version: [project manifest version at extraction time]
generation: [N]
extracted_from: [project kit_name]
extracted_date: [today]
category: [category]
base_kit_version: [base kit version this generation ran on]
description: [one sentence — what this standard is for]
status: stable

covers:
  - [concern from node]

known_gaps:
  - [gap description, including kit-silent and mispredicted areas from the reconstruction test]

mature_nodes: [count]
thin_nodes: [count]

map_entries:
  # One line per entry, each naming the node it belongs to so bootstrap can renumber the ids and update
  # that node's `triggers` and its `> **Map:**` header. A node with two entries gets two lines.
  - node: [node-id]
    line: "M-?? | [moment] | [type] | [channel] | [when] | [not when] | [load] | proposed"

precedents: [count]            # in CASEBOOK.yaml beside this file
bindings: [list of {binding} names the next project must re-bind]

reconstruction:
  test_id: RT-NNN
  decisions_tested: [n]
  matched: [n]
  kit_silent: [n]

instruments:
  candidates_per_contract_recent: [value]
  audited_share: [value]
  verified_share: [value]
  corrections_from_tests_share: [value]

recommended_for:
  - [system types this handles well]

not_recommended_for:
  - [system types outside its scope — be honest]

nodes:
  # Full node list. Each node carries: id, concern, skill_file, kind, layer, phase, load, triggers,
  # status, dependencies, open_gaps — plus origin: inherited-unchanged | inherited-modified | new-in-generation-[N]
```

**4e — Update the project manifest**

```yaml
library_entry:
  kit_name: [category]
  version: [version]
  generation: [N]
  extracted_date: [today]
  extracted_to: .claude/library/[category]/
```

---

## Step 5 — Present the Extraction

> Extraction complete. The [category] kit generation [N] has been written to `.claude/library/[category]/`.
>
> **Extracted:** [N] nodes ([count] inherited unchanged · [count] inherited modified · [count] new), their map entries, and [M] precedents
> **Stays here:** [N] project-specific nodes and [K] project precedents
> **Reconstruction:** [matched] of [tested]; kit-silent areas carried as known gaps
> **Bindings the next project must re-bind:** [list]
>
> To use this kit in a new project: copy `.claude/library/[category]/` into the new project at the same path, then let the agent run `meta-bootstrap`. It will integrate the nodes, append the map entries as proposed, and merge the precedents.

---

## Instance Data — Never Extracted

| Pair | Governance travels | Instance does not | Why |
|---|---|---|---|
| meta-manifest | SKILL.md | `MANIFEST.yaml` | regenerated per project by bootstrap |
| meta-drift-eventlog | SKILL.md | `DRIFTLOG.yaml` | specific to one developer + agent collaboration |
| meta-contract-before-execution | SKILL.md | `CONTRACT-LOG.yaml` | this project's features |
| meta-learning | SKILL.md | `LEARNINGLOG.yaml` | this project's contracted-vs-verified outcomes |
| meta-founding-contract | SKILL.md | `FOUNDING.md` | one pioneer's account of one project |
| meta-map | SKILL.md | `MAP.md` | the project's map; node entries travel through `META.yaml → map_entries` |
| meta-ledger | SKILL.md | `LEDGER.yaml`, `batches/`, `telemetry.log` | this project's evidence |
| meta-correction-log | SKILL.md | `CORRECTIONS.yaml` | this pioneer's corrections; precedents drawn from them may travel |
| meta-casebook | SKILL.md | project precedents, scenario cards, `reconstruction/` inputs and predictions | type-category precedents travel re-bound in the library's `CASEBOOK.yaml` |
| meta-mechanisms | SKILL.md and hooks | `.claude/kit-sealed/`, `meta-manifest/INSTALLED.sha1` | sealed keys and the install baseline belong to one project |

Base kit nodes and kit agents are not extracted: they travel with the base kit itself. If a future paired skill is added to the base kit, default to the same asymmetry unless its data file is explicitly stateless governance.

---

## What This Skill Does Not Do

- It does not decide when to extract — that is the developer's judgment call, informed by the instruments
- It does not push to any external registry — the developer places the library folder where they keep it
- It does not modify base kit nodes, mechanisms or agents — only project-discovered nodes and precedents are candidates
- It does not silently strip project references — bindings and gaps are shown
- It does not run the reconstruction test itself — `kit-reconstructor` does, blind to the answers
- It does not extract instance data — see the table above
