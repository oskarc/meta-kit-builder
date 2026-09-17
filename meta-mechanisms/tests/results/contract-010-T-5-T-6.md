# contract-010 T-5 and T-6 evidence, 2026-09-17

## T-5 - two installed kits, hooks anchored on the first (walk-007 states 138a-138d)
Fixture: kit A and kit B, each with an installed manifest, the kit's hooks copied into both, CLAUDE_PROJECT_DIR = A.
- a Read of B's meta-map/SKILL.md writes nothing into A's telemetry (138a);
- a Read of A's own skill still writes `loaded|meta-map/SKILL.md` into A's telemetry (138b);
- session-start told `cwd` is a subfolder of B reports B's backlog ("Contracts implemented, session not audited")
  and writes its session-start line into B's telemetry, not A's (138c, 138d).
Before this contract the same fixture (report-001) logged B's read as A's evidence.

## T-6 - the locator (walk-007 states 139a-139c)
The template's SessionStart command, extracted from settings.template.json and run through bash from a subfolder of
kit A with CLAUDE_PROJECT_DIR=/nonexistent, prints kit A's backlog: the command walked up from $PWD to lib.sh.
All seven template commands and all sixteen agent hook lines use the same locator. Not run through Claude Code
itself (untested: that Claude Code substitutes only its three documented placeholders).

## Red test
G-5 broken (the under_root guard deleted from post-read.sh): state 138a red, 69 passed 1 failed; restored: 70/70.
Two walk runs overlapped once during this contract and each saw the other's temporary edit of walk.expected
(state 99b); walk.expected was restored from git and the final run, alone, is the one recorded: walk-007 70/70,
walk.sh 36/36, walk-004 51/51.
