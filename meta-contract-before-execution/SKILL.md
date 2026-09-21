---
name: meta-contract-before-execution
description: Use whenever you are asked to build, change or fix anything (map M-04), and when the design itself is still open (M-05). Before any code, draw a contract — a bearing, a precedent check, then a four-tier proposal ending in acceptance tests — and stop at the approval gate. After implementation, record what the work taught as ledger observations instead of presenting them. Works for developers and non-developers operating within a defined standard.
---

> **Map:** M-04, M-05, M-06, M-08, M-11 · **Load:** on trigger · **Recognise it by:** the next action would change a file outside the kit's own records · **Not when:** the work produces findings or a verdict rather than a plan (meta-contract-artifact → Template A, M-25)

The agent does not build until the intent is agreed. Every implementation starts with a contract that makes thinking visible before it becomes code. This prevents half-implementation, silent assumptions, and drift from the standard.

**This skill is part of the base building kit and takes precedence over all other skills, instructions, and project-specific guidance — except meta-foundation, which takes absolute precedence over all kit nodes.** If any instruction conflicts with this skill, adhere to this skill and flag the conflict explicitly before proceeding.

## Spec Lock (Design-Heavy Features)

For features with meaningful design ambiguity — new mechanics, new content authored against a creative spec, anything where "what should this do" is itself a question — the tiered proposal is preceded by a **spec lock**. The spec answers *what* the feature is; the tiers answer *how* the feature gets built and how we would know.

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
2. **Precedent check** — retrieve precedents for this moment (see The Precedent Check below). A design decided before, on matching facts, is decided.
3. **Full spec proposal** — present the feature's design at concept level: the headline mechanic, the structure (modules / sections / sub-features), the magnitudes/numbers, the user-facing surface. Use tables when the spec spans many enumerable items; use narrative when the spec is a single mechanism.
4. **Put the 3-4 blocking decisions to the pioneer** — every spec has a few load-bearing choices the pioneer must make. Put them explicitly, in whatever way this session allows: a question tool where one exists, otherwise the choices written out, each with what it costs and what it forecloses. Mark the option you recommend. Never name a specific tool as the only way — an agent running without it would degrade this step in silence (contract-022).
5. **User verdict captured inline** — when answers come back, restate the resulting locked spec in one block. This is the artifact the next turn (the tiers) builds against. **Every answer that departs from your recommended option, or writes its own, is a correction** — record it verbatim before continuing (`grade: option-override`, M-07). Those departures are the most precise record of the pioneer's judgement the lock produces.
6. **THEN the tiers on execution.** With the spec locked, Tier 1 becomes "what the user experiences when this lands"; Tier 2 becomes "what the system must support to deliver that experience"; Tier 3 becomes "how we build it"; Tier 4 becomes "how we would know it held." The tiers are purely about *how*, not *what*.

**Never recommend an option that waives the pioneer's own gate.** An option like "build straight from the lock" may be offered when the pioneer asks for it, but recommending it puts the agent's convenience above the gate the practice exists to hold. If the pioneer chooses it, the contract records `approval: waived-at-spec-lock` so the record does not claim tiers they never saw.

### Traceability rule (spec → tiers)

Every Tier 1 / 2 / 3 / 4 entry must be derivable from the locked spec. If a Tier 2 use case appears that isn't in the spec, the spec is incomplete — return to spec-lock and resolve it. If a Tier 3 guardrail addresses a design question that should have been resolved in the spec, the spec was rushed — return to spec-lock.

### Anti-patterns

- **"Three options" disguised as the tiers.** Presenting three competing designs to choose between is a spec-lock activity, not the tiers. The tiers have one design (the locked spec) and four layers (User Scenario / Use Cases / Guardrails / Acceptance Tests).
- **Mid-tier design questions.** If the tiers turn surfaces a question like "should this cost 50 or 100" — the spec wasn't locked. Pause, return to spec-lock, then re-enter the tiers.
- **Skipping the spec lock for "I'll just propose and see."** This collapses design and execution into one turn, and the user either approves something half-baked or redirects late.

---

## The Bearing

**Every contract opens with a statement of at most two sentences: what the point of the contract is, and how it shows direction.** It is in service of the project's founding contract (`meta-founding-contract/FOUNDING.md`, always loaded). It is the first thing drawn and the first thing read — before the spec lock recap, before Tier 1.

- **It must be capable of being wrong.** A bearing that cannot be disagreed with cannot steer. It states a change of state, never a list of work. "This contract adds X, Y and Z" is a manifest, not a bearing.
- **It must expose its bet.** The pull is to phrase it so it sounds obviously right; a maximally agreeable bearing is not neutral, it is inert. Whatever the contract is wagering belongs on the first line.
- **If the bearing and the tiers disagree, the bearing wins** and the tiers are wrong. It is not a preface.
- **It is served alone, and first.** The drawn contract opens with the bearing and one line saying that
  everything below is derived from it, so stopping there costs nothing. It is the most expensive thing in the
  contract to get wrong and the cheapest to judge — two sentences against four tiers — and a pioneer who reads
  it buried at the top of a long message is already reading a plan before they have judged its direction. This
  is presentation, not a second stop: the gate is still one stop (contract-011).
- **Foundational and feature contracts bear differently.** A foundational contract's bearing says what becomes *governable* — what stops being renegotiated case by case. A feature contract's bearing says what becomes *possible*. Judging the first by the second's measure is the characteristic misreading; see `meta-founding-contract/SKILL.md`.

If the agent finds that the bearing it is about to draw sits outside the founding statement as written, that is a finding to surface, and a useful one (M-24). Proposing that the statement change so the contract fits is not the agent's move — amending is a pioneer act.

If the project has no founding statement yet, the bearing is still drawn, and the contract names that it is bearing against nothing. The gap is visible, not absorbed.

---

## The Precedent Check

Before drawing the tiers — and before locking a spec — retrieve casebook precedents whose `moments` include the moment at hand (`meta-casebook/CASEBOOK.yaml`; M-04 for a build request, M-05 for a design choice, plus any other moment the work is in), and read their facts. Retrieve trial and adopted candidates that target the area too (`meta-ledger/LEDGER.yaml`, M-29).

- A precedent whose facts match **decides** its question. Tier 3 cites it: `applies P-007`.
- A precedent that seems to match but should not decide this case is **distinguished** in Tier 3: `distinguished from P-007: {how the facts differ}`. The pioneer sees the distinction at the gate, and it is appended to the precedent's `distinguished_by` on approval.
- Two active precedents with matching facts and different holdings are a conflict the pioneer resolves (`meta-casebook`). Until they do, distinguish whichever one you depart from; never pick between them silently.
- A trial or adopted candidate that bears on a guardrail is cited by id: `trial K-012`, `adopted K-004`. Those citations are what later let the ledger tell loaded evidence from independent evidence, and what makes an adopted candidate's uses countable.

**In the draw the pioneer reads, a precedent or a candidate is named by what it says** — "you ruled that acceptance tests come after the guardrails (P-007)" — the holding first, in words, the id after. The short forms above are the log's. An id alone sends the pioneer to a file only the agent has read (C-019; `meta-foundation` → The Agent's Role).

With no casebook entries yet, say so in one line and move on. While a review batch is open the ledger is closed to this session and the casebook is not — it is left open on purpose, so that a contract drawn while a batch waits still gets its precedent check. Make the check as usual, and say in one line that trial and adopted candidates could not be read.

---

## The Proposal

When asked to implement anything, produce a full proposal across four tiers before writing a single line of code. The tiers follow the bearing. **Every use case, guardrail and acceptance test carries an id (`UC-x`, `G-x`, `T-x`)** — kit-verifier runs the tests and checks the remaining clauses one by one, and a clause that cannot be named cannot be verified.

---

### Tier 1 — User Scenario
Describe what the user is trying to accomplish. Written in plain language, from the user's perspective. No technical terms.

Answer:
- Who is the user in this context?
- What are they trying to do?
- What does success look like from their point of view?
- What happens if this feature doesn't exist — what is the cost to the user?

This tier must be legible to a non-developer. If it isn't, rewrite it. For a foundational contract, the user may be the people who build on what it makes governable — name them.

---

### Tier 2 — Use Cases
Break the user scenario into discrete, testable use cases. Each use case must be traceable to the user scenario — if it can't be justified by Tier 1, it doesn't belong here.

For each use case state:
- The action the user takes
- The system's response
- Any edge cases or failure states that must be handled

Flag any use case that requires a judgment call not covered by existing skills, precedents or instructions. Do not silently resolve it.

---

### Tier 3 — Technical Guardrails
For each use case, define the technical constraints that must be upheld during implementation. Each guardrail must be traceable to a use case — if it can't be justified by Tier 2, it doesn't belong here — and states which use cases it holds.

Guardrails cover:
- Component structure and boundaries
- State management approach
- IA and navigation decisions
- Cognitive load and layout constraints
- Class size, helper methods, separation of concerns
- Anything the standard explicitly requires, and every precedent or candidate applied, distinguished or cited

Flag any guardrail that is novel — not covered by existing kit. These are candidates for observations after implementation.

---

### Tier 4 — Acceptance Tests
**The agent drafts the tests with the tiers; the pioneer's disappointment decides them.** Tier 4 is drafted and presented with Tiers 1–3, in the same message (contract-012, C-017): each test carries an id and the guarantees it covers — `T-1 (G-2, G-3)` — a command or a check, and the exact result expected. The draft exists to show the agent's reading of the work: **a drafted test is drawn from the lay of the land after implementation** — what will be true of the records, the hooks and the pioneer's next session once the work is done, and how that would be seen — not from the text the agent intends to write; a test that only greps for the agent's own future sentences is the agent checking its typing, and a test that names what will be true can be wrong in the useful way, before any code is (C-018). At the gate, ask the pioneer, per guarantee: *what result would make you say this was not met?* Record each answer verbatim under `disappointment:` — "same as it says" is an answer, and is recorded as one — and **realign** every test whose guarantee the pioneer reads differently from the draft, before approval; the realigned test is the one frozen. Every ancestor of this tier put the acceptance test in the hands of the party who will be disappointed, and the record of tests written by the builder alone is that they pass while the work is wrong (contract-006 G-5): the draft anchors, which is why the pioneer's line is still asked and still wins, and a pioneer who only ever answers "same as it says" is the sign to watch for in the correction log.

- **A test can fail mechanically.** A grep with an expected count, a script run over a fixture with its expected output, a build that must pass, a walk of a lifecycle through named states. "Read the code and see that it is fine" is not a test; it is an untested guarantee, and is listed as one.
- **A test is seen to fail before it is trusted.** After the build and before the entry reads `implemented`, break one guarantee on purpose and confirm a named `T-x` goes red; restore it; record `red_test: {broke: G-N, went_red: T-N}` on the entry — the tests a contract drafts cannot be run until the work they test exists. A suite that has never failed carries no information, however many passes it shows.
- **A test is legible to the pioneer.** As Tier 1 must be readable by a non-developer, each Tier 4 line must be readable by the pioneer who authored its disappointment: what is checked and what result means failure, in words, before the command.
- **Every guarantee is covered or listed.** Close the tier with an `untested:` line naming each guarantee no test reaches, and why, and a `realigned:` line naming the tests the pioneer's disappointment lines moved from the draft, or `none` — the log then shows where the agent's reading and the pioneer's parted (contract-012). An empty `untested:` line is a claim the verifier will check. A contract that explores how a nuance should hold will have a long `untested:` line; that is honest, and better than a test that cannot fail.
- **Tests are frozen with the contract.** A revision while the work runs may change a test and must say so (`tests_changed`). After the verifier has reported, a test is never changed — a test found wrong at that point is a new contract that `follows` this one.

The verifier runs Tier 4 first and judges from prose only what Tier 4 leaves untested (kit-verifier, M-12), and records how many of its corrections came from a red test and how many from reading. A contract with no Tier 4 is verified entirely by reading, which is the weaker kind of evidence and is recorded as such.

---

## When a new stop earns its place

Every stop spends the pioneer's attention, and the attention spent on a weak one is taken from the ones that
matter. Before adding any point at which the work stops and asks them something, all three must hold:

1. **It is expensive or impossible to reverse after this point.** If the work can absorb being wrong here, it
   can wait for a moment when more is known. A stop placed after production is a review, not a decision.
2. **The agent genuinely cannot make it.** It needs judgement the standard does not yet hold. If the standard
   holds it, the agent decides and shows the reasoning — and if the agent keeps needing the pioneer for the
   same thing, that is the standard missing a rule, not a stop that belongs.
3. **It can be served in under a page**, with the choices named and what each one costs. A decision that
   cannot be put that briefly is not ready to be asked; making it briefer is the agent's work, and doing it is
   most of the value of asking.

And the negative: **a flag that only informs is not a flag.** A count, a progress note, a figure that changed
— those belong in a closing line, never in something that stops the work and waits.

## The Approval Gate

After presenting the bearing and Tiers 1–4 — Tier 4 drafted, as the tier says — stop once: ask for the disappointment lines per guarantee, the pre-mortem below, and the approval, in one reply; realign the drafted tests to the lines before recording the entry (contract-012). Do not proceed on silence.

**Those three asks, and nothing else.** A design choice put here arrives beside a direction to judge and tests to disappoint, and those are three different kinds of attention in one message — the most expensive decision in the practice, served under the heaviest load (contract-022). A choice that is genuinely load-bearing belongs in the spec lock, **before** the tiers exist, where it is answered while nothing has been derived from it yet. A choice that is not load-bearing is the agent's to make, with the reasoning shown where the pioneer can overturn it; naming it in Tier 2 as decided-and-why is how it is shown. If a choice surfaces after the tiers are drawn and it is load-bearing, the spec lock was skipped — go back to it rather than smuggling the question into the gate.

**Where the reply gives the pre-mortem and the approval and no line for a guarantee, the pre-mortem's words stand as that guarantee's line.** Record it so on the entry — that none was given and that the pre-mortem stands — and do not ask again. The pioneer's default, 2026-09-19: *"that is fine, the pioneer still has the opportunity to realign at that point."* A line the pioneer does give always wins (contract-015).

Ask the pre-mortem first, and record the answer verbatim under `premortem:`:
> "It is some weeks on. This contract shipped, and it turned out to be a mistake. What went wrong?"

The question exists to make it safe to voice the objection before commitment hardens; a pioneer who has just read four tiers has one. Then ask explicitly:
> "Does this proposal align with your intent? Approve to proceed, or give input to revise."

The red test comes after the build, before the entry reads `implemented` (Tier 4): one guarantee broken, a named test seen to fail, both recorded.

**If approved** — implement strictly against the approved proposal. Do not deviate. If a deviation becomes necessary during implementation, stop and surface it before continuing (M-08). If the human authorizes the deviation explicitly, record it against the contract's log entry — see Contract Log below. If implementation proceeds past a deviation without that authorising statement, it is a stop-on-triggers violation, not a contract revision — it belongs in `meta-drift-eventlog/DRIFTLOG.yaml`, not in the contract's own record. A deviation the pioneer authorises **after** it happened is recorded in the drift entry's `reaction` as a dated authorisation, and the entry stays.

**If declined with input** — the gate recognises two grades of correction, and they are not the same move:

| The pioneer corrects | Meaning | Consequence | Correction grade |
|---|---|---|---|
| a tier or use case | an adjustment within a direction already correct | **redraw** — the contract is drawn again in full, incorporating the input | `tier-redraw` |
| the bearing | the direction is off in some respect | **reevaluation** — everything below was derived from it, so it is re-decided, not repaired | `bearing-reevaluation` |

A reevaluation may legitimately end with the contract not existing. A redraw always ends with a contract. Treating a bearing correction as a redraw repairs the tiers and lets the wrong direction survive the correction. In either case, present the full result — do not partially implement while waiting.

**Record every correction before redrawing** (`meta-correction-log`, M-07): what you offered, what the pioneer said, verbatim, and its grade. Those two are the gate's grades; the correction log carries the full set — `option-override`, `scope`, `decline`, `frame-reset`, `stop`, `detail` — because the pioneer's judgement arrives in more shapes than the gate sees. A declined proposal never enters the contract log; it enters the correction log, which is where that judgement is kept.

A correction is generative, not a veto. The pioneer describes how the contract should better serve the founding statement; that description is the reorientation. It is also where amendments to the founding contract are earned — when reflection shows the statement was incomplete rather than the contract wrong. That is the pioneer's call to make, and `meta-founding-contract/SKILL.md` governs how it is recorded.

**Silence is not approval.** If no clear approval is given, ask again.

**On approval** — append an entry to `CONTRACT-LOG.yaml` (see Contract Log), append any distinguished precedents to their `distinguished_by`, and deliver the contract per `meta-contract-artifact` where it is active (M-06).

---

## Contract Log

Every approved contract is persisted to `meta-contract-before-execution/CONTRACT-LOG.yaml` — not just held in the transcript. Declined or revised-before-approval proposals are not logged here; their corrections are logged in `meta-correction-log`.

**What gets written, and when:**

| Status | Set when | Set by |
|---|---|---|
| `approved` | The entry is created at the approval gate. `bearing`, `tier_1`, `tier_2`, `tier_3`, `disappointment`, `premortem`, `tier_4` are recorded in full — the full text is the evidence, not a summary of it. `red_test` is written when the red test is run. `verification_state: none`, `audited: false`. | main agent |
| `implemented` | Implementation is complete, its observations are recorded in the ledger, the session's id is recorded on the entry as `transcript` — the id alone, which the session-start hook names, never a path — so the audit reads the right session, and `cost` is written: turns, tokens where known, the pioneer's minutes where reported — `null` where not measured, never estimated. | main agent |
| `verified` | kit-verifier reported every clause verified; or the pioneer's confirmation is recorded in the `verification` block, per clause, naming which clauses it covers. | kit-verifier, or the main agent writing the pioneer's confirmation into the block |
| `learned` | `meta-learning` has produced the matching diff in `LEARNINGLOG.yaml` and back-filled `work_id`. | meta-learning |

A blanket "looks good" is not a per-clause confirmation. Record which clauses it covers and leave the rest open; the stop-gate will route them.

**When verification reports corrected or open clauses** the status stays `implemented`, and the stop-gate hands the contract back (M-12) with three ways out, all of them the pioneer's to choose, and each one a write that ends the task:

| The pioneer chooses | Write |
|---|---|
| confirm the clauses as they stand | `status: verified`, with their confirmation recorded per clause in the `verification` block |
| draw the follow-up work as its own contract | `verification_state: closed-by-follow-up` and `led_to: contract-NNN` on this entry; the new contract carries `follows: contract-NNN` back — the same direction as the artifact cross-links below: `follows` sits on the later entry, `led_to` on the earlier |
| wait for better evidence | `verification_state: none` once that evidence exists, which relaunches the verifier |

**Putting the report to the pioneer** (`meta-foundation` → The Agent's Role): each corrected or open clause is given as what the contract promised, what the verifier found instead — its own words quoted where they carry the finding — and what is asked: one of the three ways out above, each with what it writes and what follows from it. Every such clause is put, none merged and none left out; a line of counts is not a hand-over.

Nothing else clears it — a contract left in this state blocks its own learning diff, which is the point.

**`verification_history`.** A re-verification never overwrites what the last one found: the previous `verification` block moves to `verification_history` first. `meta-learning` reads the current block and cites its date; the history is what lets a diff show that a clause was corrected before it was verified.

**The mechanisms read these marker keys** — `status`, `verification_state` (`none` · `awaiting-evidence` · `reported` · `closed-by-follow-up` · `legacy`), `audited` (`true` · `false` · `legacy` · `blocked`, the last with `blocked_since`, `blocked_reason` and `blocked_waiting_for` beside it — one line each, for an audit that cannot be run at all: meta-mechanisms → Blocked tasks, M-32), `bearing`, `transcript`. `approval` (`approved-at-gate` · `waived-at-spec-lock`; `gate` on entries from before 0.15) is read by no mechanism and recorded for the pioneer. The stop-gate uses them to launch the session auditor and the verifier without anyone asking. Entries that predate kit v0.14 carry `legacy` so history is not re-audited. Analysis reports logged here carry `type: analysis-report` and a `report-NNN` id, and the gates skip them.

**Authorized deviations, mid-run.** If the human explicitly authorizes a change to an approved contract during implementation, append it to that entry's `revisions` list — `what` changed, the `authorised_by` statement, the `date`, and `tests_changed`: the Tier 4 ids the change alters, or `[]`. The original `tier_1`–`tier_4` text stays intact; the revision is additive, not an overwrite. The verifier checks a revised clause against its revision text.

**A test changed after the report is not a revision.** Once `verification_state: reported` stands, a revision whose `tests_changed` is non-empty and whose `date` is later than the verification's is drift (M-18): the verifier does not apply it, and the stop-gate surfaces it every turn until it is withdrawn or the change is drawn as a follow-up contract that `follows` this one. That is the line between amending a contract and marking one's own exam.

**Downstream.** kit-session-auditor audits the session once the contract is implemented (M-11). kit-verifier writes the `verification` block (M-12). `meta-learning` sweeps every entry in `status: verified` (M-13).

**Schema and a worked example** — fictional ids (`contract-EX1`, `O-EX1`, `work-EX1`) so nothing here can be mistaken for a real record:

```yaml
contracts:
  - contract_id: contract-EX1
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
      UC-1 User submits credentials -> system validates against stored hash -> session issued
           on success, generic error on failure (no "wrong password" vs "no such user" distinction).
      UC-2 Session persists across requests via token. Token expiry forces re-authentication.
      UC-3 Repeated failed attempts are rate-limited.
    tier_3: |
      G-1 (UC-1) Credentials hashed with a modern KDF, never stored or logged in plaintext.
      G-2 (UC-2) Session token issued as jwt-in-cookie with httpOnly, to keep it out of reach of
          script-based extraction (principle-security-context, pattern-auth-jwt). applies P-003.
      G-3 (UC-3) Rate limiting applied at the authentication endpoint. trial K-012.
    tier_4: |
      T-1 (G-1) `grep -rn "password" src/auth/ --include=*.ts | grep -v hash` returns no line; auth.spec
          "stores only a KDF hash" passes.
      T-2 (G-2) auth.spec "rejects unknown user with generic error" passes and both failure bodies are
          byte-identical (tests/auth.spec.ts:41).
      T-3 (G-3) Six failed logins in ten seconds from one address: the seventh returns 429.
      untested: none — every guarantee has a test.
    status: learned
    verification_state: reported
    verification:
      date: 2026-07-22
      by: kit-verifier
      method: mixed
      tests: {T-1: pass, T-2: pass, T-3: pass}
      clauses:
        - clause: UC-1
          verdict: verified
          evidence: |
            auth.spec "rejects unknown user with generic error" passes; response bodies identical (tests/auth.spec.ts:41).
        - clause: G-2
          verdict: verified
          evidence: |
            Checked against revisions[0]: header + refresh rotation in src/auth/session.ts:22; staging CSRF test passes.
      summary: {verified: 6, corrected: 0, open: 0}
      open_needs: []
    audited: true
    transcript: 8f2c1e9a-3b7d-4c55-9a10-6e2f0d4b7c31    # the session's id, as the session-start hook named it
    observations: [O-EX1]
    revisions:
      - what: "G-2 changed from cookie to header with refresh rotation"
        authorised_by: "Pioneer, 2026-07-20: 'Switch to header — the proxy breaks the cookie flow.'"
        date: 2026-07-20
        tests_changed: [T-2]      # dated before the verification report, so it is a revision, not drift
    work_id: work-EX1
```

Do not leave `status` unset or infer it — every transition above is a deliberate write, same discipline as `MANIFEST.yaml` and `DRIFTLOG.yaml`.

**Optional artifact-delivery fields.** When `meta-contract-artifact` is in use, each entry also carries `file` (the stored HTML path), `artifact` (the published URL), `type` (`contract` | `analysis-report`) and cross-links recorded from both ends (`led_to` on a report, `follows` on the contract it led to). `meta-learning` never reads them.

---

## After Implementation — Record, Don't Present

Once implementation is complete, the Standard Evolution Report is still produced — but it is **recorded to the ledger, not presented for decision**. Candidates reach the pioneer later, in a review batch, once evidence independent of this session has accumulated.

For each judgment call, novel decision, or gap encountered during implementation, write one observation to `meta-ledger/LEDGER.yaml → observations` (`source: ser`):

- **What was encountered** — the decision the kit didn't cover, or covered insufficiently.
- **Evidence** — the specific component, decision or structure where it showed up.
- **Level guess** — `principle` (a transferable rule about *why*), `pattern` (a reusable structural decision for a recognisable context), `implementation` (a mechanical, stack-specific rule), `product-detail` (can't be stated without this product), or `map` (the knowledge existed but didn't load — write it as `source: map-miss`, `stewarded: false`).
- **`stated_confidence`** — your probability, written now and never revised, that this becomes a candidate the pioneer adopts and that holds through its next three independent uses. Expect your instinct to say 0.8–0.9 for most things; the number is kept as the forecast it was and is never scored or used as a gate (meta-ledger → Observations), and a spread that tracks reality is worth more than a confident one.
- **`loaded_candidates`** — every candidate id that was in your context: cited in this contract or read during the work. An observation you make about your own work counts as loaded evidence, whatever else is true.
- **`prompted: false`** — an observation nobody asked you for.
- `consolidated: false`.

One observation per learning. Do not bundle.

**While a review batch is open** the ledger is closed to this session, so you cannot write these yourself. Hand them, in full, to the **kit-recorder** subagent: it writes nothing but observations, assigns their ids, and reports the ids back. Build work does not wait for the pioneer to finish reviewing, and the presenting session still never reads the ledger.

**Commit each contract alone.** One commit holds one contract's changes and nothing else, so a test of the form *the diff names only the paths this contract lists* can always be run; two contracts sharing a commit left that test unrunnable twice (contract-013).

Then flip the contract's entry from `approved` to `implemented`, record the session's id as `transcript` (the session-start hook named it; the id alone, never a path — contract-015), add the observation ids to `observations`, and tell the pioneer in one short block what the work taught: each observation as one plain sentence — what was noticed and where, not its id, and not its confidence figure, which is a forecast kept for the ledger and asks nothing of them — then, in words, that nothing is asked of them now, and that any of these which gathers evidence from outside this session comes back to them in a review batch (`meta-foundation` → The Agent's Role). Do not ask for decisions on them now.

The stop-gate takes it from there: the session auditor, then the verifier, then the consolidator (M-11, M-12, M-14).

This report captures what looked right immediately after building. `meta-learning`'s verified diff and the verifier's clause verdicts are what test it.

---

## Traceability Rule

Every tier must be derivable from the tier above it.

- A use case with no root in the user scenario is scope creep.
- A guardrail with no root in a use case is an opinion, not a constraint — unless it is rooted in the standard itself, in which case it cites the node, precedent or candidate it comes from.
- If traceability breaks, flag it in the proposal — do not paper over it.

This is the primary mechanism for keeping the standard honest.

---

## For Non-Developer Contexts

When this skill is used by someone without a developer background:

- Tier 1 is their primary contribution — they own the user scenario
- Tier 2 and 3 are generated by the agent from the kit standard and its precedents
- The approval gate is the point where product knowledge meets the standard
- Deviations from the standard must be flagged explicitly — the non-developer should never silently override a guardrail
- Their corrections are recorded like any pioneer's; they are how the standard learns what the non-developer knows that it doesn't

The developer's role in this context is to audit the approved proposal, the verifier's clause verdicts and the auditor's findings — not the code itself. If the proposal was sound and the guardrails were verified, the output meets the standard.
