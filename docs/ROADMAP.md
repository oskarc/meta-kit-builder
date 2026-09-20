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

Named from knowledge, not yet read. The pioneer asked for the lay of the land before the kit invents its own
answer to a problem other disciplines have worked on for decades. Each line is the one idea worth taking.

| Domain | The idea |
|---|---|
| Durable workflow engines (Temporal, Step Functions, Airflow) | Progress is journaled as it happens, so a dead worker resumes from the log. Leases with expiry answer "is it running or stuck" and "who holds this record" with one mechanism. Dead-letter queues keep what cannot be processed from blocking everything behind it. |
| Erlang and OTP supervision trees | Let it crash, restart under a declared strategy, and a restart intensity limit: more than X restarts in Y seconds escalates to the parent instead of looping. Recover, recover, then stop and tell someone. |
| Autonomic computing and Kubernetes | The monitor-analyse-plan-execute loop over shared knowledge, and reconciliation: compare declared desired state against actual and close the gap continuously, rather than dispatching a plan step by step. |
| Site reliability engineering | Automated remediation with an explicit last rung — a human is paged only once the automation has exhausted its options. Runbooks, error budgets, the toil-versus-work distinction. |
| Databases | Write-ahead logging: record the intent before the act, so recovery can replay or unwind. The kit already borrows this for the upgrade; it argues an agent should write intent first, not result last. |
| Toyota: jidoka, andon, poka-yoke | A machine stops itself rather than produce defects, and the stop is visible and owned. Mistake-proofing makes the wrong action impossible rather than detectable. |
| Resilience engineering and human factors | Bainbridge's *Ironies of Automation* (1983): automating the easy parts leaves the human only the hard parts, with less practice at them — which is the five-against-twelve split, stated forty years ago. Woods on graceful extensibility covers running out of adaptive capacity. |

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
