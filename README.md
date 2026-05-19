# meta-kit-builder

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

Kit-driven development requires two things of the human simultaneously:

**Closeness** — deep enough presence in the work to sense when the agent is drifting, when a learning is real versus reactive, when a principle is almost right versus at the wrong level of abstraction entirely.

**Distance** — enough perspective above the work to see the shape of what is emerging, to know when the frame needs correcting, to distinguish a scar from an elevation.

The agent's role is to make its orientation visible at every significant inflection point — not seeking permission, but seeking alignment. The human is a guide and pioneer, not an approver.

---

## The Governing Aspects

Above all principles, patterns, and implementation rules sit four governing aspects. They are not invoked for specific tasks — they are either present or absent, and their absence is what allows drift to begin.

**Lay of the land** — before any hypothesis, establish full scope. The right to narrow is earned by first surveying broadly. Absence looks like: a confident proposal formed before the system has been read.

**Stop when discipline falls** — when reasoning quality drops below the line, work stops. The agent names the state and calls for re-orientation before any next step exists. Absence looks like: continued iteration after the same failure shape has appeared twice.

**Partner as orientation mirror** — the human is a continuous presence in the work, not an endpoint. The agent actively creates conditions for the human to correct the frame, not just approve the output. Absence looks like: the human having to force re-orientation rather than being invited into it.

**Evolution from elevation, not recovery** — learnings are only absorbed into the standard when they represent a reach upward from a position of understanding. Absence looks like: skills that capture what went wrong rather than what good looks like.

---

## How It Works

Every implementation starts with a **contract before execution** — a three-tier proposal the agent produces and the developer approves before any code is written:

1. **User scenario** — what the user is trying to accomplish, in plain language
2. **Use cases** — discrete, testable actions derived from the scenario
3. **Technical guardrails** — constraints the implementation must uphold, traceable to the use cases

No code is written without an approved proposal. This eliminates half-implementation, silent assumptions, and drift from the standard.

After implementation, the agent produces a **Standard Evolution Report** — structured classification proposals identifying what the kit should absorb from this session. Each learning is proposed at the right level — principle, pattern, or product detail — with evidence and reasoning. The developer decides what enters the standard.

Over time, **the kit builds itself through use**. Gaps surface via post-implementation reports. The standard grows in depth, not just length. The measure of a mature kit is gap frequency approaching zero.

---

## Kit Structure

### This Repository (the base building kit)

```
meta-foundation/
  SKILL.md          — Philosophical foundation, governing aspects, human and agent roles

meta-bootstrap/
  SKILL.md          — First-run onboarding — introduces the practice, checks library, establishes authority, creates project manifest

meta-contract-before-execution/
  SKILL.md          — Three-tier proposal, approval gate, Standard Evolution Report

meta-skill-builder/
  SKILL.md          — Abstraction loop for classifying learnings and evolving the standard

meta-extract/
  SKILL.md          — Extracts mature type-category nodes into a portable library artifact at end of project

meta-manifest/
  SKILL.md          — Governance, tier definitions, precedence rules, update protocol
  MANIFEST.yaml     — Node registry, coverage map, gap queue, kit identity (this repo's own manifest)

templates/
  MANIFEST.template.yaml  — Agent-readable template forked by meta-bootstrap for each new consumer project
```

### A Consumer Project After Install

The developer copies the kit folders above into their project under `.claude/skills/`. After `meta-bootstrap` runs, the project looks like this:

```
.claude/
  skills/
    meta-foundation/SKILL.md
    meta-bootstrap/SKILL.md
    meta-contract-before-execution/SKILL.md
    meta-skill-builder/SKILL.md
    meta-extract/SKILL.md
    meta-manifest/
      SKILL.md
      MANIFEST.yaml             — this project's manifest, created by meta-bootstrap
    [type-category skill folders, if a library kit was integrated]
    [project skill folders, as they emerge through use]

  library/                       — only used at startup (bootstrap) and end (extract)
    [kit-type]/                  — extracted kit dropped here by the developer for a future project
      META.yaml                  — kit identity, coverage, known gaps, generation
      [skill files]
```

The `library/` is dormant during normal development. `meta-bootstrap` reads from it once at project start; `meta-extract` writes to it once at project end.

### Load Order

An agent starting a session in a consumer project loads in this order:

1. `meta-foundation/SKILL.md` — absolute precedence, orients the agent to the work and the human
2. `meta-manifest/SKILL.md` + `meta-manifest/MANIFEST.yaml` — governance and topology
3. `meta-contract-before-execution/SKILL.md` — build loop
4. `meta-skill-builder/SKILL.md` — evolution loop

All paths above are relative to `.claude/skills/`. `meta-bootstrap` and `meta-extract` are not in the regular load order — they are invoked deliberately once each, at project start and end respectively.

### Naming Convention

All skills follow `[layer]-[name]/SKILL.md`. The folder carries layer identity. The file is always `SKILL.md` for loader auto-discovery. The manifest `skill_file` field uses the joined form: `pattern-foo/SKILL.md`.

Layer prefixes:
- `principle-` — transferable rules about why something works
- `pattern-` — reusable structural decisions for recognisable contexts
- `implementation-` — stack-specific, mechanical constraints
- `meta-` — skills that govern the kit itself

---

## Getting Started

Add the kit files to your project, then tell your agent:

> "Run meta-bootstrap."

The agent will introduce the practice to you from the foundation, establish the kit as load-bearing in your environment, orient to your project, and create your project manifest. You do not need to read every skill file first — the bootstrap will walk you through what matters before anything else happens.

**The bootstrap will not proceed past each step without your confirmation.** You are being asked to understand what you are participating in before the kit becomes active in your project.

---

## The Kit Lifecycle

Kit-driven development operates across three phases:

**Phase 1 — Discovery**
A new project, no type-category kit exists yet. Every session builds the system and evolves the emerging standard simultaneously. Type-category nodes are discovered, not inherited. The standard grows through use.

**Phase 2 — Maturity**
Through use, the type-category layer separates from the project layer. Nodes graduate from thin to mature. The gap queue shrinks. Standard Evolution Reports produce fewer candidates. The standard is learning to anticipate what it needs.

**Phase 3 — Extraction**
When the reports go quiet, run `meta-extract`. The mature type-category nodes are separated from project-specific nodes and packaged into a portable library artifact. The developer places it in their library. The next project of the same type inherits the maturity of this generation and builds further from it.

**The non-developer milestone** is not a roadmap item. It is reached when the standard has matured enough through generations that reports go silent and the governing aspects are fully encoded. That silence is the measure — not a date, not a feature count.

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

The base building kit is at **v0.7** — actively used and evolving. Type-category kits (Blazor web app, integration API, and others) are in early development, being built through use as described.

Contributions, forks, and field reports welcome.
