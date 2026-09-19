# contract-018 — the step that became a script (T-1 to T-6)

**Date:** 2026-09-20. What this contract claims is that a step an agent performs from prose can be performed two
different ways, and a step that is a shipped script cannot. The tests below are of two kinds: fixtures in
`tests/walk-007.sh`, which hold the script to what step 5 names, and two independent agents given one sentence and
the repository's address and nothing else, which is the only way to find out whether an arriving agent can use it.

## T-1 (G-1) — the script performs step 5, and refuses instead of guessing

`walk-007.sh` states 178a to 178f, each on a fresh fixture project whose settings are the ones its last install
shipped, whose `CLAUDE.md` carries the markers, and which holds two precedent checks.

| State | What it holds to |
|---|---|
| 178a | A plan naming a template or an installed copy is refused — they are what steps 7 and 8 compare against — and the project hashes identically afterwards. |
| 178b | The planned files are taken, the agent is deployed beside them, the settings are written, the kit block is replaced and what follows it kept, the folders and ignore entries are added, the stale file is removed. |
| 178c | A settings file with something of the project's own in it is refused, with what to do about it, and nothing at all is changed. |
| 178d | With `--skip-settings` the rest is done and the report says the settings were left to the agent. |
| 178e | A `CLAUDE.md` with no markers is refused, and the span the block would have replaced is printed, so the pioneer's own paragraph is seen before anything decides its fate. |
| 178f | In install mode: the agents are deployed, the installed copies the next upgrade measures against are written, the application is granted in the settings and named in the kit block. |

Both cold-start agents (T-4) called the same script from the same text: the upgrade one reported "70 files taken,
8 agents deployed, 1 stale removed" from `install.sh upgrade <plan>`.

**Not measured:** a by-hand run of the old prose against a script run, file for file. The prose it replaces no
longer stands, so there is nothing to run it against; what is measured is the script against what step 5 names,
item by item.

## T-2 (G-2) — a precedent check of the project's own is never deleted

State 179a. The fixture holds `P-010.sh`, whose precedent is in its casebook, and `P-004.sh`, whose is not. After
the run: `P-010.sh` is still there and the report says it was spared and why; `P-004.sh` is listed stale and
removed, as before. The rule is a refusal inside the script that deletes, not a clause in a paragraph.

## T-3 (G-3) — the retired-wordings check at both points of an upgrade

States 179b and 179c, on a project fixture with installed copies.

- Mid-upgrade, before step 9 has replaced the templates: an old template's retired wording is a **note** — the kit
  keeps no shipped copy of a template, so whose the line is cannot be told — while a base line the upgrade forgot
  still **fails** the check. Both in the same run.
- After step 9 has replaced both: the same check is clean, with nothing left to read.

States 177b and 177c (contract-017) still hold the other half: in a project, a retired wording in a line the
pioneer wrote is a note, and the same wording in a line the kit shipped still fails.

## T-4 (G-4) — two agents, one sentence and an address

Each agent was given the repository's address, one sentence of brief, and nothing else. Neither had read this kit.

**Install, into an empty project.** It got to the procedure's first stop — the sheet — with the kit staged and the
ground check passing, and stopped there because the pioneer was not available to answer. Its own account: "Light to
place, heavy to present. The placing is genuinely four commands at the top of the README, and three of them worked
first time." About 350 lines read before acting; about 1,400 in total to be able to write the sheet. "At no point
did I have to invent a procedure — the only invention was the missing `mkdir`."

**Upgrade, on a copy of a 0.16 project.** It rehearsed the whole upgrade end to end and stopped where the procedure
stops, with one sheet of seven questions. Its three numbers: **decisions asked 6**, **files that genuinely differed
3**, **troubleshooting steps 0** inside steps 3 to 9. Inside the rehearsal: `G1` to `G5` all 0, `hooks-selftest`
11 of 11 against a throwaway copy, `tests/walk.sh` 47 of 47, baseline 89 → 98 files. Seven places it had to decide
something the text leaves open are listed in its notes; five of those are choices the text makes the step's own.

Two refusals landed as designed and were not troubleshooting: `merge.sh --header` exit 3 on a header the pioneer
had replaced wholesale ("keep, overwrite or port"), and `merge.sh` exit 1 handing back one counted conflict with
both versions, which went onto the sheet verbatim.

### What the two runs found, and what was done

1. **The release command wrote into the kit's own repository when given a relative path.** `release.sh` did
   `cd "$SRC"` before creating the output folder, so `release.sh release-026` created it *inside the kit clone* —
   and reported success. **Fixed:** the path is now resolved where the command was typed, before the script moves
   to the kit, and a path inside the kit repository is refused with a sentence that says why. State 182.
2. **The README's placement command failed on a first install**, because `.claude/skills` does not exist yet:
   `cp: cannot create directory ... No such file or directory`, with nothing to say what to do. **Fixed:** both
   placement lines carry `mkdir -p`. State 180.
3. **Two different accounts of step 5 on the install path.** The upgrade's step 5 named `install.sh`; the install
   path still described 5a to 5g as motions to perform by hand, and never named the script. An agent would have
   done the same step two ways in two runs — which is the defect this whole contract is about, surviving in the
   half of the text the draw did not look at. **Fixed:** the install path names the same command, says which part
   it does not do (5f, a library kit's own skill files), and keeps 5a to 5g as the description of what it does.
   State 180.
4. **`G3-retired.sh` run before the map header is refreshed** reports `meta-map/MAP.md:4 still says "copies this
   file"`. Not a defect: step 7 refreshes that header and step 9 runs the check, in that order. Recorded because
   the output looks alarming when a check is run out of its place — a candidate for contract-019.

## T-5 (G-5) — the log learns what a report is

State 181: the eight records are named in the procedure, the migration leaves an entry that is an analysis report
alone instead of giving it a pre-mortem, a red test and a cost, the status enum admits `published`, and the step 9
report carries the efficacy question — "what can this project do now that it could not do before?"

**Not measured:** a fixture whose contract log holds a report entry, migrated by a live run. The migration is
performed by the agent from the text, not by a script, so there is nothing mechanical to run it through; the
evidence is the text, the template's enum, and this repository's own log, where report-004 and report-005 carry
`status: published` and no pre-mortem or red test.

## T-6 (G-6) — nothing else broke

- **All walks and checks pass**, run together after the last change: `walk-007` 148 states, `walk` 47 states
  matching `walk.expected`, `walk-004` 51 states; `G1-size`, `G2-migration`, `G3-retired`, `G4-pointers`,
  `G5-steps`, `P-004`, `P-005`, `P-006`, `P-007` all exit 0.
- **Every check exercised in a project's state, not only here.** Inside the upgrade rehearsal (T-4), on an upgraded
  copy of a real 0.16 project, `G1` to `G5`, `hooks-selftest.sh` and `tests/walk.sh` were run by the rehearsing
  agent and all passed. The fixtures add the states an upgraded project cannot reach on its own: a settings file
  with the project's own groups, a `CLAUDE.md` with no markers, a plan aimed at a template, a mid-upgrade check.
- **Every test of an earlier contract that changed is named** as a revision on this contract's entry, with what
  moved and why: contract-010 T-3 and T-4 (the grant and the block's placeholder are written by `install.sh` now,
  not by the step's prose), and contract-017 T-7 (the sentence about what is replaced last, in its new words).
- **The red test.** The sparing rule's casebook lookup in `install.sh` was disabled; state 179a failed —
  `FAIL 179a sparing`, 147 passed, 1 failed — and passed again when it was put back.
