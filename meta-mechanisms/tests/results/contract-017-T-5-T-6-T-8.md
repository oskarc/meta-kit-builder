# contract-017 — the rehearsals (T-5, T-6) and the forward check (T-8)

**Date:** 2026-09-19. Every rehearsal below was an independent agent given one line — what the
session-start hook prints when a newer kit is staged — and the staged kit's bootstrap skill as its only instruction.
It kept notes of every place the text was unclear, contradicted itself, or made it do something the steps do not
say. Each upgraded project was then checked by the building agent, not on the rehearsing agent's word. Blindness
rested on instruction, not mechanism.

Two of the three kinds of project failed the procedure's own pass rule on their first run. What they found was fixed
in the kit and the run repeated; every run is listed, the failed ones included.

## T-5 — a test project shaped like a real one

**The project (`fx016`, built by `tests/fixtures/make-upgrade-fixtures.sh`).** Installed at 0.16, with installed
copies and a current-format baseline, committed. In it, the project's own work: a passage added to one kit skill; an
edit inside a sentence the new kit also rewrote; two notes kept in the contract log's header; a learning-log header
replaced wholesale. Staged: a release of the kit's tree as it stood.

| Run | Steps the text did not describe | What it found |
|---|---|---|
| 1, rehearsal | 2 — did not pass | **The rehearsal log blocked the run that ordered it**: the procedure has it written into the project, and the preflight then refused because of that uncommitted file. **Nothing said what the rehearsal copy holds where a merge conflicts**: the remaining steps would have run on a file with conflict markers in it. **Two of the three conflict answers could not be carried out**: the pioneer's kept line held a wording the kit has retired, the retired-wordings check failed, and nothing may ask after the sheet. |
| 2, rehearsal | 2, both small — did not pass | Where the log is written (the copy has no `docs/`), and whether a rehearsal runs the closing steps of a run that never took a lock. Both now said in the text. The three holes of run 1 were gone. |
| 2, real run | **0** | The pioneer's answers were *both* on the conflict and *port* on the replaced header, the rest defaults. Every answer came from the sheet; no question was met that the sheet had not carried. The agent's words: "The rehearsal predicted the real run exactly." |

**Fixes made between runs.** `preflight.sh` sets the rehearsal log aside when it looks for uncommitted work, and any
other uncommitted file beside it still refuses. `merge.sh --take yours|kit|both` settles a file's conflicts by the
tool; a rehearsal copy takes the kit's side, the sheet still carries the conflict, and its default is the kit's so
that *defaults* stays a complete answer. `G3-retired.sh` holds only the kit's text to its list: a line that does
not stand in the kit's shipped copy of the file is the pioneer's and is reported as a note. Empty folders get a
`.gitkeep`, because a clone loses them. A rehearsal takes no lock and writes no done block.

**Checked independently on the upgraded project, after run 2's real run.**

- The hold on the first review batch is on with the done script's line taken away, and there is no session mark in
  the project: the hook test ran on a throwaway copy. This is the defect of contract-015, repaired.
- The project's telemetry holds one line, the done line. The tests wrote nothing into it.
- The contract log's header carries exactly its two notes; the learning log carries the new header with the
  pioneer's two lines beneath it; every record's body is unchanged.
- The conflicted skill holds the kit's new wording, then the pioneer's sentence, and no marker. The retired-wordings
  check passes and names the pioneer's two lines as notes.
- The migration check passes when run from outside the project. The templates and the installed copies are the new
  ones — replaced last, after the comparisons that needed the old ones. The lock and the staged kit are gone.
  `git status` shows one set of changes, all the upgrade's.

## T-6 — copies of two real projects

**An install from before the map and the hooks** (no baseline, no installed copies, no ledger, no founding file, its
own hooks in settings, a kit block in `CLAUDE.md` without markers).

| Run | Steps the text did not describe | What it found |
|---|---|---|
| 1, rehearsal | 4 — did not pass | **A contradiction this contract had introduced**: "replace the templates last … whatever the pioneer answered" overrode the rule that a template the pioneer chose to *reapply* keeps their lines. **No moment for the founding statement on the upgrade path**: such a project has never been asked for one, and the agent wrote *deferred by the pioneer*, which nobody had said. The list of what travels did not name the four new scripts the steps call. The span of an old kit block without markers had an ambiguous end — and a paragraph of the pioneer's own sat inside it, with nothing saying to carry it over. |

All five are fixed in the text: a reapplied template keeps its merged file; a template that cannot be told from an
older kit's text is replaced and the report says where the old one is; the rehearsal seeds the founding file as
*not yet given* and the presentation asks for the statement in the install's own words; the travel list names every
script; the span ends before the first rule or foreign heading, and a paragraph of the pioneer's inside it is carried
beneath the new block. **Not rehearsed again**: the second run on this kind of project is left to its own upgrade,
whose first step is a rehearsal on a copy.

**The first downstream project, at 0.16** (99 project skills, 81 contract-log entries, 17 drift entries at
*mitigated*, kept notes in three record headers, one header replaced wholesale).

| Run | Steps the text did not describe | What it found |
|---|---|---|
| before this contract | 5 — did not pass | Step 5 replaced the old templates before step 7 needed their text: 9 kept header lines came out as 14, 8 as 12. No stand-in answer for two standing questions. The rehearsal copy lacked the two ignore files. |
| with this contract's kit | see the contract's log entry | The pioneer answers this sheet themselves; the result is recorded on the entry. |

## T-8 — nothing built here has to be undone by what is left for later

| Left for later | What in this contract it builds on | What it would undo |
|---|---|---|
| **Installing the rehearsed copy** instead of repeating the run by hand | The lock and the snapshot: a swap needs a way back, and `rollback.sh` is one. The hook test already runs on a copy. `merge.sh` makes the reapplying a command, so the copy and the real run cannot differ by an agent's hand. Figures from commands, re-run before acting. | Nothing. One sentence of step 2 — "Discard the copy. Only then run steps 3–9 on the project" — would be replaced, and `rollback.sh` would gain a branch that swaps a folder back. |
| **Migrations chosen by version** | `RELEASE` carries the version a staged kit is; the manifest carries the version a project is on; `preflight.sh` already reads both. `release.sh` could ship one migration per version beside the skills without any change to how a release is built or verified. | Nothing. Step 7's one list would be divided by version; its "gains this if absent" wording is already safe to repeat. |
| **The kit's program kept apart from the project's data** | `not-shipped.txt` is already the list of what is data. `RELEASE.sha1` is already the list of what is program, so "replace the program folder whole and verify it" is one check away. The hooks read every record's path from one function in `lib.sh`. `rollback.sh` restores `.claude/` whatever is in it. | One thing would retire, not break: `merge.sh --header`. It exists because a record carries the kit's instructions in its header; with instructions moved out of the records, there is no header to refresh. "Replaced last" would stop mattering and do no harm. |

## What none of this shows

Any hook firing live in Claude Code. A push to a remote, which the preflight asks for and cannot see happen. A
project that is not a repository, beyond the kept-copy path in the walk. Whether a pioneer finds the sheet clear —
the first downstream project's sheet is the first one a pioneer has answered.
