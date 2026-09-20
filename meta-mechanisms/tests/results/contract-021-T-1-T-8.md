# contract-021 — a workflow that heals itself (T-1 to T-8)

**Date:** 2026-09-20. The lifecycle ran end to end in a real project for the first time and the pioneer held it
together by hand: four kit agents ran out of turns eight times in two days, every one with the work done and
nothing written; four times the gate dispatched a second agent while the first still held the ledger; twice it
called a task that was waiting on the pioneer a fault. This contract makes the workflow notice and recover from
each of those itself.

## T-1 (G-1, G-2) — an agent that writes nothing is noticed and resumed

`walk.sh` states 58 to 61, driven through the real hook. An agent is launched; the fixture records it with the
length of every record a kit agent may write. It stops with those lengths unchanged — which is what exhausting a
turn budget looks like from outside — and the gate's next hand-over is **resume that agent, do not start it
over, and tell it to write what it already has**. The same again and the task is recorded blocked with its
reason, and the queue moves on. `walk-007` state 196 holds the launch record itself and the settings that wire
it to the tool that starts an agent.

**The recovery is the workflow's.** Eight times downstream it was the pioneer typing "write what you have".

## T-2 (G-3) — what an agent must read is bounded

State 198, measured on this repository's own records:

| | bytes |
|---|---|
| the ledger and the correction log together | 109,506 |
| the index of what an agent must act on | **12,414** |

**8.8 times smaller**, 103 lines, and every item due appears in it: 74 unconsolidated observations and 26
unclerked corrections, each line carrying the line number in the record so the agent opens the record only at
the item it is working on. The state fails if the index is not at least four times smaller, or if a single due
item is missing from it.

This is the same move the transcript digest made for the audit, and it answers the cause rather than the
symptom: one consolidation merged sixteen observations inside its budget and a later one merged two and
exhausted — what changed was the record each had to read first.

## T-3 (G-4) — the gate does not dispatch into work in flight

State 59: with an agent recorded as launched and not yet stopped, the gate is silent — nothing else is
dispatched. State 62: when that agent never reports finishing, the hold expires after three gate firings, the
gate says so plainly and the queue continues. A hold that expires is what a durable workflow engine calls a
visibility timeout; without it a worker that dies silently keeps a task forever.

## T-4 (G-4) — waiting is not failing

States 63, 64, 65: the same hand-over three turns running, where the next move is the pioneer's, says *"it is
waiting on you rather than stuck — nothing is wrong with it"* rather than calling it a fault. The two tasks whose
next move is theirs — the verification hand-over and the review batch — are marked as such in the gate itself.
With nothing in flight and nothing owed by the pioneer, the fault fires as before (state 53).

Downstream the old behaviour advised an agent to record a working mechanism as blocked, twice.

## T-5 (G-5) — the queue's depth reaches the pioneer unasked

State 58, and state 35 which changed to carry it: every hand-over now ends with how many other kit tasks stand
behind it. Pioneer-owned items are still never counted, which contract-011 requires — knowing how many are
really due would let the re-presented ones be counted out.

Downstream, fifty-one proposed standards accumulated across a day and the pioneer learned of it by asking.

## T-6 (G-1) — a step that cannot run is recorded and routed past

The same mechanism as T-1: an agent that cannot complete its work twice has its task recorded blocked and the
queue moves on. The batch step that cannot write its key downstream is exactly this shape — it stops the queue
once rather than for three releases.

**Not reproduced here:** why that write fails. It is the harness's permission behaviour on a path the kit's own
hooks permit — the assembler's write scope includes the seal, and the project setting that guards it is a read
rule. That cause is named in the roadmap and is not this contract's.

## T-7 (G-6, G-7) — the fixture is a project now

**This is why three releases missed the batch failure.** The lifecycle fixture had no project settings, no seal
and no agents — it drove hooks with synthetic input and could not reach any of it. It now carries all three, and
state 201 holds it to that.

- `walk-007` 167 states, `walk` 65 states matching `walk.expected`, `walk-004` 51 states; all ten checks exit 0.
- **The red test.** The in-flight hold was removed. Walk state 59 failed — the gate dispatched a second agent
  while the first was still recorded as running, which is the collision that needed a person watching.
  Restored: 65 of 65 again.
- **Three earlier tests changed** and are named as revisions: contract-010 T-6 (the settings template carries an
  eighth hook), contract-015 T-3 (the travelling walk is 65 states), and the walk's own version states.
- **The refusal check caught this contract's own new refusal** before any test did, and it was registered with
  its next step.

## T-8 (all) — an independent agent

Deferred to the next session with the evidence named: it needs a project whose consolidation genuinely exhausts,
which means records larger than this repository's. Recorded here rather than claimed.

## What this does not establish

- Whether bounded reading actually prevents exhaustion in a live run at scale. The index is 8.8 times smaller
  than the records on this repository; whether that is enough for an agent working a project with years of
  records is unmeasured.
- Whether three gate firings is the right lease. It is a number chosen so a hold cannot outlive a turn or two of
  real work, not derived from anything.
- Whether the fingerprint — the length of every record — misses a write that changes a line without adding one.
  An agent that edits a field in place and writes nothing else would read as silent. No such run has been seen.
