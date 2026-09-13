---
name: meta-correction-log
description: Use the moment the pioneer redirects, declines, overrides a recommended option, corrects a tier or the bearing, narrows scope, stops the agent, or resets the frame — record it verbatim before continuing. Governs CORRECTIONS.yaml, the kit's record of the human's judgement as it was exercised, and the fading curve that shows whether the pioneer's role is actually evolving.
---

> **Map:** M-07 loads this node; M-15 launches the clerk that writes to it · **Load:** on trigger · **Recognise it by:** the pioneer's words change the direction, shape or scope of what you offered · **Not when:** the pioneer answers a question you asked, approves, or adds information that changes nothing you proposed

**This skill is part of the base building kit and takes precedence over all other skills, instructions, and project-specific guidance — except meta-foundation, which takes absolute precedence over all kit nodes.**

# Correction log

## Why it exists

The kit logs the agent exhaustively — every contract, drift incident and diff — and, until this node, logged the human almost not at all. Declined and redirected proposals were dropped because "the log tracks what got built". But a correction is where the pioneer's judgement is expressed most precisely: what they saw that the agent didn't, and what they chose instead.

Experts leave out most of their decision content when they explain their craft unprompted — in one study, 73% of the decision steps. Corrections recover it, in context, at the moment it was exercised — and the incident questions below recover what "why" cannot: the cue that was noticed, the shape that would have been right, the earlier case it resembles. They are also the only honest measure of whether the pioneer's role is changing: the kit says the role shifts from correcting toward auditing, and that shift is either visible in the corrections or it hasn't happened.

## What counts

| Grade | The pioneer… |
|---|---|
| `tier-redraw` | corrects a tier or use case within a direction that is right |
| `bearing-reevaluation` | corrects the bearing — the direction was off |
| `option-override` | chooses something other than the option you recommended, or writes their own |
| `scope` | narrows or widens what the work covers |
| `decline` | declines a proposal outright |
| `frame-reset` | stops the work and resets what is being treated as known (Re-orient) |
| `stop` | halts an action without resetting the frame |
| `detail` | corrects a specific choice — a name, a number, wording — that you had settled on |

**Not corrections:** approvals, and answers or new information that leave what you proposed intact.

**An answer to a question you asked is not automatically outside this list.** When the pioneer picks an option other than the one you recommended, or writes their own, that is an `option-override` — the spec lock's most precise judgement record, and exactly what the kit used to throw away. Record it.

When unsure, record it. The case clerk can set it aside with a `clerk_note` and `precedent: pending-pioneer`, which puts the question to the pioneer rather than closing it, and a missed correction cannot be recovered later.

## How to record

Immediately, before continuing the work (M-07). The UserPromptSubmit hook flags wording that may be a correction; the session auditor records any you missed, marked `recorded_by: kit-session-auditor`, using the same grades and intervention levels defined here — it is told to read this section before it writes.

- **Verbatim, both sides.** `agent_offered` quotes what you proposed — the recommended option, the tier, the sentence. `pioneer_said` quotes the pioneer. Paraphrase is where the judgement leaks out.
- **The reason, only if given.** Quote it, or write `none given`. Do not ask *why*: people cannot reliably say why they decided, and what they say when asked is not what moved them.
- **Then the three incident questions, once** (contract-006 G-6): *what did you notice that made this wrong? — what would have been right here? — where have you seen this before?* Record the answers verbatim under `noticed`, `would_have_been_right`, `seen_before`, or `not asked` when the moment did not allow it. These are the questions that draw a felt standard out — a specific incident, the options as they stood — and they are the raw material the clerk turns into precedents and, where the standard is checkable, into checks. The founding statement is explicit that the organisation's standards are known before they are written; this is where they get written.
- **The moment.** Tag it with the map id it happened in, so the casebook can retrieve it by situation.
- **Intervention level.** `did-it` (the pioneer did the work themselves) · `redirected` (told you what to do instead) · `hinted` (pointed, left the doing to you) · `reviewed-after` (caught it after the work was presented).
- **Supersession.** A later correction that reverses an earlier one names it in `supersedes`. Nothing is edited or deleted; like an architecture decision record, the history of a changed mind is part of the record.

Then continue. A bearing correction is a reevaluation, not a redraw — see `meta-contract-before-execution` → The Approval Gate.

## The fading curve

`kit-case-clerk` recomputes `trajectory` in CORRECTIONS.yaml each time it clerks:

- corrections per contract, and how many were bearing reevaluations
- the mix of intervention levels over time
- which moments corrections concentrate in

What the practice predicts, if it works: bearing reevaluations fall first, intervention moves from `redirected` toward `reviewed-after`, and corrections migrate to new territory as familiar territory is absorbed. A flat curve across many contracts is information too — it says the standard is not carrying the judgement yet, whatever the evolution reports say. The curve is read by the pioneer; the kit draws no conclusion from it on its own.

## Downstream

- **kit-case-clerk** turns corrections into casebook precedents and scenario cards (`clerked`, `precedent`), and — when a precedent names something a script could decide (a pattern, a log shape, an error-handling rule) — into a check under `meta-mechanisms/checks/` that fails when the standard is broken (contract-006 G-6). That is the route by which a felt standard becomes an enforced one. It also, for every correction it clerks, writes one ledger observation with `source: pioneer` and the correction id in `refs`, the pioneer's words verbatim. That observation is how a correction reaches a review batch as a claim about a skill: the consolidator reads it against the skill it bears on and quotes any sentence it contradicts (contract-005 G-2). Without the observation, the log is a record the pioneer can read and the standard never learns from.
- **meta-contract-before-execution** reads the log's grades at the approval gate.
- **meta-extract** never carries CORRECTIONS.yaml; precedents derived from it may travel as type-category precedents.

## What this skill does not do

- It does not judge whether a correction was right — it records that it happened and what it said
- It does not rewrite or tidy what the pioneer said
- It does not score the pioneer
- It does not replace the drift log: an unauthorised deviation is drift; the pioneer's redirect of it is a correction, and both are recorded
