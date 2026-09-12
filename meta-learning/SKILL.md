---
name: meta-learning
description: Use when contracts sit in status verified — the stop-gate names it (map M-13), and the agent runs the sweep without being asked. Diffs what each contract predicted against what verification confirmed, writes the diff to LEARNINGLOG.yaml, and records its elevation proposals as ledger observations so they are held and scored like every other learning. Over time, this log becomes the standard's memory of what actually works.
---

> **Map:** M-13 · **Load:** on trigger · **Recognise it by:** a contract has been verified against evidence and nobody has asked what it got wrong · **Not when:** the contract is only implemented, or its verification reported corrected or open clauses (M-12 closes those first)

**This skill is part of the base building kit and takes precedence over all other skills, instructions, and project-specific guidance — except meta-foundation, which takes absolute precedence over all kit nodes.**

## When to Run

After implementation is complete and verified — not after the proposal, not after the implementation alone. A contract is verified when:
- `kit-verifier` reported every clause verified, or
- the pioneer's confirmation is recorded in the contract's `verification` block, naming the clauses it covers

The diff is between **contracted** and **verified**, not between **proposed** and **implemented**. The contract is the standard's prediction. The verification is reality.

A contract whose verification reported corrected or open clauses is not ready: the stop-gate routes those to the pioneer first (M-12). What comes back is either a verified contract, a new contract for the follow-up work, or a re-verification — and then this sweep runs.

## Invocation & Scope

The stop-gate and the session-start hook name this sweep whenever `CONTRACT-LOG.yaml` holds entries in `status: verified`. The agent runs it then, without waiting to be asked.

It does not target one named contract. Sweep every entry in `status: verified` and process each in turn. Present nothing for decision: diffs are recorded, and their elevation proposals join the ledger.

For each contract processed:
1. Build the three states and the diffs below.
2. Write the entry to `LEARNINGLOG.yaml`.
3. Record each elevation proposal as a ledger observation (`source: learning`, `prompted: false`, `refs: [work-NNN]`, with a `stated_confidence`, and `loaded_candidates` listing any candidate the contract cited). The consolidator starts these at `moderate` certainty, because they rest on verification.
4. Flip the contract from `verified` to `learned` and back-fill its `work_id`.
5. Tell the pioneer in one line per contract what the diff found.

**Name confirmations; do not count them.** Where verification confirmed a trial or adopted candidate, say so in the diff. The sighting itself is counted once, by `kit-consolidator` reading the same verification block — recording it here as well would double the evidence behind a candidate.

## State C Comes From the Verification Record

Build State C from the contract's `verification` block: its method, and each clause's verdict and evidence. A clause verified by pioneer confirmation quotes it. **Never build State C from recollection of how the work went, or from facts that are not in the record.** That is State B, and conflating them is how an unverified prediction ends up looking confirmed. If something you remember matters and is not in the block, it is not evidence: name it as an open question in the diff instead.

## The Diff Structure

For each work, produce three states:

**State A — Contracted (what the standard predicted)**
- The approach named in the Tier 3 guardrails
- The patterns, principles and precedents the contract invoked
- The trial or adopted candidates it cited
- The assumptions the contract treated as stable

**State B — Implemented (what was actually built)**
- The approach that was actually used
- Deviations from the contract, with human authorization or flagging
- Any silent deviations discovered post-hoc

**State C — Verified (what reality confirmed)**
- The verifier's clause verdicts, or the recorded pioneer confirmation
- What worked as predicted
- What failed, surprised, or stayed open

## The Diff Questions

For each dimension where State A and State C differ:

1. **What was assumed?** — The specific statement in the contract or standard that predicted this outcome
2. **What was discovered?** — The specific evidence from verification that contradicted or refined the assumption
3. **What is the learning?** — The transferable insight, stated as a principle or pattern candidate
4. **Does this learning elevate or contradict an existing node, precedent or candidate?** — Propose: verify, update, new node, or contradiction to resolve. A contradiction with a **precedent** is surfaced, never resolved here: it reaches the pioneer as a precedent item in a review batch, because only the pioneer overrules.

Where State A and State C agree, record that too. A clean diff is the second maturity signal.

## Stakes Handling

When the diff touches stakes:

- **Transfer what:** Name the stake factually. "Authentication involves credential storage." "Payment processing involves financial transaction integrity."
- **Do not transfer meaning:** Do not label stakes as "high" or "low." Do not weight them in recommendations. The agent presents stakes neutrally. The human calibrates their meaning — and where the human has, their weighting lives in the casebook as a precedent, not in the agent's framing.
- **Operationalize what:** If a stake requires a specific operational response (e.g., "credential storage requires encryption at rest"), that response is transferable. The urgency or priority of that response is not.

## The Learning Log Entry

Each entry is written to `meta-learning/LEARNINGLOG.yaml`:

```yaml
- work_id: work-NNN
  feature: [feature name from contract]
  contract_id: [reference to contract in contract log]
  surfaced_in: YYYY-MM-DD
  states:
    contracted:
      approach: [what the contract predicted]
      principles_invoked: [list]
      patterns_invoked: [list]
      precedents_invoked: [list]
      candidates_cited: [list]
      assumptions: [list of explicit assumptions]
    implemented:
      approach: [what was actually built]
      deviations:
        - what: [deviation]
          authorized: true | false
    verified:
      method: tests | observation | pioneer-confirmation | mixed
      verification_ref: [contract_id → verification, dated]
      result: pass | fail | partial
      evidence: [clause ids and their recorded evidence]
  diffs:
    - dimension: principle | pattern | implementation | stakes
      assumption: [what was assumed]
      discovery: [what was found]
      learning: [the transferable insight]
      node_impact:
        - node_id: [existing node, precedent or candidate]
          action: verify | update | contradict | new
  elevation_proposal:
    - target: [node or new skill]
      kind: principle | pattern | implementation
      evidence: [reference to diffs]
      observation: O-NNN                      # the ledger observation this became
      human_decision: pending                 # back-filled at the reveal with the stage the pioneer chose
```

`human_decision` is written by the main agent at a batch reveal (`meta-skill-builder` → Reveal), using the batch's decision vocabulary — `trial`, `adopt`, `caution`, `decline`, `hold` or `revise` — found by following this proposal's observation to the candidate it merged into.

**Worked example.** Fictional ids (`contract-EX1`, `work-EX1`, `O-EX2`) so nothing here can be mistaken for a real record:

```yaml
- work_id: work-EX1
  feature: user-authentication
  contract_id: contract-EX1
  surfaced_in: 2026-07-23
  states:
    contracted:
      approach: jwt-in-cookie with httpOnly
      principles_invoked: [principle-security-context]
      patterns_invoked: [pattern-auth-jwt]
      precedents_invoked: [P-003]
      candidates_cited: [K-012]
      assumptions:
        - "Cookie storage is secure enough for this domain"
        - "httpOnly prevents XSS extraction"
    implemented:
      approach: jwt-in-header with refresh token rotation
      deviations:
        - what: "Switched from cookie to header due to CSRF in the proxy setup"
          authorized: true
    verified:
      method: mixed
      verification_ref: contract-EX1 → verification (2026-07-22)
      result: pass
      evidence: "UC-1..UC-3, G-1 and G-3 verified by tests (tests/auth.spec.ts); G-2 verified against its authorised revision — header with rotation, staging CSRF test passes."
  diffs:
    - dimension: pattern
      assumption: "Cookie storage is secure enough for this domain"
      discovery: "The recorded verification of G-2 shows the pattern only held after the proxy topology was taken into account"
      learning: "Session-storage patterns must be checked against the actual infrastructure topology, not assumed from stack type"
      node_impact:
        - node_id: pattern-auth-jwt
          action: update
        - node_id: P-003
          action: contradict
    - dimension: stakes
      assumption: "Authentication involves credential storage"
      discovery: "Authentication here also involves how requests pass through the proxy"
      learning: "Stakes extend beyond obvious boundaries to infrastructure interactions"
      node_impact:
        - node_id: principle-security-context
          action: update
  elevation_proposal:
    - target: pattern-auth-jwt
      kind: pattern
      evidence: "diffs[0]; G-2's verification entry"
      observation: O-EX2
      human_decision: pending
```

`LEARNINGLOG.yaml` itself ships empty. Note what the example does *not* do: every fact in State C appears in the verification block, the authorised revision is checked against its revision text rather than marked corrected, and the contradiction with `P-003` is surfaced for the pioneer rather than resolved here.
