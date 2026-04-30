# meta-kit-builder

The base building kit for kit-driven development — a methodology for building standard-driven software systems with AI agents.

Determinism is the aspiration. The proximate goals — accurate, repeatable, and transferable results across contexts and people — are how the kit gets you there. Designed for teams who want to encode their judgment into a transferable standard, so the kit, not the person, becomes the dominant force in what gets built.

---

## What This Is

**Kit-driven development** is a practice for building software with AI agents in a way that is accurate, repeatable, and transferable across contexts and people. Full determinism is the aspiration — these three properties are the load-bearing approximation that makes the practice work today.

The core idea: a developer's judgment — about architecture, information architecture, cognitive load, separation of concerns, design quality — gets encoded into a structured set of skills. An agent operating within that kit produces results that adhere to the standard without the developer needing to guide every decision. The developer becomes an auditor and owner of the standard, not the executor of every system.

`meta-kit-builder` is the repo. The **base building kit** lives inside it — the meta-layer that governs how any kit is built, evolved, and maintained. It is domain-agnostic. You load it first, always, regardless of what you are building.

---

## How It Works

Every implementation starts with a **contract before execution** — a three-tier proposal the agent produces and the developer approves before any code is written:

1. **User scenario** — what the user is trying to accomplish, in plain language
2. **Use cases** — discrete, testable actions derived from the scenario
3. **Technical guardrails** — constraints the implementation must uphold, traceable to the use cases

No code is written without an approved proposal. This eliminates half-implementation, silent assumptions, and drift from the standard.

After implementation, the agent produces a **Standard Evolution Report** — a structured set of classification proposals identifying what the kit should absorb from this session. Each learning is proposed at the right level: principle, pattern, or product detail. The developer decides what enters the standard.

Over time, **the kit builds itself through use**. Gaps surface via post-implementation reports. The standard grows in depth, not just length. The measure of a mature kit is gap frequency approaching zero.

---

## Kit Structure

```
meta-contract-before-execution/
  SKILL.md          — Three-tier proposal, approval gate, Standard Evolution Report

meta-skill-builder/
  SKILL.md          — Abstraction loop for classifying learnings and evolving the standard

meta-manifest/
  SKILL.md          — Governance, precedence rules, update protocol
  MANIFEST.yaml     — Node registry, coverage map, gap queue, kit identity
```

All skills follow the naming convention `[layer]-[name]/SKILL.md`. The folder carries layer identity. The file is always `SKILL.md` for loader auto-discovery. The manifest `skill_file` field uses the joined form: `pattern-foo/SKILL.md`.

Layer prefixes:
- `principle-` — transferable rules about why something works
- `pattern-` — reusable structural decisions for recognisable contexts
- `implementation-` — stack-specific, mechanical constraints
- `meta-` — skills that govern the kit itself

---

## Precedence

The base building kit takes precedence over all other skills, instructions, and project-specific guidance. When a conflict arises, adhere to the base kit and surface the conflict explicitly — never resolve it silently.

Precedence order:
1. Base building kit
2. Type-category kit (domain-specific, built through use)
3. Project instructions (product knowledge, one-off context)
4. Session input (what the developer adds in the current prompt)

---

## Building With the Kit

**Starting a new system type:**

1. Load the base kit into your agent environment
2. Fork `meta-manifest/MANIFEST.yaml` as your new kit's manifest — it *is* the template. Update `kit_identity`, clear the base-kit `nodes` and `gap_queue`, and reset the `coverage_map` to the concerns your kit needs to cover.
3. Begin building features using `meta-contract-before-execution`
4. Process each Standard Evolution Report through `meta-skill-builder`
5. New nodes emerge — each one a skill file prefixed by its layer
6. The coverage map fills in. Gap frequency drops. The kit matures.

**When the kit is ready to reuse**, fill the `library_entry` field in `MANIFEST.yaml` and add it to your library. A non-developer with the kit and product knowledge should be able to produce a proposal that requires no flagged gaps and no judgment calls outside the standard.

---

## The Non-Developer Use Case

A mature type-category kit built on this base can be handed to a non-developer. They bring product knowledge. The kit brings the standard. The agent produces a three-tier proposal. The developer audits the proposal — not the code.

This is the long-term goal: **executable judgment**. The developer's accumulated understanding of good software, encoded precisely enough that an agent can act on it without the developer present.

---

## What This Is Not

- A prompt library or collection of reusable snippets
- A replacement for developer judgment — it encodes judgment, it does not substitute for it
- A finished standard — the base kit is intentionally minimal. Type-category kits are built through use, not designed upfront
- A tool that works without discipline — the approval gate and abstraction loop only hold if they are respected

---

## Status

The base building kit is at **v0.4** — actively used and evolving. Type-category kits are in early development, being built through use as described.

Contributions, forks, and field reports welcome.
