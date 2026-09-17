# Upgrade rehearsal — fx014, base kit 0.14 → 0.15

Run on 2026-09-13 in the throwaway copy `round2/fx014`, following the STAGED kit's `meta-bootstrap/SKILL.md` → *Upgrading an Existing Install*, steps 1–9, with the pioneer's answers stubbed as step 2 says (*keep* for every differing file or template part, *remove* for the stale list, *yes* to removing `.claude/kit-incoming/`). Moment: M-27.

## 1. The three numbers

**Decisions asked: 2**

1. The stale-list question (step 3): remove `agents/kit-canary-author.md` (both copies), `meta-mechanisms/hooks/reveal-canaries.sh`, `templates/REBUILD.template.yaml`? — stubbed *remove*.
2. Remove `.claude/kit-incoming/` at the end (step 9)? — stubbed *yes*.

No per-file question was asked: no kit file had evolved here (see the second number). The pioneer-may-name-contracts question in step 7 did not arise: contract-001 already carried `verification_state: none` and `audited: false`, so nothing was set to `legacy` there.

Note on the pass criterion: step 2 says the rehearsal passes only when "every decision asked belongs to a file or template part that genuinely differed or is the one stale-list question". Decision 2 is neither, yet step 2 itself lists "*yes* to removing `.claude/kit-incoming/`" among the stubbed answers. By the letter, no rehearsal that reaches step 9 can pass. Counted here as asked; see §4.

**Files that genuinely differed: 0**

Every one of the 70 files in the pre-0.15 baseline (`INSTALLED.sha1.prev`) matched once the step-3 line-ending tolerance was applied: 50 matched the hash of their content with CRLF endings added (the baseline had been taken over CRLF bytes; the files on disk are LF), 20 matched the hash of their CR-stripped content (the 15 `.sh` files, and the five instance files the install had written itself: CONTRACT-LOG, CORRECTIONS, FOUNDING, MANIFEST, MAP). No file was classified *evolved here*.

**Troubleshooting steps: 1**

1. Step 3 says "recompute the baseline with the 6j command into a temporary file and compare it line by line with `meta-manifest/INSTALLED.sha1`". The pre-0.15 baseline in this project was written by the 0.14 command (`xargs -0 sha1sum`), which on Git for Windows writes each line as `<hash> *<path>` (binary-mode marker). The 0.15 command writes `<hash>  <path>`. A literal line-by-line comparison differs on every line, hash or no hash. I had to strip the `*` (parse hash and path separately) before any file could be classified. Without that, all 70 files would have read as evolved and the upgrade would have asked 70 questions.

By the procedure's own rule ("the third number is zero; otherwise fix the procedure here, in this node, and rehearse again") this rehearsal does **not** pass. The fix belongs in the staged `meta-bootstrap/SKILL.md` step 3 (tolerate the `*` marker of pre-0.15 baselines), not in this copy.

**Agent execution slips corrected during the rehearsal: 1** (kept apart from the three numbers so the pioneer can count it if they choose; counted, the third number is 2)

- Step 7, MAP.md: my first awk pass split each entry on `" | "` as a regex (space-or-space), which shredded every line. The verification diff against the staged template caught it; I restored MAP.md from the pre-migration copy and redid the migration with a literal separator. The procedure was not at fault.

## 2. The classification presented (step 3, before anything changed)

Baseline: 70 files in `INSTALLED.sha1.prev`; every one on disk; none on disk missing from the baseline.

**Untouched here — 70 of 70** (hash matches the baseline with CR tolerance) → take the staged version, no question:

- agents (deployed and kit copy, 8 each): kit-canary-author, kit-case-clerk, kit-consolidator, kit-map-steward, kit-reconstructor, kit-recorder, kit-session-auditor, kit-verifier
- skills: meta-antidrift, meta-antidrift-expand, meta-bootstrap, meta-casebook, meta-contract-artifact, meta-contract-before-execution, meta-correction-log, meta-drift-eventlog, meta-extract, meta-foundation (SKILL.md and INTENT.md), meta-founding-contract, meta-learning, meta-ledger, meta-manifest, meta-map, meta-mechanisms, meta-skill-builder
- hooks (13): batch-blind, close-batch, deny-paths, lib, owner-check, post-read, prompt-submit, reveal-canaries, session-start, stop-gate, subagent-stop, write-scope; tests: walk.sh, walk-004.sh, fixtures/make-T-2.sh, results/T-2-2026-09-12.md, results/T-7-2026-09-12.md
- templates (10): CASEBOOK, CONTRACT-LOG, CORRECTIONS, DRIFTLOG, FOUNDING, LEARNINGLOG, LEDGER, MANIFEST, MAP, REBUILD
- instance files (in the baseline but never replaced): CASEBOOK.yaml, CONTRACT-LOG.yaml, CORRECTIONS.yaml, DRIFTLOG.yaml, FOUNDING.md, LEARNINGLOG.yaml, LEDGER.yaml, MANIFEST.yaml, MAP.md

Of the 61 kit files in the baseline, 33 differ in content from the staged kit, 24 are identical to it, and 4 are the stale ones below (see §3 for which).

**Evolved here — none.**

**New in the kit — 5** → add: `agents/kit-batch-assembler.md`, `meta-mechanisms/hooks/reveal-key.sh`, `meta-mechanisms/checks/G1-size.sh`, `meta-mechanisms/tests/walk-007.sh`, `meta-mechanisms/tests/fixtures/make-upgrade-fixtures.sh`.
Present in the staged folder but not "the kit" by its own definition, therefore not added: `meta-mechanisms/checks/P-004.sh … P-007.sh`, everything under `meta-mechanisms/tests/results/` (T-1-T-3, T-10 and their fixture trees), and the base kit's own instance files (its manifest, map, logs, ledger, corrections, casebook, founding file).

**Stale — present here, absent from the staged kit — 3 (4 copies)** → one question, stubbed *remove*:

| Stale file | Kept files that still referred to it at the time of the question |
|---|---|
| `agents/kit-canary-author.md` (`.claude/agents/` and `.claude/skills/agents/`) | `MANIFEST.yaml` (node `agent-canary-author`, its coverage line), `MAP.md` (M-16), `LEDGER.yaml` (header comment: "batches — kit-canary-author") |
| `meta-mechanisms/hooks/reveal-canaries.sh` | `MAP.md` (M-17) |
| `templates/REBUILD.template.yaml` | `MANIFEST.yaml` (`base-casebook` owns `meta-casebook/REBUILD.yaml`, trigger M-31), `MAP.md` (M-31) |

All seven referring lines are template-written parts that step 7 refreshes; after step 7 nothing kept refers to any stale file (verified by grep). `settings.json`, `CLAUDE.md`, `.gitignore`, `.gitattributes` never referred to them.

Template-rule preconditions, checked mechanically before step 7: MAP.md equalled the installed template with the project name substituted; MANIFEST.yaml equalled the installed template with placeholders filled and the `__INHERITED` comment lines dropped; the header comment blocks of CONTRACT-LOG.yaml and CORRECTIONS.yaml equalled the installed template's; LEDGER.yaml, DRIFTLOG.yaml, LEARNINGLOG.yaml and CASEBOOK.yaml equalled their installed templates byte for byte; FOUNDING.md equalled the installed template with name, date and statement filled. So every template-written part "still reads as the installed template wrote it" and takes the staged template's text.

## 3. Every migration applied, file by file

### Step 5 — install

- **Folders created:** `meta-ledger/batches/`, `meta-casebook/reconstruction/` (5e — the copy lacked them), `meta-mechanisms/checks/`.
- **Skills taken from the staged kit (content differs from installed):** meta-bootstrap, meta-casebook, meta-contract-before-execution, meta-correction-log, meta-drift-eventlog, meta-extract, meta-foundation/INTENT.md, meta-ledger, meta-manifest, meta-map, meta-mechanisms, meta-skill-builder. Unchanged in 0.15 and left as they were: meta-antidrift, meta-antidrift-expand, meta-contract-artifact, meta-foundation/SKILL.md, meta-founding-contract, meta-learning.
- **Agents** deployed to `.claude/agents/` and kept under `.claude/skills/agents/`: kit-batch-assembler (new); kit-case-clerk, kit-consolidator, kit-map-steward, kit-recorder, kit-verifier (changed); kit-reconstructor, kit-session-auditor (same content). **Removed:** kit-canary-author.md from both places.
- **Hooks:** reveal-key.sh (new); batch-blind, owner-check, session-start, stop-gate (changed); close-batch, deny-paths, lib, post-read, prompt-submit, subagent-stop, write-scope (same). **Removed:** reveal-canaries.sh.
- **Tests:** walk-007.sh, fixtures/make-upgrade-fixtures.sh (new); walk.sh, walk-004.sh, walk.expected (changed); fixtures/make-T-2.sh (same). `tests/results/` not copied; the three result files the 0.14 install left (T-2, T-7, contract-004-tiers.sha1) left in place — see §4.
- **Checks:** G1-size.sh (new). P-004…P-007 not copied.
- **Templates:** CONTRACT-LOG, CORRECTIONS, LEDGER, MANIFEST, MAP (changed); CASEBOOK, DRIFTLOG, FOUNDING, LEARNINGLOG, settings (same). **Removed:** REBUILD.template.yaml.
- **settings.json:** every hook group carried `"_kit": "base-building-kit"` and there were no non-kit entries, so the merge (replace each kit group, keep the deny) yields the staged template exactly; content identical to what was there (see §4 for an unexplained plain-diff difference before the replacement).
- **CLAUDE.md:** block between the `kit-block` markers replaced by the staged 5a block — identical text, file byte-unchanged.
- **.gitignore / .gitattributes:** already carried `.claude/kit-sealed/` and `*.sh text eol=lf`; unchanged.

### Step 6 — seed

Nothing: every instance file existed, including FOUNDING.md.

### Step 7 — additive migrations (diff summaries; full diffs were verified against the staged templates)

**CONTRACT-LOG.yaml**
- Header comment block refreshed from the staged template: `approval: gate` → `approval: approved-at-gate … ; \`gate\` on entries from before 0.15, left as is`; `disappointment:` and `premortem:` schema lines added after `tier_3`; `tier_4` description reworded ("derived from the disappointment lines… legible to the pioneer"); `red_test:` schema line added; `verification_state` enumeration gains `closed-by-follow-up`; `corrections_from_tests` / `corrections_from_reading` added under `verification`; `cost:` schema line added before `work_id`.
- contract-001: `+ disappointment: legacy`, `+ premortem: legacy`, `+ red_test: legacy` (after `tier_3`, where the template places them; the entry has no `tier_4`), `+ cost: legacy` (after `revisions`). `approval: gate`, `verification_state: none`, `audited: false` kept as they were.

**CORRECTIONS.yaml**
- Header: `noticed`, `would_have_been_right`, `seen_before` schema lines added after `reason_given`.
- C-001: `+ noticed: not asked`, `+ would_have_been_right: not asked`, `+ seen_before: not asked` (after `reason_given`).

**LEDGER.yaml**
- Header: "THE ONE WRITER LIST (contract-007 G-8)" line added; observations writer list gains "(or kit-recorder while a batch is open)"; batches writer `kit-canary-author` → `kit-batch-assembler`; `evidence_refs` and `helpful` comments extended; `lower_bound` schema line removed; `outcome` comment → `{resolved, held: true | false | unobserved}`; batch `canaries` / `canaries_caught` → `represented: []`; scores `contracts` comment extended, `canary_catch_rate` / `brier_stated_confidence` / `brier_pioneer_decisions` → `coincidence: []`.
- Data: under `scores`, `- canary_catch_rate: null`, `- brier_stated_confidence: null`, `- brier_pioneer_decisions: null`, `+ coincidence: []`. No batches (nothing to give `represented: []`), no candidates (no `lower_bound` to remove). The file now equals the staged template byte for byte, which is the expected result for an empty ledger.

**DRIFTLOG.yaml, LEARNINGLOG.yaml, CASEBOOK.yaml, FOUNDING.md** — untouched (no entries; templates identical in 0.14 and 0.15; FOUNDING.md is never touched).

**MANIFEST.yaml**
- `base_kit_version: 0.14` → `0.15`.
- `base-skill-builder` concern: "…verdict before evidence, canaries, adoption…" → "…verdict before evidence, re-presented items, adoption…".
- `base-casebook`: `owns` drops `meta-casebook/REBUILD.yaml`; `triggers` `[M-04, M-05, M-26, M-31]` → `[M-04, M-05, M-26]`.
- `base-mechanisms`: `triggers` gain `M-07` (`[M-01, M-02, M-07, M-11, …]`).
- `agent-consolidator` concern: "independence-aware counters, lower bounds, fading, outcomes, scores" → "counters by reading, fading, outcomes, scores that never score the pioneer".
- `agent-canary-author` node line → `agent-batch-assembler` (staged template's line, same position): concern "Assembles review batches from real items, re-presents decided ones from the fourth batch on, and seals the key", `agent_file: agents/kit-batch-assembler.md`.
- Coverage: `base-ledger` "Evidence, candidates, canaries and maturity instruments" → "Evidence, candidates, re-presented items and maturity instruments"; `agent-canary-author` "Gate instrumentation — canaries" → `agent-batch-assembler` "Review batch assembly and re-presented items".
- `kind`, `load`, `triggers` and `owns` were already present on every node; nothing added there. Header comment unchanged (identical in both templates). Result equals the staged template with placeholders filled.

**MAP.md**
- 29 base entries refreshed to the staged template's columns, each keeping its own status (all `proposed`). Lines whose text changed: M-03 (not-when "a moment with a clear entry (M-20 records the miss)", load "meta-foundation"); M-28 (not-when "a session-level analysis (M-19)", load "INTENT.md → Close every output with this block; meta-antidrift → The Drift Score Block"); M-24 (type "situation + hook: Stop"); M-29 (load "LEDGER.yaml → candidates; meta-ledger → Candidates"); M-08 (not-when "…; an unauthorised one is drift (M-18)", load "meta-contract-before-execution → The Approval Gate"); M-09 (load "INTENT.md → The agent holds five aspects"); M-10 (load "meta-antidrift → Scoring Rules"); M-23 (not-when "a node change (M-22)", load "meta-manifest → How to Read the Manifest"); M-16 (load "agent: kit-batch-assembler, then meta-skill-builder → Review Batch"); M-17 (load "script: close-batch.sh, then reveal-key.sh; meta-skill-builder → Reveal"). The other 19 entries are textually identical in both templates.
- M-31 `launch-rebuild` removed (withdrawn by the staged template; not reworded here).
- Header comment unchanged (identical in both templates). Result equals the staged template with the project name; 6,966 bytes, 30 entries; G1-size passes.

### Step 8 — no non-base nodes; nothing to map.

### Step 9 — baseline, checks, hooks, removal

- `INSTALLED.sha1` regenerated with the 6j command: 72 files (70 before − 4 removed + 6 added). Difference to `.prev`: added 6 (kit-batch-assembler ×2, reveal-key.sh, G1-size.sh, walk-007.sh, make-upgrade-fixtures.sh); removed 4 (kit-canary-author ×2, reveal-canaries.sh, REBUILD.template.yaml); hash changed 57 — of which 38 by content (33 kit files taken with new text, 5 instance files migrated) and 19 only because the old baseline hashed CRLF bytes and the new one strips CR (kit-reconstructor ×2, kit-session-auditor ×2, meta-antidrift, meta-antidrift-expand, meta-contract-artifact, meta-foundation/SKILL.md, meta-founding-contract/SKILL.md, meta-learning/SKILL.md, CASEBOOK.yaml, DRIFTLOG.yaml, LEARNINGLOG.yaml, results/T-2, results/T-7, and the CASEBOOK, DRIFTLOG, FOUNDING, LEARNINGLOG templates); unchanged 9 (FOUNDING.md; hooks close-batch, deny-paths, lib, post-read, prompt-submit, subagent-stop, write-scope; tests/fixtures/make-T-2.sh — all LF at baseline time and identical in 0.15). 6 + 4 + 57 + 9 checks: 70 old entries = 57 + 9 + 4; 72 new = 57 + 9 + 6. `INSTALLED.sha1.prev` kept for the pioneer; the procedure says it is deleted once the report is accepted.
- Checks: `G1-size.sh` exit 0.
- Hook commands (CLAUDE_PROJECT_DIR set): session-start → valid JSON (backlog: 1 contract unaudited, 1 unverified, 1 correction unclerked, pioneer-owned items waiting, and — because the hooks run before the staged folder is removed — the "newer kit is staged" line); prompt-submit → valid JSON; stop-gate → valid JSON (hands over M-11 for contract-001); subagent-stop, post-read, owner-check, batch-blind, deny-paths → nothing; write-scope → valid JSON deny; close-batch.sh B-001 and reveal-key.sh B-001 → "No batch file", exit 1, as documented. `telemetry.log` gained `loaded|meta-map/MAP.md` and `bypass|base-casebook|meta-casebook/CASEBOOK.yaml`.
- Informational, not required by step 9 — the shipped walks: `walk.sh` all 36 states match; `walk-004.sh` 49 pass / 2 fail (77 `docs/rebuild-design.md` — a base-repo doc not shipped; 79 greps `REBUILD` in meta-bootstrap/SKILL.md and now hits the staged bootstrap's own stale-file example); `walk-007.sh` 27 pass / 5 fail (103 expects `mitigation_medium: mechanism` in the base kit's DRIFTLOG; 105 expects the *base* manifest's `version: 0.15`, whereas a project manifest carries its own `version: 0.1`; 112a/c/d README and docs/readme-review.md — base-repo files). None is a project defect.
- `.claude/kit-incoming/` removed (stubbed *yes*).

## 4. What in the procedure was unclear, wrong or missing — as hit

1. **Step 3, "compare it line by line with `meta-manifest/INSTALLED.sha1`"** — wrong for a pre-0.15 baseline written on Windows: the 0.14 command's `sha1sum` output carries `*` before each path; the 6j command's does not. Every line differs before any hash is looked at. (Troubleshooting step 1.)

2. **Step 2, the pass criterion vs the stub list** — "*yes* to removing `.claude/kit-incoming/` at the end" is a stubbed answer, so it is a decision asked; the criterion "every decision asked belongs to a file or template part that genuinely differed or is the one stale-list question" leaves no room for it. Either the criterion should read "…or the one stale-list question or the final removal", or the removal should not count as a decision. As written, the rehearsal cannot pass.

3. **"What 'the kit' is" vs the stale rule** — `tests/results/` is excluded from the kit, and the install (6h) deletes it, but the upgrade's classification only calls a file stale when it is "present here, absent from the staged kit". The three results files a 0.14 install left behind (`T-2-2026-09-12.md`, `T-7-2026-09-12.md`, `contract-004-tiers.sha1`) are present in the staged folder too, so they are neither stale nor kit. Left in place; the procedure should say whether an upgrade removes them.

4. **Step 7, CONTRACT-LOG** — "every existing entry gains … `disappointment: legacy`, `premortem: legacy`, `red_test: legacy`, `cost: legacy` if absent" does not say where in the entry. I used the template's order (after `tier_3`; `cost` after `revisions`). Any position is schema-valid, but two upgrades could disagree.

5. **Step 9, the hook run and the staged folder** — the Step 7 hook commands are run before `.claude/kit-incoming/` is removed, so `session-start.sh` still prints "A newer kit is staged … rehearse on a copy first". Expected from the order of operations, but the sentence "the expectation is only that each script prints valid JSON or nothing and that `telemetry.log` gains its `loaded` line" could say so.

6. **Step 9, "run every check under `meta-mechanisms/checks/`"** — after install that is `G1-size.sh` alone (P-NNN are excluded). Fine, but the walks under `tests/`, which `meta-mechanisms/SKILL.md` says "every one of them exits non-zero on a failure", fail in a project for base-repo reasons (docs, README, the base manifest's version, the base drift log). Either the walks should be project-safe or the kit should say they are base-repo tests.

7. **`settings.json` before the merge** — a plain `diff` against the staged template reported every line different, `diff --strip-trailing-cr` reported them identical, and a grep for carriage returns found none in either file. I replaced the file per the merge rule (the result is the template, since only kit groups existed); the cause of the plain-diff difference was not determined. Not counted as troubleshooting — nothing had to be done for the procedure to proceed — but it is an unexplained observation.

8. **Line endings generally** — this copy is LF throughout, including the hooks; the baseline had been taken over CRLF bytes for the .md/.yaml files, which is exactly the case step 3's tolerance covers, and it covered it. Nothing to fix; recorded because the first two checks I ran for CR disagreed with each other, and `od -c` output is not a reliable CR counter under Git Bash.

## 5. State after the upgrade

**MAP.md, M-16 and M-17 (verbatim):**

```
M-16 | review-due | hook: Stop | must | the stop-gate says pioneer-owned items wait, no batch open | — | agent: kit-batch-assembler, then meta-skill-builder → Review Batch | proposed
M-17 | batch-decided | hook: Stop | must | every item in the open batch carries a decision | — | script: close-batch.sh, then reveal-key.sh; meta-skill-builder → Reveal | proposed
```

No line in MAP.md mentions M-31, `REBUILD`, `kit-canary-author` or `reveal-canaries`. 30 entries, 6,966 bytes.

**MANIFEST.yaml, `base-casebook` node and coverage line (verbatim):**

```
  - {id: base-casebook, concern: Binding precedents with their facts, scenario cards, reconstruction tests, kind: record, skill_file: meta-casebook/SKILL.md, data_file: meta-casebook/CASEBOOK.yaml, owns: [meta-casebook/CASEBOOK.yaml, meta-casebook/reconstruction/, meta-casebook/SKILL.md], layer: meta, phase: [pre-build, post-build], load: trigger, triggers: [M-04, M-05, M-26], status: thin, dependencies: [base-correction-log], open_gaps: []}
  - {concern: Binding precedents and reconstruction, node_id: base-casebook, layer: meta, phase: [pre-build, post-build], status: thin}
```

`base_kit_version: 0.15`. No node or coverage line names `agent-canary-author`; `agent-batch-assembler` is registered in its place.

**Left in the project on purpose:** `INSTALLED.sha1.prev` (until the report is accepted), `meta-ledger/telemetry.log` (written by the step-9 hook run), the three 0.14-era `tests/results/` files (§4 item 3).

## Appendix — the action log kept during the rehearsal (verbatim)

```
# Upgrade rehearsal log — fx014 — 2026-09-13T14:32:58Z
step 1: installed base_kit_version 0.14, staged version 0.15 -> upgrade proceeds
step 2: INSTALLED.sha1 copied to INSTALLED.sha1.prev
step 3: classification — untouched: every kit file in the baseline (70/70, all matched once CR handling allowed); evolved: none; new: agents/kit-batch-assembler.md, hooks/reveal-key.sh, checks/G1-size.sh, tests/walk-007.sh, tests/fixtures/make-upgrade-fixtures.sh; stale: agents/kit-canary-author.md (both copies), hooks/reveal-canaries.sh, templates/REBUILD.template.yaml
step 3: stubbed answer to the one stale-list question: remove
step 4: no new node with an instance file; nothing to seed
--- step 5 install ---
5: created folders meta-ledger/batches/, meta-casebook/reconstruction/ (5e — the copy lacked them), meta-mechanisms/checks/
5: TAKEN staged meta-bootstrap/SKILL.md (untouched here, differed)
5: TAKEN staged meta-casebook/SKILL.md (untouched here, differed)
5: TAKEN staged meta-contract-before-execution/SKILL.md (untouched here, differed)
5: TAKEN staged meta-correction-log/SKILL.md (untouched here, differed)
5: TAKEN staged meta-drift-eventlog/SKILL.md (untouched here, differed)
5: TAKEN staged meta-extract/SKILL.md (untouched here, differed)
5: TAKEN staged meta-foundation/INTENT.md (untouched here, differed)
5: TAKEN staged meta-ledger/SKILL.md (untouched here, differed)
5: TAKEN staged meta-manifest/SKILL.md (untouched here, differed)
5: TAKEN staged meta-map/SKILL.md (untouched here, differed)
5: TAKEN staged meta-mechanisms/SKILL.md (untouched here, differed)
5: TAKEN staged meta-skill-builder/SKILL.md (untouched here, differed)
5: unchanged in staged kit, left as is: meta-antidrift/SKILL.md
5: unchanged in staged kit, left as is: meta-antidrift-expand/SKILL.md
5: unchanged in staged kit, left as is: meta-contract-artifact/SKILL.md
5: unchanged in staged kit, left as is: meta-foundation/SKILL.md
5: unchanged in staged kit, left as is: meta-founding-contract/SKILL.md
5: unchanged in staged kit, left as is: meta-learning/SKILL.md
5: agents deployed to .claude/agents/ and kept under .claude/skills/agents/: batch-assembler (NEW), case-clerk, consolidator, map-steward, recorder, verifier (differed); reconstructor, session-auditor (same content)
5: REMOVED stale agents/kit-canary-author.md from .claude/agents/ and .claude/skills/agents/
5: hooks installed: reveal-key.sh (NEW); batch-blind, owner-check, session-start, stop-gate (differed); the rest same content
5: REMOVED stale hooks/reveal-canaries.sh
5: tests installed: walk-007.sh, fixtures/make-upgrade-fixtures.sh (NEW); walk.sh, walk-004.sh, walk.expected (differed); fixtures/make-T-2.sh same. tests/results/ NOT copied (base kit evidence)
5: checks installed: G1-size.sh (NEW). P-004..P-007.sh NOT copied (base kit precedents)
5: templates installed: CONTRACT-LOG, CORRECTIONS, LEDGER, MANIFEST, MAP (differed); CASEBOOK, DRIFTLOG, FOUNDING, LEARNINGLOG, settings (same)
5: REMOVED stale templates/REBUILD.template.yaml
5: settings.json — kit hook groups (SessionStart, UserPromptSubmit, Stop, SubagentStop, PreToolUse, PostToolUse x2) replaced by the staged groups; deny Read(kit-sealed/**) kept; content unchanged (line endings CRLF->LF only)
5: CLAUDE.md kit block replaced between markers — identical text, file unchanged
5: .gitignore and .gitattributes already carry the 5d entries
--- step 6 ---
6: every instance file present; nothing seeded; checks/ exists
--- step 7 migrate ---
7: CONTRACT-LOG.yaml — header comment block refreshed from the staged template; contract-001 gained disappointment: legacy, premortem: legacy, red_test: legacy, cost: legacy; verification_state: none and audited: false were present and kept; approval: gate kept
7: CORRECTIONS.yaml — header comment block refreshed from the staged template; C-001 gained noticed: not asked, would_have_been_right: not asked, seen_before: not asked
7: LEDGER.yaml — header comment block refreshed from the staged template; scores: canary_catch_rate, brier_stated_confidence, brier_pioneer_decisions removed, coincidence: [] added; no batches (represented) and no candidates (lower_bound) to migrate
7: DRIFTLOG.yaml — no entries; template unchanged between 0.14 and 0.15; untouched
7: MANIFEST.yaml — base_kit_version 0.14 -> 0.15; agent-canary-author node line and coverage line replaced by agent-batch-assembler (staged template lines, same position); base node lines refreshed from the staged template (base-skill-builder concern; base-casebook owns and triggers drop REBUILD.yaml and M-31; base-mechanisms triggers gain M-07; agent-consolidator concern); base-ledger coverage line refreshed; kind, load, triggers and owns were already present on every node
7: MAP.md — 29 base entries refreshed to the staged template columns, each keeping its own status (all proposed); M-31 launch-rebuild removed (withdrawn by the staged template, not reworded here); header comment unchanged between 0.14 and 0.15
7: header comment blocks — CONTRACT-LOG, CORRECTIONS, LEDGER refreshed; DRIFTLOG, LEARNINGLOG, CASEBOOK, MANIFEST, MAP headers identical in both templates; FOUNDING.md never touched
--- step 8 ---
8: no non-base nodes in the manifest; nothing to map
7: MAP.md — first attempt mangled the lines (agent awk error: split separator read as a regex); restored from the pre-migration copy and redone with a literal separator; verified against the staged template
--- step 9 ---
9: baseline regenerated with the 6j command: 72 files
9: check G1-size.sh exit 0 
9: hook session-start exit 0 -> valid JSON
9: hook prompt-submit exit 0 -> valid JSON
9: hook stop-gate exit 0 -> valid JSON
9: hook subagent-stop exit 0 -> (nothing)
9: hook post-read exit 0 -> (nothing)
9: hook owner-check exit 0 -> (nothing)
9: hook batch-blind exit 0 -> (nothing)
9: hook deny-paths exit 0 -> (nothing)
9: hook write-scope exit 0 -> valid JSON
9: close-batch.sh B-001 exit 1 -> No batch file at <session scratchpad>/round2/fx014/.claude/skills/meta-ledger/batches/B-001.md
9: reveal-key.sh B-001 exit 1 -> No batch file at <session scratchpad>/round2/fx014/.claude/skills/meta-ledger/batches/B-001.md
2026-09-13T14:36:19Z|subagent|kit-verifier
2026-09-13T14:36:20Z|loaded|meta-map/MAP.md
2026-09-13T14:36:20Z|bypass|base-casebook|meta-casebook/CASEBOOK.yaml
9: .claude/kit-incoming/ removed (stubbed answer: yes)
```

Correction to the log: the line "settings.json — … content unchanged (line endings CRLF->LF only)" states a cause I could not confirm afterwards; see §4 item 7. Everything else in the log stands.

### Baseline difference, INSTALLED.sha1.prev → INSTALLED.sha1 (step 9)

```
ADDED .claude/agents/kit-batch-assembler.md
ADDED .claude/skills/agents/kit-batch-assembler.md
ADDED .claude/skills/meta-mechanisms/checks/G1-size.sh
ADDED .claude/skills/meta-mechanisms/hooks/reveal-key.sh
ADDED .claude/skills/meta-mechanisms/tests/fixtures/make-upgrade-fixtures.sh
ADDED .claude/skills/meta-mechanisms/tests/walk-007.sh
CHANGED .claude/agents/kit-case-clerk.md
CHANGED .claude/agents/kit-consolidator.md
CHANGED .claude/agents/kit-map-steward.md
CHANGED .claude/agents/kit-reconstructor.md
CHANGED .claude/agents/kit-recorder.md
CHANGED .claude/agents/kit-session-auditor.md
CHANGED .claude/agents/kit-verifier.md
CHANGED .claude/skills/agents/kit-case-clerk.md
CHANGED .claude/skills/agents/kit-consolidator.md
CHANGED .claude/skills/agents/kit-map-steward.md
CHANGED .claude/skills/agents/kit-reconstructor.md
CHANGED .claude/skills/agents/kit-recorder.md
CHANGED .claude/skills/agents/kit-session-auditor.md
CHANGED .claude/skills/agents/kit-verifier.md
CHANGED .claude/skills/meta-antidrift-expand/SKILL.md
CHANGED .claude/skills/meta-antidrift/SKILL.md
CHANGED .claude/skills/meta-bootstrap/SKILL.md
CHANGED .claude/skills/meta-casebook/CASEBOOK.yaml
CHANGED .claude/skills/meta-casebook/SKILL.md
CHANGED .claude/skills/meta-contract-artifact/SKILL.md
CHANGED .claude/skills/meta-contract-before-execution/CONTRACT-LOG.yaml
CHANGED .claude/skills/meta-contract-before-execution/SKILL.md
CHANGED .claude/skills/meta-correction-log/CORRECTIONS.yaml
CHANGED .claude/skills/meta-correction-log/SKILL.md
CHANGED .claude/skills/meta-drift-eventlog/DRIFTLOG.yaml
CHANGED .claude/skills/meta-drift-eventlog/SKILL.md
CHANGED .claude/skills/meta-extract/SKILL.md
CHANGED .claude/skills/meta-foundation/INTENT.md
CHANGED .claude/skills/meta-foundation/SKILL.md
CHANGED .claude/skills/meta-founding-contract/SKILL.md
CHANGED .claude/skills/meta-learning/LEARNINGLOG.yaml
CHANGED .claude/skills/meta-learning/SKILL.md
CHANGED .claude/skills/meta-ledger/LEDGER.yaml
CHANGED .claude/skills/meta-ledger/SKILL.md
CHANGED .claude/skills/meta-manifest/MANIFEST.yaml
CHANGED .claude/skills/meta-manifest/SKILL.md
CHANGED .claude/skills/meta-map/MAP.md
CHANGED .claude/skills/meta-map/SKILL.md
CHANGED .claude/skills/meta-mechanisms/SKILL.md
CHANGED .claude/skills/meta-mechanisms/hooks/batch-blind.sh
CHANGED .claude/skills/meta-mechanisms/hooks/owner-check.sh
CHANGED .claude/skills/meta-mechanisms/hooks/session-start.sh
CHANGED .claude/skills/meta-mechanisms/hooks/stop-gate.sh
CHANGED .claude/skills/meta-mechanisms/tests/results/T-2-2026-09-12.md
CHANGED .claude/skills/meta-mechanisms/tests/results/T-7-2026-09-12.md
CHANGED .claude/skills/meta-mechanisms/tests/walk-004.sh
CHANGED .claude/skills/meta-mechanisms/tests/walk.sh
CHANGED .claude/skills/meta-skill-builder/SKILL.md
CHANGED .claude/skills/templates/CASEBOOK.template.yaml
CHANGED .claude/skills/templates/CONTRACT-LOG.template.yaml
CHANGED .claude/skills/templates/CORRECTIONS.template.yaml
CHANGED .claude/skills/templates/DRIFTLOG.template.yaml
CHANGED .claude/skills/templates/FOUNDING.template.md
CHANGED .claude/skills/templates/LEARNINGLOG.template.yaml
CHANGED .claude/skills/templates/LEDGER.template.yaml
CHANGED .claude/skills/templates/MANIFEST.template.yaml
CHANGED .claude/skills/templates/MAP.template.md
REMOVED .claude/agents/kit-canary-author.md
REMOVED .claude/skills/agents/kit-canary-author.md
REMOVED .claude/skills/meta-mechanisms/hooks/reveal-canaries.sh
REMOVED .claude/skills/templates/REBUILD.template.yaml
same .claude/skills/meta-founding-contract/FOUNDING.md
same .claude/skills/meta-mechanisms/hooks/close-batch.sh
same .claude/skills/meta-mechanisms/hooks/deny-paths.sh
same .claude/skills/meta-mechanisms/hooks/lib.sh
same .claude/skills/meta-mechanisms/hooks/post-read.sh
same .claude/skills/meta-mechanisms/hooks/prompt-submit.sh
same .claude/skills/meta-mechanisms/hooks/subagent-stop.sh
same .claude/skills/meta-mechanisms/hooks/write-scope.sh
same .claude/skills/meta-mechanisms/tests/fixtures/make-T-2.sh
```
