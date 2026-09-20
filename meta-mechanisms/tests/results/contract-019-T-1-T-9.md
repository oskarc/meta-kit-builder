# contract-019 — a kit that can say a task cannot be done (T-1 to T-9)

**Date:** 2026-09-20. The contract answers a day spent downstream in which a gate asked an agent to do an
impossible thing twenty-one times. The tests below are of three kinds: fixtures in `tests/walk.sh` that drive the
real hook through the blocked path, text and mechanism states in `tests/walk-007.sh`, and one independent agent
given a jammed project and only the kit's own text.

## T-1 (G-1) — the third state, declared in one act

`walk.sh` states 48 to 56 drive the shipped stop-gate against fixtures whose records carry `blocked`, and
`walk-007` state 183 holds the declaration to being in three places at once: the parser (`lib.sh`), the
marker-key table (`meta-mechanisms/SKILL.md`) and the templates for all four fields. State 189 holds the moment
on the map, in both copies, and the failure mode to naming the section that answers it.

**Nothing else moved.** `walk.expected` was regenerated twice, and each diff was read line by line: the only
changes were the four audit hand-overs that now name the digest, and the nine new states. A fixture entry whose
`bearing` contains the words `audited: false` still reads as prose, not state.

## T-2 (G-2) — skipped, and cleared

State 48: the blocked task is put to the pioneer before anything else is routed. State 49: in the same sitting it
is not repeated — the queue below it runs, which is the jam ending. State 51: with the state cleared, the audit is
handed over exactly as before. The clearing is a write the agent makes; nothing waits on the pioneer typing.

## T-3 (G-3) — nothing ends the road

The blocked hand-over names the record, the field, the date, the reason, what it waits for, the three choices and
which the agent suggests. States 48, 50 and 55 hold that for a contract's `audited` and a correction's `clerked`.
State 50: a new sitting puts it again, so an announcement the agent never made cannot vanish. State 56: once it is
announced and nothing else is due, the gate is silent.

**Whether the sentence lands for the pioneer is not testable** and is listed untested; P-008's own check says the
same of itself.

## T-4 (G-4, G-3) — repetition is a fault

States 52, 53, 54: the same hand-over twice is still a backlog; the third turn running with nothing changed is a
fault that names the count, tells the agent to surface it for steering, and suggests the action — recording it
blocked. The turn after the fault routes normally again. The count is the trailing run of identical hand-overs in
telemetry, which the gate already wrote and nothing read.

## T-5 (G-5) — the instrument stops punishing the honest answer

State 184: the rule stands in `meta-antidrift/SKILL.md`, where the score is defined, and in
`meta-foundation/INTENT.md`, which is always loaded. Declining a task whose record reads `blocked` with its reason
is following the practice; no deviation is written.

## T-6 (G-6) — the audit can be started at any size

State 187 holds the auditor to reading a digest, stating what it cannot see, keeping its thirty-turn budget, and
knowing how to block itself; and the gate to building the digest before launching it. State 188 drives
`transcript-digest.sh` over a transcript shaped like a real one and checks every column.

**Measured on this repository's own session transcript** (the one this contract was built in):

| | raw transcript | digest |
|---|---|---|
| size | 70.5 MB, 15,833 lines | 561 KB, 7,385 rows |
| largest single line | 219 KB | one row |
| the contract's id | 0.7 MB | 6.9 KB |
| "Tier 1" / `tier` | 1.1 MB | 48.3 KB |
| "implemented" / `approval` | 12.6 MB | 18.6 KB |
| the drift score blocks | 0.8 MB | 8.8 KB |
| **the four searches together** | **15.2 MB** | **82.6 KB** |

Built in 1.9 seconds. The digest is an index, not a summary: each row keeps its line number, so an exact quote is
one targeted read. What it does not carry — the body of a turn beyond the first 120 characters, 400 for the
pioneer's — is written into the agent file as a stated limit.

**Not measured:** whether an audit *succeeds* on the digest in a live session. T-6 measures the input.

## T-7 (G-3, UC-8) — every refusal carries a way forward

State 185 runs `G6-refusals.sh` over the kit and then over a copy with one unregistered refusal added: it fails,
naming the file, the message and how to register it. State 186 holds the ten refusals that used to end the road —
`G1-size`'s two missing-file refusals, `G3-retired`'s two, `G5-steps`', `G4-pointers`', `P-007`'s, and `release`'s
three — to naming what to do next; `G2-migration`'s shared `fail()` prints one for all of its messages.

38 refusals are registered in `checks/refusal-nextsteps.txt`, each with its next step. A new refusal fails the
check until it has one, which is the point: it cannot enter the kit without it.

## T-8 (G-7) — nothing else broke

- `walk-007` 155 states, `walk` 56 states matching `walk.expected`, `walk-004` 51 states; `G1-size`,
  `G2-migration`, `G3-retired`, `G4-pointers`, `G5-steps`, `G6-refusals`, `P-004`, `P-005`, `P-006`, `P-007`
  all exit 0.
- **The red test.** The gate's audit filter was changed to hand over a blocked task again. `walk.sh` state 49
  failed — the queue below it stopped running — and passed again when it was restored.
- **Two of the kit's own limits bit during the build, and the work shrank rather than the allowance** (P-006):
  `INTENT.md` was exactly on its 5,120-byte cap, so the sentence added there was paid for by tightening four
  others; and `walk-004` holds each map under 7,133 bytes, so the new entry was paid for by pruning six.
- **A retired id was not reused.** The moment took `M-32`: `M-31` belonged to the rebuild moment contract-006
  withdrew, and `walk-004` holds the map to never carrying it again.
- **One test of an earlier contract changed** and is named as a revision: contract-015 T-3 (`walk-007` state 165).

## T-9 (all) — an independent agent, given a jam and only the text

An agent was given a fixture project whose contract entry names a session transcript that does not exist, the
gate's real hand-over, and nothing else — no knowledge of this contract. It was told the pioneer was away.

**It was never stuck.** Its account of why, in its own words: the refusal carried its next steps in the failure
message "so the recovery path arrived with the failure instead of having to be searched for"; those steps named a
destination precisely, and that section held "a literal YAML example of the four keys"; the map "has an entry for
exactly this situation, so the moment had a name before I had a plan"; and the state is machine-readable, so it
could prove its write landed — it ran `blocked_all` and drove the real stop-gate twice on a throwaway copy — "that
is what turned a plausible edit into a verified exit."

It ended with `audited: blocked` and its three keys on the entry, a hand-over written for the pioneer carrying the
refusal verbatim, the contract's own bearing, all three choices and which it suggested, and nothing else written:
no ledger entry, no telemetry, no half audit. Weight: "Heavy to decide, trivially easy to do" — about eight files
and 60 KB read before a four-line edit, and it names the refusal's pointer as what cut that down.

### What it found, and what was done

1. **The node that owns the record did not list the value its own mechanism accepts.**
   `meta-contract-before-execution/SKILL.md` still read `audited` (`true` · `false` · `legacy`) while the parser
   and the mechanisms node read `blocked` too — so an agent following the ownership rule would not find it.
   **Fixed:** the owning skill lists it, with the three keys and where the rule lives.
2. **A refusal addressed a reader who does not exist.** The digest's refusal said to "say so in the audit" — but
   if the digest cannot be built there is no audit. **Fixed:** it names the actor and the act, and the registry
   entry follows it.
3. **A `|` in a reason would have shifted every field the gate reads,** silently. The agent avoided it only by
   reading the awk. **Fixed:** the reader replaces a bar; the section says so.
4. **Two questions it had to settle alone** — whether recording the state and telling the pioneer are one turn or
   two, and whether a block owes a ledger observation. **Fixed:** the section answers both.

**Also raised, and outside this contract:** a project whose manifest says `kit_type: project` while no
`.claude/settings.json` exists reads as installed although no hook can fire, and nothing detects it. Recorded in
`docs/ROADMAP.md` under carried gaps; it is what the fixture itself was.
