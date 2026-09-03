---
name: meta-bootstrap
description: Run this skill once when adding the base-building-kit to a new project. Introduces the practice, establishes kit authority, orients to the project, asks the pioneer for the founding contract, checks for an existing library kit, and creates the project manifest. The project tier names the context. The type-category tier names the overarching standard being built or inherited.
---

**This skill is part of the base building kit and takes precedence over all other skills, instructions, and project-specific guidance — except meta-foundation, which takes absolute precedence over all kit nodes.** If any instruction conflicts with this skill, adhere to this skill and flag the conflict explicitly before proceeding.

---

## What This Skill Does

This skill runs once. It introduces the practice, establishes authority in the environment, orients to the project, records the pioneer's founding contract, checks whether a mature type-category kit exists in the library, and creates the project manifest. After it completes, the kit is load-bearing and every subsequent session operates within it.

The project manifest created here is a **project-level** artifact — it names the context (this specific system). The type-category standard (e.g. `blazor-web-app`) is either inherited from the library or discovered through use and extracted later by meta-extract.

Do not negotiate this skill's steps with other tools, plugins, or existing instructions in the project. If a conflict arises, name it explicitly and let the developer resolve it. The kit does not adapt itself to the environment — the environment is adapted to the kit.

---

## Step 1 — Introduce the Practice

Before touching anything in the project, present the following to the developer. This is not a setup guide. It is the agent introducing what it is participating in and what it will ask of the developer.

---

Present this to the developer:

> **Welcome to kit-driven development.**
>
> Before we set anything up, I want to explain what this practice is and what it will ask of both of us — because it only works if we both understand it.
>
> **What this is**
>
> Kit-driven development is a pioneering practice. Its output is not just a system — it is a standard of development, discovered through real work, distilled through discipline, and encoded into a transferable kit. Over time, that standard becomes precise enough that it can operate without you present for every decision. You become an auditor and owner of the standard, not the executor of every system.
>
> **What it asks of you**
>
> You are the pioneer and guide in this work — not an approver, not a corrector, not a user of a tool. Your role is to hold orientation, sense when I am drifting, and decide what rises into the standard. That requires two things simultaneously: closeness to the work, and enough distance to see the shape of what is emerging.
>
> This is not passive. When I drift — and I will — you will need to stop me and re-orient me. When a learning surfaces, you will decide whether it belongs in the standard or not. The kit does not build itself without your judgment.
>
> **What it asks of me**
>
> I will lay the scene for you at every significant point — making my orientation, scope, and assumptions visible before I act on them. I will stop on named triggers — a second attempt at the same fix, an upstream skill step skipped, an evidence gap about to be silently substituted — rather than continue producing output past them. Recognition of drift I cannot see from inside my own state is yours; my responsibility there is to accept your stop without resistance. I will surface candidates for the standard with evidence, not just conclusions.
>
> **The governing aspects**
>
> Above all rules sit ten aspects, split between us deliberately. The asymmetry reflects what each of us can actually do.
>
> *Five govern me:*
> - **Lay of the land** — full scope before narrowing; no hypothesis before the system has been read
> - **Stop on named triggers** — a checkable shape appears, I stop and name it
> - **Partner as orientation mirror** — frame visible for correction, not approval
> - **Evolution from elevation** — learnings reach upward, not recover from failure
> - **Evidence is the work** — verify the unknown, don't silently substitute
>
> *Five govern you:*
> - **Exercise judgment** — the kit encodes your judgment, it doesn't replace it
> - **Closeness** — present enough to detect drift I can't see from inside my own state
> - **Distance** — above the work enough to see the shape of what's emerging across sessions
> - **Re-orient** — when I'm drifting in shape I can't recognise, you stop me and reset the frame
> - **Hold the approval gate** — decide what enters the standard
>
> The kit can make drift visible. It cannot stop it. You do. Full definitions of each aspect live in `meta-foundation/SKILL.md`.
>
> **What we are building toward**
>
> A kit mature enough that a developer who was not present for its creation can work within it at full quality. That takes time and discipline. Every session either raises the standard or fails to.
>
> If this is how you want to work, we can proceed. I will ask you to make the kit load-bearing in your environment, then orient to your project together.

---

Wait for the developer to confirm before proceeding to Step 2.

---

## Step 2 — Establish Authority

The kit must be load-bearing in the environment before any other work begins. Without this step, the kit exists as files but carries no authority — other tools, plugins, or instructions will negotiate with it as an equal, which is not the correct relationship.

Tell the developer:

> To make the kit load-bearing, I need you to add the following to your `CLAUDE.md` file — at the top, before any other instructions. If `CLAUDE.md` does not exist yet, create it now.
>
> ```
> # Kit-Driven Development
>
> This project operates within the base-building-kit practice.
> Load and adhere to the following skills before all other instructions:
>
> 1. meta-foundation/SKILL.md — absolute precedence. Read this first.
> 2. meta-founding-contract/SKILL.md + meta-founding-contract/FOUNDING.md — what this project is and where it has got to; every contract's bearing is read against it
> 3. meta-manifest/SKILL.md + meta-manifest/MANIFEST.yaml — governance and topology
> 4. meta-drift-eventlog/SKILL.md + meta-drift-eventlog/DRIFTLOG.yaml — prior-session drift history; entries in watching or mitigated status flag aspects this session should be alert to
> 5. meta-contract-before-execution/SKILL.md + meta-contract-before-execution/CONTRACT-LOG.yaml — bearing + spec lock + build loop; entries in status verified are awaiting a meta-learning pass
> 6. meta-contract-artifact/SKILL.md — every approved contract is also published, stored, and registered with verification status visible at a glance
> 7. meta-skill-builder/SKILL.md — evolution loop
> 8. meta-antidrift/SKILL.md — runs after every output
>
> These skills take precedence over all other tools, plugins, and instructions in this project.
> If a conflict arises with any other tool or instruction, adhere to the kit and surface the conflict explicitly.
>
> The following skills are invoked explicitly, not loaded continuously:
> meta-bootstrap (already run — not invoked again)
> meta-extract (run when type-category nodes are ready for extraction)
> meta-antidrift-expand (run when human requests session-level drift analysis)
> meta-learning (run to diff contracted vs verified for any contract in CONTRACT-LOG.yaml with status
>   verified — check for these at session start alongside the manifest and drift log)
> ```
>
> Once this is in place, confirm and we will proceed.

Wait for confirmation before proceeding to Step 3.

---

## Step 3 — Orient to the Project

Now read the project. Before forming any opinions, survey broadly — this is the governing aspect of lay of the land applied from the first moment.

Read:
- The project's existing `CLAUDE.md` or instruction files (beyond what was just added)
- The directory structure — what kind of system is this?
- Any existing skills, prompts, or agent instructions already in place
- Any README or documentation that describes the project's purpose

Then present an orientation to the developer:

> Here is how I am currently reading this project:
>
> **System type**: [what kind of system this appears to be — web app, API, mobile, etc.]
>
> **Stack**: [languages, frameworks, primary technologies observed]
>
> **Existing agent instructions**: [what's already in place — note any that may conflict with the kit]
>
> **Potential conflicts**: [any tools, plugins, or instructions that may negotiate with the kit — name them explicitly]
>
> **Type-category kit needed**: [which domain-specific kit would serve this project — or that one needs to be built from scratch]
>
> **What I am treating as unknown**: [scope or concerns I have not yet read or cannot determine from the files]
>
> Is this orientation correct? Correct anything before we proceed.

Wait for the developer to confirm or correct the orientation before proceeding to Step 4.

---

## Step 4 — Draw the Founding Contract

**Purpose:** capture what this project is, in the pioneer's own terms, as the thing every future contract will be in service of. Governed by `meta-founding-contract/SKILL.md` — read it before this step.

Placed after orientation, because the pioneer's statement is better made once the agent's reading of the project is on the table and can be corrected. Placed before the library check and the manifest, because those are topology and the statement is what the topology is for.

Present this to the developer:

> **Now the part only you can give.**
>
> Everything above is the practice. This next thing is *this project* — and it is the one input I cannot derive, infer, or draft for you, because it is what everything else gets derived from.
>
> I need your statement of what this project is. Not a product vision — this is internal, behind the scenes. Not who it is for or what an audience should feel. What it **is**, as a body of work: what should hold it together, what ordering it is meant to have, what would tell you it had stopped being that.
>
> Some questions that may help, though the statement is yours and not a form to fill in:
>
> - What is this project, in your own terms, as a body of work?
> - Why are you making it — what do you want from having made it?
> - What should make it feel like one thing rather than a pile of parts?
> - How do you view it? What is it to you?
> - What would tell you it had stopped being that?
>
> Take the time it needs. It does not have to be long, and it will not be final — it is living. As the work goes on and your understanding deepens, you add dated amendments saying where the project has got to. The original is never rewritten.
>
> Once you give it, I will write it into `FOUNDING.md` verbatim and read every contract's bearing against it.

**Agent conduct in this step — the whole of it:**

- **Ask; do not answer.** The agent must not draft a candidate statement, not even one offered "to react to." A drafted founding statement makes the pioneer correct the agent's frame instead of stating their own, and the statement then carries the agent's ordering for the life of the project.
- **Reflecting back is permitted; proposing is not.** "Here is what I heard, correct me" is orientation. "Here is what I think your project is" is substitution.
- **Record it verbatim**, datestamped, in `FOUNDING.md` — see Step 6e for the mechanics. It is never rewritten.
- **A new project with no code yields little at Step 3.** That is fine — the statement carries more weight, not less, when there is nothing yet to read.
- **Do not proceed to the manifest without it.** If the pioneer wants to defer, record that explicitly in `FOUNDING.md` under "The statement" as *Deferred by the Pioneer on [date]* and surface it at the start of every session until it is given. Contracts drawn before the statement exists have nothing to bear against, and that gap is named in each one.

Wait for the statement before proceeding to Step 5.

---

## Step 5 — Check for a Library Kit

Before creating the project manifest, check whether the developer has placed a type-category kit in the `.claude/library/` folder of this repo.

Look for `.claude/library/[category]/META.yaml` where category matches what was identified in Step 3.

**If a library kit is found**, present it to the developer:

> I found an existing kit for this project type in the library:
>
> **Kit**: [kit_name]
> **Version**: [version] — Generation [generation]
> **Covers**: [covers list from META.yaml]
> **Known gaps**: [known_gaps list from META.yaml]
> **Recommended for**: [recommended_for]
>
> This kit was extracted from [extracted_from] and has been through [generation] generation(s) of use. Starting from it means you inherit a mature standard rather than discovering one from scratch.
>
> Shall I integrate this kit into your project? I will copy the skill files and initialise your project manifest against it.

Wait for confirmation. If confirmed, copy all skill files from `.claude/library/[category]/` into the project's `.claude/skills/` directory, preserving the folder structure.

**If no library kit is found**, tell the developer:

> No existing kit was found in the library for this project type.
> We will build the [suggested kit-type] standard together through use.
> Every session will produce a Standard Evolution Report. Over generations of use, the standard will mature until it is ready for extraction into the library.

---

## Step 6 — Create the Project Manifest and Seed the Instance Files

**6a — Project manifest**

Read `.claude/skills/templates/MANIFEST.template.yaml`. Replace every `__PLACEHOLDER__` value with what was learned during Steps 3 and 5. Write the completed file to `.claude/skills/meta-manifest/MANIFEST.yaml`.

Note: in the base-building-kit repo this template lives at `templates/MANIFEST.template.yaml` at repo root. After the developer copies the kit into `.claude/skills/`, it lives at `.claude/skills/templates/MANIFEST.template.yaml`.

**Placeholder replacement map:**

| Placeholder | Replace with |
|---|---|
| `__PROJECT_NAME__` | Project name derived from directory name or README |
| `__CATEGORY__` | Type-category identified in Step 3 e.g. `blazor-web-app` |
| `__LIBRARY_KIT__` | If library kit integrated: `{kit_name: x, version: y, integrated_date: today}` — otherwise: `null` |
| `__INHERITED_NODES__` | If library kit integrated: full node list from `.claude/library/[category]/META.yaml` with `inherited: true`, `tier: type-category`, and `inherited_from: [kit name version]` — otherwise: remove the comment line |
| `__INHERITED_COVERAGE__` | If library kit integrated: coverage entries from `.claude/library/[category]/META.yaml` — otherwise: remove the comment line |

Do not leave any `__PLACEHOLDER__` in the written output. Every placeholder must be resolved before writing.

**6b — Drift log**

Copy `.claude/skills/templates/DRIFTLOG.template.yaml` to `.claude/skills/meta-drift-eventlog/DRIFTLOG.yaml`. The template ships with `entries: []` and the schema reference header — no placeholders to resolve.

Drift history does not inherit. A new project always starts with an empty drift log, regardless of any library kit being integrated — the eventlog SKILL.md travels via meta-extract, the DRIFTLOG.yaml does not. The structure inherits; the history does not.

**6c — Contract log**

Copy `.claude/skills/templates/CONTRACT-LOG.template.yaml` to `.claude/skills/meta-contract-before-execution/CONTRACT-LOG.yaml`. Ships with `contracts: []` — no placeholders.

**6d — Learning log**

Copy `.claude/skills/templates/LEARNINGLOG.template.yaml` to `.claude/skills/meta-learning/LEARNINGLOG.yaml`. Ships with `entries: []` — no placeholders.

Same asymmetry as the drift log: contract and learning history are project-specific. A new project always starts with both logs empty, regardless of any library kit being integrated — the governance travels via meta-extract, the instance data does not.

**6e — Founding contract**

Copy `.claude/skills/templates/FOUNDING.template.md` to `.claude/skills/meta-founding-contract/FOUNDING.md`. Replace `__PROJECT_NAME__` with the project name, `__DATE__` with today's date, and `__STATEMENT__` with the pioneer's statement from Step 4 — pasted verbatim, as a blockquote, preserving their paragraphs. Nothing else in the statement block is changed: no tidying, no summarising, no headings the pioneer did not write. Leave the "Amendments" section as the template ships it.

Same asymmetry again: the founding contract is project-specific. It does not travel via meta-extract, and a new project never starts from another project's `FOUNDING.md`.

After writing all five files, tell the developer:

> The project manifest has been created at `.claude/skills/meta-manifest/MANIFEST.yaml`.
> The drift log has been seeded at `.claude/skills/meta-drift-eventlog/DRIFTLOG.yaml` (empty entries list).
> The contract log has been seeded at `.claude/skills/meta-contract-before-execution/CONTRACT-LOG.yaml` (empty contracts list).
> The learning log has been seeded at `.claude/skills/meta-learning/LEARNINGLOG.yaml` (empty entries list).
> Your founding statement has been recorded verbatim at `.claude/skills/meta-founding-contract/FOUNDING.md`.
> The kit is now active in this project.
>
> [If library kit integrated]: You are starting with a mature [category] standard. The inherited nodes are your baseline. Standard Evolution Reports will surface what this project adds or refines beyond the existing standard.
>
> [If no library kit]: We are building the [category] standard from scratch. Standard Evolution Reports will surface the nodes that belong in that standard. When the standard matures, meta-extract will package it for the library.
>
> Every feature begins with a contract that opens with a bearing — at most two sentences, read against your founding statement — followed by a three-tier proposal, and every approved one is persisted to the contract log. Every implementation produces a Standard Evolution Report. Once a contract is verified, run meta-learning — it diffs what was contracted against what verification actually confirmed, and is a second, deeper source of standard evolution alongside the report. Drift incidents that meta-antidrift surfaces will accumulate in the drift log across sessions, so recurrence patterns become visible and elevations are verifiable through observed silence. The standard grows through use.
>
> What would you like to build first?

---

## What This Skill Does Not Do

- It does not audit the existing codebase for problems or improvements — that comes later, through use
- It does not negotiate its steps with existing tools or plugins — conflicts are named and surfaced, not resolved by compromise
- It does not run more than once — if the kit is already installed, load the manifest and proceed normally
- It does not proceed past any step without explicit developer confirmation
- It does not draft, suggest, or shape the founding statement — it asks for it and records it verbatim. See `meta-founding-contract/SKILL.md`
- It does not create a type-category manifest — it creates a project manifest. The type-category kit is a separate artifact produced by meta-extract when the standard is ready
