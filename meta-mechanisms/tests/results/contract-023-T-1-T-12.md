# contract-023 — the obvious repairs (T-1 to T-12)

**Date:** 2026-09-21. The review of the same day found nineteen places where one part of the kit contradicts
another. The pioneer's ruling on the list: *"I dont want us to leave obvious conflicts or errors to later, id
like us to handle them."* This contract takes every one with a single right answer. Each test below is drawn
from the side the defect was hidden from — the agent's own guards, the tool the agent really uses, the other
readers of the same rule — because nine of the nineteen had come from contracts that passed tests drawn from
their own clauses.

## How the live tests were run, and why that matters

Three tests run a real session of the program the kit lives inside (Claude Code 2.1.170, unattended). **Partway
through this contract one of them wrote into a real project**: a recorder agent resolved the project-relative
path to the ledger into another repository the user's global settings make available to every session, and
appended a fake observation there. The pioneer was told at once, the lines were removed with their word, and
that repository's diff against its last commit was empty afterwards. Their ruling: tests run on a copy in
another folder; nothing is ever written into another repository (C-036).

Every live run after that was isolated, and the isolation was seen to work before any agent ran in it: the
session loads no user-level settings, so it has no directory but its own; a guard hook refuses any tool call
that points outside the throwaway folder, and was shown refusing a read of this repository from inside one; the
prompt gives the folder's absolute path. **No agent run after that was refused anything by the guard — each
stayed inside its folder.**

One more thing about the ground these tests stand on. An unattended session can write under a project's
`.claude/` folder only in the program's most permissive mode; in that mode, on this version, the *old* way of
writing the key works too. A test run there could not have failed. So the throwaway project carries one extra
hook that refuses the file tools in the sealed folder — which is what both observed versions do in every other
mode — and the kit as it stood at the last commit was run in the same project, to see what the test shows
without the repair.

## T-1 (G-1) — the batch step, run for real

A throwaway project with this kit, the kit's own settings, three due candidates and one unranked card. The
session was given the gate's hand-over for the batch step, word for word, and nothing else.

| | the kit as it was | the kit now |
|---|---|---|
| batch file | written: four items | written: four items, no ledger id in it |
| the file tools on the sealed folder | tried, refused | never tried |
| a shell command naming the sealed folder | tried, refused by the agent's own guard | never tried |
| how the key got written | **by evading its own guard**: it read the refusing hook and the guard's source, then split the folder's name in two inside the command so the text no longer matched | by `seal-key.sh`, first try |
| batch registered in the ledger | yes | yes — `decided: false`, `revealed: false`, `represented: []` |
| what the kit's own hooks recorded | — | a launch and a stop with different fingerprints: it wrote something |

**The left column is the finding.** Four releases of reports say the old design jams: the downstream agent,
refused twice, *"correctly refuses to work around either"*, and no batch is ever assembled. Here a more able
agent, refused the same two ways, went and read why — and wrote the key through a shell command built so that
its own guard could not see the folder's name. The old design offers an agent a jam or an evasion of the kit's
own rule, and which one it takes depends on the agent. The sanctioned script removes the choice: with it, the
agent did neither.

The first attempt at this column was not a fair one, and is kept for what it showed by accident: the old
assembler *text* in a project carrying the new kit sealed the key correctly — it read the ledger skill, which
now says how the key is written, found the script and used it. An agent file that lags an upgrade is carried by
the skill.

The session's whole reply was the assembler's one line, as its file requires.

## T-2 (G-1) — the sealing script refuses what it should

`walk-007` state 207, and the travelling walk's state 78. A key shorter than the batch, an id that is not a
batch id, a batch that does not exist and a second key for a sealed batch are each refused with what to do
next; a whole key is sealed; nothing the script prints ever contains a key line; seal then reveal round-trips.
All six refusals are in the registry — the refusal check caught them as unregistered the moment the script was
written, which is that check doing its job.

## T-3 (G-2) — the gate tells the truth about a jammed batch step

The travelling walk, states 69 to 77. The review's fixture — items due, nothing assembled, three turns — now
ends in the fault message, which names where the block is written (`assembly: blocked`, at the top level of the
ledger) and no longer says *"waiting on you rather than stuck - nothing is wrong with it"*. With the block
written, the gate puts it to the pioneer once and the queue behind it runs. A map miss the steward could not
take is announced the same way. And a task with no blocked state of its own — a contract with no bearing — is
told plainly that there is nothing to write and the pioneer is asked; its fault never mentions a key.

## T-4 (G-3) — only the kit's agents are watched, and "wrote nothing" means nothing changed

States 66 to 68 of the travelling walk and 208 and 209 of `walk-007`. A project's own helper agent neither holds
the kit's queue while it runs nor is read as a kit agent that failed when it stops: the gate hands over the next
real task both times. For each kit agent the edit it really makes — a merge made in
place, a predictions file, a key, a check, a verdict, a clerked correction, a precedent — changes the
fingerprint, and doing nothing does not. The fingerprint's list of places is held to the agents' own files:
fourteen write-scope pieces parsed from the eight agent files, none uncovered. The fingerprint is awk alone
and takes about half a second over this repository's records; it runs when an agent starts and stops.

## T-5 (G-4) — the auditor can open what it is handed

State 210, and one read-only live session. On a Windows shell the script now prints the digest's path with its
drive letter, under the platform's temp folder; the session opened it. It used to print `/tmp/kit-digest-<id>.txt`
for the same file; the session was told *"File does not exist."*

**What the live run also showed.** A path in the shell's other spelling (`/c/…` for `C:/…`) *opened* — because the
model rewrote it to the platform's spelling before calling the tool, which the guard's log of calls shows. An
able agent repairs what it is handed; the failure only shows with a path it cannot translate.

## T-6 (G-5) — every agent's procedure, through its own guards

State 211. Thirty-nine paths the eight agents are told to read, write or stay out of, each run through that
agent's guards with the arguments parsed from its own file. Told-to is allowed; blind-to is refused. Two of them
are the repairs: the assembler may run the sealing script and may **not** write the sealed folder with the file
tools — its scope no longer names it; the reconstructor may read the skill that describes a record and not the
record.

## T-7 (G-5) — the recorder, red first

A ledger of 7,600 lines (420 observations), the same observation dictated each time.

| | launches | tool calls | what happened |
|---|---|---|---|
| the recorder as it was | 3 | 9, then 8, then 7 | first run: nine reads, no edit, nothing recorded. Second: written. Third: "already appended" |
| the first rewrite | 1 | 4 | **numbered it O-251** — the search tool hands back its first 250 lines |
| the recorder now | 1 | 6, and 4 on a second sample | O-421, with its date, one hunk, nothing else changed |

The middle row is the test earning its keep: the procedure written for this contract was wrong, read correctly,
and would have passed any shell test. It now finds the end of the list and reads the last observation, never
the highest id from a search.

## T-8 (G-6) — three readers, one rule

State 212. Eight fixtures through the gate, the session-start list and the waiting list: one due candidate is
not a review; three are; one unranked card, one precedent conflict, one pending map proposal, one drift
resolution or one unratified map entry is — unless the ratification was put off. All three agree on all eight.
The waiting list's line about a review carries no number, and the session-start message now hides how many
items are *due*, not how many a batch holds.

## T-9 (G-7, G-8) — retired wordings; reports and the migration check

State 213. No wording this contract retired still stands; putting one sentence back is caught by name. Fifteen
wordings joined the list — six of them belonging to contract-020, which had retired the self-score and listed
nothing. A report entry written as the rule requires passes the migration check; a contract without a
pre-mortem still fails it.

## T-10 (G-9) — held to the folder

State 214. The self-test runs every hook; every hook and check script has its inventory row; every shipped
skill has its node in the template manifest. On a copy with one of each taken out, all three are named.

## T-11 (G-10) — what is the project's own

State 215. A project's own refusal registry, put on an upgrade's stale list, is spared and named by the install
script; the refusal check passes with a refusal registered only there, and fails without it.

## T-12 (G-11) — nothing else broke

- The travelling walk: all 78 states match `walk.expected`. Of the 65 states that existed before, exactly one line changed — the message for an agent silent twice now names where its block is written — which is the only evidence this kind of test can give that the unchanged paths were not disturbed.
- `walk-004`: 51 passed. `walk-007`: 181 passed, none failed, on the final run over the finished tree — 180 of 181 on the first, for the reason below.
- **What the first full run caught.** One state of an earlier contract failed: it holds that only two mechanisms name the block that closes every output, and the wording this contract had just added to the retired list named it too. The list now retires the garbled phrase by words that do not themselves name the block. That is this contract's own thesis arriving from the other side: a neighbour's test, not the clause's, found it.
- All ten checks exit 0. The always-loaded files are untouched — no difference from the last commit in the intent, the map or the map template.

## The red test

The rule that only the kit's own agents are watched (G-3) was removed from the library, and the removal confirmed — no such line, a different checksum. **Every state still passed.** The state covered a helper agent that had started *and stopped*, which a second filter also neutralises; it did not cover one that was still running, and with the rule gone a project's helper agent held the kit's queue. The state was strengthened — and the travelling walk's with it — and then failed as it should: *"other-agent-ignored=n (the queue was held while it ran)"*. The rule was put back, the library's checksum matched the one taken before the break to the last byte, and the states passed again.

## What this does not establish

- **How any of this behaves on another version of the program.** Every live result is from 2.1.170 on one
  machine. The downstream project saw a different refusal for the same write; the sealing script avoids both,
  by that project's own account of what a shell may do, which was not re-tested there.
- **What a real pioneer meets.** The live runs bypass the program's permission prompts on purpose. On this
  version every write under `.claude/` asks for a grant outside the most permissive mode, and the kit still
  says nothing about it. Left out of this contract as a decision, not a repair.
- **Whether the foundation's new sentences land.** That is the pioneer's to judge.
- **One sample is one sample.** The assembler was run once each way; the recorder twice.

## Found while building, and not in this contract

- After the gate says an agent *"has now run twice and written nothing"*, it says so again every turn, even
  once the session has recorded the block — and it infers the second run from being asked again, not from
  seeing one. Reproduced.
- Where a task covers many entries — twelve unconsolidated observations — only the first blocked entry is ever
  put to the pioneer in a sitting.
- **An agent can write into another repository's kit.** Agents are given project-relative paths, their guards
  match a piece of a path, and every installed kit has the same pieces; a session that can see a second
  repository — which the kit itself arranges for systems that span several — lets a kit agent write there with
  its own guard's blessing. It happened during this contract.
