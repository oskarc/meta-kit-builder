# Roadmap — base building kit

**What this file is.** What the kit is going to do next, and the analysis that put it there. It is written
for someone who has not been in the room: each item says what is wrong now, what it would cost to leave it,
and what would change.

**What it is not.** It is not a record. The records are the contract log, the ledger, the correction log and
the casebook, and nothing here decides anything — an item leaves this file by being drawn as a contract and
approved, or by being struck out. Finished analyses live in `docs/reports/`.

---

## Built — the kit can now say "this cannot be done"

**Status:** contract-019, implemented 2026-09-20 at v0.27. The analysis that put it here is kept below, because it is what the
work answers to. Evidence: `meta-mechanisms/tests/results/contract-019-T-1-T-9.md`.

### What happened

A project running the kit at v0.25 hit this for a whole working day, and its agent wrote the day up. The
sequence was: a gate task asked the agent to run the session auditor; the auditor cannot finish on a
transcript of that size; the agent declined, honestly and with a reason; the gate, which reads one
true/false field, asked again. Twenty-one times.

Nothing in the kit lets an agent write down *attempted, cannot complete, here is why*. `audited` is `true`
or `false`. So an impossible task and a neglected one are recorded identically, and the gate cannot tell
them apart.

Three things followed, and the third is the one that costs most:

1. **The queue jammed.** The gate hands over one task per turn in a fixed order of twelve, and the audit is
   fourth. While it never clears, positions five through twelve are unreachable — consolidation, the
   learning diff, the case clerk, the batch assembler. All of them work. None of them ran.
2. **The human became the scheduler.** Every task below position four that ran that day ran because a
   person typed its name. The kit's own promise is the opposite: *"When a hook hands you a kit task, do it.
   The pioneer never has to invoke the kit."*
3. **The instrument punished the honest answer.** Declining a kit task is a deviation from an active skill,
   and the kit requires a named human confirmation for a deviation. Twenty entries in that agent's own
   fidelity score say it departed from the practice — for giving the only true answer available. An agent
   optimising that score launches the broken agent instead, lets it fail silently, and writes nothing.

### What we checked, in this repository

Every claim was read against the kit as it ships. All of it holds.

| Claim | Where it is true |
|---|---|
| The auditor is told to search rather than read | `agents/kit-session-auditor.md` step 1: "Transcripts are large: use Grep, not a whole-file Read." It has `maxTurns: 30`. |
| A search returns whole turns, not lines | A transcript is JSONL — one line per turn, with every tool result inside that line. A match hands back the turn. |
| The gate is strict priority, audit fourth | `meta-mechanisms/hooks/stop-gate.sh` — the first matching task wins and the rest are never evaluated. |
| The kit names this failure and measures it nowhere | `meta-mechanisms/SKILL.md`: "Every gate task must have a write that ends it. A task with no exit repeats every turn and blocks every step below it." |
| A refusal scores as a deviation | `meta-antidrift/SKILL.md` requires a named human confirmation for any deviation; `meta-foundation/INTENT.md` says to do the task a hook hands over. |
| The presentation check is inside the broken agent | `presented_for_pioneer` exists in exactly one place: the auditor. Contract-014's guarantee is unenforced whenever the auditor cannot run. |

### What we measured here

The same searches, on a 70.5 MB session transcript from this repository — 15,833 turns, the largest single
turn 219 KB:

| The search the auditor is told to make | What comes back |
|---|---|
| the contract id | 0.7 MB |
| "Tier 1" | 1.1 MB |
| "implemented" | 12.6 MB |
| the drift-score blocks | 0.8 MB |
| **all four** | **15.2 MB, inside a thirty-turn budget** |

The strategy is unbounded: the transcript grows with every turn, including the turns spent discussing the
problem. The downstream file was 19 MB and already impossible; ours is three times worse.

### Two things the downstream report did not find

**The kit solved this once already, one field over.** `verification_state` carries a real vocabulary —
`none · awaiting-evidence · reported · closed-by-follow-up · legacy`. `awaiting-evidence` *is* "attempted,
cannot complete, here is what is needed", and the gate routes on it correctly. The third state exists. It
was never carried to `audited`, `clerked`, `consolidated` or `revealed`.

**A third value would work today — as a silent failure.** The hooks' parser only accepts `audited:` when
the value is `true`, `false` or `legacy`. Write anything else and the field reads as absent, the gate skips
the task, and nobody is told. That is gap-025, already written down in `meta-mechanisms/SKILL.md`: an
unlisted value switches a mechanism off silently. So the escape hatch exists in the worst possible form.

### What this says about us

This repository's contract log holds 23 entries. 21 are implemented and unaudited, and **no audit has ever
run here.** The gate is silent in the base kit (`kit_type: base`), so the jam never bit us — which is
exactly why nobody noticed. The auditor's first use at scale was downstream, and it failed there.

The walks could not catch this either. `tests/walk.sh` drove the gate through 36 states and proved the right
task wins the priority order; it hands each state to the hook directly and never runs an agent, so it
cannot show whether the winner can finish. It now has nine more states that drive the blocked path — but it
still runs no agent, which stays a carried gap below.

### What was built, in that order

1. **A third state on every gate task.** `audited`, `clerked`, `consolidated` and `revealed` take `blocked` with
   `blocked_since`, `blocked_reason` and `blocked_waiting_for` beside it, on the record. The gate skips a blocked
   task and routes the queue below it, and puts it to the pioneer once a sitting with the choices and a suggested
   action. Clearing it is the agent's write.
2. **A gate that notices repetition.** The same hand-over three turns running with nothing changed is a fault, not
   a backlog: the gate says so and suggests the action, reading the telemetry it already wrote.
3. **A bounded input for the auditor.** `checks/transcript-digest.sh` turns a transcript into one row per turn —
   line, time, who, flags, tools, files, first words. On this repository's own 70.5 MB session, the four searches
   the auditor is told to make went from 15.2 MB to 82.6 KB. The agent builds it before launching the auditor,
   which has no Bash.
4. **A refusal with a recorded reason no longer counts as a deviation** — said in `meta-antidrift` and in the
   always-loaded intent, not only in the mechanism.
5. **And what the pioneer's ruling of 2026-09-20 added:** every refusal the kit can print now names a way forward,
   held by `checks/G6-refusals.sh` against a registry of all 38 of them. Ten had ended the road.

---

## Next

- **The seal: why the batch step cannot write its key.** The one step of the lifecycle that has never run, across
  three releases and three reports. The kit's own hooks permit the write and the project setting that guards the
  path is a read rule, so the cause is in how the permission behaves at runtime, which cannot be reproduced from
  the base kit. Contract-021 made the failure survivable — it stops the queue once rather than forever — and left
  the cause here.
- **Bound the upgrade section, not the paragraph** — which means splitting install from upgrade in
  `meta-bootstrap`. Named in contract-018, which called it contract-019; the vocabulary of failure took that
  number and the closing four took contract-020, so this is contract-021.
- **Promote "every figure that reaches the pioneer comes from a command"** out of the upgrade procedure and
  into the foundation, where it governs every number the agent shows.

## Research — where this has been solved already

**Done 2026-09-21.** Six sources read first-hand; one, Bainbridge, read only through an encyclopaedia summary
because the paper would not render — her own sentences are still unread and nothing below quotes her. Sources
and extracts are kept locally under `research/`.

The question was what other disciplines do about a workflow that recovers from its own failures without a
person. Seven findings, ordered by what they change here.

### 1. We collapse four different failures into one

Temporal detects four things, with four separate timeouts, because they are four different problems: work that
was queued and never picked up; a single attempt that hangs; the whole job including all its retries; and an
attempt that is running but making no progress. The kit has one crude version of the second.

The consequence is concrete: **we cannot tell an agent that never started from one that started and died.** Both
read as "launched, no stop recorded". The first needs relaunching, the second needs resuming, and telling an
agent to "write what you already have" when it never ran is nonsense.

And the sentence that justifies the whole apparatus, which applies exactly to us: *"The Temporal Server doesn't
detect failures when a Worker loses communication with the Server or crashes."* No engine detects silent death
directly. Every one of them infers it from a timeout, which means our lease is the right shape and the right
answer is more kinds of timeout, not a cleverer one.

### 2. Nothing heartbeats, and that is the signal we most lack

A heartbeat is a ping that says work is still progressing. It is the only thing that tells a slow agent from a
stuck one — and telling those apart is precisely what we cannot currently do. The index built this week already
gives an agent a per-item structure to report against: an item finished is a natural beat.

### 3. Escalation should be graded, and ours has two rungs and no clock

Erlang's supervisors carry an intensity and a period: more than so many restarts within so many seconds and the
supervisor stops trying and escalates to its parent. Ours is intensity one with no period at all — resume once,
then block, however far apart the failures are. Its warning also lands: intensities **multiply** across levels,
so an agent that retries internally, under a gate that resumes, under a pioneer who restarts, makes far more
attempts than any layer intended.

### 4. Toyota's cord does not stop the line, and the popular version we were carrying is wrong

Pulling the andon cord raises a signal. The line keeps moving to the next fixed position — one work cycle, five
to thirty seconds — and the team leader has that window to resolve it. The line stops only if they cannot. Two
things follow. There is a **bounded window for the nearest responder before anything escalates**, which is what
our single resume accidentally is. And the stop happens at a **safe point**, the end of a work cycle, never
mid-task — which we do not honour: nothing stops a block being recorded in the middle of a write.

### 5. Backoff, with a cap and a reset

Kubernetes restarts a failed container after 100ms, doubling to a five-minute ceiling, and resets the counter
once the thing has run cleanly for ten minutes. We resume immediately, into exactly the condition that just
failed. If the cause is size — which the evidence says it is — an immediate retry is a retry into the same wall.

Its three probes are the same lesson as finding 1 from another angle: *started*, *healthy* and *ready for work*
are three questions with three different answers. The startup probe exists because slow-starting things were
being killed by health checks meant for running ones — which is exactly the mistake a shorter lease would make
here.

### 6. A gap this reading found in what we shipped last night

Every one of these engines assumes at-least-once delivery, and therefore demands that retried work be
idempotent. **Our resume is not.** "Resume and write what you already have" is safe only if the agent had
written nothing; if it had written half its items and stopped, nothing prevents it writing some of them twice.
No run has shown this, because no agent has yet been resumed after a partial write — which is luck, not design.

### 7. Two warnings that bound the whole direction, and disagree with each other

Google's definition of toil ends with a caution aimed straight at the conclusion this kit has been drawing:
it warns against using *"human judgment"* as an excuse for poor system design. Our reading of one day's evidence
— that mechanisms caught five failures with a shape and a person caught twelve without one — is one step away
from being exactly that excuse.

Bainbridge's is the opposite warning. Automating the parts that can be automated leaves the human only the parts
that cannot, with less practice at them and a monitoring job people do badly. The better the workflow heals
itself, the rarer and harder the pioneer's interventions become. Her remedy is not less automation but more
preparation — the operator needs *more* training for the rare crucial moment, not less.

Held together: automate what has a shape, and do not let "that needs judgement" become the reason a shapeless
failure was never given one. But expect that every success here raises what is asked of the pioneer on the day
something falls outside it.

### What should be drawn from this

Nothing is drawn yet. In order of what the evidence supports:

1. **Idempotent resume** — the gap above, in work already shipped. Smallest and most urgent.
2. **Tell "never started" from "started and died"**, because the recovery differs.
3. **A heartbeat**, so slow and stuck stop looking alike.
4. **A period on the escalation**, and backoff with a reset, rather than an immediate retry into the same wall.
5. **Record a block at a safe point**, never mid-write.

## Later — the shape changes contract-017 left standing

Each is its own decision, and none is blocked by the others:

- installing the rehearsed copy instead of repeating the run on the real project
- choosing migrations by version rather than running every one
- keeping the kit's program apart from the project's data
- the gaps only an old-format baseline would meet (`docs/reports/report-004-upgrade-rehearsal-at-0-24.html`)

## Gaps carried, not yet scheduled

- **gap-025** — nothing validates a record against the marker-key table; a renamed key or an unlisted value
  switches a mechanism off silently.
- **The auditor has never run in this repository.** Whatever it would find about our own sessions is
  unknown, and 21 entries are waiting.
- **No walk runs an agent.** Every walk hands states to the hooks directly, so a task that wins the priority
  order and then cannot finish is invisible to all of them.
- **A project can read as installed with no hooks wired up.** `kit_installed` is false only when the manifest is
  missing or declares a base `kit_type`. A project whose manifest says `kit_type: project` but which has no
  `.claude/settings.json` passes that test while no mechanism can fire, and nothing detects it. Found by
  contract-019's T-9 agent, in the fixture it was given.  Seen a second time by contract-020's T-7 agent, which named
  it unprompted in a different fixture.
- **The practice has no shape for "the contract cannot be drawn yet."** An agent asked to plan a fix could not
  write the last two tiers without facts no file in the project held. The blocked state covers a lifecycle task a
  hook hands over, not a build request the agent cannot responsibly tier. It improvised, correctly, from the
  pioneer's ruling that nothing may stop the work without asking — but the procedure does not name the case.
- **Two moments claim the same request.** "Tell me what you would do, no code yet" reads as both a build request
  and analysis work; the two entries' boundaries do not settle it. The agent chose by the recognition test —
  whether the next action changes a file — which is in one skill and not in the map.
- **The contract artifact skill and the contract skill disagree on when a contract is published** — before
  approval by one, on approval by the other.
- **The spec lock names a tool an agent may not have.** It requires the question tool for its blocking decisions;
  a subagent has none, and the step degrades silently into prose.
- **The manifest is YAML-shaped but not valid YAML.** 61 lines would fail a strict read, because an unquoted value
  that begins with a word and a colon parses as a mapping key. Nothing in the kit reads it with a YAML parser —
  the hooks use awk and the portability rule forbids anything else — so it has never mattered. It would matter
  the first time anyone points a YAML tool at a project's records.
