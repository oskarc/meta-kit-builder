# Upgrade rehearsal — fx013, base kit 0.14 → 0.15

Run on 2026-09-13 against this folder, which is itself the throwaway copy the bootstrap's step 2 calls for.
Followed the **staged** kit's `meta-bootstrap/SKILL.md` → *Upgrading an Existing Install*, steps 3–9, with the
pioneer's answers stubbed exactly as step 2 specifies: *keep* for every differing file, *remove* for the stale
list, *legacy* for every existing contract, *none for now* for the map question, *defer* for the ratification
pass, and the report accepted at the end.

Step 1: project `kit_identity.base_kit_version: 0.14`; staged `kit_identity.version: 0.15`. Not equal, so the
upgrade proceeds. The project's field is present, so this is not a pre-0.14 project.

---

## 1. The three numbers

### Decisions asked — **3**

| # | Question | Stub answer | Legitimate under the pass criterion? |
|---|---|---|---|
| D1 | `.claude/skills/meta-casebook/SKILL.md` is evolved here — overwrite with the staged, keep yours, or port the staged changes by hand? (shown: the diff against the staged copy) | **keep** | Yes — a file that genuinely differed |
| D2 | The stale list, one question for the whole list — remove these 9 paths? | **remove** | Yes — standing question (step 3) |
| D3 | The ratification pass over the 30 base map entries — run it now, or defer? | **defer** | Yes — standing question (step 9) |

**Questions the procedure did *not* ask, correctly:**

- **The step-7 contract standing question** (whether any recent implemented contract should be verified and
  audited rather than marked legacy) was **skipped entirely**, because `contract-001` already carries both
  `verification_state: none` and `audited: false`. The procedure says to skip it in exactly that case, "since
  then both answers write the same file". Had it been asked it would still have been legitimate — it is one of
  the four standing questions — but skipping it is one decision the pioneer does not spend.
- **The step-8 map question** never arose: fx013 registers no project nodes, so no entries were drafted, nothing
  waited in `proposed-entries.md`, and the map budget was never forced.
- **The pioneer's acceptance of the report** at the end is not counted, per the criterion.

### Files that genuinely differed — **1**

A file "genuinely differed" when it differs from the baseline **and** its content differs from the staged copy.

| File | Why |
|---|---|
| `.claude/skills/meta-casebook/SKILL.md` | Hash differs from the baseline under both the raw-byte and the line-ending reading, and its content differs from the staged copy — the project added a "Project addition" section and kept the withdrawn launch-rebuild material |

Full tally over the 72 files under `.claude/skills` and `.claude/agents`:

| Classification | Count | Question asked? |
|---|---|---|
| Untouched — hash matched the baseline directly | 20 | no |
| Untouched — matched **only** through the line-ending fallback | 49 | no |
| Untouched — not in the baseline because the pre-0.15 pattern did not cover it (`walk.expected`, `settings.template.json`) | 2 | no |
| **Evolved here** | **1** | **yes (D1)** |
| Stale — present here, absent from the staged kit, or base-kit evidence an earlier install carried | 9 paths | one question for the list (D2) |

### Troubleshooting steps — **0**

Nothing had to be done that the procedure does not say. No script errored, no hook misbehaved, no step had to be
reordered or improvised.

**Separately, one slip of my own, disclosed and not counted.** In the step-9 script I invoked
`tests/walk.sh` twice — once to print its tail and once to capture its exit code — which pushed that shell call
past its 120-second limit and into the background. That is my scripting inefficiency, not a defect in the
procedure: the procedure says to run the checks once, the walk passed on the first invocation
(`walk: all 36 states match walk.expected`), and the second run changed nothing. I am **not** counting it as a
troubleshooting step, because a troubleshooting step is something needed to make the upgrade work, and the
upgrade worked. The pioneer can overrule that judgement; if counted, the third number is 1 and the rehearsal
fails on its own criterion.

### Verdict against the bootstrap's own criterion

> "The rehearsal passes only when every decision asked belongs to a file that genuinely differed or is one of the
> four standing questions … with the pioneer's acceptance of the report at the end not counted, and the third
> number is zero."

D1 belongs to the one file that genuinely differed. D2 and D3 are standing questions. The third number is zero.

**PASS.**

---

## 2. The classification, as presented

Presented before anything was changed, as step 3 requires. The baseline (`meta-manifest/INSTALLED.sha1`) was in
the **pre-0.15 form** — `*`-prefixed paths, hashes over raw bytes — so the leading `*` was dropped and the
line-ending fallback applied to every mismatch.

**Untouched here → take the staged version, no question asked (69 files + 2 uncovered by the old pattern)**
All 8 deployed agents and all 8 kit copies under `skills/agents/`; every `meta-*/SKILL.md` except the casebook;
`meta-foundation/INTENT.md`; all 12 hooks; all 10 templates; `tests/walk.sh`, `tests/walk.expected`;
`CONTRACT-LOG.yaml`, `CORRECTIONS.yaml`, `LEDGER.yaml`, `DRIFTLOG.yaml`, `LEARNINGLOG.yaml`, `CASEBOOK.yaml`,
`MANIFEST.yaml`, `MAP.md`, `FOUNDING.md`.

**Evolved here → one question (1 file)**
`meta-casebook/SKILL.md`. What differs from the staged copy was shown in full: the staged kit withdrew the launch
rebuild (its `### The launch rebuild (M-31)` section becomes `### The rebuild — withdrawn from the map`), dropped
`M-31` from the header, and this project has added a `## Project addition` section the staged kit does not carry.
It is not under `templates/`, so the "keeping it costs you the yardstick" warning did not apply.

**New in the kit → add (3 files)**

- `agents/kit-batch-assembler.md` (replaces the retired `kit-canary-author`)
- `meta-mechanisms/hooks/reveal-key.sh` (replaces `reveal-canaries.sh`)
- `meta-mechanisms/checks/G1-size.sh` — the kit's own check; the staged `P-004`–`P-007` are the base repository's
  own precedent checks and do not travel, and neither do `walk-007.sh`, `tests/fixtures/` or `tests/results/`

**Stale → one question for the whole list (9 paths), with what a *keep* would leave pointing at nothing**

| Stale path | Why | Kept file still referring to it |
|---|---|---|
| `.claude/agents/kit-canary-author.md` | absent from the staged kit | — |
| `.claude/skills/agents/kit-canary-author.md` | absent from the staged kit | — |
| `meta-mechanisms/hooks/reveal-canaries.sh` | absent from the staged kit | — |
| `templates/REBUILD.template.yaml` | withdrawn rebuild template | **`meta-casebook/SKILL.md`** (kept) names it |
| `meta-mechanisms/tests/walk-004.sh` | the base kit's own contract walk | — |
| `meta-mechanisms/tests/fixtures/make-T-2.sh` | the base kit's own fixtures | — |
| `meta-mechanisms/tests/results/T-2-2026-09-12.md` | the base kit's own evidence | — |
| `meta-mechanisms/tests/results/T-7-2026-09-12.md` | the base kit's own evidence | — |
| `meta-mechanisms/tests/results/contract-004-tiers.sha1` | the base kit's own evidence | — |

No `P-NNN.sh` check was present here, so none went on the list.

### The step-3 template-rule record

Made in step 3 and written down **before** step 5 replaced the templates, because that is the only surviving copy
of the yardstick by the time step 7 runs:

```
HEADER-AS-TEMPLATE-WROTE-IT   meta-contract-before-execution/CONTRACT-LOG.yaml  -> refresh from staged
HEADER-AS-TEMPLATE-WROTE-IT   meta-correction-log/CORRECTIONS.yaml              -> refresh from staged
HEADER-AS-TEMPLATE-WROTE-IT   meta-ledger/LEDGER.yaml                           -> refresh from staged
HEADER-AS-TEMPLATE-WROTE-IT   meta-drift-eventlog/DRIFTLOG.yaml                 -> refresh from staged
HEADER-AS-TEMPLATE-WROTE-IT   meta-learning/LEARNINGLOG.yaml                    -> refresh from staged
HEADER-AS-TEMPLATE-WROTE-IT   meta-casebook/CASEBOOK.yaml                       -> refresh from staged
HEADER-AS-TEMPLATE-WROTE-IT   meta-manifest/MANIFEST.yaml                       -> refresh from staged
MAP.md header comment            — as the template wrote it (modulo project name) -> refresh from staged
MAP.md base entries              — ALL 31 read as the installed template wrote them -> all refreshable
MANIFEST base node + coverage    — ALL read as the installed template wrote them  -> all refreshable
FOUNDING.md header comment       — as the template wrote it (modulo name/date)   -> refresh from staged
```

Every template-written part was untouched by the pioneer, so **no part of any instance file had to be asked
about** — the template rule produced zero questions here.

---

## 3. Every migration applied, file by file

Before any migration, `.upgrade-premigration/` was written with a copy of all ten instance files. Each migrated
file was then diffed against its own copy. Every diff was inspected; every changed line is accounted for below as
either an additive schema field, a named retired key, or a header comment line refreshed under the template rule.
No record line — no contract, correction, observation, precedent, drift entry or project map entry — was altered.

### `meta-contract-before-execution/CONTRACT-LOG.yaml`
- **Added to `contract-001`:** `disappointment: legacy`, `premortem: legacy`, `red_test: legacy`, `cost: legacy`
  (the contract-006 fields).
- **Not added:** `verification_state` and `audited` were already present, so the standing question was skipped.
- `approval: gate` left exactly as it stands — the staged template names `gate` as the pre-0.15 value.
- Header comment refreshed from the staged template.
- **Verified:** diff against `.upgrade-premigration/` shows only the 4 added lines plus header comment lines.
  `contract_id`, `feature`, `type`, both dates, `approval`, `bearing`, `tier_1`–`tier_3`, `status`,
  `verification_state`, `audited`, `transcript`, `observations`, `revisions`, `work_id` all present unchanged.

### `meta-correction-log/CORRECTIONS.yaml`
- **Added to `C-001`:** `noticed: not asked`, `would_have_been_right: not asked`, `seen_before: not asked`.
- Header comment refreshed.
- **Verified:** diff shows only those 3 added lines plus header comment lines. `agent_offered` ("return 204") and
  `pioneer_said` ("return 200 with a body") survive verbatim, as do `clerked: false` and the trajectory block.

### `meta-ledger/LEDGER.yaml`
- **Removed from `scores` (the retired keys this list names):** `canary_catch_rate`, `brier_stated_confidence`,
  `brier_pioneer_decisions`. **Added:** `coincidence: []`.
- No batches exist, so no `represented: []` was due; no candidates exist, so no `lower_bound` was present to remove.
- Header comment refreshed.
- **Verified:** diff shows only the three retired keys removed, `coincidence: []` added, and header comment lines.
  All six top-level lists survive.

### `meta-drift-eventlog/DRIFTLOG.yaml`, `meta-learning/LEARNINGLOG.yaml`, `meta-casebook/CASEBOOK.yaml`
- `entries: []` / `entries: []` / empty precedent, scenario and reconstruction lists — nothing to migrate.
- Header refresh is a **no-op**: each file is identical to the staged template, so the template rule changes nothing.
- **Verified:** each diffed against the staged template — identical. Files untouched.

### `meta-manifest/MANIFEST.yaml`
- `base_kit_version: 0.14` → `0.15`.
- All 26 base node lines and all 26 base coverage lines refreshed from the staged template (the step-3 record
  showed every one still read as the installed template wrote it). The substantive changes:
  - `agent-canary-author` → **`agent-batch-assembler`**, taking the staged template's whole node line and coverage
    line (the rename the procedure names explicitly).
  - `base-casebook` loses `meta-casebook/REBUILD.yaml` from `owns:` and `M-31` from `triggers:`.
  - `base-mechanisms` gains `M-07` in `triggers:`.
  - `base-skill-builder`, `agent-consolidator` and the `base-ledger` coverage line take their reworded concerns.
- `kind` and `load` were already on every node; `library_kit: null` already present; `kit_type: project` left as
  the project declared it; no project nodes, so no `triggers` or `owns` to draft and no pending-entry note.
- **Verified:** diff against `.upgrade-premigration/` shows exactly seven changed lines, all of them base node or
  base coverage lines plus `base_kit_version`. `kit_name: fx013`, `category: test-api`, `version: 0.1`,
  `gap_queue: []` and `library_entry: null` survive unchanged.

### `meta-map/MAP.md`
- Every base entry took the staged template's columns and kept its own `proposed` status.
  Changed: M-03, M-07, M-08, M-09, M-10, M-16, M-17, M-23, M-24, M-28, M-29.
- **`M-31 | launch-rebuild` removed** — the staged template withdrew it and the pioneer had not reworded it.
- Header comment refreshed; `ratification: deferred` added inside it in step 9.
- **Verified:** diff against `.upgrade-premigration/`; and checked that no surviving entry names a file step 5
  removed — `grep -E 'reveal-canaries|kit-canary-author|REBUILD|walk-004'` over MAP.md returns nothing.

### `meta-casebook/SKILL.md` (the kept file)
- Only its `> **Map:**` header was touched: `M-04, M-05, M-26, M-31` → **`M-04, M-05, M-26`**. The rest of the line
  is the kept file's and stays. This is reported, not asked, as the procedure says.

### Not migrated
`FOUNDING.md` — no schema migration is listed for it, its header already read as the template wrote it, and the
statement block is never rewritten. Left untouched.

---

## 4. What is still unclear, wrong or missing — verbatim as I hit it

### (a) The verification sentence contradicts the header-refresh rule in the same step

Step 7 opens:

> "**verify by diffing the migrated file against a copy taken before the migration, confirming that every
> pre-existing line is still there unchanged**"

and closes:

> "The header comment block of every instance file above follows the template rule."

Taken literally the first sentence fails on **every file I migrated**, because refreshing the header changes
pre-existing lines — and the LEDGER bullet deliberately *removes* three pre-existing lines
(`canary_catch_rate`, `brier_stated_confidence`, `brier_pioneer_decisions`). The step names both exceptions
elsewhere ("remove only the retired keys this list names"), so the intent is recoverable, but the verification
sentence itself carries no carve-out. I resolved it by treating every changed line as needing to be either a
header comment line under the template rule or a named retired key, and confirming no record line moved. That
worked, but it was my reading rather than the procedure's words. **This is the one wording change I would make:**
say "every pre-existing **record** line", or "every pre-existing line outside the header block and the retired
keys named above".

### (b) "write the result down" does not say where

Step 3: "make it in step 3 and write the result down". It does not name a destination. I wrote it to a temp file
in the project root and folded it into this report, deleting the temp with the others. A clause naming the
rehearsal log (or the step 9 report) as its home would remove a choice the agent currently makes for itself.

### (c) The installed 0.14 `session-start.sh` does not print the staged-kit line

This is not a defect, but it should be on record for the real run. The backlog line quoted at the top of this
rehearsal —

> "- A newer kit is staged in .claude/kit-incoming/ -> M-27 follow the STAGED kit's meta-bootstrap/SKILL.md,
> Upgrading an Existing Install: rehearse on a copy first"

— exists only in the **0.15** hook. Running the project's own installed 0.14 hook here printed a five-line
backlog with no such line. The staged manifest documents this precisely (gap-032, `status: mitigated`): "The
0.14-to-0.15 hop itself has neither in the installed kit; there the pioneer's staging message must say 'follow
the staged kit's meta-bootstrap'". So on the real 0.14 → 0.15 run **the pioneer's staging sentence is
load-bearing** — nothing in the installed project will route the agent to the staged copy. From 0.15 onward the
hook does it, as verified below.

### (d) What *keep* leaves behind — for the pioneer to weigh at the real run

`meta-casebook/SKILL.md` was kept, and it still describes things the staged kit removed:

- line 6: the header still ends "— or the milestone in **REBUILD.yaml** has been reached", a file this upgrade
  deleted. The procedure says only the withdrawn id comes out of the header and "the rest of the line is the kept
  file's and stays", so this is correct behaviour, and it is reported here rather than silently fixed.
- line 59: `### The launch rebuild (M-31)` — a section headed by a map entry that no longer exists.
- line 63: names both `REBUILD.yaml` and `templates/REBUILD.template.yaml`, neither of which is now installed.
- line 69: "When the milestone arrives (M-31)…".

So *keep* on this file leaves a node whose largest section describes a mechanism the kit has withdrawn and whose
supporting template is gone. That is the cost of the stub answer, and exactly what the rehearsal is meant to put
in front of the pioneer before the real run.

### (e) Nothing else

No step was ambiguous, no command failed, no ordering had to be inferred.

---

## 5. The five verdicts asked for

### Inserting new fields into existing records — **enough to act on; I was not left guessing**

> "Field order carries no meaning: put a new field where it reads naturally in the entry, and do not hunt for an
> anchor the old entries may not have."

Dropping the named anchor was the right move: it dissolves the question instead of answering it. The case it
anticipates is live here — `contract-001` has **no `tier_4`**, so an instruction like "insert after `tier_4`"
would have pointed at a line that does not exist, and I would have had to improvise exactly what the sentence
forbids. I placed `disappointment`, `premortem` and `red_test` after `tier_3` and `cost` before `work_id`,
following the template's own reading order. No hesitation.

### The verification requirement — **clear as to what; I did it; one wording flaw**

The requirement ("diff the migrated file against a copy taken before the migration, confirming every pre-existing
line survives") and the freedom ("The verification is the requirement; the method is yours") were both
unambiguous. I took `.upgrade-premigration/` copies of all ten instance files before touching any, and diffed
every migrated file against its copy; all diffs are in the run transcript and summarised in §3. The flaw is in
(a) above: as literally worded the check cannot pass, because the same step mandates refreshing headers and
removing three named keys. I would fix the sentence, not the requirement.

### The pending-entry note — **clear, including the no-`note:` case; but unexercised here**

> "a project node whose entry waits in `proposed-entries.md` gets `triggers: []` and the sentence `entry pending
> the map question` in its `note:`, **appended to whatever that field already says, or as a new `note:` where it
> has none**"

The trailing clause closes the gap: a node with no `note:` field gets one created, rather than the instruction
silently assuming a field that may not exist. That is unambiguous on the page. **It did not fire in this
rehearsal** — fx013 registers no project nodes, so nothing waited in `proposed-entries.md`, no note was written,
and `proposed-entries.md` was never created. So I can vouch for the wording but not for its execution; a fixture
with a project node and no `note:` field is what would actually test it.

### The ordering between steps 3, 5 and 7 — **clear enough to follow; I was never without a yardstick**

Step 3's template-rule line now reads:

> "`.claude/skills/templates/` is the copy the last install shipped, so the comparison is mechanical — **make it
> in step 3 and write the result down, because step 5 replaces those templates before step 7 runs**"

and step 5 reinforces it from the other side: "`templates/` (whose old copies step 7 needs as its yardstick, so
step 3's comparison must already be recorded)". The two agree, and the reason is stated, not just the
instruction — which is what made it followable without my reconstructing the dependency.

The trap is real and would be silent. Step 5 overwrote all ten installed templates; six of them differ from what
they were. Had I deferred the comparison to step 7, the yardstick would have been the *staged* template compared
against itself, every base line would have looked "as the template wrote it" for the wrong reason, and the
failure would have produced no error. Because step 3 told me to record it first, step 7 read my written record
and the comparison stayed honest. **I was never left without a yardstick I needed**, and I did not have to work
the ordering out myself. The only residue is (b) above: it does not say where to write the result.

### The line-ending fallback in step 3 — **49 of 70; without it, 32 questions instead of 1**

| | |
|---|---|
| Baseline entries | 70 |
| Matched the recomputed hash directly | 20 |
| **Matched only through the line-ending fallback** | **49** |
| Genuinely evolved | 1 |

The baseline is the pre-0.15 raw-byte form and most of the tree is CRLF on disk, so nearly every file mismatched
on the first comparison and was rescued by re-hashing with CRLF endings
(`tr -d '\r' < file | sed 's/$/\r/' | sha1sum`).

**Without the fallback**, each of those 49 would have classified as "evolved here". Of them, 31 also differ in
content from the staged copy, so — applying the procedure's own "none where nothing differs" rule — the upgrade
would have asked **32 one-per-file questions** (those 31 plus the one genuinely evolved file) instead of **1**.
Total decisions would have been **34 instead of 3**.

That is the difference between passing and failing the pioneer's recorded failure condition for an upgrade:
*"if it human is required to make many manual decisions or the agent needs to troubleshoot to make it work."*
On a Windows install the fallback is not a nicety; it is what makes the upgrade viable at all.

---

## 6. Final state of the upgraded project

### MAP.md — M-07, M-16, M-17

```
M-07 | pioneer-correction | situation + hook cue | must | the pioneer redirects, declines, corrects a tier or bearing, overrides a recommendation, or resets the frame | answers to your own question; approvals | meta-correction-log → How to record | proposed
M-16 | review-due | hook: Stop | must | the stop-gate says pioneer-owned items wait, no batch open | — | agent: kit-batch-assembler, then meta-skill-builder → Review Batch | proposed
M-17 | batch-decided | hook: Stop | must | every item in the open batch carries a decision | — | script: close-batch.sh, then reveal-key.sh; meta-skill-builder → Reveal | proposed
```

M-07's load moved from "meta-correction-log → record verbatim first" to "→ How to record". M-16 now names
**kit-batch-assembler** instead of the retired kit-canary-author. M-17 now names **close-batch.sh, then
reveal-key.sh** instead of the deleted reveal-canaries.sh. Every one of the three points at a file that exists.
All keep status `proposed`, since ratifying is the pioneer's. `M-31` is gone. 30 entries, 6,969 bytes.

### The kept skill's header

```
> **Map:** M-04, M-05, M-26 · **Load:** retrieved on trigger by moment tag · **Recognise it by:** "we have decided a situation like this before" — or the milestone in REBUILD.yaml has been reached · **Not when:** the question is what the rule says (that is the node) rather than how it was applied
```

`M-31` removed because the staged template withdrew that entry; everything else on the line is the kept file's and
stays — including the reference to `REBUILD.yaml`, which is reported in §4(d), not silently repaired.

### `.claude/kit-incoming/` — **gone**

Removed on the stubbed acceptance of the report, as step 9 directs. 113 files.

### `walk.sh` — **passes**

```
walk: all 36 states match walk.expected
walk.sh exit code: 0
```

### Other step-9 results

- `checks/G1-size.sh` → exit 0. INTENT.md 4,820 bytes (≤ 5,120); MAP.md 6,969 bytes and 30 entries
  (≤ 8,192 / ≤ 40); `templates/MAP.template.md` 6,980 bytes.
- All nine hook commands printed valid JSON or nothing. `close-batch.sh B-001` and `reveal-key.sh B-001` both
  reported *No batch file* with exit 1 — the expected result.
- Telemetry gained its `loaded|meta-map/MAP.md` line, plus an ownership `bypass|base-casebook|…` line, during the
  checks. Those were the check's and were deleted afterwards; `telemetry.log` holds only this session's own
  `session-start|startup` line. The file was not created by the checks, so it was kept.
- Baseline regenerated after the ratification marker: 68 lines, in the 0.15 form (no `*` prefix).
- `ratification: deferred` sits inside MAP.md's header comment block, so the stop-gate and session-start hold the
  base entries back from opening batches.
- Session-start in the upgraded project now prints three backlog lines — audit, verification, clerking — and
  **no staged-kit line**, confirming the staged folder is gone.
- `.gitignore` (`.claude/kit-sealed/`) and `.gitattributes` (`*.sh text eol=lf`) were already correct;
  `meta-ledger/batches/`, `meta-casebook/reconstruction/` and `meta-mechanisms/checks/` were missing and were
  recreated.
- `settings.json`: all six hook groups carry `"_kit"`, so all six were replaced by the staged template's and the
  `permissions.deny` entry kept. Verified byte-identical to the staged template — the merge is a no-op in content
  for this project.
- The `CLAUDE.md` kit-block markers were present and the block is identical to the staged 5a text; no rewrite was
  needed.
- All rehearsal temp files and `.upgrade-premigration/` removed.
