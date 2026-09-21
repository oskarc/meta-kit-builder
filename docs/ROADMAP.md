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

- **An agent can write into another repository's kit.** Found the hard way, while contract-023 was being built:
  a test agent told to write the ledger by its project-relative path wrote into a different repository's ledger,
  one the user's global settings make available to every session. Its own write guard let it — the guard matches a
  piece of a path, and every installed kit has the same pieces. The kit gives its agents relative paths, and grants
  extra directories itself for systems that span repositories (contract-010). The write was undone with the
  pioneer's word, and their ruling stands for the work here — tests run on a copy, nothing is written into another
  repository — but the kit's own guards are as they were. Nothing is drawn.
- **What the kit says, or sets up, about permission grants.** On the version probed, every write under a project's
  `.claude/` folder asks the human for a grant outside the program's most permissive mode, and the kit says nothing
  about it anywhere. The pioneer is told they never have to invoke the kit; they are not told what they have to
  approve. A decision, not a repair, so contract-023 left it.
- **The silent-agent message never ends.** Once the gate says an agent "has now run twice and written nothing", it
  says so again every turn, even after the session has recorded the block as asked; and it infers the second run
  from being asked again, not from seeing one. Reproduced during contract-023; not in its scope.
- **A block on a task that covers many entries** — twelve unconsolidated observations — puts only the first entry
  to the pioneer in a sitting. Seen, not drawn.
- **Recording a ledger task blocked while a review batch is open.** The session cannot read the ledger then, so it
  cannot write the block the gate asks for, and the recorder's job is observations only.
- **The install and upgrade path has not had the review** that found the nineteen. The bootstrap skill and its five
  scripts were searched, not read, for contradictions of this kind.
- **Bound the upgrade section, not the paragraph** — which means splitting install from upgrade in
  `meta-bootstrap`. Named in contract-018 under a number that three later contracts have since taken; it has no
  number until it is drawn.
- **Promote "every figure that reaches the pioneer comes from a command"** out of the upgrade procedure and
  into the foundation, where it governs every number the agent shows.

## Review of 2026-09-21 — where one part of the kit contradicts another

**Why it was done.** A downstream report argued that the seal survived four releases because it lives in the
one layer the kit's tests cannot reach: every test here is a shell script, and the permission rules of the
program the kit runs inside do not govern a shell. The pioneer asked for the other places of the same kind, and
for a long-term answer. Nothing below is drawn as a contract.

**What was read, and what was not.** Read in full: the eight agent files, all fourteen hooks, the settings
template, `install.sh`, the six `G` checks and the four `P` checks, the hooks self-test, `waiting-on-you.sh`, and
eight skills — mechanisms, ledger, skill-builder, contract-before-execution, casebook, learning, correction-log
and foundation. Read in part: `transcript-digest.sh`, `records-index.sh`, the fixture set-up of `walk.sh`.
**Only searched** — for named tools, statements about permissions, and leftovers of the retired self-score:
bootstrap, contract-artifact, extract, manifest, map, understanding, antidrift, antidrift-expand, drift-eventlog,
founding-contract, the README, the record templates, `merge.sh`, `preflight.sh`, `residue.sh`, `rollback.sh`,
`roots.sh`. So the install and upgrade path has not had this review, and the list below is a floor, not a count.

**The tally.** Nineteen. Nine seen first-hand that day — by running the real hooks and checks against a throwaway
project, or in a live session. Nine read on both sides and not run. One reasoned from one side. **Nine of the
nineteen were introduced by contracts 019 to 022, the four most recent, and every one of them passed its walk and
its red test.**

### What became of them

**Contract-023, the same day, took every one with a single right answer** — eighteen of the nineteen, by the
pioneer's ruling that obvious conflicts and errors are handled, not parked. One was left because it needs a
decision rather than a repair: what the kit says about permission grants (2). One was taken in part: a blocked
task now has somewhere to be written (6), except a ledger task while a review batch is open. The recorder finding
(4), only reasoned here, was reproduced first-hand during the build — nine reads, no edit, nothing recorded — and
repaired. The evidence is `meta-mechanisms/tests/results/contract-023-T-1-T-12.md`.
What that contract found and did not take is under *Next*, above.

### What someone is told to do, against what they are able to do

1. **The sealed key cannot be written** *(seen first-hand)*. The assembler is told to write it and its own guard
   allows it. In a live session the write was refused because the program treats that folder as a sensitive
   location and asks the human; with nobody to ask, it refuses. That is not the refusal the downstream project
   reported, and here the read rule alone did **not** stop a new file being written into a read-denied folder — so
   the behaviour differs between versions of the program. A script run through the shell wrote the key without
   obstruction, which is how the key is already opened.
2. **Every write into the kit's folder asks for the human's grant, and the kit never says so** *(seen
   first-hand)*. Writing a batch file under the kit's folder was held for approval even with writes pre-approved.
   The kit says the pioneer never has to invoke it, and nowhere says what they have to approve: no text in the
   repository mentions permission modes or allow rules.
3. **The auditor is handed a path it cannot open** *(seen first-hand; contract-019)*. On Windows the digest script
   reports its output under the shell's own spelling of the temp folder; the auditor has no shell and its file tool
   cannot resolve it. `lib.sh` already names that folder as the one with no spelling the two sides share.
4. **The recorder was left out of the fix for agents that run out of turns** *(reasoned)*. Read and Edit only,
   eight turns, and it must read the whole ledger to find the next number. The index given to the consolidator
   and the clerk cannot be run by it.
5. **The reconstructor is told to read every skill and is kept out of two** *(read on both sides)*. Its guard names
   whole folders where the verifier's names single files. The refusal is polite; the cost is small.
6. **A blocked task has nowhere to be written for half the queue** *(read on both sides)*. The blocked state exists
   on four fields. Assembling a batch has no record until a batch exists, and a map miss takes only yes or no —
   yet the gate's fault message says to set "the state key on that record". While a batch is open the session
   cannot write a block into the ledger at all.

### One rule, told two ways

7. **The list of what waits on the pioneer disagrees with the gate** *(seen first-hand; contract-022)*. Four of its
   searches use a plus sign that plain `grep` reads literally, so it never sees unranked cards, precedent
   conflicts, pending map proposals or drift resolutions. And it reports a review waiting at one due candidate
   where the gate opens a batch at three. Its walk state used the one search that works.
8. **"Say nothing about how many items a review batch holds" against "Tell the pioneer how many items there
   are"** *(read on both sides; contract-022)*. The rule being protected hides how many items are due in the
   records, not how many a batch holds; the session-start message states it about the wrong thing.
9. **The contract skill says the casebook is closed during a batch; four other places keep it open** *(read on
   both sides; dated 2026-09-13)*. It was left open on purpose, so a contract drawn mid-batch still gets its
   precedent check. An agent following the contract skill skips a check the auditor then fails it for.
10. **The migration check demands fields the rules say a report entry never carries** *(seen first-hand)*. Known
    from downstream and run again: an entry written exactly as the rule requires fails the check, and the way
    forward the refusal offers points the wrong way.
11. **A forecast is "scored later" in the contract skill and "never scored" in the ledger skill** *(read on both
    sides)*.
12. **The retired self-score still stands in five places, including the foundation** *(read on both sides;
    contract-020)*. The foundation still describes the pioneer's part as watching scores degrade; the four closing
    questions replaced them and the foundation does not mention them. None of the old wording was added to the
    retired-phrases list.
13. **A garbled marker phrase and a stale figure in the mechanisms skill** *(read on both sides; contracts 020 and
    021)*. It names a phrase the hook does not use, and gives the travelling walk 54 states where it has 65.
14. **The newest hook is missing from the self-test, the travelling walk and the inventory** *(read on both sides;
    contracts 021 and 022)*. The self-test says it runs every hook and does not run the one that records an agent
    starting; the only walk that ships writes those lines by hand instead of running the hook.

### A rule written for one case, quietly covering others

15. **A jammed batch step is reported as "waiting on you — nothing is wrong"** *(seen first-hand; contract-021)*.
    See the corrected bullet above.
16. **The launch record counts every agent, not only the kit's** *(seen first-hand; contract-021)*. A project that
    uses any other helper agent is told it "stopped without writing anything" and to resume it.
17. **"Wrote nothing" is judged by the line counts of five records** *(seen first-hand; contract-021)*. A
    consolidator that merges in place changes no count and is told it failed; the reconstructor writes a file that
    is not one of the five, so it always reads as failed.

### Files the kit owns that a project is meant to add to

18. **A project's own refusals are wiped at every upgrade** *(read on both sides; first reported downstream)*. The
    registry is one kit file, replaced whole.
19. **The understanding skill ships registered in no template** *(seen first-hand)*. The completeness check reads
    in one direction only.

### What two live sessions established about the program underneath

Version 2.1.170 of the command-line program; a throwaway project carrying the kit's own permission rule and a hook
that wrote down everything it was sent. Held: the sealed folder cannot be read with the file tools at any depth;
hooks inside an agent are told which agent they are in; guards declared in an agent's own file fire; the launching
tool and its field are named as the kit's matcher expects; the end-of-turn hook receives the last message and can
continue the turn. New: a refused read never reaches the hooks; a small model resolved a project-relative path to
the user's home folder (one observation). **Not probed:** whether an agent's turn limit is honoured, whether a
finished agent can be resumed, whether an agent may read transcripts outside the project, whether the always-loaded
files really load, how stable the transcript's shape is.

### What it points to — nothing drawn yet

The kit verifies clause by clause, and these are failures between clauses. Each contract's tests asked whether the
new rule does what it says; none asked what else now passes through the point that was changed — although the
practice already says a test is drawn from the lay of the land after the work, not from the text the agent means
to write.

1. **Keep the map of who may touch what as a record in the kit** — actors, records, read and write, and which
   layer enforces each — read before any shared point is changed, and against which the agent files and the
   settings are compared. Today it can only be recovered by reading the whole repository.
2. **Name the program underneath as a dependency.** A written list of what the kit assumes of it, observed
   first-hand: a live run before a release here, and a short rehearsal of real tool calls at the end of an
   install, in the pioneer's own program and permission mode.
3. **At the contract gate, ask what else passes through** — judgement, not a mechanism. The guardrails name every
   actor that touches the changed point, and one test is drawn from a neighbour's side.
4. **A proving ground.** No hook has ever fired in this repository, because it is the base; every lifecycle
   failure so far was found by a pioneer downstream. One real project where a release runs the whole loop with
   real agents before anyone else meets it.
5. **Pay for shared points.** The gate, the shared library, the settings and the agents' scopes are where rules
   collide; a contract that touches one carries the heavier burden, and one that removes or merges is worth as
   much as one that adds.
6. **One rule for what an upgrade may replace.** Anything a project is meant to add to lives in a file of its own.

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
- ~~**The spec lock names a tool an agent may not have.**~~ Closed by contract-022: the lock now says to put the
  choices in whatever way the session allows, and never to name one tool as the only way. Left here struck rather
  than deleted, because this list said it was open for a day after it was not.
- **The manifest is YAML-shaped but not valid YAML.** 61 lines would fail a strict read, because an unquoted value
  that begins with a word and a colon parses as a mapping key. Nothing in the kit reads it with a YAML parser —
  the hooks use awk and the portability rule forbids anything else — so it has never mattered. It would matter
  the first time anyone points a YAML tool at a project's records.
