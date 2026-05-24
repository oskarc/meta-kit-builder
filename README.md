# base-building-kit

A methodology and base kit for building deterministic, standard-driven software systems using AI agents. Designed for teams who want to encode their judgment into a transferable standard — so the kit, not the person, becomes the dominant force in what gets built.

---

## What This Is

**Kit-driven development** is a pioneering practice. Its output is not a system — it is a **standard of development**, discovered through real work, distilled through discipline, and encoded into a transferable kit that can operate without its author present.

The core idea: a developer's judgment — about architecture, information architecture, cognitive load, separation of concerns, design quality — gets encoded into a structured set of skills. An agent operating within that kit produces results that adhere to the standard without the developer needing to guide every decision. The developer becomes an auditor and owner of the standard, not the executor of every system.

This repo contains the **base building kit** — the meta-layer that governs how any kit is built, evolved, and maintained. It is domain-agnostic. You load it first, always, regardless of what you are building.

---

## The Foundation

Before anything else, read `meta-foundation`. It defines what this work is, what the human's role demands, and how the agent must orient itself to that human.

This is not a rule set. It is the frame within which all rules become operative.

The work rises when human judgment is present and active. It drifts when it isn't. The kit's job is to make the human's presence as effective as possible, and to preserve what that presence produces so it compounds across time. The human is a pioneer and guide — not an approver, not a corrector, not a user of a tool.

---

## The Governing Aspects

Above all principles, patterns, and implementation rules sit ten governing aspects, split between agent and human deliberately. The asymmetry reflects what each can actually do.

**The agent holds five.** *Lay of the land*, *Stop on named triggers*, *Partner as orientation mirror*, *Evolution from elevation*, *Evidence is the work*. These are checkable disciplines the agent can score itself against after every output via `meta-antidrift`.

**The human holds five.** *Exercise judgment*, *Closeness*, *Distance*, *Re-orient*, *Hold the approval gate*. These cannot be encoded — they are what the kit is in service of. The kit can make drift visible. It cannot stop it. The human stops it.

See `meta-foundation/SKILL.md` for the full definition of each aspect, what its absence looks like, and how the two sides interact.

---

## How It Works

Every implementation starts with a **contract before execution** — a three-tier proposal the agent produces and the developer approves before any code is written:

1. **User scenario** — what the user is trying to accomplish, in plain language
2. **Use cases** — discrete, testable actions derived from the scenario
3. **Technical guardrails** — constraints the implementation must uphold, traceable to the use cases

No code is written without an approved proposal. This eliminates half-implementation, silent assumptions, and drift from the standard.

After implementation, the agent produces a **Standard Evolution Report** — structured classification proposals identifying what the kit should absorb from this session. Each learning is proposed at the right level — principle, pattern, or product detail — with evidence and reasoning. The developer decides what enters the standard.

Over time, **the kit builds itself through use**. Gaps surface via post-implementation reports. The standard grows in depth, not just length. The maturity signal is the Standard Evolution Reports going quiet — when sessions produce few or no evolution candidates, the standard has learned to anticipate what it needs.

---

## Kit Structure

This is the base-building-kit repo layout:

```
meta-foundation/
  SKILL.md          — Philosophical foundation, governing aspects, human and agent roles

meta-bootstrap/
  SKILL.md          — First-run onboarding — installs kit, introduces practice, creates project manifest

meta-contract-before-execution/
  SKILL.md          — Three-tier proposal, approval gate, Standard Evolution Report

meta-skill-builder/
  SKILL.md          — Abstraction loop for classifying learnings and evolving the standard

meta-antidrift/
  SKILL.md          — Post-output drift scoring against governing aspects and active skills

meta-antidrift-expand/
  SKILL.md          — Session-level drift analysis, invoked by the human

meta-drift-eventlog/
  SKILL.md          — Governance for the persistent drift log — schema, lifecycle, update protocol
  DRIFTLOG.yaml     — Instance data — one entry per drift incident, cumulative across sessions

meta-extract/
  SKILL.md          — Extracts mature type-category nodes into a portable library artifact

meta-manifest/
  SKILL.md          — Governance, schema, tier definitions, precedence rules, update protocol
  MANIFEST.yaml     — Node registry, coverage map, gap queue, kit identity

templates/
  MANIFEST.template.yaml  — Agent-readable template used by meta-bootstrap to create the project manifest
  DRIFTLOG.template.yaml  — Agent-readable template used by meta-bootstrap to seed an empty drift log
```

### Load Order

An agent starting a session loads in this order:

1. `meta-foundation/SKILL.md` — absolute precedence, orients the agent to the work and the human
2. `meta-manifest/SKILL.md` + `MANIFEST.yaml` — governance and topology
3. `meta-drift-eventlog/SKILL.md` + `DRIFTLOG.yaml` — governance and prior-session drift history; entries in `watching` or `mitigated` status flag aspects the current session should be alert to
4. `meta-contract-before-execution/SKILL.md` — build loop
5. `meta-skill-builder/SKILL.md` — evolution loop
6. `meta-antidrift/SKILL.md` — runs after every output

Invoked explicitly, not loaded continuously:
- `meta-bootstrap` — runs once on first install, not again
- `meta-extract` — run when type-category nodes are ready for extraction
- `meta-antidrift-expand` — run when human requests session-level drift analysis

### Consumer Project Layout

After meta-bootstrap runs, a project using the kit has this structure:

```
.claude/
  skills/
    meta-foundation/SKILL.md
    meta-bootstrap/SKILL.md
    meta-contract-before-execution/SKILL.md
    meta-skill-builder/SKILL.md
    meta-antidrift/SKILL.md
    meta-antidrift-expand/SKILL.md
    meta-extract/SKILL.md
    meta-manifest/
      SKILL.md
      MANIFEST.yaml        ← project manifest created here by bootstrap
    meta-drift-eventlog/
      SKILL.md
      DRIFTLOG.yaml        ← empty drift log seeded here by bootstrap
    templates/
      MANIFEST.template.yaml
      DRIFTLOG.template.yaml
    [type-category nodes discovered through use]
  library/
    [category]/            ← placed here by the developer from their library
      META.yaml
      [skill files]
  CLAUDE.md                ← load order declared here by bootstrap
```

All paths in the kit — bootstrap, extract, manifest — reference this layout. The manifest always lives at `.claude/skills/meta-manifest/MANIFEST.yaml`. The drift log always lives at `.claude/skills/meta-drift-eventlog/DRIFTLOG.yaml`. The library always lives at `.claude/library/[category]/`. Templates always live under `.claude/skills/templates/`.

### Naming Convention

All skills follow `[layer]-[name]/SKILL.md`. The folder carries layer identity. The file is always `SKILL.md` for loader auto-discovery. The manifest `skill_file` field uses the joined form: `pattern-foo/SKILL.md`.

Layer prefixes:
- `principle-` — transferable rules about why something works
- `pattern-` — reusable structural decisions for recognisable contexts
- `implementation-` — stack-specific, mechanical constraints
- `meta-` — skills that govern the kit itself

---

## Getting Started

**1. Copy all kit contents into your project's `.claude/skills/` folder:**

Everything in this repo — all `meta-*/` skill folders and the `templates/` folder — goes directly into `.claude/skills/` in your consumer project.

```
your-project/
  .claude/
    skills/
      meta-foundation/
      meta-bootstrap/
      meta-contract-before-execution/
      meta-skill-builder/
      meta-antidrift/
      meta-antidrift-expand/
      meta-drift-eventlog/
      meta-extract/
      meta-manifest/
      templates/
```

**2. Tell your agent:**

> "Run meta-bootstrap."

Bootstrap will introduce the practice, establish the kit as load-bearing in your environment, orient to your project, and create your project manifest. It will not proceed past each step without your confirmation.

---

## The Kit Lifecycle

Kit-driven development operates across three phases:

**Phase 1 — Discovery**
A new project, no type-category kit exists yet. Every session builds the system and evolves the emerging standard simultaneously. Type-category nodes are discovered, not inherited. The standard grows through use.

**Phase 2 — Maturity**
Through use, the type-category layer separates from the project layer. Nodes graduate from thin to mature. The gap queue shrinks. Standard Evolution Reports produce fewer candidates. The standard is learning to anticipate what it needs.

**Phase 3 — Extraction**
When the reports go quiet, run `meta-extract`. The mature type-category nodes are separated from project-specific nodes and packaged into a portable library artifact. The developer places it in their library. The next project of the same type inherits the maturity of this generation and builds further from it.

**The non-developer milestone** is not a roadmap item. It is reached when the standard has matured enough through generations that reports go silent. That silence is the measure — not a date, not a feature count.

---

## Building With the Kit

**Once installed:**

1. Every feature begins with a three-tier proposal from the agent
2. You approve, redirect, or refine — no code is written until the proposal is accepted
3. Implementation proceeds against the approved proposal
4. The agent produces a Standard Evolution Report after each implementation
5. You decide what enters the standard — and at which tier: type-category or project
6. New nodes emerge, each prefixed by layer, each added to the manifest
7. The coverage map fills in. Gap frequency drops. The kit matures.

**When reports go quiet**, run `meta-extract`. The type-category kit becomes a library artifact. The next project inherits the generation.

---

## What This Is Not

- A prompt library or collection of reusable snippets
- A replacement for developer judgment — it encodes judgment, it does not substitute for it
- A finished standard — the base kit is intentionally minimal. Type-category kits are built through use, not designed upfront
- A tool that works without discipline — the governing aspects and approval gate only hold if they are respected
- A solo endeavour — the human's presence in the work is not optional. It is what makes the standard rise rather than drift

---

## Status

The base building kit is at **v0.9.1** — actively used and evolving.

Contributions, forks, and field reports welcome.
