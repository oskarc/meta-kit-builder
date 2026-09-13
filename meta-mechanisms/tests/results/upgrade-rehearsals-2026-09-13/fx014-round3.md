# Upgrade rehearsal — fx014 (kit 0.14 → 0.15)

Run on 2026-09-13 in the throwaway copy, following the STAGED kit's `meta-bootstrap/SKILL.md` → *Upgrading an Existing Install*, steps 3–9, with the pioneer's answers stubbed as step 2 says: *keep* per differing file (none arose), *remove* for the stale list, *legacy* per existing contract, *defer* for the ratification pass, report accepted. Moment named: M-27.

Rehearsal verdict against the procedure's own criterion: **third number is zero; but decision 2 (the ratification-pass offer) is outside the set the pass criterion allows** — see section 4, item 1. By the literal wording the rehearsal does not pass; by the stub list it asked exactly what it was told to ask. The node needs a one-line fix before the real run.

---

## 1. The three numbers

### Decisions asked: **2**

1. **Stale list — remove?** (stubbed: remove). One question for the whole list:
   `skills/agents/kit-canary-author.md`, `.claude/agents/kit-canary-author.md`, `hooks/reveal-canaries.sh`, `templates/REBUILD.template.yaml`, and the base kit's evidence the 0.14 install carried: `tests/results/T-2-2026-09-12.md`, `tests/results/T-7-2026-09-12.md`, `tests/results/contract-004-tiers.sha1`, `tests/walk-004.sh`, `tests/fixtures/make-T-2.sh`.
   Kept files that still referred to them (all refreshed in step 7): `MANIFEST.yaml` (agent-canary-author node + coverage line; `meta-casebook/REBUILD.yaml` in base-casebook `owns`; M-31 in its triggers), `MAP.md` (M-16 → kit-canary-author, M-17 → reveal-canaries.sh, M-31 → REBUILD.yaml), `LEDGER.yaml` header (kit-canary-author, `canaries`/`canaries_caught`/`canary_catch_rate`).
2. **Ratification pass — now, or defer?** (stubbed: defer). Offered exactly as install Step 7 does; marker added.

Not asked, and why:
- *keep / overwrite / port* per evolved file: **no file was evolved** (section 1, "files that genuinely differed").
- *legacy* for contract-001 (step 7, CONTRACT-LOG): the rule adds `verification_state: legacy` and `audited: legacy` **if absent**; contract-001 already carries `verification_state: none` and `audited: false`, so nothing was added and the parenthetical ("the pioneer may name recent implemented contracts to verify and audit; set `none` and `false` on those") had nothing to apply to. The contract-006 fields were set to `legacy` unconditionally, as the rule says.
- Report acceptance: not a decision, per step 2.

### Files that genuinely differed: **0**

Baseline: `INSTALLED.sha1` from 0.14 — 70 lines, `hash *path` form (raw-byte hashes). Recomputed with the staged 6j command (CR-stripped) into a temp file: 70 lines. Per path:
- 20 paths matched directly (the LF files: every hook, `walk.sh`, `walk-004.sh`, `make-T-2.sh`, and the LF instance files `CONTRACT-LOG.yaml`, `CORRECTIONS.yaml`, `FOUNDING.md`, `MANIFEST.yaml`, `MAP.md`).
- 50 paths mismatched on the CR-stripped hash; every one matched on the procedure's second re-hash (CRLF added, `tr -d '\r' | sed 's/$/\r/'`). They are CRLF-saved copies of the 0.14 files (e.g. `INTENT.md`: 57 CR bytes) — "an install made on Windows re-saves files with the other ending", exactly the case the procedure names. Paths not covered by either re-hash: 0.
- Paths in the baseline only, or on disk only: 0.

So every kit file was **untouched here**, and no per-file question was due.

### Troubleshooting steps: **0**

Nothing was done that steps 3–9 do not say. For the record, the things that could be mistaken for troubleshooting:
- A temp folder (`.rehearsal-tmp/`, inside PROJECT) held the recomputed baseline the procedure says to write "into a temporary file", plus before-copies of the five migrated instance files so section 3 could show real diffs; removed with the staged kit at the end.
- A byte probe (`od`, CR counts) to confirm why 50 hashes mismatched before applying the CRLF re-hash — reading, not a fix.
- `node` used to confirm each hook's output parses as JSON ("confirm it prints valid JSON or nothing").
- Two extra `session-start.sh` runs after the marker and after the removal, as evidence for sections 4 and 6 — reads, no writes except telemetry lines.

---

## 2. Classification presented (step 3)

| Class | Files | Action |
|---|---|---|
| **untouched here** | 8 deployed agents; 8 kit agent copies; 17 `meta-*/SKILL.md`; `meta-foundation/INTENT.md`; 11 templates; 13 hooks; `tests/walk.sh`, `tests/walk-004.sh`, `tests/fixtures/make-T-2.sh`, `tests/results/T-2-2026-09-12.md`, `tests/results/T-7-2026-09-12.md` | take the staged version where the staged kit ships one; stale otherwise |
| **evolved here** | none | — |
| **new in the kit** | `agents/kit-batch-assembler.md` (kit copy + deployed), `hooks/reveal-key.sh`, `checks/G1-size.sh`, `tests/walk.expected` | added |
| **staged but not "the kit"** (not installed) | `checks/P-004.sh`…`P-007.sh`, `tests/walk-004.sh`, `tests/walk-007.sh`, `tests/fixtures/make-upgrade-fixtures.sh`, `tests/results/**` (26 files), and the staged kit's own instance files (`MANIFEST.yaml`, `MAP.md`, `FOUNDING.md`, `CONTRACT-LOG.yaml`, `CORRECTIONS.yaml`, `DRIFTLOG.yaml`, `LEDGER.yaml`, `LEARNINGLOG.yaml`, `CASEBOOK.yaml`) | left in `kit-incoming/`, removed with it |
| **stale** (present here, absent from staged) | the 9 files in section 1, decision 1 | removed on the stubbed *remove* |
| **instance files** (never replaced) | `MANIFEST.yaml`, `MAP.md`, `FOUNDING.md`, `CONTRACT-LOG.yaml`, `CORRECTIONS.yaml`, `DRIFTLOG.yaml`, `LEDGER.yaml`, `LEARNINGLOG.yaml`, `CASEBOOK.yaml`, `INSTALLED.sha1` | migrated additively (section 3) |

Of the 43 staged kit files with an installed counterpart, 25 differ from the installed copy and 18 are identical; all 43 were taken because all were untouched. `settings.json` is byte-identical to the staged `settings.template.json` (merge: replaced the seven `_kit` groups with identical text; no group's script is missing). The `CLAUDE.md` kit block is byte-identical to the staged 5a text (replaced between its markers with the same text). `.gitignore` and `.gitattributes` already carried the 5d entries; `meta-ledger/batches/`, `meta-casebook/reconstruction/` and `meta-mechanisms/checks/` did not exist and were created (5e / step 6).

Kept files that still describe something the staged kit removed or renamed (for the pioneer to weigh at the real run): **none** — no kit file was kept in its 0.14 form, and every instance-file reference was refreshed by step 7.

Step 8: the manifest has no non-base nodes, so no project entries were drafted. `G1-size.sh` exit 0 (MAP.md 6,966 bytes / 30 entries before the marker, 6,998 after; INTENT.md 4,820 bytes).

---

## 3. Migrations applied (steps 5 and 7), file by file

### `.claude/skills/meta-contract-before-execution/CONTRACT-LOG.yaml` (LF, kept LF)
- Header comment block: read exactly as the 0.14 template wrote it → refreshed from the staged template. Lines changed: `approval:` comment (`gate` → `approved-at-gate`, with the pre-0.15 note); `disappointment` and `premortem` schema lines added; `tier_4` description reworded; `red_test` added; `verification_state` gains `closed-by-follow-up`; `corrections_from_tests` / `corrections_from_reading` added under `verification`; `cost` added.
- contract-001 (the only entry): after `tier_3` **+** `disappointment: legacy`, `premortem: legacy`, `red_test: legacy` (no `tier_4` exists, so `red_test` follows `premortem`); after `revisions: []` **+** `cost: legacy`. `verification_state: none`, `audited: false`, `approval: gate` untouched.

### `.claude/skills/meta-correction-log/CORRECTIONS.yaml` (LF, kept LF)
- Header: refreshed — six schema lines for `noticed` / `would_have_been_right` / `seen_before` added after `reason_given`.
- C-001: after `reason_given` **+** `noticed: not asked`, `would_have_been_right: not asked`, `seen_before: not asked`. Everything else untouched; `clerked: false` stays.

### `.claude/skills/meta-ledger/LEDGER.yaml` (CRLF, kept CRLF — 121 lines, 121 CRs)
- Header: refreshed — the one-writer list (contract-007 G-8); `kit-canary-author` → `kit-batch-assembler`; `evidence_refs` / `helpful` comments; `lower_bound` line removed; `outcome` comment; batch `canaries` / `canaries_caught` → `represented: []`; scores comments.
- `scores`: **−** `canary_catch_rate: null`, **−** `brier_stated_confidence: null`, **−** `brier_pioneer_decisions: null`; **+** `coincidence: []` after `contracts: []`. No batches, candidates, observations — nothing else to migrate.

### `.claude/skills/meta-manifest/MANIFEST.yaml` (LF)
Every base node line and base coverage line read exactly as the 0.14 template wrote it (diff against the installed template: only `kit_name`, `category`, `library_kit` and the two removed placeholder comment lines) → each took the staged template's columns. Resulting diff, old → new:
- `base_kit_version: 0.14` → `0.15`
- `base-skill-builder` concern: "…verdict before evidence, canaries, adoption…" → "…verdict before evidence, re-presented items, adoption…"
- `base-casebook`: `owns:` loses `meta-casebook/REBUILD.yaml`; `triggers: [M-04, M-05, M-26, M-31]` → `[M-04, M-05, M-26]`
- `base-mechanisms`: `triggers` gains `M-07`
- `agent-consolidator` concern: "independence-aware counters, lower bounds, fading, outcomes, scores" → "counters by reading, fading, outcomes, scores that never score the pioneer"
- `agent-canary-author` node line → `agent-batch-assembler` node line (staged, whole line); its coverage line "Gate instrumentation — canaries" → "Review batch assembly and re-presented items, node_id: agent-batch-assembler"
- `base-ledger` coverage: "Evidence, candidates, canaries and maturity instruments" → "…re-presented items and maturity instruments"
- Unchanged: `kit_identity` (kit_name fx013, category test-api, library_kit null already present), every other node, `gap_queue: []`, `library_entry: null`. `kind`, `load`, `owns` were already present on every node (0.14 install).

### `.claude/skills/meta-map/MAP.md` (LF)
Every base entry read exactly as the 0.14 template wrote it (diff against installed template: the project name only); all 31 statuses were `proposed`, so status was kept. Diff, old → new:
- M-03: not-when "a moment with a clear entry" → "a moment with a clear entry (M-20 records the miss)"; load "meta-foundation, then record the miss (M-20)" → "meta-foundation"
- M-28: not-when "—" → "a session-level analysis (M-19)"; load → "INTENT.md → Close every output with this block; meta-antidrift → The Drift Score Block"
- M-24: type "situation" → "situation + hook: Stop"
- M-29: load "LEDGER.yaml → candidates at stage trial or adopt; cite the id" → "LEDGER.yaml → candidates; meta-ledger → Candidates"
- M-08: not-when gains "; an unauthorised one is drift (M-18)"; load drops "; unauthorised → meta-drift-eventlog"
- M-09: load "INTENT.md → Evidence is the work: stop, propose the verification" → "INTENT.md → The agent holds five aspects"
- M-10: load "INTENT.md → Stop on named triggers: name it, ask to re-orient" → "meta-antidrift → Scoring Rules"
- M-23: not-when "—" → "a node change (M-22)"; load "MANIFEST.yaml: flag it, never fill it silently" → "meta-manifest → How to Read the Manifest"
- M-16: load "agent: kit-canary-author, then …" → "agent: kit-batch-assembler, then meta-skill-builder → Review Batch"
- M-17: load "script: reveal-canaries.sh; …" → "script: close-batch.sh, then reveal-key.sh; meta-skill-builder → Reveal"
- M-31 (launch-rebuild): **removed** — withdrawn by the staged template, not reworded here
- Header comment: unchanged (identical in both templates); **+** `<!-- ratification: deferred -->` on its own line directly under the header comment (step 9 deferral)
- Result: 30 entries, 6,998 bytes.

### `.claude/skills/meta-manifest/INSTALLED.sha1`
Regenerated with the staged 6j command: 66 lines, CR-stripped hashes, `hash  path` form (no `*`). Written before the marker line went into MAP.md — see section 4, item 3.

### Unchanged instance files
`DRIFTLOG.yaml` (no entries; template identical), `CASEBOOK.yaml`, `LEARNINGLOG.yaml`, `FOUNDING.md` (templates identical). `telemetry.log` created by the hook run (8 lines).

### Kit files installed from the staged copies (step 5) — all verified byte-identical to staged afterwards
17 × `meta-*/SKILL.md`; `meta-foundation/INTENT.md`; 8 agents into `.claude/skills/agents/` and `.claude/agents/`; 10 templates; 13 hooks (`reveal-key.sh` new); `checks/G1-size.sh`; `tests/walk.sh`, `tests/walk.expected`. Removed: the 9 stale files. No kept skill exists whose `> **Map:**` header names M-31 (the staged `meta-casebook/SKILL.md` header reads `M-04, M-05, M-26`).

### Step 9 hook run (CLAUDE_PROJECT_DIR set)
- `session-start.sh`: valid JSON; backlog = contract-001 unaudited (M-11), no verification evidence (M-12), C-001 unclerked (M-15), pioneer-owned items waiting (M-16 — the 30 proposed entries, before the marker), and the staged-kit line (M-27) — which, as step 9 says, prints until the folder is removed.
- `prompt-submit.sh`, `stop-gate.sh` (hands M-11: audit contract-001), `write-scope.sh` (deny): valid JSON.
- `subagent-stop.sh`, `post-read.sh`, `owner-check.sh`, `batch-blind.sh`, `deny-paths.sh`: no output.
- `close-batch.sh B-001`, `reveal-key.sh B-001`: "No batch file at …", exit 1.
- `telemetry.log` tail: `subagent|kit-verifier`, `loaded|meta-map/MAP.md`, `bypass|base-casebook|meta-casebook/CASEBOOK.yaml` — the `loaded` line and the ownership line naming `base-casebook`, as the install's Step 7 describes.
- After the marker: session-start no longer lists pioneer-owned items. After removal: the staged-kit line is gone; three backlog lines remain (the project's live records).

---

## 4. Unclear, wrong or missing in the procedure — verbatim, as hit

1. **The pass criterion excludes a question the stubs require.** Step 2: *"run steps 3–9 there with the pioneer's answers stubbed: keep for every differing file or template part, remove for the stale list, legacy for every existing contract (step 7), defer for the ratification pass (step 9), and the report accepted at the end"* — and then: *"The rehearsal passes only when every decision asked belongs to a file or template part that genuinely differed or is the one stale-list question — the pioneer's acceptance of the report at the end is not a decision and is not counted — and the third number is zero; otherwise fix the procedure here, in this node, and rehearse again."* Step 9 says *"Offer the ratification pass exactly as Step 7 of the install does"*. The ratification offer is a decision the stubs anticipate (*defer*) and the criterion does not allow; the same holds for *legacy* if a contract lacks the fields. As written, no rehearsal that follows step 9 can pass. The fix belongs in the node (list the ratification offer, and the per-contract legacy question, beside the stale-list question as permitted decisions), and the node was not edited here.
2. **The marker's placement.** Install Step 7 / step 9: *"On a deferral: add `<!-- ratification: deferred -->` to `MAP.md`'s header comment."* The header comment is already a `<!-- … -->` block; putting that literal inside it would close the block early and leave a stray `-->` visible. The marker was written as its own line directly under the header comment. The hooks grep only the phrase `ratification: deferred`, so either placement fires; the text should say which.
3. **Baseline before marker.** Step 9 orders *"Regenerate the baseline (6j), run every check … and report … Offer the ratification pass … on a deferral add the `ratification: deferred` marker"*. The marker changes MAP.md after INSTALLED.sha1 was written, so the baseline's MAP.md hash is one line stale. Harmless today — step 3 classifies kit files by the baseline and instance files by the template rule — but 6j should follow the marker, or the step should say the instance-file hashes in the baseline are not load-bearing.
4. **The baseline glob misses kit files that are not `.md`/`.yaml`/`.sh`.** 6j hashes `*.md`, `*.yaml`, `*.sh` only. `templates/settings.template.json` is part of "the kit" (*"templates/"*) but has no baseline line, so a locally evolved settings template would be invisible to step 3 and silently overwritten. `tests/results/contract-004-tiers.sha1` likewise had no line (it went on the stale list under `tests/results/`, which is right, but by folder, not by hash).
5. **A redundant re-hash.** Step 3: *"for a file whose hash differs from such a baseline, hash it once more with carriage returns removed and once more with CRLF endings added"* — the recomputed hash is already the CR-removed one (6j strips CRs), so the first re-hash can never differ from it. Only the CRLF-added hash does work; here it matched all 50.
6. **"Read both kits in full"** (step 3) against a staged folder that carries 26 files of the base kit's own test evidence (`tests/results/**`, including three fixture ledgers and two sealed keys) which the same step says do not travel. Reading them adds nothing to the classification; the sentence could exclude what *What "the kit" is* excludes.
7. **The legacy stub on an entry that already has the fields.** Step 7: *"every existing entry gains `verification_state: legacy` and `audited: legacy` if absent (the pioneer may name recent implemented contracts to verify and audit; set `none` and `false` on those)"*. When the fields are present (every 0.14 contract), the parenthetical has no object and the stub *"legacy for every existing contract"* has nothing to stub. Not wrong, but the stub list reads as if a question is always asked.
8. **Step 2's copy instruction was moot here** (*"Copy the project's `.claude/` (and its `CLAUDE.md`) to a temporary folder beside it"*): the task supplied the copy. Noted only so the count of copies is honest — one, this folder.
9. Nothing in steps 3–9 says what to do with the temporary baseline file afterwards; it was discarded with the copy.

---

## 5. State after the upgrade

`MAP.md` lines 51–52:

```
M-16 | review-due | hook: Stop | must | the stop-gate says pioneer-owned items wait, no batch open | — | agent: kit-batch-assembler, then meta-skill-builder → Review Batch | proposed
M-17 | batch-decided | hook: Stop | must | every item in the open batch carries a decision | — | script: close-batch.sh, then reveal-key.sh; meta-skill-builder → Reveal | proposed
```

M-31: absent (0 matches). Marker `<!-- ratification: deferred -->` present under the header comment.

`MANIFEST.yaml` base-casebook node (line 45):

```
- {id: base-casebook, concern: Binding precedents with their facts, scenario cards, reconstruction tests, kind: record, skill_file: meta-casebook/SKILL.md, data_file: meta-casebook/CASEBOOK.yaml, owns: [meta-casebook/CASEBOOK.yaml, meta-casebook/reconstruction/, meta-casebook/SKILL.md], layer: meta, phase: [pre-build, post-build], load: trigger, triggers: [M-04, M-05, M-26], status: thin, dependencies: [base-correction-log], open_gaps: []}
```

Coverage line 107 unchanged ("Binding precedents and reconstruction"). `base_kit_version: 0.15`. `agent-batch-assembler` registered at line 51 with its coverage line at 121; `agent-canary-author` absent.

## 6. `.claude/kit-incoming/`

Gone — removed on the stubbed acceptance of this report. `.claude/` now holds `agents/`, `settings.json`, `skills/` only. `.rehearsal-tmp/` removed with it.
