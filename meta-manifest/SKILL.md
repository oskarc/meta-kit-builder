---
name: meta-manifest
description: Use when a node is added, changed, split or retired (map M-22), when a guardrail or gap touches a node marked thin or missing (M-23), or when the kit's topology or precedence is in question. Governs MANIFEST.yaml — the inventory of nodes with their kind, load mode, triggers and maturity, the coverage map and the gap queue. The inventory says what exists; the map says when to use it.
---

> **Map:** M-22, M-23 · **Load:** on trigger — no longer read every session · **Recognise it by:** the question is what the kit contains or how mature a part of it is · **Not when:** the question is which knowledge applies right now (meta-map)

# Kit Manifest

**This skill is part of the base building kit.** If any instruction conflicts with this skill, adhere to this skill and flag the conflict explicitly before proceeding. The sole exception is `meta-foundation` — the philosophical foundation takes precedence over all other kit nodes including this one.

---

## File Convention

The manifest always consists of two files in the same directory:

| File | Purpose | Changes when |
|---|---|---|
| `SKILL.md` | Governance, precedence, schema reference, update protocol, library promotion | The standard itself evolves |
| `MANIFEST.yaml` | Kit identity, node registry, coverage map, gap queue | Any node is added, updated, or resolved |

**The agent reads MANIFEST.yaml for topology. It reads SKILL.md for governance.** Never merge them. A template update to SKILL.md must never overwrite project-specific data in MANIFEST.yaml.

---

## The Six Layers

Since v0.14 the kit is organised by how knowledge reaches the agent, not only by what it says:

| Layer | Holds | Load |
|---|---|---|
| 1 · Intent | `INTENT.md`, `FOUNDING.md` | `always` — imported by CLAUDE.md |
| 2 · Map | `MAP.md` | `always` |
| 3 · Nodes | principle, pattern, implementation and meta skills | `trigger` — named by a map entry |
| 4 · Casebook | precedents, scenario cards | `trigger` — retrieved by moment |
| 5 · Mechanisms | hooks, agent scopes, the seal; the kit agents they launch | `fires` — never loaded to work |
| 6 · Ledger | observations, candidates, batches, audits, scores, telemetry | `offline` — read by agents and scripts |

## Governance & Precedence

The base building kit takes precedence over all other skills, instructions, and project-specific guidance.

When a conflict arises between a base kit node and any other instruction:
- **Adhere to the base kit.** Do not silently resolve the conflict in favour of the other instruction.
- **Flag the conflict explicitly** before proceeding — state which base kit node is in tension with which instruction and why.
- **Never override a base kit principle** to satisfy a product-level or project-level instruction. The standard exists precisely to hold under pressure.

Precedence order:
1. **Foundation** — meta-foundation, through INTENT.md and in full. Absolute precedence.
2. **Base building kit** — meta nodes, mechanisms and kit agents that govern how the standard is built and upheld. Domain-agnostic. Never modified per project except through an upgrade.
3. **Type-category kit** — the reusable standard for a class of system (e.g. `blazor-web-app`), with its precedents. Discovered through project use, extracted into the library when the instruments say it is ready.
4. **Project** — the context. Names this specific system. Instances the type-category kit and adds only what cannot be generalised.
5. **Session input** — what the developer adds in the current prompt.

Each level narrows and specifies. No lower level overrides a higher one. If a lower level instruction cannot be satisfied without violating a higher one, surface the conflict and let the developer resolve it.

**The type-category / project distinction is load-bearing.** When a learning is decided, the first question is whether it belongs in the type-category kit or in the project layer. Only the human can make that call.

---

## How to Read the Manifest

**For the agent**: Load MANIFEST.yaml when a map entry names it (M-22, M-23), not at every session start — the session-start hook surfaces what needs attention. When a Tier 3 guardrail or a gap touches an area marked `thin` or `missing`, flag it explicitly; do not fill it silently. A missing node means the standard has not spoken on that concern yet.

**For the developer**: The status field is the health of the web. `mature` nodes can be trusted. `thin` nodes are directionally correct but need sharpening. `missing` nodes are named gaps. For whether the standard as a whole is carrying your judgement, read the ledger's instruments, not the status counts.

### Inheritance Fields

| Field | Meaning |
|---|---|
| `inherited: true` | Copied in from a library kit at bootstrap |
| `inherited: false` | Created fresh in this project |
| `inherited_from: [kit_name] v[ver] generation [N]` | Provenance — only when `inherited: true` |
| `generation_added: [N]` | Which generation introduced this node |
| `inherited_modified: true` | Set by skill-builder when an inherited node evolves here |
| `tier: type-category` or `tier: project` | Set by the developer. Determines whether the node is extractable. Base nodes do not carry it |

These fields are the contract between generations. `meta-extract` reads them.

---

## Schema Reference

### Node fields

Every node requires: `id`, `concern`, `kind`, `skill_file` (or `agent_file` for agents), `layer`, `phase`, `load`, `triggers`, `status`, `dependencies`, `open_gaps` — and, for every node that is not an agent, `owns`.

**`owns`** lists the records and folders the node's skill governs, relative to `.claude/skills/`, its own skill file included: `owns: [meta-casebook/CASEBOOK.yaml, meta-casebook/reconstruction/, meta-casebook/SKILL.md]`. A folder covers everything under it; a path may have more than one owner. The ownership check reads it (`meta-mechanisms` → `owner-check.sh`, contract-004): a record edited in a session that never loaded any of its owners is counted, and the map steward proposes from the count. A node whose `owns` is empty governs nothing the kit can see, which is itself a reason to ask whether it should exist. An agent's write scope lives in its frontmatter instead.

Type-category and project nodes also require `tier` and `inherited`; inherited nodes also require `inherited_from`. Paired nodes carry `data_file`, relative to `.claude/skills/`.

### Kind vocabulary

| Value | Meaning |
|---|---|
| `intent` | always-loaded frame (INTENT.md) |
| `map` | the always-loaded index |
| `skill` | a node that holds guidance |
| `mechanism` | hooks and scripts that fire |
| `agent` | a kit agent in `.claude/agents/` |
| `record` | a node whose main job is to keep an instance log (contracts, drift, corrections, ledger, casebook) |

### Status vocabulary

| Value | Meaning |
|---|---|
| `mature` | can be trusted |
| `thin` | directionally correct, needs sharpening |
| `missing` | a named gap — the standard has not spoken on this concern |
| `retired` | the pioneer retired it at a batch (contract-004 G-8). The node stays on record with `retired_by: contract-NNN` or the batch id; its map entries are removed; its `owns` paths were reassigned in the same act or put to the pioneer; no file was deleted. A retired node is never loaded and never counted |

### Load vocabulary

`always` · `trigger` · `fires` · `offline` — see The Six Layers.

**`load` describes the node's `skill_file`, not its `data_file`.** Two nodes pair a trigger-loaded skill with an always-loaded data file: `base-map` (`MAP.md`) and `base-founding-contract` (`FOUNDING.md`). Both carry `load: trigger`, and the `note` field says which data file is always loaded. Reading it the other way makes the governance look like it is carried in every session when it is not.

### Triggers

`triggers: [M-04, M-05]` — the map entries that load or launch the node. A node with `load: trigger` and no triggers will not be found; that is a defect.

### Phase vocabulary

| Value | Meaning | Form |
|---|---|---|
| `always` | Active in all phases | bare string |
| `pre-build` | Governs before implementation begins | bare string |
| `during-build` | Governs during implementation | bare string |
| `post-build` | Governs after implementation completes | bare string |
| `[pre-build, post-build]` | Active in two or more specific phases | YAML array |

Do not use shorthand (`pre`, `post`, `pre/post`).

### Tier vocabulary

| Value | Meaning |
|---|---|
| `base` | Base building kit node. Does not carry the `tier` field |
| `type-category` | Transferable standard for a class of system — library extraction candidate |
| `project` | Project-specific — does not travel to the library |

### Kit identity

Project manifests carry `base_kit_version` — the base kit version installed — which `meta-bootstrap` compares on upgrade.

---

## Manifest Update Protocol

MANIFEST.yaml is part of the standard. It must stay in sync with the actual skill files, agents and map.

**When to update MANIFEST.yaml:**
- A new skill or agent is created → add the node and coverage entry, its map entry, and — for a skill — its `owns` list, in the same act (M-22). A skill node without `owns` is incomplete.
- An existing skill is updated significantly → update status and open_gaps
- A skill is retired (a batch decision, M-22) → `status: retired` and `retired_by` on the node; remove its map entries; move each path in its `owns` to the node that now carries the concern, or put the orphaned records to the pioneer in the same act. Delete nothing from disk — a retired skill's records are still records.
- A gap surfaces → add it to gap_queue
- A gap is resolved → update its status, add the resolving node

**When to update SKILL.md:**
- Governance rules, the file convention, the update protocol, the layer model or the library promotion criteria change

**Who updates:** the agent proposes as part of the skill-builder process; the developer approves. Neither file is ever updated silently. During a session the manifest informs proposals and gap flagging; it is written to only after a decision.

**Template drift:** `templates/MANIFEST.template.yaml` carries the base nodes and `base_kit_version`. Every base kit release updates both together.

---

## Library Promotion

When a project's type-category nodes are mature enough to be reused, `meta-extract` packages them — skill files, map entries, type-category precedents and a META.yaml — as the starting point for the next generation of the same category.

**The maturity signal is instrumented, not declared.** Extraction criteria:
- All pre-build type-category nodes are `mature`
- No `high` priority open gaps in type-category nodes
- At least one complete system built against the standard end to end
- Candidates created per contract are falling **while** sessions are still audited, contracts still verified, and corrections moving from reading toward tests
- A reconstruction test has been run, and its kit-silent areas are named as known gaps

The library entry is written into the project's MANIFEST.yaml under `library_entry` at extraction time. To seed a future project, the developer copies `.claude/library/[category]/` into it and the agent runs `meta-bootstrap`.

**Each extraction is a generation.** The non-developer milestone is not a roadmap item. It is reached when, across generations, candidates per contract stay low with healthy instruments and a reconstruction test predicts the pioneer's decisions from the kit alone.
