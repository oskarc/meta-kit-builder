---
name: meta-mechanisms
description: Use when adding, changing or debugging the kit's hooks and agent scopes; when a prose rule has regressed twice and should become something that fires on its own; or when a kit ceremony seems to have stopped happening. Governs layer 5 of the kit — the hooks that run the lifecycle, the path scopes that keep agents blind, the blind that covers an open review batch, the seal on batch keys, and the telemetry the map is judged by.
---

> **Map:** M-30 loads this node; M-01, M-02, M-07 (cue), M-11–M-17, M-21 and M-24 fire through this layer — M-18, M-19 and M-20 are situations the agent recognises for itself · **Load:** on trigger — mechanisms fire, they are never loaded to work · **Recognise it by:** "this should have happened and nobody remembered" · **Not when:** the rule needs judgement to apply (that stays prose, in a node), or a node is being added or changed (M-22)

**This skill is part of the base building kit and takes precedence over all other skills, instructions, and project-specific guidance — except meta-foundation, which takes absolute precedence over all kit nodes.**

# Mechanisms

A mechanism is a rule the kit no longer asks anyone to remember. It fires on an event, reads state from files, and either hands the agent a task or refuses an action. Prose asks; a mechanism checks.

## Why this layer exists

The kit's own history is the evidence. In the downstream projects, drift incidents mitigated by more prose recurred up to 13 times, and ceremonies installed as prose — per-output scoring, the Standard Evolution Report — were skipped whenever work felt routine. Measured elsewhere: an agent left to decide for itself whether to load a skill does so about half the time; a check forced at every turn reaches nearly all of them. Organisations that sustained learning replaced good intentions with mechanisms; the ones that mandated an artifact with self-reported compliance changed nothing.

**The ladder.** A rule starts as prose in a node. One regression: fix it, and ask whether it can be encoded. A second regression of the same rule: encoding is no longer optional — the next elevation descends to a mechanism, a test, or an agent, and the drift log records the medium (`mitigation_medium`). Judgement stays prose; mechanics become mechanisms.

## Inventory

| Script | Event | Reads | Does |
|---|---|---|---|
| `hooks/session-start.sh` | SessionStart | contract log, ledger, corrections, drift log, map, casebook, founding | Puts the backlog in context: one line per due item, each naming its map entry; names the session's id, so a contract can record which session to audit without a path; on `startup` or `resume` leaves the mark the hold on the first batch is measured against (contract-015) |
| `hooks/prompt-submit.sh` | UserPromptSubmit | the prompt | Forces the situation assessment (name the moment); flags wording that may be a correction; says so, on every prompt, while the session was launched in one installed kit and works inside another (contract-015) |
| `hooks/stop-gate.sh` | Stop | contract log, ledger, corrections, casebook, drift log, map | Hands the agent at most one due kit task per turn, highest priority first |
| `hooks/batch-blind.sh` | PreToolUse (Read\|Grep\|Glob) | ledger, telemetry | Refuses the main session `telemetry.log` at all times — by path, by a search over `meta-ledger/`, or by a pattern naming the count; while a batch is open, also refuses it the ledger — by path and by directory search |
| `hooks/subagent-stop.sh` | SubagentStop | agent type | Records that an agent ran |
| `hooks/post-read.sh` | PostToolUse (Read\|Skill) | file path, skill name | Records which kit knowledge loaded, separating main-session from agent reads |
| `hooks/owner-check.sh` | PostToolUse (Write\|Edit) | file path, manifest `owns:`, telemetry | Records a governed record edited in a session that never loaded its owner's skill — read by kit-map-steward alone |
| `hooks/deny-paths.sh` | PreToolUse, in agent frontmatter | tool input | Keeps an agent blind to named paths |
| `hooks/write-scope.sh` | PreToolUse (Write\|Edit), in agent frontmatter | file path | Limits where an agent may write |
| `hooks/close-batch.sh` | run by the agent with Bash | batch file, ledger | Marks a batch decided once every item carries a decision |
| `hooks/reveal-key.sh` | run by the agent with Bash | batch file, sealed key | Opens the key only after every decision |
| `hooks/mark-done.sh` | run by the agent with Bash at the end of an install or upgrade | telemetry | Writes a `done` line to telemetry (contract-011). The hold on the first batch no longer rests on it: the stop-gate holds the batch whenever the baseline the install or upgrade wrote is newer than the last session start (contract-015) |
| `hooks/lib.sh` | — | — | Shared parsing; the marker-key contract below; one spelling for a path (a Windows shell reports the same file as `/d/x` and as `D:\x`, and both are brought to `D:/x` before any comparison — contract-013) |
| `checks/G3-retired.sh` | run by the verifier and on upgrade | `checks/retired-phrases.txt`, every kit text | Fails when a wording the kit has retired still stands anywhere — a contract that replaces a sentence adds the old one to the list (contract-013) |
| `checks/G4-pointers.sh` | run by the verifier and on upgrade | every `node → Heading` pointer | Fails when a pointer names a heading its target does not have (contract-013) |
| `checks/G5-steps.sh` | run by the verifier and on upgrade | `meta-bootstrap/SKILL.md` | Fails when a paragraph of the bootstrap skill is over 1,200 bytes, naming the line — the text an agent follows while records are at risk stays in steps, and the allowance does not move (contract-016) |
| `hooks/agent-launch.sh` | PreToolUse on the tool that launches an agent | the agent's type and the length of every record a kit agent may write | Records that an agent is STARTING. Nothing did before, so an agent that exhausted its turns, a collision and a task being worked on all looked alike |
| `checks/records-index.sh` | run by an agent before it reads a record | LEDGER.yaml, CORRECTIONS.yaml | One line per item to act on, each keeping its line number, so what an agent must read does not grow with the project |
| `checks/G6-refusals.sh` | run by the verifier and on upgrade | every refusal string in `checks/`, `hooks/` and `meta-bootstrap/` | Fails when a refusal the kit can print is not registered in `refusal-nextsteps.txt` with the next step it gives the reader (contract-019) |
| `checks/transcript-digest.sh` | run by the agent before it launches the session auditor | a session transcript | Writes one row per turn — line, time, who, flags, tools, files, first words — so the audit can be started at any transcript size |
| `checks/preflight.sh` | run at the start of an install or upgrade, from the NEW kit's copy | the staged kit's `RELEASE.sha1`, the ledger, git status, the lock | `check` changes nothing and refuses, each time with its reason, when git is missing, the staged kit is not a whole release, a review batch is open, a lock is left, or the pioneer has uncommitted work (it asks them to commit and push, and says why); `begin` records the starting point in `.claude/kit-upgrade.lock`; `end` removes it (contract-017) |
| `checks/rollback.sh` | run after an install or upgrade that stopped halfway | the lock | Restores `.claude/`, `CLAUDE.md` and the two ignore files to the recorded commit, or from the kept copy outside a repository; leaves the staged kit in place. A half-finished run is never continued (contract-017) |
| `checks/merge.sh` | run on upgrade | a project's copy, the installed copy, the staged copy | git's three-way merge for a skill the project edited — exit code is the number of conflicts, each printed with both versions; `--header` refreshes a record's comment block and keeps the pioneer's notes beneath it (contract-017) |
| `checks/hooks-selftest.sh` | run at the end of an install or upgrade | a throwaway copy of `.claude/` | Runs every hook once against the copy, so the test writes no telemetry and no session mark into the project (contract-017) |
| `checks/residue.sh` | run on upgrade | a project's copy of a kit skill, the yardstick | Prints the lines that are the project's own, taking a re-wrapped line for the kit's (contract-013) |

Installed by `meta-bootstrap` from `templates/settings.template.json` into the project's `.claude/settings.json`. Each kit hook group carries `"_kit": "base-building-kit"`, which is how an upgrade replaces them instead of appending a second copy.

**Which kit a hook acts on.** A hook acts on the kit its event belongs to: `lib.sh` walks up from the event's working directory (`cwd` in the hook input, which follows Claude after `/cd` or a `cd`) to the nearest installed manifest and reads that kit's records; when no ancestor holds one, the launch directory (`CLAUDE_PROJECT_DIR`) stands. The two path hooks, `post-read.sh` and `owner-check.sh`, act only on paths under that root, so a read or an edit in another repository's kit is never this kit's evidence. The settings template and the agents locate the scripts the same way, so a session moved into a kit with `/cd` runs that kit's hooks. Other repositories a system spans are named in the manifest's `workspace` list and granted through `permissions.additionalDirectories`, which loads nothing from them (contract-010). One case is said aloud rather than left silent: a session launched inside one installed kit whose working directory moves inside another — `prompt-submit.sh` tells the pioneer, on every prompt while it lasts, which kit's records are now being governed (contract-015).

**Not installed yet?** `kit_installed` is false when `MANIFEST.yaml` is missing *or* declares a base `kit_type`. The kit ships with its own manifest and its own records; until bootstrap's last seeding step replaces them, every mechanism stays silent rather than running the lifecycle against the base kit's data.

## The stop-gate

At the end of each turn the gate checks, in this order, and hands over the first task that is due:

1. An open batch whose every item carries a decision → run `close-batch.sh` (M-17)
2. A decided batch with an unopened key → run the reveal (M-17)
3. A reported contract with a revision that changes Tier 4 tests dated after the report → surface it as drift; the revision is never applied (M-18)
4. An implemented contract whose session is unaudited → kit-session-auditor, with the session id recorded on the entry as `transcript` (M-11)
5. An implemented contract whose verification reported corrected or open clauses → put them to the pioneer, then close one of three ways (M-12)
6. An implemented contract with `verification_state: none` → kit-verifier, or mark `awaiting-evidence` (M-12)
7. Unconsolidated ledger observations → kit-consolidator (M-14)
8. Verified contracts → meta-learning sweep (M-13)
9. Unclerked corrections → kit-case-clerk (M-15)
10. Pioneer-owned items waiting and no batch open → kit-batch-assembler, then the review batch (M-16) — held until the next session start after an install or upgrade (`done` in telemetry, contract-011)
11. Three or more unstewarded map misses → kit-map-steward (M-21)
12. A live contract with no bearing → surface it to the pioneer (M-24)

Step 10 fires on three or more due candidates, or on any pending map proposal, unratified map entry, unranked scenario card, precedent conflict or drift entry awaiting resolution — so pioneer-owned items that are not candidates are not stuck behind a candidate threshold. **It never names how many items are due:** with the batch size visible, that count would give away how many re-presented items the batch carries. Unratified *base* map entries are excluded while `MAP.md` carries `ratification: deferred`, so a fresh install does not open ten ratification batches before any feature work.

**Every step names a write that ends it.** A task whose only exit the agent cannot reach would repeat every turn and hide every step below it, which is the failure `drift-002` records.

**Guards.** `stop_hook_active` allows one forced continuation per turn, and Claude Code caps consecutive continuations at eight. A turn whose visible text ends by asking the pioneer a question is never extended: the guard splits the text at the **last** `What should you have based the framing score` marker — the block that closes every output, a phrase that also appears in ordinary prose — and looks for a question mark in the closing 400 characters of each side, before the block and after it (contract-007 G-6). A deferral is written to telemetry as `stop-deferred|question`, which kit-map-steward reads: a session that defers turn after turn is a lifecycle that has stopped, not a conversation. A late question mark that was not a question costs one turn of delay; a buried question is the worse failure. The gate uses `additionalContext`, which continues the conversation without reporting a hook error.

## Agent scopes

Each kit agent declares `PreToolUse` hooks in its own frontmatter: `deny-paths.sh` with the paths it must not see, `write-scope.sh` with the only paths it may change.

**Limits, stated plainly.** Scopes cover the ordinary path and nothing more:
- A Grep over a parent directory can still reach a denied file.
- `write-scope.sh` matches `Write` and `Edit`. An agent that also has `Bash` can write through a shell command; its instructions, not the hook, hold that line.
- An agent's own transcript, under `~/.claude/projects/<session>/subagents/`, records what it read, and the session auditor does not read those.
- `kit-session-auditor` is deliberately **not** blinded to `kit-sealed/`: its `sealed_access` form check greps transcripts for that very string, and `deny-paths.sh` inspects the `pattern` field, so a deny would disable the check. The agent that polices sealed access is therefore the one agent that could read the key, and only its instructions stop it.

Blindness here is a discipline made cheap to keep, not a security boundary.

## The blind and the seal

A review batch may carry items the pioneer already decided, shown again as if new (from the fourth batch on). Two mechanisms keep them indistinguishable from the rest:

- **The blind.** At all times, `batch-blind.sh` refuses the main session `telemetry.log` — the ownership count lives there, and a count the session can read becomes a ceremony (contract-005 G-1). While any batch is `decided: false`, it also refuses the main session's reads of `LEDGER.yaml`, by any path spelling, and any Grep or Glob whose search path covers a directory holding it. It deliberately does **not** close the casebook: scenario cards and precedents are never re-presented, so closing it would only break the precedent check (M-04, M-05) for contracts drawn while a batch waits. Kit agents keep their access — they are not the presenter — which is also how an implementation that finishes mid-batch still records its observations: the main agent hands them to `kit-recorder`, whose write scope is the ledger. To close the batch without reading the ledger, the agent runs `close-batch.sh B-NNN`, which sets `decided: true` only when every item carries a decision (any non-empty value, including a ranking such as `[B, A, C]`).
- **The seal.** The key lives in `.claude/kit-sealed/`, and the project's `permissions.deny` carries `Read(kit-sealed/**)` — a single-segment deny pattern, which per Claude Code's permission rules matches that directory at any depth, and which the docs say is applied to Grep and Glob on a best-effort basis and inherited by subagents. `reveal-key.sh` is the one sanctioned opening and refuses until every item is decided. Bash can still read the directory; any sealed-path access in a transcript before a reveal is drift, and the auditor reports it. The directory is gitignored so the key never surfaces in a diff.

**What neither covers:** Bash reads, and the pioneer, who can open the ledger themselves. Re-presentation records whether a real item was decided the same way twice when the batch is read as presented, not under adversarial inspection — and it is recorded per item, never as a rate.

## Telemetry

`meta-ledger/telemetry.log`, append-only, one line per event: `timestamp|event|detail`.

| Event | Written by | Used for |
|---|---|---|
| `session-start` | session-start.sh | sessions as a denominator; only `startup` counts as a new session for fading |
| `prompt` | prompt-submit.sh | turns as a denominator |
| `loaded` | post-read.sh | a map target the main session loaded — the map's firing evidence |
| `loaded-agent` | post-read.sh | the same read made by a kit agent; never evidence that a map entry fired |
| `subagent` | subagent-stop.sh | which agents actually ran — the firing evidence for entries that launch agents |
| `stop-gate` / `stop-deferred` | stop-gate.sh | how often the lifecycle intervened, and how often it waited |
| `batch-blind` | batch-blind.sh | attempts to read the ledger while a batch was open |
| `bypass` | owner-check.sh | a record a node governs was edited in a session that never loaded that node's skill — `bypass\|<node>\|<path>`. Ownership evidence for kit-map-steward, which alone reads it; no hook or skill surfaces the count to the acting session, because a count the agent can see becomes a ceremony (contract-004 G-6) |
| `batch-decided` / `reveal` | close-batch.sh, reveal-key.sh | batch cadence |
| `done` | mark-done.sh | an install or upgrade ended; one of two signs that hold the stop-gate's batch step until the next sitting (`startup` or `resume`) — the other, which needs no script, is a baseline newer than the session's mark |

Telemetry is evidence, never context: no agent loads it whole, and it does not extract. **The main session cannot read it at all** — `batch-blind.sh` refuses the file by path, any search over `meta-ledger/`, and any Grep whose pattern names the count, at all times (contract-005 G-1); the steward and the consolidator, which run as agents, read it. A wide search from above `meta-ledger/` with a pattern that names nothing in the file is the stated limit.

**What "loaded this session" means to the ownership check.** `owner-check.sh` looks for a `loaded` line for the owner's skill file — or `loaded|skill:<folder>` from the Skill tool — **since the last `session-start` whose source was `startup` or `clear`**. A resume or a compaction keeps what was loaded in context, so those do not reset the lookback; a clear empties the context, so it does. Loads by agents (`loaded-agent`) never count: the agent read it, the session did not.

## The marker-key contract

The scripts read state through flat keys. Two rules make that parsing honest, and both are load-bearing:

- **Indentation decides what is state.** A marker is read only at the entry's own indentation — the column two spaces right of the entry's opening `-`. An enumerated value quoted inside a tier block, a revision note or a description is prose, not state.
- **Trailing comments are allowed** on any marker value.

| File | Keys the mechanisms read |
|---|---|
| MANIFEST.yaml | its presence, and `kit_type` (`base` means "not installed here"); per node `id`, `skill_file` and `owns` — a flow list `[a, b]` or a block list, paths relative to `.claude/skills/`, a folder covering what is under it — in either the one-line node form the template seeds or the block form |
| CONTRACT-LOG.yaml | entry-opening `contract_id` (a `report-NNN` id or `type: analysis-report` marks an entry the gates skip), `status` (approved \| implemented \| verified \| learned \| legacy), `verification_state` (none \| awaiting-evidence \| reported \| closed-by-follow-up \| legacy), `audited` (true \| false \| legacy \| blocked), `bearing`, `transcript` (`null`/`~`/`none` read as absent), and beside a blocked state `blocked_since`, `blocked_reason`, `blocked_waiting_for` — each one line; `verification.date` at the entry's indentation + 2, and per `revisions` item `date` and `tests_changed` (`[]`/`null`/`none` read as no tests) |
| LEDGER.yaml | entry-opening `obs_id`, `cand_id`, `batch_id`, `prop_id`, `audit_id`; `consolidated` and `revealed` (true \| false \| blocked, with the `blocked_*` keys beside them), `stewarded`, `review_due`, `state: pending`, `decided`, `revealed` |
| CORRECTIONS.yaml | `clerked` (true \| false \| blocked, with the `blocked_*` keys beside it) |
| CASEBOOK.yaml | `pioneer_ranking: pending`, `conflict: P-NNN` |
| DRIFTLOG.yaml | `status` (`watching` is counted in the backlog; `mitigated` makes a resolution item due; `legacy` — a pre-upgrade entry the pioneer deferred — is counted nowhere and presented in no batch) |
| MAP.md | the trailing `proposed` / `ratified` / `declined` column, and the `ratification: deferred` marker |
| FOUNDING.md | `### Amendment`, `**Caused by:**`, `**Now binds:**`, "Not yet given", "Deferred by the Pioneer" |
| batches/B-NNN.md | `## I-n` headings, `Decision:` lines with any non-empty value (bold markers allowed) |

`legacy` marks entries that predate v0.14 so the gate does not demand audits of history. Nothing validates instance files against this table (gap-025): a renamed key or an unlisted value switches a mechanism off silently.

## Portability

bash, sed, awk, grep, tr and date — and git, by the pioneer's ruling of 2026-09-19 ("the kit may use git."): the install and the upgrade take their snapshot, find their way back and merge the pioneer's lines with it. The hooks themselves still use none of it. No jq, no python. **This is the tool list a contract cites** when it guarantees a hook's portability; a shorter list elsewhere is a paraphrase of this one, not a stricter rule. Claude Code on Windows requires Git for Windows, which provides all of them. Avoid `grep -iF`: it aborts in some Git for Windows builds; `lib.sh` provides `contains` instead. Ship the scripts with LF endings (`.gitattributes`: `*.sh text eol=lf`); CRLF breaks them under bash. Hook input is read from the request only — `lib.sh` truncates the payload before any `tool_response`, so an echoed field cannot override `tool_input`.

## Adding or changing a mechanism

A mechanism is a node change and needs a contract (M-30). The contract's Tier 3 names the event, the files and keys read, the output, and its Tier 4 the fixture test: a sample hook input and the exact output expected. Run the fixture before and after — **and walk the lifecycle, not only the script**: one batch and one contract through every state, because each hook can pass while the loop they form deadlocks. Every walk exits non-zero on a failure. `tests/walk.sh` ships with the kit and runs in any project: it drives the stop-gate through 54 states and diffs against `tests/walk.expected` (regenerate that file only when a gate message changed by design — the command is in the script's header). `tests/walk-004.sh` (the ownership check, late test revisions, retirement, the batch) and `tests/walk-007.sh` (what session-start says, the question guard, the size check, import-loaded owners, the README's structure) are the base kit's own contract walks: they read this repository's templates, docs and manifest, and do not travel. The checks under `checks/` are run by the verifier and on every upgrade; `G1-size.sh` travels, the `P-NNN.sh` checks are this repository's own precedents and do not. Extend them with every mechanism change; a state the walk does not visit is a state nobody has seen. Add the row to the inventory, the keys to the marker-key contract, and — when the mechanism replaces a prose rule — record `mitigation_medium: mechanism` on the drift entry it answers.

## Failure modes

- **Silent rot.** A renamed key, a moved file, a path the matcher no longer sees. The mechanism stops firing and nothing errors. Watch telemetry for events that stop appearing.
- **A step nobody can clear.** Every gate task must have a write that ends it. A task with no exit repeats every turn and blocks every step below it. Answered by Blocked tasks below (contract-019), which is the exit when the write cannot be made.
- **Over-triggering.** A gate that hands a task every turn becomes noise the pioneer tunes out. One task per turn, and questions are never buried.
- **False authority.** A mechanism that passed says the form held, not that the judgement was sound. A bearing that exists is not a bearing that steers.
- **Mechanising judgement.** A hook that decided whether a learning is elevation or recovery would be a green light on a judgement nobody made. Mechanisms route and refuse; they never elevate.

## A workflow that heals itself

Four kit agents ran out of turns eight times in two days downstream, every one with the work done and nothing
written, and a person restarted each by hand. Four times the gate dispatched a second agent while the first still
held the ledger, and only someone watching stopped the collision. Twice it called a task waiting on the pioneer a
fault. The pioneer's words: the workflow is fragile as it stands, and before anything else it must be
self-healing (contract-021).

**An agent is recorded starting, not only stopping.** `agent-launch.sh` writes the agent's type and the length of
every record a kit agent may write; `subagent-stop.sh` writes the same again. Equal lengths mean nothing was
written. From those two lines the gate can tell four states apart that used to look identical: running, never
reported finishing, stopped having written nothing, stopped having written something.

**While an agent runs, nothing else is dispatched.** That is a lease, in the sense a durable workflow engine
means: a hold on the queue that expires. If the agent never reports finishing, the hold lapses after three gate
firings, the gate says so plainly, and the queue continues - a worker that dies silently cannot keep a task
forever.

**An agent that wrote nothing is resumed, once.** Not restarted: told to write what it already has. A second
silence records the task blocked with its reason and the queue moves on. The recovery is the workflow's, never a
command the pioneer runs (P-004).

**Waiting is not failing.** A hand-over repeating because the pioneer has not answered is waiting; the gate says
so rather than calling it a fault. Only a task with nobody and nothing pending is a fault.

**The queue's depth rides along.** Every hand-over names how many other kit tasks stand behind it, so a backlog
reaches the pioneer without their having to ask. Pioneer-owned items stay uncounted (contract-011).

## Blocked tasks

A gate task that cannot be completed is written down as such, and the pioneer is asked for guidance. The pioneer's
ruling of 2026-09-20: *"No check must block the work being initiated, if something is not possible to resolve; ask
the pioneer for guidance."* Before it, a task that could not be done and a task nobody had got to were recorded
identically — `audited: false` either way — so the gate asked for the impossible every turn and every step below it
went unserved. A day of that downstream is what drew contract-019.

**The state.** Each of the four lifecycle booleans — `audited`, `clerked`, `consolidated`, `revealed` — takes
`blocked` as a third value, with three one-line keys beside it at the entry's own indentation:

```yaml
    audited: blocked
    blocked_since: 2026-09-20
    blocked_reason: the transcript is 70 MB and the auditor's search returns whole turns, so it fills its budget first
    blocked_waiting_for: a digest of the transcript, built by checks/transcript-digest.sh
```

The reason lives on the record beside the state, not in the drift log, by the pioneer's ruling: one read finds both,
and the drift log is written by other agents.

**What the gate does with it.** A blocked task is skipped, so the queue below it runs. Once per sitting — not once
ever, or an announcement the agent never made would disappear — the gate hands the agent the task of putting it to
the pioneer: what is stuck, what it waits for, the choices, and which the agent suggests. Clearing it is the agent's
write, never the pioneer's command (P-004): set the key back to `false` once what it waits for exists, and the task
returns to the queue.

**Recording it and saying it are one act, not two turns.** "One kit task per turn" governs the tasks the gate hands
over; writing the state and putting it to the pioneer is a single one. No ledger observation is owed for a block —
what was learned goes in the hand-over, where the pioneer can see it and decide. Keep each of the three values to
one line and leave `|` out of them: the gate reads these fields bar-separated, and the reader replaces a bar
rather than let it shift a field.

**Repetition is a fault, not a backlog.** The same hand-over three turns running with nothing changing means the
task cannot be cleared the way it is being tried. The gate stops repeating itself, says so, and tells the agent to
surface it for steering with a suggested action — usually to record it blocked. The count is the trailing run of
identical hand-overs in telemetry, which the gate already writes; any other gate event breaks the run.

**Every refusal carries a way forward.** The same ruling governs the scripts: a refusal names what to do next, and
where the agent can do nothing, it says to ask the pioneer. `checks/G6-refusals.sh` holds every refusal the kit can
print to that rule — a message not registered in `checks/refusal-nextsteps.txt` fails the check, which is how a new
refusal cannot be added without one.

## What this skill does not do

- It does not decide anything that belongs to the pioneer — the gate hands tasks to the agent, never decisions
- It does not make agents' blindness, the blind or the seal a security boundary — see the limits above
- It does not replace prose for rules that need context to apply
