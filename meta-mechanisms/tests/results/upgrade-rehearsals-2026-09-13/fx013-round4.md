# Upgrade rehearsal — fx013, base kit 0.14 → 0.15

Run on 2026-09-13 in the throwaway copy at `scratchpad/round4/fx013`, following the **staged** kit's `meta-bootstrap/SKILL.md → Upgrading an Existing Install`, steps 1–9, with the pioneer's answers stubbed as step 2 prescribes (keep / remove / legacy / defer / report accepted). `CLAUDE_PROJECT_DIR` was set to the project root for every hook, check and walk. Shell: Git Bash.

Step 1: project `kit_identity.base_kit_version: 0.14`, staged `kit_identity.version: 0.15` — upgrade due. Step 2: this folder is the copy; no second copy was made.

---

## 1. The three numbers

### Decisions asked: **3**

| # | Question | Belongs to | Stubbed answer |
|---|---|---|---|
| D-1 | `.claude/skills/meta-casebook/SKILL.md` differs from the staged copy (header names M-31 and REBUILD.yaml; a "The launch rebuild (M-31)" section the staged kit replaced with "The rebuild — withdrawn from the map"; a pioneer-added "Project addition" section). Overwrite with the staged, keep yours, or port the staged changes in by hand? | a file that genuinely differed (F-1) | keep |
| D-2 | Remove the stale list (below)? | standing question — the stale list | remove |
| D-3 | Ratify the 30 base map entries now, or defer? | standing question — the ratification pass step 9 offers | defer |

Report acceptance at the end: given (stub), not counted, `.claude/kit-incoming/` removed on it.

Not asked, and why: the *legacy* stub for existing contracts never became a question, because contract-001 already carries `verification_state: none` and `audited: false` and step 7 adds those fields only "if absent" (see §4, item 1).

### Files that genuinely differed: **1**

| # | File | What differed from the staged copy |
|---|---|---|
| F-1 | `.claude/skills/meta-casebook/SKILL.md` | header: `M-04, M-05, M-26, M-31` and "— or the milestone in REBUILD.yaml has been reached"; section `### The launch rebuild (M-31)` (11 lines on REBUILD.yaml, frozen_on, milestone/oracle/arms) where the staged kit has `### The rebuild — withdrawn from the map` (one paragraph); an appended `## Project addition` section ("In this project, precedents about response shapes are reviewed with the API owner.") absent from the staged kit |

Template parts that differed from what the installed template wrote: **none**. MAP.md's base entries and header, the manifest's base node lines, coverage lines and header, and every log's header comment read exactly as the installed 0.14 templates wrote them (verified by diff after substituting the project name and date), so all of them refreshed mechanically with no question.

### Troubleshooting steps: **1**

| # | What I had to do that the steps do not say |
|---|---|
| T-1 | **Restore line endings the migration dropped.** Step 7 says "Kit files arrive with LF endings; instance files keep whatever endings they have". The template rule refreshes a log's header comment from the staged template, which is LF; `LEDGER.yaml` was CRLF (121 CRs), and rebuilding it as "staged header + kept data" produced an LF file. Likewise `sed -i` on the kept CRLF `meta-casebook/SKILL.md` (to drop M-31 from its header, step 7's last bullet) rewrote the whole file LF under Git Bash. I had to re-apply the original endings after the fact — and my first re-application was itself wrong: it put CRs on the pioneer's four appended "Project addition" lines, which had been LF-only in the original (86 CRs on a 90-line file), so I rebuilt the file a second time from the before-copy with only the header change (`perl -pe` on line 6). Final state: `LEDGER.yaml` 121 CRs as before; `meta-casebook/SKILL.md` 86 CRs as before, byte-identical to the original except line 6. The procedure states the outcome and gives no way to reach it. |

### Verdict against the bootstrap's own criterion

> "The rehearsal passes only when every decision asked belongs to a file or template part that genuinely differed or is one of the two standing questions — the stale list, and the ratification pass step 9 offers — with the pioneer's acceptance of the report at the end not counted, and the third number is zero; otherwise fix the procedure here, in this node, and rehearse again."

Decisions: D-1 belongs to F-1; D-2 and D-3 are the two standing questions — this half holds. Third number: **1, not zero.**

**Result: FAIL.** The procedure has to be fixed in the bootstrap node (step 7: say how a header refresh and a header edit preserve an instance file's — and a kept skill's — existing line endings) and the rehearsal run again before the real project is touched.

---

## 2. The classification presented (step 3)

Baseline `INSTALLED.sha1` was pre-0.15: every path carried a leading `*` (dropped) and the hashes were over raw bytes. Recomputed with the 6j command (CR-stripped) into a temp file and compared hash-to-hash by path; for every mismatch the file was hashed raw and with CRLF added, as step 3 says.

**Untouched here** (take the staged version, no question) — 66 files:
- direct hash match (LF files): `CONTRACT-LOG.yaml`, `CORRECTIONS.yaml`, `MANIFEST.yaml`, `MAP.md`, `FOUNDING.md` (instance files, listed but never replaced), all 12 `meta-mechanisms/hooks/*.sh`, `tests/walk.sh`, `tests/walk-004.sh`, `tests/fixtures/make-T-2.sh`
- match once CRLF is added (an install re-saved on Windows — "differs by nothing"): all 8 agents in both `.claude/agents/` and `.claude/skills/agents/`, every `meta-*/SKILL.md` except meta-casebook's, `meta-foundation/INTENT.md`, all 10 `templates/*`, `LEARNINGLOG.yaml`, `LEDGER.yaml`, `DRIFTLOG.yaml`, `CASEBOOK.yaml`, `tests/results/T-2-2026-09-12.md`, `tests/results/T-7-2026-09-12.md`
- no baseline line because the 0.14 pattern did not cover them (untouched, not evolved): `tests/walk.expected` (named in the procedure), `templates/settings.template.json` (same case, not named)

**Evolved here** (one question each): `.claude/skills/meta-casebook/SKILL.md` → D-1.

**New in the kit** (add): `agents/kit-batch-assembler.md` (kit copy and deployed), `hooks/reveal-key.sh`, `checks/G1-size.sh` (and the `checks/` folder).

**Present here, absent from the staged kit / the base kit's own evidence** (stale, one question → D-2), with the kept files that still referred to each:
- `.claude/agents/kit-canary-author.md`, `.claude/skills/agents/kit-canary-author.md` ← MAP.md M-16, MANIFEST `agent-canary-author`, LEDGER.yaml header (all refreshed in step 7)
- `hooks/reveal-canaries.sh` ← MAP.md M-17 (refreshed in step 7)
- `templates/REBUILD.template.yaml` ← MANIFEST base-casebook `owns:` (refreshed in step 7); **kept `meta-casebook/SKILL.md`** (header clause and the launch-rebuild section — still refers to it after the upgrade; see §3)
- `tests/results/` (T-2, T-7, `contract-004-tiers.sha1`), `tests/fixtures/make-T-2.sh`, `tests/walk-004.sh` ← nothing kept refers to them
- `P-NNN.sh` checks: none were installed; the staged `P-004..P-007.sh` were not installed either (only `G1-size.sh` travels)

**Not installed from the staged folder** (base kit's own precedents and evidence): `tests/results/*`, `tests/fixtures/*`, `tests/walk-004.sh`, `tests/walk-007.sh`, `checks/P-00[4-7].sh`, and its instance files (`MANIFEST.yaml`, `MAP.md`, `FOUNDING.md`, `CONTRACT-LOG.yaml`, `CORRECTIONS.yaml`, `DRIFTLOG.yaml`, `LEARNINGLOG.yaml`, `LEDGER.yaml`, `CASEBOOK.yaml`).

Step 4: no new node arrived with an instance file. Step 6: nothing to seed — every instance file existed; `checks/` created. Step 8: the manifest has 26 nodes, all base; no non-base skill folders exist; nothing to draft. G1-size passed (MAP.md 6,966 bytes, 30 entries; INTENT.md 4,820 bytes).

**Kept file that still describes something the staged kit removed or renamed** (for the pioneer to weigh at the real run, as step 2 requires): `meta-casebook/SKILL.md` — its header still says "— or the milestone in REBUILD.yaml has been reached", and its `### The launch rebuild (M-31)` section still instructs seeding `REBUILD.yaml` from `templates/REBUILD.template.yaml` (removed) and firing on M-31 (withdrawn from the map). With *keep*, that section points at nothing.

---

## 3. Every migration applied, file by file

### Step 5 — installed from the staged copies (untouched or new)
- `meta-{antidrift,antidrift-expand,bootstrap,contract-artifact,contract-before-execution,correction-log,drift-eventlog,extract,foundation,founding-contract,learning,ledger,manifest,map,mechanisms,skill-builder}/SKILL.md` and `meta-foundation/INTENT.md` — replaced with the staged text (LF).
- `templates/` — 10 files replaced with the staged versions; `REBUILD.template.yaml` removed (stale).
- `meta-mechanisms/hooks/` — 12 staged scripts written (`batch-blind.sh`, `owner-check.sh`, `session-start.sh`, `stop-gate.sh` changed; `reveal-key.sh` new; others identical); `reveal-canaries.sh` removed.
- `meta-mechanisms/checks/G1-size.sh` — added (folder created).
- `meta-mechanisms/tests/walk.sh`, `walk.expected` — replaced; `walk-004.sh`, `fixtures/`, `results/` removed.
- `.claude/skills/agents/` and `.claude/agents/` — 8 staged agents written to each (5 changed, `kit-batch-assembler.md` new, 2 identical); `kit-canary-author.md` removed from both.
- `.claude/settings.json` — kit hook groups replaced with the staged template's; content identical, the only byte difference before/after was line endings (template LF).
- `CLAUDE.md` — block between the `kit-block` markers is identical to the staged 5a text; unchanged.
- `.gitignore` (`.claude/kit-sealed/`) and `.gitattributes` (`*.sh text eol=lf`) — present; unchanged. Folders `meta-ledger/batches/` and `meta-casebook/reconstruction/` — missing in the copy, recreated.

### Step 7 — instance files (additive; positions from the staged template)

**`meta-contract-before-execution/CONTRACT-LOG.yaml`** (LF, kept LF)
- header comment: refreshed from the staged template — `approval: approved-at-gate` (with the note that `gate` on pre-0.15 entries is left as is), `disappointment`/`premortem` schema lines, the reworded `tier_4` note, `red_test`, `closed-by-follow-up` in `verification_state`, `corrections_from_tests`/`corrections_from_reading` under verification, `cost` — 8 hunks, comments only.
- contract-001: `+ disappointment: legacy`, `+ premortem: legacy`, `+ red_test: legacy` after `tier_3` (no `tier_4` exists); `+ cost: legacy` after `revisions: []`, before `work_id`. `approval: gate`, `verification_state: none`, `audited: false` untouched.

**`meta-correction-log/CORRECTIONS.yaml`** (LF, kept LF)
- header comment: `noticed` / `would_have_been_right` / `seen_before` schema lines added (2 hunks, comments only).
- C-001: `+ noticed: not asked`, `+ would_have_been_right: not asked`, `+ seen_before: not asked` after `reason_given`, before `supersedes`.

**`meta-ledger/LEDGER.yaml`** (CRLF, restored to CRLF — T-1)
- header comment: refreshed — "THE ONE WRITER LIST", `kit-batch-assembler` for `kit-canary-author`, `evidence_refs` grading note, `lower_bound` line dropped, `outcome` shape, `represented: []` for `canaries`/`canaries_caught`, `scores` shape with `coincidence` (7 hunks, comments only).
- `scores:` — removed `canary_catch_rate: null`, `brier_stated_confidence: null`, `brier_pioneer_decisions: null`; added `coincidence: []` after `contracts: []`. No batches, no candidates existed. Result equals the staged template byte for byte apart from endings.

**`meta-drift-eventlog/DRIFTLOG.yaml`, `meta-casebook/CASEBOOK.yaml`, `meta-learning/LEARNINGLOG.yaml`, `meta-founding-contract/FOUNDING.md`** — staged templates identical to the installed ones; no elevations, no entries; unchanged.

**`meta-manifest/MANIFEST.yaml`** (LF) — header identical between templates; every node already had `kind`, `load`, `owns`, `library_kit: null`; base node and coverage lines refreshed by the template rule:
```
20:  base_kit_version: 0.14                                   -> 0.15
37:  base-skill-builder concern "… verdict before evidence, canaries, …"   -> "… re-presented items, …"
45:  base-casebook owns [CASEBOOK.yaml, reconstruction/, REBUILD.yaml, SKILL.md] -> [CASEBOOK.yaml, reconstruction/, SKILL.md]
     base-casebook triggers [M-04, M-05, M-26, M-31]            -> [M-04, M-05, M-26]
46:  base-mechanisms triggers [M-01, M-02, M-11, …]             -> [M-01, M-02, M-07, M-11, …]
49:  agent-consolidator concern "independence-aware counters, lower bounds, fading, outcomes, scores" -> "counters by reading, fading, outcomes, scores that never score the pioneer"
51:  agent-canary-author node line                              -> agent-batch-assembler node line (staged template's, whole line)
111: coverage base-ledger "Evidence, candidates, canaries and maturity instruments" -> "…, re-presented items and …"
121: coverage "Gate instrumentation — canaries / agent-canary-author" -> "Review batch assembly and re-presented items / agent-batch-assembler"
```
`kit_type: project`, `category: test-api`, `kit_name: fx013`, `gap_queue: []`, `library_entry: null` untouched.

**`meta-map/MAP.md`** (LF) — header comment identical between templates; every base entry took the staged template's columns and kept its status (all `proposed`):
```
M-03  not-when "a moment with a clear entry" -> "a moment with a clear entry (M-20 records the miss)"; load "meta-foundation, then record the miss (M-20)" -> "meta-foundation"
M-28  not-when "—" -> "a session-level analysis (M-19)"; load -> "INTENT.md → Close every output with this block; meta-antidrift → The Drift Score Block"
M-24  type "situation" -> "situation + hook: Stop"
M-29  load "LEDGER.yaml → candidates at stage trial or adopt; cite the id" -> "LEDGER.yaml → candidates; meta-ledger → Candidates"
M-08  not-when "a change already in revisions" -> "…; an unauthorised one is drift (M-18)"; load loses "unauthorised → meta-drift-eventlog"
M-09  load "INTENT.md → Evidence is the work: stop, propose the verification" -> "INTENT.md → The agent holds five aspects"
M-10  load "INTENT.md → Stop on named triggers: name it, ask to re-orient" -> "meta-antidrift → Scoring Rules"
M-23  not-when "—" -> "a node change (M-22)"; load "MANIFEST.yaml: flag it, never fill it silently" -> "meta-manifest → How to Read the Manifest"
M-16  load "agent: kit-canary-author, then meta-skill-builder → Review Batch" -> "agent: kit-batch-assembler, then meta-skill-builder → Review Batch"
M-17  load "script: reveal-canaries.sh; meta-skill-builder → Reveal" -> "script: close-batch.sh, then reveal-key.sh; meta-skill-builder → Reveal"
M-31  removed (withdrawn by the staged template; not reworded here)
```
Step 9 (D-3 defer): `ratification: deferred` added as the last line inside the header comment.

**`meta-casebook/SKILL.md`** (kept, CRLF) — line 6 only: `> **Map:** M-04, M-05, M-26, M-31 ·` → `> **Map:** M-04, M-05, M-26 ·`. Reported, not asked. Everything else — including "or the milestone in REBUILD.yaml has been reached" in the same header and the M-31 section — left as the pioneer kept it.

### Step 9
- `INSTALLED.sha1` regenerated with 6j: 68 lines, new format (no `*`, CR-stripped hashes).
- `checks/G1-size.sh`: exit 0.
- Hook commands (all with `CLAUDE_PROJECT_DIR` set): `session-start.sh` printed the project's live backlog (contract-001 unaudited, no verification evidence, C-001 unclerked, pioneer-owned items waiting, and the staged-kit line — the last two gone after the deferral marker and the folder removal); `prompt-submit.sh` JSON; `stop-gate.sh` handed M-11 for contract-001; `subagent-stop.sh`, `post-read.sh`, `owner-check.sh`, `batch-blind.sh`, `deny-paths.sh` nothing; `write-scope.sh` a deny JSON; `close-batch.sh B-001` and `reveal-key.sh B-001` "No batch file at …" (exit 1); `telemetry.log` tail: `subagent|kit-verifier`, `loaded|meta-map/MAP.md`, `bypass|base-casebook|meta-casebook/CASEBOOK.yaml`.
- `tests/walk.sh`: "walk: all 36 states match walk.expected" — before and after the folder removal.
- Report accepted (stub) → `.claude/kit-incoming/` removed.

---

## 4. Unclear, wrong or missing in the procedure, verbatim as I hit it

1. **Step 2 vs step 7 vs the pass criterion — the *legacy* stub.** Step 2: "*legacy* for every existing contract (step 7)". Step 7: "every existing entry gains `verification_state: legacy` and `audited: legacy` if absent (the pioneer may name recent implemented contracts to verify and audit; set `none` and `false` on those)". The criterion: "every decision asked belongs to a file or template part that genuinely differed or is one of the two standing questions". If the legacy-or-none choice is a question to the pioneer, it fails the criterion on any project that has contracts, because it is neither a differing file nor a standing question; if it is not a question, the step 2 stub has nothing to stub. Here it was moot only because contract-001 already carried both fields.

2. **Step 7, endings.** "Kit files arrive with LF endings; instance files keep whatever endings they have — a mixed tree is expected and harmless." and, in the template rule, "each such part is refreshed from the staged template". Refreshing a CRLF instance file's header from an LF template does not keep its endings; nothing says to re-apply them. Same for "The `> **Map:**` header of a kept skill loses any id the staged template withdrew" — an in-place edit under Git Bash rewrote the kept file LF. This is T-1.

3. **Step 9, order.** "**Regenerate the baseline** (6j) … Offer the ratification pass … on a deferral add the line `ratification: deferred` inside the map's header comment". The baseline is written before the deferral edits MAP.md, so the baseline's MAP.md hash is stale the moment the step ends. Harmless because MAP.md is an instance file the classification never replaces, but the step does not say so, and a reader checking the baseline will find a mismatch.

4. **Step 3, unlisted files.** "A kit file the old baseline never listed because its pattern did not cover it (`walk.expected` before 0.15) is untouched, not evolved". `templates/settings.template.json` is the same case (the 0.14 pattern had no `*.json`) and is not named; I applied the rule to it.

5. **Step 7, the kept header.** "The `> **Map:**` header of a kept skill loses any id the staged template withdrew from the map." The header line also carries the "Recognise it by" clause, which in this file still names REBUILD.yaml. The rule removes the id and is silent on the rest of the line — so the header is left half-pointing at the withdrawn thing.

6. **Step 5, the settings merge.** "the settings merge — **replacing** the hook groups whose `"_kit"` key marks them". When the groups are identical, the only effect is that the file takes the template's line endings. Not wrong; unstated.

7. **Step 2, the report's provenance.** "the step 9 report, whose lists of what was taken, ported, removed and migrated come from the step 3 classification and the step 7 edits, not from a diff of the tree" — followed; but the rehearsal step also says to "Discard the copy", which in this run cannot be done by the agent (the copy is the working folder the pioneer provided).

Everything else — the leading-`*` handling, the CRLF-added hash rule, the classification vocabulary, the stale-list shape, the hook expectations on an upgrade ("the backlog and the gate's task reflect the project's live records … the staged-kit line prints until the folder is removed at the end") — read as written and matched what happened.

---

## 5. State after the upgrade

**MAP.md M-16 and M-17:**
```
M-16 | review-due | hook: Stop | must | the stop-gate says pioneer-owned items wait, no batch open | — | agent: kit-batch-assembler, then meta-skill-builder → Review Batch | proposed
M-17 | batch-decided | hook: Stop | must | every item in the open batch carries a decision | — | script: close-batch.sh, then reveal-key.sh; meta-skill-builder → Reveal | proposed
```
M-31 is gone (0 matches). Header comment ends with `ratification: deferred`.

**MANIFEST.yaml base-casebook node (line 45):**
```
- {id: base-casebook, concern: Binding precedents with their facts, scenario cards, reconstruction tests, kind: record, skill_file: meta-casebook/SKILL.md, data_file: meta-casebook/CASEBOOK.yaml, owns: [meta-casebook/CASEBOOK.yaml, meta-casebook/reconstruction/, meta-casebook/SKILL.md], layer: meta, phase: [pre-build, post-build], load: trigger, triggers: [M-04, M-05, M-26], status: thin, dependencies: [base-correction-log], open_gaps: []}
```
`base_kit_version: 0.15`; `agent-batch-assembler` registered at line 51 with its coverage line at 121; no `canary` anywhere in the file.

**Kept meta-casebook/SKILL.md header (line 6):**
```
> **Map:** M-04, M-05, M-26 · **Load:** retrieved on trigger by moment tag · **Recognise it by:** "we have decided a situation like this before" — or the milestone in REBUILD.yaml has been reached · **Not when:** the question is what the rule says (that is the node) rather than how it was applied
```

---

## 6. Closing checks

- `.claude/kit-incoming/` — **gone** (removed on report acceptance; session-start no longer prints the staged-kit line).
- `tests/walk.sh` in the upgraded project — **passes**: "walk: all 36 states match walk.expected", run after the upgrade and again after the folder removal.
- `checks/G1-size.sh` — passes.
- Final tree: 8 agents (deployed and kit copy), 16 skill folders, 12 hooks, 1 check, `walk.sh` + `walk.expected`, 10 templates, `INSTALLED.sha1` (68 lines), `telemetry.log` created by the hook runs, `batches/` and `reconstruction/` present, no `kit-sealed/` yet (the assembler creates it at the first batch).

Before-copies used for the diffs above lived in `.upgrade-tmp/` inside this folder and were deleted after this report was written.
