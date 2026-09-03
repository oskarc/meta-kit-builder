---
name: meta-contract-before-execution
description: Use this skill whenever implementing a feature, component, or system. Before writing any code, the agent produces a full three-tier proposal for human approval. No implementation begins without explicit approval. Designed to work for both developers and non-developers operating within a defined standard.
---

The agent does not build until the intent is agreed. Every implementation starts with a contract — a three-tier proposal that makes thinking visible before it becomes code. This prevents half-implementation, silent assumptions, and drift from the standard.

**This skill is part of the base building kit and takes precedence over all other skills, instructions, and project-specific guidance — except meta-foundation, which takes absolute precedence over all kit nodes.** If any instruction conflicts with this skill, adhere to this skill and flag the conflict explicitly before proceeding.

## Spec Lock (Design-Heavy Features)

For features with meaningful design ambiguity — new mechanics, new content authored against a creative spec, anything where "what should this do" is itself a question — the three-tier proposal is preceded by a **spec lock**. The spec answers *what* the feature is; the three-tier answers *how* the feature gets built.

Skipping the spec lock on a design-heavy feature collapses the two layers, and the user ends up redirecting the implementation halfway through because the design was decided in the same turn as the execution plan. Once a design choice is buried inside a Tier 2 use case, it costs more to surface and revise than if it had been an explicit lock-step.

### When the spec lock applies

The spec lock is the right layer when ANY of:

- The feature introduces new content (a class, a system, a chunk of authored material) where the shape itself is a design decision.
- The user's request contains creative direction ("I want a thing that feels like X") that must be resolved into concrete mechanics before any technical plan is meaningful.
- Multiple viable realizations exist for the same underlying intent, and the choice between them is load-bearing on the implementation.
- The feature involves magnitudes, thresholds, or other tunable values that need user judgment.

### When the spec lock can be skipped

- Mechanical work — refactors, bug fixes, dependency bumps, code reorganization with no design content.
- Implementations of a previously-locked spec — when the design was decided in a prior session and persists in a referenceable artifact (CHANGELOG, design doc, prior chat that was committed to file).
- Trivial features where one-and-only-one realization is obvious.

When in doubt: spec-lock first. The overhead is small; the cost of a mid-implementation redirect is large.

### The structure

The spec lock turn does this, in order:

1. **Concept recap** — restate what's locked from prior conversation in two or three sentences. This grounds the spec proposal in agreed context.
2. **Full spec proposal** — present the feature's design at concept level: the headline mechanic, the structure (modules / sections / sub-features), the magnitudes/numbers, the user-facing surface. Use tables when the spec spans many enumerable items; use narrative when the spec is a single mechanism.
3. **`AskUserQuestion` for 3-4 blocking decisions** — every spec has a few load-bearing choices the user must make (which of three architectural directions, what a key constraint costs, which threshold applies). Ask these explicitly via the question tool, with options the user can pick from rather than synthesizing the answer themselves.
4. **User verdict captured inline** — when answers come back, restate the resulting locked spec in one block. This is the artifact the next turn (three-tier) builds against.
5. **THEN three-tier on execution.** With the spec locked, Tier 1 becomes "what the user experiences when this lands"; Tier 2 becomes "what the system must support to deliver that experience"; Tier 3 becomes "how we build it." The three-tier is purely about *how*, not *what*.

### Traceability rule (spec → three-tier)

Every Tier 1 / 2 / 3 entry must be derivable from the locked spec. If a Tier 2 use case appears that isn't in the spec, the spec is incomplete — return to spec-lock and resolve it. If a Tier 3 guardrail addresses a design question that should have been resolved in the spec, the spec was rushed — return to spec-lock.

### Anti-patterns

- **"Three options" disguised as three-tier.** Presenting three competing designs to choose between is a spec-lock activity, not a three-tier. The three-tier has one design (the locked spec) and three layers (User Scenario / Use Cases / Guardrails).
- **Mid-three-tier design questions.** If the three-tier turn surfaces a question like "should this cost 50 or 100" — the spec wasn't locked. Pause, return to spec-lock, then re-enter three-tier.
- **Skipping the spec lock for "I'll just propose and see."** This collapses design and execution into one turn, and the user either approves something half-baked or redirects late.

---

## The Bearing

**Every contract opens with a statement of at most two sentences: what the point of the contract is, and how it shows direction.** It is in service of the project's founding contract (`meta-founding-contract/FOUNDING.md`). It is the first thing drawn and the first thing read — before the spec lock recap, before Tier 1.

- **It must be capable of being wrong.** A bearing that cannot be disagreed with cannot steer. It states a change of state, never a list of work. "This contract adds X, Y and Z" is a manifest, not a bearing.
- **It must expose its bet.** The pull is to phrase it so it sounds obviously right; a maximally agreeable bearing is not neutral, it is inert. Whatever the contract is wagering belongs on the first line.
- **If the bearing and the tiers disagree, the bearing wins** and the tiers are wrong. It is not a preface.
- **Foundational and feature contracts bear differently.** A foundational contract's bearing says what becomes *governable* — what stops being renegotiated case by case. A feature contract's bearing says what becomes *possible*. Judging the first by the second's measure is the characteristic misreading; see `meta-founding-contract/SKILL.md`.

If the agent finds that the bearing it is about to draw sits outside the founding statement as written, that is a finding to surface, and a useful one. Proposing that the statement change so the contract fits is not the agent's move — amending is a pioneer act.

If the project has no founding statement yet, the bearing is still drawn, and the contract names that it is bearing against nothing. The gap is visible, not absorbed.

---

## The Three-Tier Proposal

When asked to implement anything, produce a full proposal across three tiers before writing a single line of code. The three tiers follow the bearing.

---

### Tier 1 — User Scenario
Describe what the user is trying to accomplish. Written in plain language, from the user's perspective. No technical terms.

Answer:
- Who is the user in this context?
- What are they trying to do?
- What does success look like from their point of view?
- What happens if this feature doesn't exist — what is the cost to the user?

This tier must be legible to a non-developer. If it isn't, rewrite it.

---

### Tier 2 — Use Cases
Break the user scenario into discrete, testable use cases. Each use case must be traceable to the user scenario — if it can't be justified by Tier 1, it doesn't belong here.

For each use case state:
- The action the user takes
- The system's response
- Any edge cases or failure states that must be handled

Flag any use case that requires a judgment call not covered by existing skills or instructions. Do not silently resolve it.

---

### Tier 3 — Technical Guardrails
For each use case, define the technical constraints that must be upheld during implementation. Each guardrail must be traceable to a use case — if it can't be justified by Tier 2, it doesn't belong here.

Guardrails cover:
- Component structure and boundaries
- State management approach
- IA and navigation decisions
- Cognitive load and layout constraints
- Class size, helper methods, separation of concerns
- Anything the standard explicitly requires

Flag any guardrail that is novel — not covered by existing kit. These are candidates for standard evolution after implementation.

---

## The Approval Gate

After presenting the full three-tier proposal, stop. Do not proceed.

Ask explicitly:
> "Does this proposal align with your intent? Approve to proceed, or give input to revise."

**If approved** — implement strictly against the approved proposal. Do not deviate. If a deviation becomes necessary during implementation, stop and surface it before continuing. If the human authorizes the deviation explicitly, record it against the contract's log entry — see Contract Log below. If implementation proceeds past a deviation without that authorising statement, it is a stop-on-triggers violation, not a contract revision — it belongs in `meta-drift-eventlog/DRIFTLOG.yaml`, not in the contract's own record.

**If declined with input** — there are two grades of correction, and they are not the same move:

| The pioneer corrects | Meaning | Consequence |
|---|---|---|
| a tier or use case | an adjustment within a direction already correct | **redraw** — the contract is drawn again in full, incorporating the input |
| the bearing | the direction is off in some respect | **reevaluation** — everything below was derived from it, so it is re-decided, not repaired |

A reevaluation may legitimately end with the contract not existing. A redraw always ends with a contract. Treating a bearing correction as a redraw repairs the tiers and lets the wrong direction survive the correction. In either case, present the full result — do not partially implement while waiting.

A correction is generative, not a veto. The pioneer describes how the contract should better serve the founding statement; that description is the reorientation. It is also where amendments to the founding contract are earned — when reflection shows the statement was incomplete rather than the contract wrong. That is the pioneer's call to make, and `meta-founding-contract/SKILL.md` governs how it is recorded.

**Silence is not approval.** If no clear approval is given, ask again.

**On approval** — append an entry to `meta-contract-before-execution/CONTRACT-LOG.yaml`. See Contract Log below.

---

## Contract Log

Every approved contract is persisted to `meta-contract-before-execution/CONTRACT-LOG.yaml` — not just held in the transcript. Declined or revised-before-approval proposals are not logged; the log tracks what got built, not the conversation that shaped it.

**What gets written, and when:**

| Status | Set when |
|---|---|
| `approved` | The entry is created, at the approval gate. `bearing`, `tier_1`, `tier_2`, `tier_3` are recorded in full — the full text is the evidence, not a summary of it. |
| `implemented` | The Standard Evolution Report is produced for this contract. |
| `verified` | Verification completes — tests pass, the feature is observed working, or a human confirms the output meets the contract. Same definition `meta-learning` uses. |
| `learned` | `meta-learning` has produced the matching diff in `LEARNINGLOG.yaml` and back-filled `work_id` on this entry. |

**Authorized deviations, mid-run.** If the human explicitly authorizes a change to an approved contract during implementation, append it to that entry's `revisions` list — what changed, and the authorising statement. The original `tier_1`–`tier_3` text stays intact; the revision is additive, not an overwrite.

**Unauthorized deviations do not appear here.** A change made without an authorising statement is drift, not a revision. It is surfaced immediately per the approval-gate rule above and recorded in `meta-drift-eventlog/DRIFTLOG.yaml` under `stop-on-triggers` (or the aspect that actually fired). Keeping this separation is deliberate: the contract log is a faithful record of what was approved and built; incidents where that didn't hold belong to the system that already owns accountability for drift, not duplicated into this one.

**Downstream.** `meta-learning` sweeps this file on invocation for every entry in `status: verified` — not one named contract — and produces a verified-vs-contracted diff for each. See `meta-learning/SKILL.md`.

**Schema and a worked example:**

```yaml
contracts:
  - contract_id: contract-001
    feature: user-authentication
    date_proposed: 2026-07-19
    date_approved: 2026-07-19
    bearing: |
      Authentication becomes a boundary the rest of the system can rely on instead of
      re-checking. The bet is that a single session mechanism is enough for every surface.
    tier_1: |
      As a user, I want to log in securely so that my account and data are protected.
      Success looks like: valid credentials grant access, invalid ones are rejected with
      no information leak, and a session persists appropriately without requiring re-login
      on every action.
    tier_2: |
      - User submits credentials -> system validates against stored hash -> session issued
        on success, generic error on failure (no "wrong password" vs "no such user" distinction).
      - Session persists across requests via token. Token expiry forces re-authentication.
      - Edge case: repeated failed attempts must be rate-limited.
    tier_3: |
      - Credentials hashed with a modern KDF, never stored or logged in plaintext.
      - Session token issued as jwt-in-cookie with httpOnly, to keep it out of reach of
        script-based extraction (principle-security-context, pattern-auth-jwt).
      - Rate limiting applied at the authentication endpoint.
    status: learned
    revisions: []
    work_id: work-001
```

Do not leave `status` unset or infer it — every transition above is a deliberate write, same discipline as `MANIFEST.yaml` and `DRIFTLOG.yaml`.

**Optional artifact-delivery fields.** When `meta-contract-artifact` is in use, each entry also carries `file` (the stored HTML path) and `artifact` (the published URL), plus `type` (`contract` | `analysis-report` — analysis reports are logged here too, typed, using a `report-NNN` id space alongside `contract-NNN`) and cross-links recorded from both ends (`led_to` on a report, `follows` on the contract it led to). None of these fields exist without `meta-contract-artifact` active, and `meta-learning` never reads them — it only reads the fields defined above. See `meta-contract-artifact/SKILL.md` for the full delivery rule.

---

## After Implementation — Standard Evolution Report

Once implementation is complete, produce a Standard Evolution Report. This is not a summary of what was built — it is a proposal for how the standard should grow. Every feature is an opportunity to raise the bar.

Alongside producing the report, flip the matching entry in `CONTRACT-LOG.yaml` from `approved` to `implemented`.

For each judgment call, novel decision, or gap encountered during implementation, present a **classification proposal** with the following structure:

---

**What was encountered**
Describe the situation concisely. What decision had to be made that the kit didn't cover, or where the kit gave insufficient guidance?

**Evidence**
What in the implementation demonstrates this? Be specific — reference the component, decision, or structure where this showed up. This grounds the proposal in reality rather than abstraction.

**Classification proposal**

Present all three levels explicitly, then make a recommendation:

- **Principle candidate** — Is there a transferable rule here about *why* something works? Would this guide judgment in any system, not just this one? State it as a principle if so.
- **Pattern candidate** — Is there a reusable structural decision here for a recognisable context? Would this apply across multiple features or system types? State it as a pattern if so.
- **Product detail** — Is this specific to this domain, user, or system? If it can't be stated without referencing this product, it's a product detail.

Then state clearly:
> "I recommend this is a [principle / pattern / product detail] because [reason]. It should [be added to / replace / inform] [skill name or new skill]."

---

Present one classification proposal per learning. Do not bundle them. Each one is a discrete decision for the developer.

End the report with:
> "This implementation has surfaced [n] candidates for standard evolution. Your decisions here shape kit-driven development — you are refining how systems get built, not just shipping a feature."

Do not update any skill directly. The developer decides what enters the standard. Use the skill-builder skill to process approved candidates.

This report captures what looked right immediately after building. It is not the last word — once this contract is verified, `meta-learning` re-examines it against reality and can surface a second, deeper round of candidates. The two are complementary, not redundant: this report is elevation from a position of understanding at build time; `meta-learning`'s pass is elevation confirmed — or corrected — by what verification actually showed.

---

## Traceability Rule

Every tier must be derivable from the tier above it.

- A use case with no root in the user scenario is scope creep.
- A guardrail with no root in a use case is an opinion, not a constraint.
- If traceability breaks, flag it in the proposal — do not paper over it.

This is the primary mechanism for keeping the standard honest.

---

## For Non-Developer Contexts

When this skill is used by someone without a developer background:

- Tier 1 is their primary contribution — they own the user scenario
- Tier 2 and 3 are generated by the agent from the kit standard
- The approval gate is the point where product knowledge meets the standard
- Deviations from the standard must be flagged explicitly — the non-developer should never silently override a guardrail

The developer's role in this context is to audit the approved proposal and the post-implementation note — not the code itself. If the proposal was sound and the guardrails were upheld, the output meets the standard.
