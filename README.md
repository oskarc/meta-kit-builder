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

```
meta-foundation/
  SKILL.md          — Philosophical foundation, governing aspects, human and agent roles

meta-contract-before-execution/
  SKILL.md          — Three-tier proposal, approval gate, Standard Evolution Report

meta-skill-builder/
  SKILL.md          — Abstraction loop for classifying learnings and evolving the standard

meta-manifest/
  SKILL.md          — Governance, precedence rules, update protocol
  MANIFEST.yaml     — Node registry, coverage map, gap queue, kit identity
```

### Load Order

An agent starting a session loads in this order:

1. `meta-foundation/SKILL.md` — absolute precedence, orients the agent to the work and the human
2. `meta-manifest/SKILL.md` + `MANIFEST.yaml` — governance and topology
3. `meta-contract-before-execution/SKILL.md` — build loop
4. `meta-skill-builder/SKILL.md` — evolution loop

### Naming Convention

All skills follow `[layer]-[name]/SKILL.md`. The folder carries layer identity. The file is always `SKILL.md` for loader auto-discovery. The manifest `skill_file` field uses the joined form: `pattern-foo/SKILL.md`.

Layer prefixes:
- `principle-` — transferable rules about why something works
- `pattern-` — reusable structural decisions for recognisable contexts
- `implementation-` — stack-specific, mechanical constraints
- `meta-` — skills that govern the kit itself

---

## Precedence

1. **Foundation** — `meta-foundation` governs what this work is and how the agent orients to the human. Absolute precedence.
2. **Base building kit** — meta skills that govern how the standard is built and upheld
3. **Type-category kit** — domain-specific nodes for the current assignment type
4. **Project instructions** — product knowledge, specific constraints, one-off context
5. **Session input** — what the developer adds in the current prompt

When a conflict arises, adhere to the higher level and surface the conflict explicitly — never resolve it silently.

---

## Building With the Kit

**Starting a new system type:**

1. Load the base kit into your agent environment
2. Read `meta-foundation` — understand what you are participating in before any other step
3. Create a `MANIFEST.yaml` for your new kit, forked from the base template
4. Begin building features using `meta-contract-before-execution`
5. Process each Standard Evolution Report through `meta-skill-builder`
6. New nodes emerge — each prefixed by layer, each added to the manifest
7. The coverage map fills in. Gap frequency drops. The kit matures.

**When the kit is ready to reuse**, fill the `library_entry` field in `MANIFEST.yaml`. A non-developer with the kit and product knowledge should be able to produce a proposal that requires no flagged gaps and no judgment calls outside the standard.

---

## The Non-Developer Use Case

A mature type-category kit built on this base can be handed to a non-developer. They bring product knowledge. The kit brings the standard. The agent produces a three-tier proposal. The developer audits the proposal — not the code.

This is the long-term goal: **executable judgment**. The developer's accumulated understanding of good software, encoded precisely enough that an agent can act on it without the developer present.

The pioneer's ultimate task is to encode their judgment into the standard completely enough that the standard can sustain itself — so that a developer who was not present for the discovery can work within it at the same quality as the one who built it.

---

## What This Is Not

- A prompt library or collection of reusable snippets
- A replacement for developer judgment — it encodes judgment, it does not substitute for it
- A finished standard — the base kit is intentionally minimal. Type-category kits are built through use, not designed upfront
- A tool that works without discipline — the governing aspects and approval gate only hold if they are respected
- A solo endeavour — the human's presence in the work is not optional. It is what makes the standard rise rather than drift

---

## Status

The base building kit is at **v0.5** — actively used and evolving. Type-category kits (Blazor web app, integration API, and others) are in early development, being built through use as described.

Contributions, forks, and field reports welcome.
