# Upgrade rehearsal — fx013, base kit 0.14 → 0.15

Run on 2026-09-13 in the throwaway copy at `scratchpad/round2/fx013`, following the **staged** kit's
`meta-bootstrap/SKILL.md → Upgrading an Existing Install` (map M-27), steps 1–9, with the pioneer's answers
stubbed as step 2 prescribes: *keep* for the differing file, *remove* for the stale list, *yes* to removing
`.claude/kit-incoming/`. `INSTALLED.sha1.prev` was written before step 3 and is still on disk — the procedure
deletes it only once this report is accepted.

**Verdict against the rehearsal's own pass criterion: does not pass.** The third number is 2, not 0, and the
first number includes one question the criterion does not allow. Details in sections 1 and 4.

---

## 1. The three numbers

### Decisions asked: 3

| # | Question | Belongs to | Stubbed answer |
|---|---|---|---|
| 1 | `meta-casebook/SKILL.md` evolved here — *overwrite with the staged, keep yours, or port the staged changes into yours by hand?* | the one genuinely differing file | keep |
| 2 | Stale list — *remove `kit-canary-author.md` (in `.claude/agents/` and `.claude/skills/agents/`), `hooks/reveal-canaries.sh`, `templates/REBUILD.template.yaml`?* | the one stale-list question | remove |
| 3 | *Remove `.claude/kit-incoming/`?* | prescribed by step 2 ("*yes* to removing `.claude/kit-incoming/` at the end") and step 9 ("on the pioneer's confirmation") | yes |

Under the pass criterion's own wording — "every decision asked belongs to a file or template part that
genuinely differed or is the one stale-list question" — only questions 1 and 2 are allowed. Question 3 is
asked because the same node tells the agent to ask it. The count is 3; the criterion permits 2. The procedure
contradicts itself here (section 4, item 3).

No question was asked about any template part: every header comment block, every base manifest line and every
base map entry still read exactly as the installed template wrote them (checked mechanically against
`.claude/skills/templates/` before any change), so the template rule refreshed them without asking.

### Files that genuinely differed: 1

- `.claude/skills/meta-casebook/SKILL.md` — the only file of the 70 in the baseline whose hash matched neither
  the recomputed CR-stripped hash, the raw hash, nor the CRLF-added hash. What differs from the staged copy:
  1. its `> **Map:**` header still names `M-31` and "the milestone in REBUILD.yaml has been reached";
  2. its section `### The launch rebuild (M-31)` is the text the staged kit replaced with
     `### The rebuild — withdrawn from the map`;
  3. it carries a section the kit never shipped:
     `## Project addition — In this project, precedents about response shapes are reviewed with the API owner.`

Of the other 69 baseline files: 16 matched the recomputed hash directly (LF files) and 53 matched only by the
raw-bytes rule for a pre-0.15 baseline (the install carries CRLF; e.g. `INTENT.md` held 57 carriage returns).
None lacked a baseline entry.

### Troubleshooting steps: 2

Things done that steps 3–9 do not say, without which the procedure as written did not produce the result it
describes:

1. **Baseline line format.** The installed `INSTALLED.sha1` was written by `xargs -0 sha1sum`, so every line
   reads `hash *path` (binary-mode asterisk, one space). The 6j command writes `hash  path` (two spaces, no
   asterisk). Step 3 says "compare it line by line": done literally, all 70 lines differ. I parsed the path out
   of each line, dropping the `*`, and compared hash-to-hash per path. The text does not say to.
2. **The report's change list.** Step 2 says the report's list of "what was taken, ported, removed and
   migrated is the difference between the two" baselines. Against a pre-0.15 baseline that difference is
   wrong: 57 hashes differ for paths present in both, but only 37 of those files changed content; the other 20
   (listed below) differ only because the old baseline hashed raw CRLF bytes and the new one hashes CR-stripped.
   The baseline difference also cannot show *what* was migrated inside an instance file. I kept an action log
   during steps 3–5 and snapshotted the instance files before step 7 to produce sections 3 and 5. Neither is in
   the text.

   Method-only rehash lines (content unchanged): `agents/kit-reconstructor.md` and `agents/kit-session-auditor.md`
   (both copies), `meta-antidrift-expand/SKILL.md`, `meta-antidrift/SKILL.md`, `meta-casebook/CASEBOOK.yaml`,
   `meta-casebook/SKILL.md` (kept), `meta-contract-artifact/SKILL.md`, `meta-drift-eventlog/DRIFTLOG.yaml`,
   `meta-foundation/SKILL.md`, `meta-founding-contract/SKILL.md`, `meta-learning/LEARNINGLOG.yaml`,
   `meta-learning/SKILL.md`, `tests/results/T-2-2026-09-12.md`, `tests/results/T-7-2026-09-12.md`,
   `templates/CASEBOOK.template.yaml`, `templates/DRIFTLOG.template.yaml`, `templates/FOUNDING.template.md`,
   `templates/LEARNINGLOG.template.yaml`.

Not counted as troubleshooting, because the upgrade completed without them, but unclear in the text: see
section 4.

---

## 2. The classification presented (step 3)

Version check: staged `kit_identity.version: 0.15`, project `base_kit_version: 0.14` — not equal, proceed.
Baseline present, pre-0.15 (raw bytes).

**Untouched here → staged version taken, no question** — 69 files. 35 differed in content from the staged
copy and were replaced; 34 were byte-identical (after CR stripping) and were re-copied with no change.
Replaced: `meta-bootstrap`, `meta-contract-before-execution`, `meta-correction-log`, `meta-drift-eventlog`,
`meta-extract`, `meta-ledger`, `meta-manifest`, `meta-map`, `meta-mechanisms`, `meta-skill-builder` (each
`SKILL.md`); `meta-foundation/INTENT.md`; agents `kit-case-clerk`, `kit-consolidator`, `kit-map-steward`,
`kit-recorder`, `kit-verifier` (kit copy and deployed copy); hooks `batch-blind.sh`, `owner-check.sh`,
`session-start.sh`, `stop-gate.sh`; tests `walk.sh`, `walk-004.sh`, `walk.expected`; templates
`CONTRACT-LOG`, `CORRECTIONS`, `LEDGER`, `MANIFEST`, `MAP`.

**Evolved here → one question** — `meta-casebook/SKILL.md` (section 1). Answer: keep. Consequence named at
presentation: its header keeps pointing at M-31, which step 7 withdraws, and at `REBUILD.yaml`, which nothing
seeds any more.

**New in the kit → added** — `agents/kit-batch-assembler.md` (deployed to `.claude/agents/` and kept under
`.claude/skills/agents/`), `meta-mechanisms/checks/G1-size.sh`, `meta-mechanisms/hooks/reveal-key.sh`,
`meta-mechanisms/tests/fixtures/make-upgrade-fixtures.sh`, `meta-mechanisms/tests/walk-007.sh`.

**Present here, absent from the staged kit → stale, one question** — `kit-canary-author.md` (both copies),
`hooks/reveal-canaries.sh`, `templates/REBUILD.template.yaml`. Beside each, what still refers to it after
the upgrade: the kept `meta-casebook/SKILL.md` names `REBUILD.yaml` and `templates/REBUILD.template.yaml`
(kept — left pointing at nothing); MAP.md M-16/M-17, the manifest's `agent-canary-author` node and LEDGER.yaml's
header named the canary author and `reveal-canaries.sh`, and all of those were refreshed by step 7. Answer:
remove.

**Excluded from "the kit" by definition, so on no list** — the staged folder's `tests/results/` (26 files)
and `checks/P-004..P-007.sh` were not copied. The *installed* project also carries base-kit evidence the 0.14
install brought in — `tests/results/T-2-2026-09-12.md`, `T-7-2026-09-12.md`, `contract-004-tiers.sha1`.
The stale rule ("absent from the staged kit") does not catch them because the staged folder still has those
paths; the kit definition says they are not kit files. They were left in place (section 4, item 6).

**Instance files, never replaced** — manifest, map, founding file, contract log, learning log, drift log,
ledger, corrections, casebook; all present, none missing, so step 6 seeded nothing. `telemetry.log` did not
exist before the hook run and was created by it.

**Step 4** — no new node arrived with a missing record. **Step 8** — no non-base node exists; nothing to map.

---

## 3. Migrations applied, file by file (step 7)

### `meta-contract-before-execution/CONTRACT-LOG.yaml` (LF)
- Header comment block refreshed from the staged template: `approval:` example now `approved-at-gate` with
  the note that `gate` on pre-0.15 entries stays; `disappointment`, `premortem`, `red_test` schema lines
  added; `tier_4` description reworded; `verification_state` enumeration gains `closed-by-follow-up`;
  `corrections_from_tests` / `corrections_from_reading` added under `verification`; `cost` schema line added.
- Entry `contract-001`: `verification_state: none` and `audited: false` already present — untouched;
  `approval: gate` left as is; **added** `disappointment: legacy`, `premortem: legacy`, `red_test: legacy`,
  `cost: legacy` (plain scalars, before `work_id`).

### `meta-correction-log/CORRECTIONS.yaml` (LF)
- Header refreshed: the three incident-probe schema lines (`noticed`, `would_have_been_right`, `seen_before`).
- Entry `C-001`: **added** `noticed: not asked`, `would_have_been_right: not asked`, `seen_before: not asked`
  (before `supersedes`).

### `meta-ledger/LEDGER.yaml` (CRLF, endings preserved)
- Header refreshed: "THE ONE WRITER LIST" paragraph; `kit-canary-author` → `kit-batch-assembler`;
  `evidence_refs` grade note; `lower_bound` schema line gone; `outcome` shape now
  `{resolved, held: true|false|unobserved}`; batch `canaries`/`canaries_caught` → `represented: []`;
  `scores` schema now `contracts` (with cost and correction counts) and `coincidence`.
- `scores:` — **removed** `canary_catch_rate: null`, `brier_stated_confidence: null`,
  `brier_pioneer_decisions: null`; **added** `coincidence: []`.
- No batches (`represented: []` not needed), no candidates (`lower_bound` not present).

### `meta-drift-eventlog/DRIFTLOG.yaml` (CRLF)
- Template identical between 0.14 and 0.15; header re-applied with no textual change. No elevations exist,
  so no `mitigation_medium: unknown` was added.

### `meta-manifest/MANIFEST.yaml` (LF)
- `base_kit_version: 0.14` → `0.15`.
- Every node already had `kind`, `load`, `triggers` and (non-agent) `owns:` — nothing added.
- Base node lines taken from the staged template where the template changed:
  - `base-skill-builder` concern: "canaries" → "re-presented items".
  - `base-casebook` concern unchanged; `owns:` loses `meta-casebook/REBUILD.yaml`; `triggers:` loses `M-31`.
  - `base-mechanisms` `triggers:` gains `M-07`.
  - `agent-consolidator` concern: "independence-aware counters, lower bounds, fading, outcomes, scores" →
    "counters by reading, fading, outcomes, scores that never score the pioneer".
  - `agent-canary-author` → **`agent-batch-assembler`**, whole node line: concern "Assembles review batches
    from real items, re-presents decided ones from the fourth batch on, and seals the key",
    `agent_file: agents/kit-batch-assembler.md`, `triggers: [M-16]`.
- Coverage lines: `base-ledger` concern "canaries" → "re-presented items"; `agent-canary-author` line
  → `agent-batch-assembler` "Review batch assembly and re-presented items".
- Header comment block: identical in both templates; unchanged.

### `meta-map/MAP.md` (LF)
Every base entry still read as the installed template wrote it, so each took the staged template's columns
and kept its own status (`proposed`, all 30). Ten entries changed columns, one was withdrawn:
- `M-03` not-when "a moment with a clear entry (M-20 records the miss)"; load `meta-foundation`.
- `M-28` not-when "a session-level analysis (M-19)"; load "INTENT.md → Close every output with this block;
  meta-antidrift → The Drift Score Block".
- `M-24` type "situation + hook: Stop".
- `M-29` load "LEDGER.yaml → candidates; meta-ledger → Candidates".
- `M-08` not-when gains "; an unauthorised one is drift (M-18)"; load drops "unauthorised → meta-drift-eventlog".
- `M-09` load "INTENT.md → The agent holds five aspects".
- `M-10` load "meta-antidrift → Scoring Rules".
- `M-23` not-when "a node change (M-22)"; load "meta-manifest → How to Read the Manifest".
- `M-16` load "agent: kit-batch-assembler, then meta-skill-builder → Review Batch".
- `M-17` load "script: close-batch.sh, then reveal-key.sh; meta-skill-builder → Reveal".
- `M-31 | launch-rebuild` **removed** — withdrawn by the staged template, not reworded here.
- Header comment block identical in both templates; unchanged. Result: 6,966 bytes, 30 entries, body
  identical entry-for-entry to the staged template with `fx013` substituted.

### Not migrated (no change needed)
`FOUNDING.md`, `LEARNINGLOG.yaml`, `CASEBOOK.yaml` — templates identical between versions, headers unchanged.

### Steps 5 and 9 alongside
- `settings.json`: staged template is byte-identical to the installed file; kit groups "replaced" with no
  textual change; no group to remove (`reveal-canaries.sh` was never in settings).
- `CLAUDE.md`: the block between the `kit-block` markers is identical to the staged Step 5a text; unchanged.
- `.gitignore` (`.claude/kit-sealed/`) and `.gitattributes` (`*.sh text eol=lf`): present.
- Folders created (the copy had none of them): `meta-ledger/batches/`, `meta-casebook/reconstruction/`,
  `meta-mechanisms/checks/`.
- `INSTALLED.sha1` regenerated with 6j: 72 lines (was 70), format `hash  path`, CR-stripped.
  Path-level difference from `.prev`: −`kit-canary-author.md` ×2, −`reveal-canaries.sh`,
  −`REBUILD.template.yaml`; +`kit-batch-assembler.md` ×2, +`checks/G1-size.sh`, +`hooks/reveal-key.sh`,
  +`tests/fixtures/make-upgrade-fixtures.sh`, +`tests/walk-007.sh`.
- Checks: `checks/G1-size.sh` exit 0 (INTENT.md 4,820 B; MAP.md 6,966 B / 30 entries).
- Step 7 hook commands, all with `CLAUDE_PROJECT_DIR` set: `session-start`, `prompt-submit`, `stop-gate`,
  `write-scope` printed valid JSON (checked with `json.loads`); `subagent-stop`, `post-read`, `owner-check`,
  `batch-blind`, `deny-paths` printed nothing; `close-batch.sh B-001` and `reveal-key.sh B-001` said "No batch
  file", exit 1. `telemetry.log` tail: `subagent|kit-verifier`, `loaded|meta-map/MAP.md`,
  `bypass|base-casebook|meta-casebook/CASEBOOK.yaml`. The stop-gate handed M-11 (contract-001 unaudited); the
  backlog reflected the live records (unaudited contract, unverified contract, unclerked correction,
  pioneer-owned items) plus the staged-kit line until `.claude/kit-incoming/` was removed, after which the
  staged-kit line cleared.
- The walks (`walk.sh`, `walk-004.sh`, `walk-007.sh`) were not run: step 9 names only `checks/` and the
  Step 7 hook commands.

---

## 4. Unclear, wrong or missing in the procedure — as hit, verbatim

1. **Step 3, "Recompute the baseline with the 6j command into a temporary file and compare it line by line
   with `meta-manifest/INSTALLED.sha1`."** — Wrong for a pre-0.15 baseline: its lines are `hash *path`
   (binary-mode `sha1sum` via `xargs -0`), 6j's are `hash  path`. Line by line, all 70 differ. The comparison
   must be hash-to-hash keyed by path with the `*` dropped. (Troubleshooting step 1.)

2. **Step 2, "the report's list of what was taken, ported, removed and migrated is the difference between the
   two"** — Wrong for a pre-0.15 baseline: the difference mixes real changes with files re-hashed by the new
   method (20 of 57 here), and it cannot show what was migrated inside an instance file. Either the CR/CRLF
   rule of step 3 must be applied to the `.prev` comparison as well, or the list must come from the step 3
   classification plus the step 7 edits. (Troubleshooting step 2.)

3. **Step 2, "The rehearsal passes only when every decision asked belongs to a file or template part that
   genuinely differed or is the one stale-list question"** against, in the same step, "*yes* to removing
   `.claude/kit-incoming/` at the end" and step 9, "Remove `.claude/kit-incoming/` on the pioneer's
   confirmation." — The procedure asks a question its own pass criterion forbids. Either the removal is
   automatic once the report is accepted, or the criterion lists it.

4. **Step 3, evolved file: "show the pioneer what differs — the sections changed, in a few lines each"** —
   Differs from what is not said. The baseline holds hashes, not text, so the installed 0.14 original is not
   available; the only diff that can be shown is against the staged copy. That is what was shown. The text
   should say so.

5. **Step 5, "Install from the staged copies: agents …, the hook scripts …, and the settings merge …"** —
   Does not name the untouched `meta-*/SKILL.md` files, `INTENT.md`, `templates/`, `tests/` or the `G*.sh`
   checks. They are taken only by the step 3 bullet "untouched here → take the staged version". Step 5 should
   enumerate them, or step 3 should say the taking happens there.

6. **"What 'the kit' is" — "not `tests/results/` or the base kit's `P-NNN.sh` checks, which are its own
   evidence"** — Says what not to copy in, not what to do with base-kit evidence a 0.14 install already
   carried (`tests/results/T-2-2026-09-12.md`, `T-7-2026-09-12.md`, `contract-004-tiers.sha1`, all present here
   and in the baseline). They are neither "present here, absent from the staged kit" (the staged folder has
   those paths) nor kit files. Left in place; the procedure should say whether they go on the stale list.

7. **Step 7, MAP.md: "An entry that names a file step 5 removes and was not refreshed here is an error in
   this list, not a judgement call."** — Covers the map only. A kept evolved skill keeps its `> **Map:**`
   header: here `meta-casebook/SKILL.md` still names `M-31` (withdrawn) and `REBUILD.yaml` /
   `templates/REBUILD.template.yaml` (removed). The stale-list question names the file being kept, as
   required, but nothing then says what to do with the header, and meta-map's rule that header and entry are
   co-owned is broken by a *keep*. In the real run the pioneer would need *port*, or the procedure needs a
   line for a kept file whose header names a withdrawn entry.

8. **Step 3, "an install made on Windows re-saves files with the other ending, and that differs by
   nothing"** — Holds, but the consequence is unstated: after "take the staged version" every kit file is LF
   while the migrated instance files keep their own endings (LEDGER.yaml and DRIFTLOG.yaml stayed CRLF; the
   refreshed headers were written with the file's existing ending). Harmless, but a reader diffing the tree
   will see it.

9. **Step 9, "the expectation is only that each script prints valid JSON or nothing"** — `close-batch.sh` and
   `reveal-key.sh` print a plain-text error and exit 1 on a project with no batch. The install's Step 7 says
   "expect: no batch file", so this is expected, but the upgrade sentence should say so instead of "valid
   JSON or nothing".

Nothing in the procedure was found wrong about the migration list itself: every field, removal and rename it
names was applicable or correctly inapplicable here.

---

## 5. State after the upgrade

### `MAP.md` lines M-16 and M-17
```
M-16 | review-due | hook: Stop | must | the stop-gate says pioneer-owned items wait, no batch open | — | agent: kit-batch-assembler, then meta-skill-builder → Review Batch | proposed
M-17 | batch-decided | hook: Stop | must | every item in the open batch carries a decision | — | script: close-batch.sh, then reveal-key.sh; meta-skill-builder → Reveal | proposed
```
Both name files that exist (`.claude/agents/kit-batch-assembler.md`, `hooks/close-batch.sh`,
`hooks/reveal-key.sh`). No line in MAP.md names `kit-canary-author`, `reveal-canaries.sh`, `REBUILD` or
`M-31`.

### Manifest `base-casebook` node
```
- {id: base-casebook, concern: Binding precedents with their facts, scenario cards, reconstruction tests, kind: record, skill_file: meta-casebook/SKILL.md, data_file: meta-casebook/CASEBOOK.yaml, owns: [meta-casebook/CASEBOOK.yaml, meta-casebook/reconstruction/, meta-casebook/SKILL.md], layer: meta, phase: [pre-build, post-build], load: trigger, triggers: [M-04, M-05, M-26], status: thin, dependencies: [base-correction-log], open_gaps: []}
```
Coverage line: `{concern: Binding precedents and reconstruction, node_id: base-casebook, layer: meta,
phase: [pre-build, post-build], status: thin}`. `base_kit_version: 0.15`. `owner-check.sh` read the
`owns:` and logged `bypass|base-casebook|meta-casebook/CASEBOOK.yaml`, so ownership survived the migration.

### Loose ends the real run must carry
- The kept `meta-casebook/SKILL.md` header names M-31 and REBUILD.yaml (item 7 above).
- `INSTALLED.sha1.prev` is still on disk pending acceptance of this report.
- Base-kit evidence under `tests/results/` from the 0.14 install is still on disk (item 6 above).
- The rehearsal fails its own criterion; per step 2 the procedure is to be fixed in the node and rehearsed
  again before steps 3–9 run on the real project. The fixes are proposed in section 4, items 1–3 and 5; they
  are not applied here, because editing `meta-bootstrap/SKILL.md` is a node change in the base kit (M-22),
  outside this copy.
