# Upgrade rehearsal — fx013, base kit 0.14 → 0.15

Run on 2026-09-13 in this folder (already the throwaway copy), following the **staged** kit's `meta-bootstrap/SKILL.md` → *Upgrading an Existing Install*, steps 3–9, with the pioneer's answers stubbed exactly as step 2 says: *keep* for every differing file or template part, *remove* for the stale list, *legacy* for existing contracts, *defer* for the ratification pass, report accepted at the end.

Step 1: staged `kit_identity.version: 0.15` vs project `base_kit_version: 0.14` — an upgrade. The project's baseline (`INSTALLED.sha1`) is pre-0.15: every path carries a leading `*` and the hashes are raw-byte hashes; both allowances in step 3 were applied (the tree has no CR bytes anywhere, so the raw hash and the CR-stripped hash coincide for every file).

---

## 1. The three numbers

### Decisions asked: **4**

| # | Question put (stubbed) | Belongs to | Answer | Admitted by the pass criterion? |
|---|---|---|---|---|
| 1 | `meta-casebook/SKILL.md` evolved here — *overwrite with the staged, keep yours, or port the staged changes into yours by hand?* (differences shown: header `M-31` and "or the milestone in REBUILD.yaml has been reached"; the section *The launch rebuild (M-31)* which the staged copy replaces with *The rebuild — withdrawn from the map*; a local *Project addition* section) | a file that genuinely differed | keep | yes |
| 2 | `meta-mechanisms/tests/walk.expected` — same question. The 6j baseline command hashes only `*.md`, `*.yaml`, `*.sh`, so this kit file has **no baseline entry**; step 3's rule "evolved here (hash differs, **or no baseline exists**)" forces the question. It differs from the staged copy on 13 lines, all of them the 0.14→0.15 renames (`kit-canary-author`→`kit-batch-assembler`, `reveal-canaries.sh`→`reveal-key.sh`, `M-16`→`M-17` on the close-batch line). Nothing suggests it was edited here. | a file with no baseline, not one that evolved here | keep | **no** — a spurious question caused by the 6j pattern |
| 3 | The stale list, one question (9 files, listed in §2) | the one stale-list question | remove | yes |
| 4 | The ratification pass offer (step 9 → install Step 7): *ratify all 30 now, or defer?* | not a file; the procedure's own stub | defer | **not covered** — step 2 stubs it, the criterion neither admits nor excludes it |

Not asked: the step-7 "the pioneer may name recent implemented contracts to verify and audit" prompt — `contract-001` already carries `verification_state: none` and `audited: false`, so the *if absent* rule did not fire and there was nothing to name.

### Files that genuinely differed: **1**

- `.claude/skills/meta-casebook/SKILL.md` — baseline `ae6a2fef…`; the installed file differed from it under all three hashings (raw, CR-stripped, CRLF-added). I did not record its pre-upgrade hash; after the step-7 header edit it hashes `e36de3cd…`, which is what the new baseline holds. Everything else in the baseline (69 other paths) matched.

Borderline, not counted: `tests/walk.expected` (see decision 2). `templates/settings.template.json` likewise has no baseline entry (`.json`), but is byte-identical to the staged copy, so under "none where nothing differs" no question was asked.

### Troubleshooting steps: **1**

1. **The deferral marker.** Install Step 7 says: *"On a deferral: add `<!-- ratification: deferred -->` to `MAP.md`'s header comment."* Done literally, that nests a comment inside the header comment: the outer `<!--` closes at the marker's `-->` and the header's own `-->` becomes a stray visible line. I moved the marker to its own comment line directly after the header comment (the form `tests/walk.sh` state 29 uses). The hooks `grep` for the bare string, so both placements fire; only the literal one leaves a malformed file.

Not counted as troubleshooting, but noted: (a) my first check of the CLAUDE.md kit-block reported a difference that was an artefact of my own extraction (the staged block's bare `>` lines were dropped) — re-checked, the blocks are identical; (b) the step-9 hook run happens before `kit-incoming/` is removed, so `session-start.sh` still printed the "newer kit is staged" line — I re-ran it after removal to confirm the line is gone (it is).

### Verdict against step 2's pass criterion

> "The rehearsal passes only when every decision asked belongs to a file or template part that genuinely differed or is the one stale-list question … and the third number is zero"

**Does not pass**: decision 2 is a question about a file that did not evolve here, decision 4 is outside the admitted set, and the third number is 1. Per step 2 the fix belongs in `meta-bootstrap/SKILL.md` before the real run: extend the 6j `find` pattern to the files "What *the kit* is" names (`walk.expected`, `settings.template.json`), state where the marker goes, and say whether the ratification offer counts.

---

## 2. Classification presented (step 3)

**Untouched here → take the staged version, no question** (baseline hash matched):
- 16 skill files: `meta-antidrift`, `meta-antidrift-expand`, `meta-bootstrap`, `meta-contract-artifact`, `meta-contract-before-execution`, `meta-correction-log`, `meta-drift-eventlog`, `meta-extract`, `meta-foundation`, `meta-founding-contract`, `meta-learning`, `meta-ledger`, `meta-manifest`, `meta-map`, `meta-mechanisms`, `meta-skill-builder` (each `SKILL.md`); `meta-foundation/INTENT.md`
- 7 agents, both copies (`.claude/skills/agents/` and `.claude/agents/`): `kit-case-clerk`, `kit-consolidator`, `kit-map-steward`, `kit-reconstructor`, `kit-recorder`, `kit-session-auditor`, `kit-verifier`
- 11 hooks still shipped: `batch-blind`, `close-batch`, `deny-paths`, `lib`, `owner-check`, `post-read`, `prompt-submit`, `session-start`, `stop-gate`, `subagent-stop`, `write-scope`
- 9 templates still shipped: `CASEBOOK`, `CONTRACT-LOG`, `CORRECTIONS`, `DRIFTLOG`, `FOUNDING`, `LEARNINGLOG`, `LEDGER`, `MANIFEST`, `MAP`
- `meta-mechanisms/tests/walk.sh`

**Evolved here → shown, asked** (hash differs): `meta-casebook/SKILL.md` (decision 1).

**No baseline exists** (not hashed by 6j): `meta-mechanisms/tests/walk.expected` (differs from staged → decision 2); `templates/settings.template.json` (identical to staged → no question).

**New in the kit → add**: `agents/kit-batch-assembler.md` (both copies), `meta-mechanisms/hooks/reveal-key.sh`, `meta-mechanisms/checks/G1-size.sh`. Not taken, per *What "the kit" is*: `checks/P-004.sh`…`P-007.sh` (no P-id exists in this project's casebook), `tests/results/**`, `tests/walk-007.sh`, `tests/fixtures/make-upgrade-fixtures.sh`.

**Stale (present here, absent from the staged kit, or the base kit's own evidence) → one question**, with the kept files that still refer to each:

| Stale file | Kept file still referring to it |
|---|---|
| `.claude/skills/agents/kit-canary-author.md` | `tests/walk.expected` (kept) states 23, 25, 26, 27, 28, 30 |
| `.claude/agents/kit-canary-author.md` | same |
| `meta-mechanisms/hooks/reveal-canaries.sh` | `tests/walk.expected` (kept) state 09 |
| `templates/REBUILD.template.yaml` | `meta-casebook/SKILL.md` (kept) line 63 |
| `meta-mechanisms/tests/walk-004.sh` | none kept (the refreshed `meta-mechanisms/SKILL.md` names it as the base kit's own walk) |
| `meta-mechanisms/tests/fixtures/make-T-2.sh` | none |
| `meta-mechanisms/tests/results/T-2-2026-09-12.md` | none |
| `meta-mechanisms/tests/results/T-7-2026-09-12.md` | none |
| `meta-mechanisms/tests/results/contract-004-tiers.sha1` | none |

(`MAP.md` M-16/M-17, the manifest's `agent-canary-author` node and coverage line, and the `LEDGER.yaml` header also named the first three — all refreshed by the template rule in step 7, so they are not "kept" references.)

**Instance files** (never replaced): `MANIFEST.yaml`, `MAP.md`, `FOUNDING.md`, `CONTRACT-LOG.yaml`, `LEARNINGLOG.yaml`, `DRIFTLOG.yaml`, `LEDGER.yaml`, `CORRECTIONS.yaml`, `CASEBOOK.yaml`, `INSTALLED.sha1`. `telemetry.log` did not exist before the upgrade (the hooks had never run here). Template-rule check: `MAP.md` was byte-identical to the installed `MAP.template.md` (name substituted); `MANIFEST.yaml` was identical to the installed `MANIFEST.template.yaml` with the install's substitutions; the header comment blocks of `CONTRACT-LOG`, `CORRECTIONS` and `LEDGER` were identical to their installed templates — so every template part "still reads as the installed template wrote it" and was refreshed without a question.

**What *keep* leaves pointing at removed or renamed things** (for the pioneer to weigh at the real run):
- `meta-casebook/SKILL.md` (kept): section *### The launch rebuild (M-31)*; "When the milestone arrives (M-31)"; `REBUILD.yaml` and `templates/REBUILD.template.yaml` (now removed); `frozen_on`; the header still says "— or the milestone in REBUILD.yaml has been reached". Only the id `M-31` was removed from the header, as step 7 states.
- `tests/walk.expected` (kept): 13 lines naming `kit-canary-author`, `reveal-canaries.sh`, "canaries are unrevealed", and `M-16` where the 0.15 gate says `M-17`. **Consequence: `bash .claude/skills/meta-mechanisms/tests/walk.sh` (now the 0.15 script, which diffs against this file) will exit non-zero.**

---

## 3. Migrations applied, file by file

### Step 5 — installed / removed
- Copied from the staged kit: the 16 untouched `SKILL.md`s, `INTENT.md`, 10 templates (incl. `settings.template.json`), 11 hooks + new `reveal-key.sh`, new `checks/G1-size.sh` (creating `checks/`), `tests/walk.sh`, 8 agents to `.claude/skills/agents/` and `.claude/agents/` (incl. new `kit-batch-assembler.md`).
- `.claude/settings.json`: the kit's `"_kit"` hook groups are byte-identical to the staged template; merge is a no-op. No non-kit groups; `Read(kit-sealed/**)` deny present.
- `CLAUDE.md`: the block between the `kit-block` markers is identical to the staged 5a block; no change.
- 5d: `.gitignore` already has `.claude/kit-sealed/`; `.gitattributes` already has `*.sh text eol=lf`. 5e: created `meta-ledger/batches/` and `meta-casebook/reconstruction/` (both missing).
- Removed the 9 stale files above; `tests/results/` and `tests/fixtures/` then empty and removed.

### Step 6 — nothing to seed (every instance file present).

### Step 7 — `meta-map/MAP.md` (template rule; status column kept — all 30 surviving entries `proposed`)
```
M-03 | … | a moment with a clear entry | meta-foundation, then record the miss (M-20)
   → | a moment with a clear entry (M-20 records the miss) | meta-foundation
M-28 | … | — | INTENT.md → drift score block; meta-antidrift if a line is hard to fill
   → | a session-level analysis (M-19) | INTENT.md → Close every output with this block; meta-antidrift → The Drift Score Block
M-24 | founding-question | situation | …          → | situation + hook: Stop | …
M-29 | … | LEDGER.yaml → candidates at stage trial or adopt; cite the id
   → | LEDGER.yaml → candidates; meta-ledger → Candidates
M-08 | … | a change already in revisions | meta-contract-before-execution → The Approval Gate; unauthorised → meta-drift-eventlog
   → | a change already in revisions; an unauthorised one is drift (M-18) | meta-contract-before-execution → The Approval Gate
M-09 | … | INTENT.md → Evidence is the work: stop, propose the verification   → | INTENT.md → The agent holds five aspects
M-10 | … | INTENT.md → Stop on named triggers: name it, ask to re-orient        → | meta-antidrift → Scoring Rules
M-23 | … | — | MANIFEST.yaml: flag it, never fill it silently                    → | a node change (M-22) | meta-manifest → How to Read the Manifest
M-16 | … | agent: kit-canary-author, then meta-skill-builder → Review Batch    → | agent: kit-batch-assembler, then meta-skill-builder → Review Batch
M-17 | … | script: reveal-canaries.sh; meta-skill-builder → Reveal              → | script: close-batch.sh, then reveal-key.sh; meta-skill-builder → Reveal
M-31 | launch-rebuild | … | REBUILD.yaml; meta-casebook → Reconstruction tests   → REMOVED (withdrawn by the staged template; not reworded here)
```
Step 9: `<!-- ratification: deferred -->` added as its own comment line after the header comment. Size after: 6,998 bytes, 30 entries (G1-size passes).

### Step 7 — `meta-manifest/MANIFEST.yaml` (template rule on every base node and coverage line; `kit_name`, `kit_type`, `category`, `library_kit: null` left as the project declared them; no project or inherited nodes exist)
```
kit_identity.base_kit_version: 0.14 → 0.15
base-skill-builder   concern: "… verdict before evidence, canaries, adoption …" → "… verdict before evidence, re-presented items, adoption …"
base-casebook        owns: [CASEBOOK.yaml, reconstruction/, REBUILD.yaml, SKILL.md] → [CASEBOOK.yaml, reconstruction/, SKILL.md]
                     triggers: [M-04, M-05, M-26, M-31] → [M-04, M-05, M-26]
base-mechanisms      triggers: + M-07
agent-consolidator   concern: "Sole writer of candidates — independence-aware counters, lower bounds, fading, outcomes, scores"
                              → "Sole writer of candidates — counters by reading, fading, outcomes, scores that never score the pioneer"
agent-canary-author  → agent-batch-assembler (whole node line and coverage line taken from the staged template)
coverage base-ledger "Evidence, candidates, canaries and maturity instruments" → "Evidence, candidates, re-presented items and maturity instruments"
coverage             "Gate instrumentation — canaries / agent-canary-author" → "Review batch assembly and re-presented items / agent-batch-assembler"
```
(Note: the 0.14 install listed `meta-casebook/REBUILD.yaml` under `base-casebook.owns` although no `REBUILD.yaml` ever existed in this project; the refresh resolves that.)

### Step 7 — `meta-contract-before-execution/CONTRACT-LOG.yaml`
- Header comment block refreshed from the staged template (adds `disappointment`, `premortem`, `red_test`, `cost`, `closed-by-follow-up`, `corrections_from_tests/_reading`; `approval: approved-at-gate` with "`gate` on entries from before 0.15, left as is").
- `contract-001`: + `disappointment: legacy`, + `premortem: legacy`, + `red_test: legacy` (after `tier_3`), + `cost: legacy` (before `work_id`). `approval: gate` left as is. `verification_state: none` / `audited: false` already present → untouched (the live gate will audit and verify it).

### Step 7 — `meta-correction-log/CORRECTIONS.yaml`
- Header refreshed from the staged template (adds the three incident-probe fields).
- `C-001`: + `noticed: not asked`, + `would_have_been_right: not asked`, + `seen_before: not asked` (after `reason_given`).

### Step 7 — `meta-ledger/LEDGER.yaml`
- Header refreshed (the one-writer list; `kit-batch-assembler`; `represented`, `coincidence`; `lower_bound` and the two brier lines gone from the schema comment).
- `scores`: − `canary_catch_rate: null`, − `brier_stated_confidence: null`, − `brier_pioneer_decisions: null`, + `coincidence: []`. No batches, no candidates → nothing else.

### Step 7 — untouched
`DRIFTLOG.yaml` (no entries; template identical between versions), `CASEBOOK.yaml`, `LEARNINGLOG.yaml`, `FOUNDING.md` (templates identical between versions).

### Step 7 — kept skill header
`meta-casebook/SKILL.md` line 6: `> **Map:** M-04, M-05, M-26, M-31 ·` → `> **Map:** M-04, M-05, M-26 ·` (reported, not asked). Nothing else in the file changed.

### Step 8 — no non-base nodes; nothing drafted. `checks/G1-size.sh`: exit 0.

### Step 9
- Baseline regenerated with the 0.15 6j command: 66 entries (no `*` prefix; CR-stripped hashes).
- Every check under `checks/`: `G1-size.sh` exit 0.
- Install Step 7 hook commands with `CLAUDE_PROJECT_DIR=PROJECT`: `session-start.sh`, `prompt-submit.sh`, `stop-gate.sh` printed valid JSON; `subagent-stop`, `post-read`, `owner-check`, `batch-blind`, `deny-paths` printed nothing; `write-scope.sh` printed a valid JSON deny (correct for `src/x.cs`); `close-batch.sh B-001` and `reveal-key.sh B-001` both reported *No batch file*. `telemetry.log` was created and gained `loaded|meta-map/MAP.md` followed by `bypass|base-casebook|meta-casebook/CASEBOOK.yaml` — exactly what Step 7 says a correct run shows. The backlog reflects the live records: `contract-001` implemented/unaudited/unverified (M-11, M-12), `C-001` unclerked (M-15); the stop-gate hands over the M-11 audit. With the marker in place the "pioneer-owned items waiting" line is gone.
- Ratification pass offered → stubbed *defer* → marker added. Report accepted (stub) → `.claude/kit-incoming/` removed.

---

## 4. Unclear, wrong or missing in the procedure — verbatim, as hit

1. **6j / step 3 — the baseline cannot cover two kit files.** 6j: `find .claude/skills .claude/agents \( -name '*.md' -o -name '*.yaml' -o -name '*.sh' \)`. *What "the kit" is* names "`templates/`" and "of `tests/` only `walk.sh` and `walk.expected`". `walk.expected` and `templates/settings.template.json` therefore never get a baseline entry, and step 3's "**evolved here** (hash differs, or no baseline exists) → show the pioneer what differs … and ask one question" turns an untouched `walk.expected` into a question at every upgrade where the gate texts changed. Fix: add `-o -name '*.expected' -o -name '*.json'` to 6j (and to the step-3 recomputation).

2. **Install Step 7 — marker placement.** "On a deferral: add `<!-- ratification: deferred -->` to `MAP.md`'s header comment." Read literally this nests one HTML comment inside another. Say: *as its own comment line, after the header comment's closing `-->`*.

3. **Step 2 — the stub list and the pass criterion disagree.** Step 2 stubs "*legacy* for every existing contract (step 7), *defer* for the ratification pass (step 9)", then says the rehearsal passes "only when every decision asked belongs to a file or template part that genuinely differed or is the one stale-list question — the pioneer's acceptance of the report at the end is not a decision and is not counted". The ratification offer and the legacy-naming prompt are stubbed answers, so they are decisions asked, yet neither is a differing file nor the stale-list question. Either exempt them explicitly (as the report acceptance is) or drop them from the stub list.

4. **Step 9 — ordering leaves the baseline stale.** "Regenerate the baseline (6j) … Offer the ratification pass … on a deferral add the `ratification: deferred` marker". The marker is written to `MAP.md` after its hash was recorded, so `INSTALLED.sha1` disagrees with `MAP.md` from the first minute (confirmed: `MAP.md` is the one hashed file that differs from the fresh baseline). Harmless for step 3 of the next upgrade only because `MAP.md` is an instance file the template rule compares as text — but the baseline is then not "every file in its installed state". Write the marker before 6j, or exclude instance files from the baseline.

5. **Step 9 — the hook run precedes the removal of `kit-incoming/`.** "run … the install's Step 7 hook commands … When the pioneer accepts the report, remove `.claude/kit-incoming/`." `session-start.sh` therefore still prints "A newer kit is staged in .claude/kit-incoming/ -> M-27 …" during the check. Expected, but the text describing what the upgrade run shows ("the backlog and the gate's task reflect the project's live records") does not say so.

6. **Step 7 — `> **Map:**` header rule stops at the id.** "The `> **Map:**` header of a kept skill loses any id the staged template withdrew from the map." Only the id. The kept `meta-casebook/SKILL.md` header still ends its *Recognise it by* with "— or the milestone in REBUILD.yaml has been reached", and the body keeps "### The launch rebuild (M-31)" and "When the milestone arrives (M-31)". Whether the prose around a withdrawn id is the map's (co-owned) or the pioneer's is not stated; I removed the id only.

7. **Step 3 — "the questions will therefore be one per skill"** (no-baseline case) versus "**show the pioneer what differs** from the staged copy … One question per differing file". For a file with no baseline that is identical to the staged copy (`settings.template.json` here) the two sentences point different ways; I followed "none where nothing differs".

8. **Step 2 — "Discard the copy."** Not applicable here by the caller's instruction (this folder *is* the copy); noted so the count of what was done matches the text.

9. **Minor.** Step 6 "Create `.claude/skills/meta-mechanisms/checks/` if absent" is already done by step 5 copying `G1-size.sh`. The 0.14 install left `REBUILD.yaml` in `base-casebook.owns` without ever seeding the file — a pre-existing 0.14 defect, not the upgrade's.

---

## 5. State after the upgrade

**`MAP.md` M-16 and M-17:**
```
M-16 | review-due | hook: Stop | must | the stop-gate says pioneer-owned items wait, no batch open | — | agent: kit-batch-assembler, then meta-skill-builder → Review Batch | proposed
M-17 | batch-decided | hook: Stop | must | every item in the open batch carries a decision | — | script: close-batch.sh, then reveal-key.sh; meta-skill-builder → Reveal | proposed
```
`M-31` no longer appears anywhere in `MAP.md`; `<!-- ratification: deferred -->` sits on its own line after the header comment.

**Manifest `base-casebook` node (line 45) and coverage line (107):**
```
- {id: base-casebook, concern: Binding precedents with their facts, scenario cards, reconstruction tests, kind: record, skill_file: meta-casebook/SKILL.md, data_file: meta-casebook/CASEBOOK.yaml, owns: [meta-casebook/CASEBOOK.yaml, meta-casebook/reconstruction/, meta-casebook/SKILL.md], layer: meta, phase: [pre-build, post-build], load: trigger, triggers: [M-04, M-05, M-26], status: thin, dependencies: [base-correction-log], open_gaps: []}
- {concern: Binding precedents and reconstruction, node_id: base-casebook, layer: meta, phase: [pre-build, post-build], status: thin}
```
`base_kit_version: 0.15`.

**Kept `meta-casebook/SKILL.md` header (line 6):**
```
> **Map:** M-04, M-05, M-26 · **Load:** retrieved on trigger by moment tag · **Recognise it by:** "we have decided a situation like this before" — or the milestone in REBUILD.yaml has been reached · **Not when:** the question is what the rule says (that is the node) rather than how it was applied
```
Body unchanged, including the local *Project addition* section and the *The launch rebuild (M-31)* section.

## 6. Is `.claude/kit-incoming/` gone?

**Yes.** Removed at the end of step 9 on the stubbed acceptance; `session-start.sh` no longer prints the M-27 line.

---

## Appendix A — the log kept during the run (verbatim)

```
# Upgrade rehearsal log — fx013, 0.14 -> 0.15, 2026-09-13T14:43:33Z
decisions asked: 4        (D1 meta-casebook/SKILL.md keep · D2 tests/walk.expected keep [no baseline] · D3 stale list remove · D4 ratification defer)
files that genuinely differed: 1   (meta-casebook/SKILL.md)
troubleshooting steps: 1  (deferral marker placement)

## step 5 — install
took staged meta-antidrift/SKILL.md … meta-skill-builder/SKILL.md (16 skills), meta-foundation/INTENT.md
took staged templates/* (10 files)
took staged hooks/*.sh (11 hooks; reveal-key.sh new)
added checks/G1-size.sh (new)
took staged tests/walk.sh; tests/walk.expected kept (stubbed keep)
took staged agents/*.md -> skills/agents + .claude/agents (8; kit-batch-assembler new)
settings.json: kit hook groups identical to staged template — merge is a no-op; no non-kit groups present; deny Read(kit-sealed/**) present
CLAUDE.md kit-block: first check reported blank-line differences — an artefact of my extraction; re-checked: identical to the staged 5a block, replacement is a no-op
.gitignore already has .claude/kit-sealed/ ; .gitattributes already has *.sh text eol=lf
created meta-ledger/batches/ and meta-casebook/reconstruction/ (5e folders were missing)
removed stale: skills/agents/kit-canary-author.md, agents/kit-canary-author.md, hooks/reveal-canaries.sh, templates/REBUILD.template.yaml, tests/walk-004.sh, tests/fixtures/make-T-2.sh, tests/results/T-2-2026-09-12.md, tests/results/T-7-2026-09-12.md, tests/results/contract-004-tiers.sha1; removed empty tests/results/ and tests/fixtures/
## step 6 — seed missing instance files: none missing; checks/ created in step 5
## step 7 — migrations
MAP.md: base entries refreshed from staged template (template rule); status column unchanged for all 30 surviving entries (all proposed); M-31 withdrawn   [diff in §3]
MANIFEST.yaml: base node lines, coverage lines and base_kit_version refreshed from staged template   [diff in §3]
CONTRACT-LOG.yaml / CORRECTIONS.yaml / LEDGER.yaml: header comment blocks refreshed from staged templates; DRIFTLOG/CASEBOOK/LEARNINGLOG templates unchanged -> no header change
CONTRACT-LOG.yaml contract-001: added disappointment/premortem/red_test: legacy (after tier_3), cost: legacy (before work_id); verification_state/audited already present -> untouched
CORRECTIONS.yaml C-001: added noticed / would_have_been_right / seen_before: not asked
LEDGER.yaml scores: removed canary_catch_rate, brier_stated_confidence, brier_pioneer_decisions; added coincidence: []
DRIFTLOG.yaml: no entries; CASEBOOK.yaml, LEARNINGLOG.yaml, FOUNDING.md untouched
meta-casebook/SKILL.md (kept): > **Map:** header lost M-31 — reported, not asked
## step 8 — no non-base nodes -> nothing drafted; G1-size.sh rc=0
## step 9
baseline regenerated: 66 entries
G1-size.sh rc=0
hooks: session-start / prompt-submit / stop-gate valid JSON; subagent-stop, post-read, owner-check, batch-blind, deny-paths silent; write-scope valid JSON deny; close-batch & reveal-key: "No batch file"; telemetry gained loaded|meta-map/MAP.md then bypass|base-casebook|meta-casebook/CASEBOOK.yaml
ratification pass offered -> stubbed defer -> marker added (after the baseline, as step 9 orders it)
TROUBLESHOOTING 1: marker first landed inside the header comment (literal reading of Step 7); moved to its own comment line after it
report accepted (stub) -> .claude/kit-incoming/ removed; present now? no
```

## Appendix B — deviations from the brief, for the record

- I briefly created a temp folder *beside* PROJECT for the recomputed baseline; moved it inside PROJECT (`.rehearsal-tmp/`, deleted after this report) and removed the outer one. One `ls ..` listed sibling folder names; nothing in them was read.
- Under the kit's own rule every output closes with a drift score block; the caller fixed the final message's shape, so the block is here instead:

```
─── drift score (agent) ──────────────────────────────────
lay of the land      [evidence: both kits read in full before any write; every hashed path classified; the 6j gap found before it bit]
stop on triggers     [evidence: stopped on the nested-marker shape and the spurious walk.expected question rather than continuing past them]
partner mirror       [evidence: classification and the four stubbed questions presented in §2/§1 for correction, not approval]
elevation not rec.   [evidence: procedure defects reported as fixes to the node (§4), not patched during the run]
evidence-as-work     [evidence: template-rule claims verified by diff against the installed templates; hook JSON checked with python]
implicit approvals   [none — every answer was a stub the procedure names]
skill deviations     [meta-bootstrap step 2 "Discard the copy" — not done, by the caller's instruction]
──────────────────────────────────────────────────────────
```
