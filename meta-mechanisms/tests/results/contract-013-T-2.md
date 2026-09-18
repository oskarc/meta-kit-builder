# contract-013 T-2 — both flows read from first step to last

**Date:** 2026-09-18 · **Read:** `meta-bootstrap/SKILL.md`, whole file, in one pass, after the contract's first edits.
**The test:** *neither flow contains a sentence after the sheet that tells the agent to stop, ask, surface or wait on
the pioneer.* The retired-wordings check (`checks/G3-retired.sh`) carries every old sentence named below; this file
is the read itself, which a check cannot do.

## What the two flows are allowed to stop for

- **Install:** the sheet (Step 2), then the founding statement (Step 3), which the skill gives its own moment. Nothing
  after Step 3.
- **Upgrade:** the sheet, produced by the rehearsal (step 2). Nothing after it. Step 1's *"Equal means nothing to do —
  say so and stop"* comes before the sheet and ends the run; it is not a question.

## Sentences after the sheet that read as an ask, or described a flow the kit no longer has

Two were named when the contract was drawn. The read found ten more. All twelve are reworded, and each old wording is
on the retired list, so the check fails if one returns.

| Where | It said | It says now |
|---|---|---|
| Step 5b | stop and surface an agent-name collision | do as the sheet's collision line answered; nothing stops here |
| upgrade step 3 | the agent asks how to resolve a conflict | the rehearsal finds it and the sheet carries it; one it missed is left out and listed in the done block |
| frontmatter description | offers the one-off map ratification pass | runs it when the sheet chose it |
| *What This Skill Does* | offers a single pass to ratify the base map | runs one when the pioneer chose it on the sheet |
| Step 5, opening | everything here is shown to the developer before it is written | everything written here was shown on the sheet; nothing is shown again, and nothing asks |
| Step 7, heading | Then Offer the Ratification Pass | Then the Ratification Pass as the Sheet Answered |
| Step 6h | the kit's own checks stay: `G1-size.sh` and any later `G*.sh` | every `G*.sh`, `roots.sh`, `residue.sh` and `retired-phrases.txt` — the same list the upgrade's travel sentence gives |
| the template rule | parts the pioneer changed are asked about once per file | …once per file, on the sheet |
| upgrade step 2 | unreapplied lines listed for the pioneer to weigh at the real run | …to weigh on the sheet, before the real run |
| upgrade step 2, pass rule | the ratification pass (step 9, when offered) | (step 9, when the sheet carries it) |
| upgrade step 7, `MAP.md` | a reworded entry is asked about | a reworded entry goes on the sheet's instance-file line |
| upgrade step 8 | the ratification pass step 9 offers | the ratification pass, when the sheet chose it |

## Sentences read and left, with the reason

- Step 3, *"Wait for the statement, or an explicit deferral"* — the statement's own moment, by design.
- Step 7, *"On a pass: present the entries in their map groups"* — runs only when the pioneer answered *now* on the
  sheet's line 7; it is the thing they chose, not a new question.
- Step 6h, *"list every `{binding}` … for the pioneer to re-bind"* — a list in the report; the sheet's line 4 already
  said it would come. No reply is waited for.
- upgrade step 3, *"show the pioneer what differs"* — in a rehearsal this goes into the log and onto the sheet; the
  next paragraph says the real run does not present it again.
- upgrade step 9, *"there is nothing to ratify; say so in one line, ask nothing"* — says itself that it does not ask.

## What this read does not show

Whether an agent following the text behaves this way. The text no longer tells it to ask; no install or upgrade has
been run on the text as it now stands. That run is the rehearsal on the shipped fixtures, which this contract leaves
to after contracts 014 and 015.
