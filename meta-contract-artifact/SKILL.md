---
name: meta-contract-artifact
description: Every contract ships as a published artifact as well as a chat draw. Enhances meta-contract-before-execution by fixing HOW a contract is delivered, not what it contains. Two templates — an ANALYSIS REPORT for work that produces findings and judgement, and an EXECUTION CONTRACT for work that produces a plan. The artifact must separate what was verified from what is judgement from what is undecided, so the reader can act on the first and interrogate the second.
---

`meta-contract-before-execution` says what a contract contains. This says how it
is delivered. It changes nothing about the three tiers, the spec lock, or the
approval gate.

**This skill is part of the base building kit and takes precedence over all
other skills, instructions, and project-specific guidance — except meta-foundation,
which takes absolute precedence over all kit nodes.** If any instruction
conflicts with it, adhere to it and flag the conflict explicitly.

## Why

A contract is read once, at the moment of deciding, by someone who was not in
the agent's head. Chat prose is the wrong shape for that reading twice over.

**It scrolls.** A contract drawn in chat is buried by the next turn. The reader
who wants to check a Tier 2 use case against what shipped has to scroll back
through an implementation to find it. A contract that cannot be re-read is a
contract nobody audits.

**It flattens.** In prose, a number the agent computed, a number the agent read
out of the binary, and a number the agent guessed all look identical. That is
the failure this skill exists to prevent, and it has a worked instance: a
design review reported a subsystem's daily revenue as "~99,000 a day" from an
arithmetic sum, presented in the same register as every verified claim beside
it. The sum was wrong by 28,000. Prose gave the reader no way to tell which
sentences had been checked.

This is the same failure a verification suite falls into when it tests
mechanism instead of output — a check that a cache key exists, a loop is
bounded, a call happens on the right thread can all pass while the actual
answer is wrong, because none of them asked what the answer *was*. A contract
in uniform prose is the document-shaped version of that suite: it reports that
claims were made, not that they were checked, and the two read identically
until someone goes looking.

So the delivery has one job the content does not: **make verification state
visible at a glance.** What was checked against source, what is the agent's
judgement, and what is still open must be separable without reading a word.

## The rule

> Every contract is drawn in full in the chat, **published** as an artifact,
> **stored** as HTML in the repo, and **registered** in the contract log.

Four places, one identity. Neither of the first two replaces the other, and the
last two are what stop the pair drifting apart.

### Where it lives

| Kind | Stored at | Log id |
|---|---|---|
| Execution contract | `docs/contracts/contract-NNN-slug.html` | `contract-NNN` |
| Analysis report | `docs/reports/report-NNN-slug.html` | `report-NNN` |

**The log is `meta-contract-before-execution/CONTRACT-LOG.yaml`** — the one the
base kit already defines, in the schema it already defines. This skill adds no
second register and invents no schema; it adds two fields to the existing entry
shape, `file` and `artifact`, which are the only facts the base log had nowhere
to put. Everything else — `contract_id`, `feature`, the dates, the three tiers
in full, `status`, `revisions`, `work_id` — is the base kit's, unchanged, and
`meta-learning` reads those fields expecting exactly that shape.

Reports are registered in the same log, typed, so a report and the contract it
led to sit in one register rather than two. The link between them is recorded
from *both* ends (`led_to`, `follows`), because either is the one a future
reader happens to be holding.

A second register for the same fact — a project-local contract log invented
independently of this schema, existing alongside `CONTRACT-LOG.yaml` rather than
reconciled into it — is the failure mode this note exists to prevent. If a
project already tracks contracts its own way, fold that into this schema rather
than maintaining both.

### The id is stamped on the artifact

**The id appears in the artifact's own masthead.** This is the join, and without
it the three copies are three unrelated documents: a reader holding a URL cannot
find the stored file, and a reader holding the repo cannot tell which artifact
it was published as.

Ids are sequential per type and never reused, matching the `drift-NNN`
convention the drift log already uses. A contract that is redrawn **keeps its
id** — the redraw is the same contract, said again correctly.

### Status is the log's job, not the page's

The page carries whether it is awaiting approval. The log carries the lifecycle,
and the lifecycle is the base kit's: `approved` → `implemented` → `verified` →
`learned`. A contract whose status still reads `approved` while its code is
shipping is drift the log makes visible; one that reads `implemented` forever is
a learning diff never taken, which is what `meta-learning` sweeps for.

No status is ever inferred. Each transition is a deliberate write, and
`verified` in particular means observed working — not built, not compiling.

## Resolving the tension with "never a file"

This practice already holds that a contract is drawn in chat and **never** lives
as a file, because a file invites amendment, and a partly-amended contract is
worse than no contract. That rule stands. The artifact does not weaken it,
under three conditions:

1. **The chat draw is still the primary act.** The artifact renders a contract
   that was drawn in full in the conversation. It is never the place a contract
   is first composed, and never the only place it exists.
2. **A change is a full redraw of both.** Redraw the whole contract in chat, then
   republish the whole artifact to the same URL. Never edit one section of a
   published contract; never publish a delta.
3. **The artifact is a rendering, not a record.** It holds no state the chat does
   not. If the two ever disagree, the chat is right and the artifact is stale —
   republish it.

An artifact that gets amended in place has become the repo doc the original rule
forbade. The URL staying constant is what makes republishing cheap enough that
amending is never tempting.

**The stored HTML is bound by the same three conditions.** A file under
`docs/contracts/` is version control's copy of a rendering — it is regenerated
whole from the redraw, never hand-edited to reflect a change. The moment someone
edits a stored contract to correct one clause, the practice has the amendable
document back, in the place it was most careful to avoid.

## Which template

| The work produces | Template |
|---|---|
| Findings, a verdict, options to choose between | **A — Analysis report** |
| A plan to build something specific | **B — Execution contract** |

A review, an audit, a feasibility pass, a subagent's output being checked, a
"which direction should this go" question — all A. A three-tier proposal for a
feature — B.

When a single piece of work does both — a review that ends in a recommendation
to build — it is still two artifacts, published in sequence. Collapsing them
produces a page whose reader cannot tell which parts they are approving.

---

## Template A — Analysis report

**Purpose.** Present findings so a reader can act on what is settled and
interrogate what is not.

**Required elements, in order:**

1. **Masthead.** A name, not a caption. One standfirst sentence stating what was
   examined and why the reader should care.

2. **Verdict strip.** The counts that summarise the pass, before any prose —
   claims corrected, claims verified, open questions, contracts drawn. A reader
   who stops here should still know the shape of the outcome.

3. **The corrected claims first, if any.** When the agent — or a subagent, or a
   prior session — asserted something the source contradicts, that goes at the
   top, with the correction shown rather than described. A reconciliation
   table putting claimed against actual, line by line, is the strongest form:
   it lets the reader audit the audit. A subagent's report is a claim like any
   other — it earns Verified only when something outside the subagent checked
   it, never by default.

4. **Claim rows with visible status.** Every substantive claim carries one of
   three states, encoded in form as well as words — a stripe, a chip, a colour:
   - **Verified** — checked against source, with the source named.
   - **Corrected** — asserted, checked, found wrong.
   - **Open** — a live defect, an unanswered question, or a claim whose source
     could not actually be checked. A claim that couldn't be verified is Open,
     never rounded up to Verified because the check that would have caught the
     gap wasn't run — an instrument that can't see the whole of what it's
     checking must report itself unable to, not a clean result by default.

5. **The mechanism, drawn.** If the reader would otherwise assemble a system
   from prose, draw it. Show the parts the argument turns on, label every
   arrow with what moves along it, and draw the *absent* edge when an absence is
   the finding.

6. **Options as differences, not as a list.** When the report ends in a choice,
   draw what each option changes against the same skeleton, with the unchanged
   parts faded. A separate box per option is a restated list, not a comparison.
   Pair it with a matrix scoring the options on the axes that actually separate
   them — build cost, overlap, what each forecloses.

7. **What was not answered.** The questions the pass could not close, and why.
   An analysis that reports only what it found reads as complete when it is not.

8. **Recommendation, marked as judgement.** Distinct from the verified findings
   above it, so the reader can take the facts and reject the advice.

**The rule that makes it worth publishing:** no claim appears without its
status. A page where verified and unverified sentences look alike is prose with
better typography.

---

## Template B — Execution contract

**Purpose.** Present a proposal so a reader can approve it — which means they can
see what they decided, what the code decided, and what the agent decided, and
tell the three apart.

A report ends in a verdict; a contract ends in a gate. Everything below follows
from that difference.

**Required elements, in order:**

1. **Masthead.** A name, not a caption. One standfirst sentence naming the
   problem in the world, not the change in the code — *"a cart that quietly
   empties itself on refresh"*, not *"add cart persistence"*.

2. **Approval state, carried on the page.** A band under the masthead declaring
   the contract unapproved and that silence is not approval. The gate lives in
   the conversation, but a page that omits its own state reads as a description
   of work already agreed.

3. **Tally strip.** Use cases, guardrails, magnitudes — and, when one exists,
   *the count of decisions still open*. That last figure is the honest one; a
   strip that shows only volume flatters the proposal.

4. **Provenance, above every clause.** What the human locked, restated verbatim,
   with the rule stated plainly: **a clause that cannot be traced to one of these
   is wrong, not merely debatable.** This is the artifact's answer to the
   traceability rule in `meta-contract-before-execution`, and putting it first
   means the reader audits downward from their own decisions.

5. **The mechanism, drawn — one design, not a comparison.** This is where B
   departs from A. A report draws the *difference* between options because the
   reader is choosing; a contract has one locked design, so the drawings show
   how it works. Two figures usually carry it: how a quantity is computed, and
   what one action sets in motion. Mark clearly which parts of the mechanism are
   existing behaviour and which the contract adds — the reader is approving the
   delta, and a diagram that hides it inflates what they think they are agreeing
   to.

6. **The three tiers as identified clauses.** Every use case and guardrail gets a
   visible id (`UC-x`, `G-x`), because a clause that cannot be named cannot be
   cited when implementation deviates from it. Each guardrail states which use
   cases it holds.

7. **Every magnitude with its derivation.** One table: quantity, value, and what
   produced it — an existing constant, a curve reused from elsewhere, a host
   threshold, or an authored judgement. Distinguish kept values from new ones.
   *A number with no derivation is a guess wearing a decimal point*, and in prose
   it is indistinguishable from one that was computed.

8. **A traceability matrix.** Use cases against guardrails. Every row carries a
   mark and every column carries a mark; an empty row is a use case nothing
   protects, an empty column is a guardrail defending nothing. The prose rule
   already requires this — the matrix makes it checkable at a glance instead of
   by reading twice.

9. **Boundaries.** What this contract is *not*, named specifically enough to
   refuse scope later without renegotiating.

10. **The gate, in full.** What approval authorises, that a deviation found in
    flight stops the work rather than being resolved quietly, that a change means
    a whole redraw, and any decision deliberately left open — named, so approving
    as-is is itself a decision the reader knows they are making.

11. **Footer of verified surfaces.** Which host APIs, data files and constants
    were read this session, and an explicit statement that no code has changed.

**The rule that makes it worth publishing:** **every clause traces both ways and
every number names its source.** A contract where the reader cannot tell which
parts came from their own decisions, which from the code, and which from the
agent's judgement is asking for trust rather than approval.

---

## What separates the two templates

They share a visual family — the same page, read for different purposes — but
three things differ, and getting them the wrong way round produces a document
that looks right and does the wrong job.

| | **A — Analysis report** | **B — Execution contract** |
|---|---|---|
| Ends in | a verdict | a gate |
| Its status axis | verified / corrected / open, per claim | kept / new / open, per clause and per number |
| What its diagrams show | the **difference** between options the reader is choosing between | the **mechanism** of the one design, with the delta marked |

A contract that draws options has not locked its spec. A report that draws one
mechanism has already chosen for the reader. Both mistakes are visible in the
figures before they are visible in the prose, which is a good reason to draw
early.

## Craft

The artifact skills own presentation; this skill owns only what a contract
artifact must contain. Two constraints are specific enough to state here:

- **Status is information, so it may use colour.** Verified / corrected / open,
  or kept / new, is semantic and is separate from the page's accent hue.
- **Diagrams show mechanism, not vocabulary.** A box labelled with a system's
  name tells the reader less than the prose did. If a sentence says it faster,
  write the sentence.

## Anti-patterns

- **Publishing instead of drawing.** The artifact is not a way to skip the chat
  contract. A reader who has to open a link to learn what is being proposed has
  been handed homework instead of a proposal.
- **Amending a published contract.** Redraw and republish whole. The moment one
  section is edited in place, the artifact has become the file this practice
  spent a rule forbidding.
- **Uniform confidence.** Presenting a computed figure, a decompiled fact and a
  guess in the same register. This is the failure the skill exists for.
- **Options as boxes.** Three labelled panels with nothing connecting them to the
  system is the option list retyped, not a comparison.
- **A verdict strip that flatters.** The counts are the honest shape of the pass,
  including zero contracts drawn and every claim that had to be corrected.
- **A contract page with no state on it.** A proposal that does not say it is
  unapproved reads as a description of agreed work, and the reader's own memory
  becomes the only record of whether they said yes.
- **Bare magnitudes.** A table of numbers without derivations invites approval of
  figures nobody can audit. The derivation column is the load-bearing one.
- **An empty row or column in the trace matrix.** A use case no guardrail holds,
  or a guardrail defending nothing. The matrix exists to make those visible; if
  one appears, redraw the contract rather than the matrix.
- **An artifact with no id in its masthead.** Three copies of a document with
  nothing joining them. The id costs one line and is the only thing that makes
  the log worth keeping.
- **Editing a stored contract.** Regenerate it whole from the redraw. A hand-
  corrected file under `docs/contracts/` is the amendable document this practice
  spent a rule forbidding, wearing a version-controlled hat.
- **A log entry that never leaves `awaiting-approval`.** If code shipped, the
  status is wrong, and the log is the only place that shows it.

## Composition

- [[meta-contract-before-execution]] — owns what a contract contains; this owns
  how it ships. Read that first; this changes none of it.

This skill's verification-status discipline rests on two ideas that don't have
base-kit nodes of their own: a check that cannot see the whole of what it
verifies must report itself unable to, never a clean pass by default — folded
into the Open status above; and a check that only verifies mechanism (the right
shape, the right call) without verifying output (the actually-correct answer)
produces coverage that looks like correctness and isn't — folded into the Why
section above. Both are named here rather than linked, since a link to a node
this kit doesn't have would itself be exactly the kind of thing-that-looks-
checked-but-isn't this skill exists to prevent.
