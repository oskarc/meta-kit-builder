---
name: meta-founding-contract
description: The project's own statement of what it is — internal, behind the scenes, never about the product's audience — held as an original text that is never rewritten plus dated amendments saying where the project has progressed to. Every contract opens with a two-sentence BEARING in service of it. Correcting a bearing is a reevaluation (the direction is off in some respect), not a redraw (an adjustment within a direction already correct). An amendment must name what caused it and what it now binds; one that only ratifies work already done is retro-fitting, and retro-fitting turns the statement into a check that cannot fail at the top of the practice. Amending is a pioneer act. The content is unmeasurable and reached by reflection; only the form is enforceable.
---

# Founding contract

**Neither party can see the end of the work.** If either could, the practice
would be specification and delivery, and the ceremonies would be overhead.
Because neither can, the *purpose* has to carry what the *destination* cannot —
and the founding contract is where that purpose is written down.

---

## What it is

An **internal** statement about the project as a body of work: what it is, how
it should hold together, what ordering it is meant to have.

It is **not** a product vision. It does not describe an audience, a market, or
what an end user should feel. A design system for colour and iconography is
invisible to any user and is *directly* in service of the founding statement,
because it settles how every surface is permitted to look and ties the whole
together.

**Judging a contract's service by its proximity to what a user sees is the
characteristic misreading.** It systematically undervalues the foundational
layer the practice most exists to build, and it is quiet — nothing fails when
it happens.

---

## It is living, and it grows by addition

Development is an evolutionary lifecycle; part of the work is letting something
take shape. Understanding deepens, and the statement must be able to say so.

- **The original text is never rewritten.** It stands as first written,
  permanently readable.
- **Amendments are appended and datestamped.** They say where the project has
  progressed to.
- **Each amendment names what caused it** — the work that revealed the nuance,
  traceable to contracts by id.
- **Each amendment names what it now binds** — what future work must honour
  that it need not have before.

### The sharp test

**An amendment that only ratifies is suspect; one that also binds is earned.**

A retro-fitted amendment licenses what was already done and constrains nothing.
An honest one usually makes future work *harder*, because a nuance discovered
is a constraint discovered. If an amendment cannot be shown to bind, it is a
description wearing a statement's clothes.

### Amending is a pioneer act

The agent may surface that a contract's bearing sits outside the statement as
written — that is a finding, and a useful one. **Proposing that the statement
change so a contract fits is the corruption of the mechanism**, and it is the
one that would be hardest to see afterwards.

---

## The bearing

**Every contract opens with a statement of at most two sentences: what the
point of the contract is, and how it shows direction.** It is in service of the
founding statement. It is the first thing drawn and the first thing read.

- **It must be capable of being wrong.** A bearing that cannot be disagreed
  with cannot steer. It states a change of state, never a list of work.
- **It must expose its bet.** The pull is to phrase it so it sounds obviously
  right; a maximally agreeable bearing is not neutral, it is inert. Whatever
  the contract is wagering belongs on the first line.
- **If the bearing and the tiers disagree, the bearing wins** and the tiers are
  wrong. It is not a preface.

---

## Two grades of correction

| The pioneer corrects | Meaning | Consequence |
|---|---|---|
| a tier or use case | an adjustment within a direction already correct | **redraw** — the contract is drawn again in full |
| the bearing | the direction is off in some respect | **reevaluation** — everything below was derived from it, so it is re-decided, not repaired |

A reevaluation may legitimately end with the contract not existing. A redraw
always ends with a contract. **Treating a bearing correction as a redraw
repairs the tiers and lets the wrong direction survive the correction.**

**A correction is generative, not a veto.** The pioneer reflects and describes
how the contract should better be in service of the founding statement. That
description is the reorientation; it is also where amendments are earned, when
reflection shows the statement was incomplete rather than the contract wrong.

---

## Foundational and feature contracts are measured differently

- A **foundational** contract is measured by what it makes **governable** —
  what stops being renegotiated case by case.
- A **feature** contract is measured by what becomes **possible**.

Judging the first by the second's measure pushes a practice toward features and
away from the ordering that keeps features coherent.

---

## What is enforceable, and what is not

**The content is not mechanically measurable.** Whether a bearing serves the
statement is reached by reflection. Any check that claimed to score it would be
the most dangerous artifact in the kit: a green light on a judgement nobody
made.

**The form is enforceable, and should be.** A check may assert that the
original block is byte-unchanged, that every amendment carries a date, a cause
and a binding clause, and that every contract carries a bearing of at most two
sentences. It cannot judge whether an amendment is earned — it can refuse one
written in a shape that hides the question.

---

## Failure modes

- **The statement drifts to match the work.** The worst outcome: every contract
  becomes trivially in service, because the thing it serves was edited to make
  it so. Prevented by append-only, and by the ratifies-versus-binds test.
- **The bearing becomes a summary.** "This contract adds X, Y and Z" is a
  manifest. A bearing states a change of state.
- **The bearing goes vague to avoid being wrong.** Then it cannot be refused or
  redirected, which are the only two things it is for.
- **Service is judged by user-visibility.** See above; this one is quiet and
  expensive.

---

## Instance

This project's statement and its amendments live in `FOUNDING.md`, beside this
file. The skill is transferable; the statement is not. A new project is seeded
from `templates/FOUNDING.template.md` by `meta-bootstrap` (Step 4), which asks
the pioneer for the statement and records it verbatim. `meta-extract` never
carries `FOUNDING.md` into the library.

The bearing rule and the two grades of correction are applied where contracts
are drawn — see `meta-contract-before-execution/SKILL.md`, "The Bearing" and
"The Approval Gate". `bearing` is a field on every entry in `CONTRACT-LOG.yaml`.
