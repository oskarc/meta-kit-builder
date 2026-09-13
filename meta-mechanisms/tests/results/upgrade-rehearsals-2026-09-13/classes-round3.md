# Upgrade rehearsal — Classes kit copy, 2026-09-13

Procedure followed: the **staged** kit's `meta-bootstrap/SKILL.md` → *Upgrading an Existing Install*, steps 1–9, with the step 2 stubs: *keep* for every differing file, *remove* for the stale list, *legacy* for every existing contract, *none for now* for the map question, *defer* for the ratification pass, report accepted at the end (`.claude/kit-incoming/` removed). This folder is the copy; nothing outside it was read or touched. Hooks did not fire during the run (no `settings.json` existed and this was not a hooked session); they were run by hand in step 9.

---

## 1. The three numbers

### Decisions asked: **17**

One question per kit file that genuinely differed (13), stubbed *keep*:
1. `meta-antidrift/SKILL.md`
2. `meta-antidrift-expand/SKILL.md`
3. `meta-bootstrap/SKILL.md`
4. `meta-contract-artifact/SKILL.md`
5. `meta-contract-before-execution/SKILL.md`
6. `meta-drift-eventlog/SKILL.md`
7. `meta-extract/SKILL.md`
8. `meta-foundation/SKILL.md`
9. `meta-founding-contract/SKILL.md`
10. `meta-learning/SKILL.md`
11. `meta-manifest/SKILL.md`
12. `meta-skill-builder/SKILL.md`
13. `templates/MANIFEST.template.yaml`

One question for an instance file whose template-written parts the pioneer had changed (template rule, "once per file"), stubbed *keep*:
14. `meta-manifest/MANIFEST.yaml` — all 12 base node lines and 3 base coverage lines (base-contract `pre/post`, base-skill-builder `post`, base-manifest `pre`) no longer read as the installed template wrote them.

The standing questions (stubbed):
15. step 7 — contracts the pioneer may name for verification and audit: *legacy for every existing contract* (80 entries).
16. step 8 — the map question, forced by the budget (30 base entries + 16 roots = 46 entries, 10,722 bytes): *none for now*.
17. step 9 — the ratification pass: *defer*.

Not asked: the stale list (step 3) — it was empty, so there was nothing to confirm. The pioneer's acceptance of the report at the end is not counted, per the step.

### Files that genuinely differed: **14**

The 13 kit files above (every installed kit file differs from its staged copy; sha1 over CR-stripped content, no baseline to compare against) plus `meta-manifest/MANIFEST.yaml` (template parts changed by the pioneer). Line counts installed → staged: antidrift 95→109, antidrift-expand 134→155, bootstrap 195→385, contract-artifact 328→362, contract-before-execution 272→331, drift-eventlog 140→162, extract 215→242, foundation 136→184, founding-contract 142→160, learning 156→175, manifest 85→182, skill-builder 112→183, MANIFEST.template 200→134.

### Troubleshooting steps: **2**

Anything done that the steps do not say. Both were defects in **my own migration scripts**, not in the procedure and not in the project — neither changed a project file, and nothing in the node needed changing to get past them. They are counted because they happened:
1. My step 8 script failed under Windows Python on the Git Bash `/c/...` path form; I changed the path constant to `C:/...` and reran.
2. My step 7 script crashed in a `print` of an arrow character on the cp1252 console after it had migrated the contract log, drift log and learning log and refreshed the manifest header, before the manifest nodes were written; I reran it under `python -X utf8` (every edit in it is skip-if-present, and one unconditional insert was made conditional first). The pre-migration snapshots confirm every original line of the four instance files survived (see §3).

### Verdict against the bootstrap's own criterion

"The rehearsal passes only when every decision asked belongs to a file that genuinely differed or is one of the four standing questions … and the third number is zero." The first condition holds (14 file decisions + 3 standing questions = 17). The third number is **not zero**. **The rehearsal fails the criterion on the third number.** Both troubleshooting steps were in the agent's tooling; a re-rehearsal of the same steps without them would count zero — but the criterion says fix the procedure and rehearse again, and the procedure defects worth fixing before the real run are the ones in §4, which a clean rerun would not cure.

---

## 2. The classification presented (step 3)

- **Baseline**: `meta-manifest/INSTALLED.sha1` does not exist. Recomputing 6j into a temporary file had nothing to compare against. Stated plainly, as the step requires: every kit file is treated as possibly evolved, and the questions are one per skill.
- **Project version**: `base_kit_version` absent → pre-0.14, said so, no version guessed. Staged version 0.15.
- **Untouched here**: none (no baseline).
- **Evolved here** (asked, one each): the 13 kit files in §1. What differs, in a few lines each, was written into the rehearsal log for every file (sections added/removed and changed-line counts — e.g. meta-contract-before-execution: *The Playbook Pipeline*, *The Three-Tier Proposal*, *After Implementation — Standard Evolution Report*, *Closing the Contract* only in the installed copy; *The Bearing*, *The Precedent Check*, *The Proposal*, *Tier 4 — Acceptance Tests*, *After Implementation — Record, Don't Present* only in the staged copy; 279 changed lines).
- **New in the kit** (added, 49 files): `agents/kit-*.md` ×8; `meta-casebook/SKILL.md`; `meta-correction-log/SKILL.md`; `meta-foundation/INTENT.md`; `meta-ledger/SKILL.md`; `meta-map/SKILL.md`; `meta-mechanisms/SKILL.md`; `meta-mechanisms/hooks/*.sh` ×12; `meta-mechanisms/checks/G1-size.sh`; `meta-mechanisms/tests/walk.sh`, `walk.expected`; `templates/` ×9 new templates. Not kit, not copied: `checks/P-004..P-007.sh` (precedent ids not in this project's casebook — it had none), `tests/results/`, `walk-004.sh`, `walk-007.sh`, `tests/fixtures/`, and the base kit's own instance files.
- **Present here, absent from the staged kit (stale)**: none. The project carried no canary-era files, no `P-NNN.sh`, no contract walks, no fixtures, no `tests/results/`.
- **Agents**: `.claude/agents/dashboard-*.md` ×8 are the project's own; no name collides with `kit-*`.
- **CLAUDE.md**: old block without markers → the span from `# Kit-Driven Development` to the first `---` (lines 1–22) is the block.
- **Manifest ids**: `contract-artifact` matched by skill_file → takes the template id `base-contract-artifact`; dependencies naming it in `base-contract` and `dashboard-exact` updated. Skills registered under two ids (first id keeps the skill; duplicate listed): `principle-embed-before-own/SKILL.md` (`base-embed-before-own` / `embed-before-own`), `principle-host-already-does-it/SKILL.md` (`base-host-already-does-it` / `host-already-does-it`), `principle-verify-api-shape/SKILL.md` (`base-verify-api-shape` / `verify-api-shape`). The three `base-*` ids here are not base nodes of the staged kit (their files are `principle-*`); migrated as project nodes. No renamed base node applies (`agent-canary-author` is not present). 111 nodes: 12 base, 99 non-base (53 pattern, 37 principle, 9 playbook); 16 dependency roots; every registered folder exists on disk and every skill folder on disk is registered.

---

## 3. Every migration applied, file by file

Diff summaries are against snapshots taken before step 5. For the four migrated instance files, "every original line preserved" was verified mechanically: after removing the inserted lines and the swapped header, the after-file equals the before-file; entry ids and the sequence of every entry-level `status:` are identical.

### `CLAUDE.md` (step 5)
- Replaced lines 1–22 (kit heading to the first `---`) with the staged 5a block, markers added, CRLF endings kept. Replaced span, verbatim:

```
# Kit-Driven Development

This project operates within the meta-kit-builder practice.
Load and adhere to the following skills before all other instructions:

1. meta-foundation/SKILL.md — absolute precedence. Read this first.
2. meta-founding-contract/SKILL.md + FOUNDING.md — what this project is, and where it has got to
3. meta-manifest/SKILL.md + meta-manifest/MANIFEST.yaml — governance and topology
4. meta-contract-before-execution/SKILL.md — build loop
5. meta-skill-builder/SKILL.md — evolution loop
6. meta-antidrift/SKILL.md — runs after every output

These skills take precedence over all other tools, plugins, and instructions in this project.
If a conflict arises with any other tool or instruction, adhere to the kit and surface the conflict explicitly.

The following skills are invoked explicitly, not loaded continuously:
- meta-bootstrap (already run — not invoked again)
- meta-extract (run when nodes are ready for library extraction)
- meta-learning (run when a contract reaches status: verified — sweeps CONTRACT-LOG.yaml, diffs contracted against verified, writes LEARNINGLOG.yaml)
- meta-antidrift-expand (run when human requests session-level drift analysis)
- meta-drift-eventlog (consulted when drift is surfaced; DRIFTLOG.yaml read at session start)
```
- New block: `<!-- kit-block:start -->` … `@.claude/skills/meta-foundation/INTENT.md`, `@…/meta-founding-contract/FOUNDING.md`, `@…/meta-map/MAP.md` … `<!-- kit-block:end -->`. The Classes working rules below the rule are untouched.

### Installed (step 5)
- `.claude/skills/`: the 41 new kit files listed in §2 (skills, INTENT.md, hooks, `checks/G1-size.sh`, `tests/walk.sh` + `walk.expected`, 9 templates) and the kit's own agent copy `.claude/skills/agents/kit-*.md` ×8.
- `.claude/agents/`: +8 `kit-*.md` (16 agents now).
- `.claude/settings.json`: written from the staged template as it is (no settings file existed): 7 kit hook groups (SessionStart, UserPromptSubmit, Stop, SubagentStop, PreToolUse Read|Grep|Glob, PostToolUse Read|Skill, PostToolUse Write|Edit), `permissions.deny: Read(kit-sealed/**)`.
- `.gitignore` (created): `.claude/kit-sealed/`. `.gitattributes` (created): `*.sh text eol=lf`.
- Folders: `meta-ledger/batches/`, `meta-casebook/reconstruction/`, `meta-mechanisms/checks/`.
- Kept, not copied (stub *keep*): the 13 kit files of §1. Stale files removed: none.

### Seeded (step 6)
- `meta-ledger/LEDGER.yaml`, `meta-correction-log/CORRECTIONS.yaml`, `meta-casebook/CASEBOOK.yaml`: empty seeds from the staged templates.
- `meta-map/MAP.md`: from `MAP.template.md` with `__PROJECT_NAME__` → `Classes` (title `# Map — Classes`); 30 base entries, all `proposed`; 6,970 bytes seeded, 6,993 with the deferral marker.
- Existing, kept: `DRIFTLOG.yaml`, `CONTRACT-LOG.yaml`, `LEARNINGLOG.yaml`, `FOUNDING.md`.

### `meta-contract-before-execution/CONTRACT-LOG.yaml` (step 7)
- Header comment block: 12 lines replaced by the staged template's 86 (the old header documented the project's `artifact`/`file` fields as "local additions"; the new header lists them as optional artifact-delivery fields).
- 80 entries (73 contracts, 3 `analysis-report`, 4 `standard-evolution-report` — all seven reports have `report-NNN` ids and are skipped by the gate). Each entry gained, at the template's positions: `disappointment: legacy`, `premortem: legacy`, `red_test: legacy` (immediately before `status:` — no entry has `tier_4`), `verification_state: legacy` (after `status:`), `audited: legacy` (after `verification_state:`; nine entries carry a `verification: |` block, all before `status:`, so none needed the after-the-block position), `cost: legacy` (before `work_id:`, else after the `revisions` block, else at the entry's end). +480 lines. `approval:` is on no entry and the migration adds nothing there.
- Result read by `contracts_table`: 73 rows, every one `implemented|approved|learned legacy legacy`; 0 rows with a verification_state the gate acts on, 0 `audited: false`, 0 `verified`.

### `meta-drift-eventlog/DRIFTLOG.yaml` (step 7)
- Header comment block: 28 lines → the template's 44 (the new header's schema names the agent/human aspect vocabulary and `mitigation_medium`).
- `mitigation_medium: unknown` added to 65 elevation items written as maps (after each item's `kind:` line), under both `elevation:` (38 entries) and `elevations:` (16 entries). Left as they are: 20 prose-string items (`- >-` under `elevations:` in drift-027…036) and 15 inline values (`elevation: []` ×14, `elevation: [feedback_never_discard_uncommitted_work]` ×1). +89 lines.

### `meta-learning/LEARNINGLOG.yaml` (step 7, header rule only)
- Header comment block: 6 lines → the template's 47. The old header, verbatim:

```
# LEARNINGLOG - the standard's memory of what actually works.
# Written by meta-learning: the diff is CONTRACTED against VERIFIED.
# Founded 2026-08-27 with the four contracts then standing verified.
# BACKLOG (kept visible, per the skill): contract-044 -- its phase 3, the
# Legatus deed-row overlap, is open and unverified; not swept 2026-09-03.
```
The BACKLOG line is a record and is gone from the file (see §4). No field migration is listed for this file. Its 12 entries are a top-level sequence with no `entries:` key, unlike the template; left as they are.

### `meta-manifest/MANIFEST.yaml` (step 7) — 125 nodes after, 111 before
- Header comment: 4 lines → the template's 13.
- `kit_identity`: `+ base_kit_version: 0.15`, `+ library_kit: null` (after `parent_kit`); `kit_type: type-category` left as declared.
- `- id: contract-artifact` → `base-contract-artifact`; `dependencies:` updated on `base-contract` and `dashboard-exact` (2 lines).
- Every one of the 111 nodes gained `kind:` (before `skill_file:`), `owns:` (after `skill_file:`/`data_file:`), `load:` and `triggers:` (after `phase:`): 12 base nodes from the staged template's node of the same id (e.g. base-foundation: `kind: skill`, `owns: [meta-foundation/SKILL.md, meta-foundation/INTENT.md]`, `load: trigger`, `triggers: [M-03]`); 99 project nodes with `kind: skill`, `load: trigger`, `triggers: []`, `owns: [<own skill_file>]` (+ `data_file` where present; none has one). The three duplicate registrations got the same fields and both ids now own the same file.
- 14 new base nodes registered as the template's one-line form, verbatim, in a block before `# --- Type-category nodes (built through use) ---`: base-intent, base-map, base-correction-log, base-casebook, base-mechanisms, base-ledger, agent-verifier, agent-consolidator, agent-map-steward, agent-batch-assembler, agent-case-clerk, agent-session-auditor, agent-reconstructor, agent-recorder.
- Base node lines the pioneer changed (all 12): kept (stub) — only the four additive fields were added.
- `coverage_map`: 5 base coverage entries that still read as the installed template wrote them replaced by the staged flow lines (base-foundation, base-bootstrap, base-antidrift, base-antidrift-expand, base-extract); 3 pioneer-changed ones kept in block form (base-contract, base-skill-builder, base-manifest); 18 base coverage lines added after the base-manifest entry (base-intent, base-founding-contract, base-map, base-contract-artifact, base-casebook, base-correction-log, base-learning, base-ledger, base-mechanisms, base-drift-eventlog, agent-verifier, agent-consolidator, agent-map-steward, agent-batch-assembler, agent-case-clerk, agent-session-auditor, agent-reconstructor, agent-recorder).
- Net: +500 / −29 lines; the 29 removed are the old header (3), the renamed id line, two dependency lines, and the five block-form coverage entries (25 lines) that became one-line entries. `gap_queue` and `library_entry` untouched.

### `meta-map/MAP.md` (steps 6, 8, 9)
- Seeded (above). Step 8: no project entry added (budget, §5). Step 9: `ratification: deferred` inserted inside the header comment (before the `Budget:` line). No base entry was migrated (the file is new). Final: 6,993 bytes, 30 entries, `G1-size.sh` exit 0.
- `meta-map/proposed-entries.md` (new, not loaded): 96 drafted entries.

### Step 9 records
- `meta-manifest/INSTALLED.sha1`: written after the marker with the 6j command; 175 files (16 agents included; `kit-incoming` excluded by the command's paths).
- `meta-ledger/telemetry.log`: created by the hook checks (9 lines: two `session-start|startup`, two `prompt`, two `stop-gate`, one `subagent|kit-verifier`, one `loaded|meta-map/MAP.md`, one `bypass|base-casebook|meta-casebook/CASEBOOK.yaml`).
- `.claude/kit-incoming/` removed on the (stubbed) acceptance of the report.

### Checks and hooks (step 9), verbatim results
- `checks/G1-size.sh`: exit 0 (INTENT.md 4,820 bytes; MAP.md 6,993 bytes, 30 entries).
- `session-start.sh` (before removal): three backlog lines — drift entries watching or mitigated: 38; pioneer-owned items are waiting; a newer kit is staged. `prompt-submit.sh`: valid JSON. `stop-gate.sh`: hands over M-16 (batch assembler). `subagent-stop.sh`, `post-read.sh`, `owner-check.sh`, `batch-blind.sh`, `deny-paths.sh`: nothing (exit 0). `write-scope.sh` on `src/x.cs`: deny (correct). `close-batch.sh B-001` / `reveal-key.sh B-001`: "No batch file". `tail -3 telemetry.log`: `subagent|kit-verifier`, `loaded|meta-map/MAP.md`, `bypass|base-casebook|meta-casebook/CASEBOOK.yaml` — the `loaded` line and the ownership line naming base-casebook, as the install's Step 7 says.
- Beyond the letter of step 9: `tests/walk.sh` — "all 36 states match walk.expected".

---

## 4. Unclear, wrong or missing in the procedure — verbatim as hit

1. Step 3, *"Read both kits in full (the base kit's own evidence under `tests/results/` excepted)."* — every kit file of both kits was read in full; the project's instance logs (`CONTRACT-LOG.yaml` 662 KB / 10,650 lines, `DRIFTLOG.yaml` 282 KB / 5,086 lines, `MANIFEST.yaml` 2,097 lines) were read whole only for the manifest; the two logs were surveyed structurally (every entry id, every entry-level key, every elevation item shape, every status and aspect value) rather than line by line. The step does not say whether "both kits" includes a project's instance records.
2. Step 6f, *"Copy `MAP.template.md` … and replace `__PROJECT_NAME__`."* — the staged template's own header comment carries the placeholder in an instruction sentence ("meta-bootstrap copies this file and replaces __PROJECT_NAME__."). The literal replacement leaves the seeded map reading "meta-bootstrap copies this file and replaces Classes." A fresh install produces the same. Template defect.
3. Step 6/6i, *"`__PROJECT_NAME__` | Project name derived from directory name or README"* — the copy's directory is `classes-copy`, the manifest says `kit_name: classes-kit`, `FOUNDING.md` says `Classes`. Chose `Classes`. The step does not say which source wins when they disagree.
4. Step 7, *"The header comment block of every instance file above follows the template rule."* and the template rule's *"a header comment block is always refreshed from the staged template — it is instruction, never record."* — `LEARNINGLOG.yaml`'s header held a record line ("# BACKLOG (kept visible, per the skill): contract-044 -- its phase 3, the Legatus deed-row overlap, is open and unverified; not swept 2026-09-03."). Following the rule discarded it. The rule's premise ("never record") was false for this file.
5. Step 7, *"project nodes gain `triggers` from the entries step 8 drafts for them (so step 8 runs before this line)"* — when step 8's budget rule keeps every drafted entry out of the map, there are no map entries to take triggers from. All 99 project nodes were written `triggers: []`, which the staged `meta-manifest/SKILL.md` calls a defect ("A node with `load: trigger` and no triggers will not be found; that is a defect"). The procedure does not say what a project node carries while its entry waits in `proposed-entries.md`, nor whether the waiting entries get provisional ids (they were written `M-??`, as meta-extract writes unnumbered lines).
6. Step 7, *"a skill registered under two ids keeps the id whose line names it as `skill_file` first, and the duplicate is listed in the report"* — it does not say whether the duplicate node line stays, is removed, or receives the additive fields. Since the migration is additive and "never change[s] what is present", both nodes stayed and both received kind/owns/load/triggers; the file is now owned twice.
7. Step 7, *"a base node the project registered under another id is matched by its `skill_file` and takes the template's id"* — the project also has `base-embed-before-own`, `base-host-already-does-it`, `base-verify-api-shape`: base-prefixed ids whose files are `principle-*` and which the staged base kit does not carry. They were migrated as project nodes; the kept `coverage_map` still lists them under "Base kit coverage (always present)". The step is silent on legacy `base-` ids the base kit no longer owns.
8. Step 7, CONTRACT-LOG — four entries carry `type: standard-evolution-report`, a value the template's `type: contract # or analysis-report` enumeration does not have. The gate skips them only because their ids begin `report-`. The migration says nothing about values outside the enumerations.
9. Step 7, DRIFTLOG — *"existing elevations written as maps gain `mitigation_medium: unknown` … an elevation written as a prose string is left as it is."* Done; but the project's `aspect` values are outside the staged vocabulary in 46 of 54 entries (`evidence-is-the-work` ×26, `discipline-is-the-work` ×9, `stop-when-falls`, `evolution-from-elevation`, `verify-api-shape` ×2, `recurrence-means-incomplete-fix` ×2, `the-contract-is-load-bearing` ×2, `recall-is-hypothesis-not-truth`, `verification-before-claim`, `verify-the-output-not-the-mechanism`), and one entry has `status: elevated`, which `session-start.sh` and `stop-gate.sh` do not count (marker-key contract: an unlisted value switches a mechanism off silently). The step migrates fields, never values, and does not say to report values the hooks cannot read.
10. Step 3, *"show the pioneer what differs from the staged copy — the sections changed, in a few lines each"* — for `meta-bootstrap` (348 changed lines, 195 → 385) and `meta-contract-before-execution` (279) a few lines cannot carry it, and the question as specified does not have to state the consequence of *keep*: that the seeded map points at headings the kept file does not have (§7). The step says the report lists what *keep* leaves pointing at nothing; the question itself does not.
11. Step 5, *"then the agents to `.claude/agents/` … and the settings merge"*; step 3's stale rule names *"a kept file whose `> **Map:**` header names an entry the staged template withdrew"* — none of the 13 kept kit files has a `> **Map:**` header at all (pre-0.14), so the header rule in step 7's last bullet had nothing to act on, and the map's "not when" columns have no co-owned header to agree with (meta-map: "header and entry are co-owned"). The procedure assumes kept skills carry headers.
12. Step 8, *"draft an entry … from its description … Then run `checks/G1-size.sh`. If the map is over its budget, the drafted entries do not go into the map"* — with 96 drafts the map was never under budget; I did not append 96 entries to prove it and went straight to `proposed-entries.md` and the roots trial. The step reads as if the full set is tried first.
13. Step 9, *"run every check under `meta-mechanisms/checks/`"* — after the upgrade that folder holds only `G1-size.sh` (the `P-NNN.sh` checks are the base kit's and were not copied), so "every check" is one check.
14. Step 9's hook commands write real lines into the project's `telemetry.log` — including a `bypass|base-casebook|meta-casebook/CASEBOOK.yaml` line the install's Step 7 expects. On a real run that line is a recorded ownership bypass in the project's evidence, and the kit-map-steward reads such lines. The step does not say to clear the check's own lines.
15. Step 2, *"Copy the project's `.claude/` (and its `CLAUDE.md`) to a temporary folder beside it"* — here the pioneer supplied the copy; fine. But the rehearsal instruction's *"the stubs count decisions; they do not show whether keep leaves a usable kit"* is exactly what §7 shows: with *keep* on every file, after `.claude/kit-incoming/` is removed the project has no `Upgrading an Existing Install` section anywhere and M-27 points at the old bootstrap.

---

## 5. The project's own non-base skills

- 99 non-base manifest nodes over 96 skill files (three files registered twice), all in `.claude/skills/`: 53 `pattern-*`, 37 `principle-*`, 9 `playbook-*`, plus `dashboard-exact/` (with `LESSONS.md` and `RUN_CLOSE_TEMPLATE.md` beside its `SKILL.md`, and the eight `dashboard-*` agents it drives).
- Step 8 drafting: one entry per skill file from its frontmatter description — moment = folder name without the layer prefix, type `situation`, channel `must` for playbooks and `ambient` otherwise, "when" = the description's first sentence (cut at 120 characters), "not when" = "— (sibling to be named at ratification)", load = the bare node name, status `proposed`, id `M-??`. All 96 written to `meta-map/proposed-entries.md` (24,937 bytes), roots first.
- The size check on the map (`checks/G1-size.sh`, allowance 8,192 bytes / 40 entries):
  - base entries only: 6,970 bytes, 30 entries → **exit 0**;
  - with the 16 dependency roots appended (dashboard-exact, added-persisted-field-is-null, bannerlord-configure-then-bind, bannerlord-runtime-sprite-injection, concurrent-session-ledger-and-commit, host-registry-ownership, quantised-progression-eats-levels, split-by-thing-and-job, widen-signature-not-overload, playbook-implementation, playbook-orientation, playbook-verify-design, playbook-verify-implementation, playbook-verify-text, surface-audits-the-system, write-to-the-set-not-the-instance): 10,722 bytes, 46 entries → **exit 1**: "G1-size broken: meta-map/MAP.md is 10722 bytes, over the 8192-byte allowance — prune the map; the allowance does not move";
  - so the map keeps only its base entries, every drafted entry waits for the pioneer's one question (stubbed *none for now*), no `> **Map:**` header was added to any project skill, and every project node carries `triggers: []`.
- Consequence for the upgraded project: none of its 96 skills is reachable through the map. They are reachable only by the agent's own recall, by the Skill tool's descriptions, or through the nodes that name them as dependencies — and the map's M-03 fallback ("nothing fits: meta-foundation, record the miss") will fire on Bannerlord work the kit already has 96 nodes for.
- `owns:` for `dashboard-exact` names only `dashboard-exact/SKILL.md`; `LESSONS.md` and `RUN_CLOSE_TEMPLATE.md` in the same folder have no owner (the step says "the node's own skill and data files").

---

## 6. What a session in the upgraded project sees at start

After `.claude/kit-incoming/` was removed, run by hand with `CLAUDE_PROJECT_DIR` set to the copy.

**Always loaded via CLAUDE.md**: `INTENT.md` (4,820 bytes, five agent aspects, the 7-line `drift score (agent)` block), `FOUNDING.md` (the Classes statement, unchanged), `MAP.md` (30 base entries, `ratification: deferred`), then the Classes working rules.

**`session-start.sh` (source: startup)**:
```
Kit backlog (session-start hook):
- Drift entries watching or mitigated: 38 -> M-18 stay alert to those aspects
- Pioneer-owned items are waiting (candidates, map proposals, unratified entries, unranked cards, precedent conflicts or drift resolutions) -> M-16 kit-batch-assembler assembles the batch
Act on each line through its map entry, one kit task at a time. The pioneer does not need to invoke any of this.
```
(38 = 21 `watching` + 17 `mitigated`; the one `status: elevated` entry is invisible to the hook. No contract line: every contract is `legacy`. No founding line: the statement is present and there are no amendments.)

**`prompt-submit.sh`** on the first prompt: "Kit: before acting, name this moment by its map id (meta-map/MAP.md) and load what that entry points to. Close the turn with the drift score block from INTENT.md."

**`stop-gate.sh`, first task** (a turn ending without a question):
```
Kit mechanism (stop-gate): Pioneer-owned items are waiting: candidates, map proposals, unratified entries, unranked cards, precedent conflicts or drift resolutions. Launch the kit-batch-assembler subagent to assemble a batch, then present it per meta-skill-builder's review batch (M-16). Never read .claude/kit-sealed/, and while the batch is open your reads of the ledger are blocked so re-presented items stay indistinguishable. One kit task per turn. The pioneer does not need to invoke this.
```
Why: the 17 `mitigated` drift entries are pioneer-owned drift-resolution items (batch step 10 fires on `resolutions >= 1`); the deferral marker keeps the 30 unratified base entries out of it. The assembler takes up to two drift resolutions per batch, so the first nine batches of the upgraded project are drift resolutions, unless the pioneer resolves them otherwise — and the batch is presented "per meta-skill-builder's review batch", a section the kept `meta-skill-builder/SKILL.md` does not have (§7).

---

## 7. Kept files that still describe something the staged kit removed or renamed

Every kept file was searched for the terms the staged kit dropped or renamed. Listed per file, with what the staged kit says instead.

**Kept kit files (all 13 lack a `> **Map:**` header; the map now points at them):**
- `meta-antidrift/SKILL.md`: prescribes a 9-line `─── drift score ───` block with lines "stop when falls", "discipline is work", "format compliance … DEGRADED", and "6th governing aspect"; the always-loaded `INTENT.md` prescribes the 7-line `drift score (agent)` block with "stop on triggers" and "evidence-as-work". Two block formats are in force every turn; M-28 loads both. `INTENT.md` says "the five shapes are listed in `meta-antidrift/SKILL.md` → Scoring Rules" — the kept file lists no trigger shapes.
- `meta-foundation/SKILL.md`: six agent aspects including "Stop when discipline falls" and "Discipline is the work, not overhead on it"; no human aspects, no `INTENT.md`, no instruments; a project-specific *Principles* section ("Host VMs do not own feature-specific state"). Staged: five agent aspects (`stop-on-triggers`, `evidence-as-work`) and five human aspects.
- `meta-drift-eventlog/SKILL.md`: aspect vocabulary `stop-when-falls`; elevation schema without `mitigation_medium` or `reviewed` (the migration added a field its governing skill does not define); entries "end-of-session"; "the human approves" transitions; "Discipline Fall Point". Staged: agent writes open→watching, mitigated→resolved at a batch, the ladder to a mechanism.
- `meta-antidrift-expand/SKILL.md`: "Invoked by the human" (M-19 fires it); §4 "Discipline Fall Point"; §6 recommends "elevate now / restate before elevating / discard" (staged forbids that filter: everything goes to the ledger as observations).
- `meta-contract-before-execution/SKILL.md`: three tiers, "The Three-Tier Proposal"; no *The Bearing*, *The Precedent Check*, *The Proposal* or *Tier 4* sections (M-04's pointers are missing headings); no `verification_state`, `audited`, `transcript`, `disappointment`, `premortem`, `red_test`, `cost` — a contract drawn under it writes none of the marker keys, so the stop-gate never launches the auditor or verifier for it (`contracts_table` shows `-` for both); "Standard Evolution Report" presented for decision and "Closing the Contract — How was the run?" (staged: recorded to the ledger; the closing question does not exist); "The Playbook Pipeline"; cites `tools/verify/verify_contract_log.py`.
- `meta-skill-builder/SKILL.md`: "Input — Standard Evolution Report"; no *Review Batch*, *Reveal*, *Contradictions*, *Drift Log Back-reference* (M-16 and M-17 point at missing headings); "Step 2 — Let the human decide … Ask: Which of these belongs" (staged: decisions only at a batch, level and tier recorded).
- `meta-learning/SKILL.md`: "invoked explicitly by the pioneer — it is not part of the continuous load order" (M-13 now fires it from the stop-gate); State C from "tests / observation / human-confirmation", not the verification record; `human_decision: [pending | approved | declined]` (staged: trial / adopt / caution / decline / hold / revise); "Goal and meaning".
- `meta-manifest/SKILL.md`: "At the start of every session, load MANIFEST.yaml and read the full node list" (staged: on trigger only); "The manifest is read-only for the agent during a session"; no schema for `kind`, `load`, `triggers`, `owns`, `retired`, `base_kit_version` — the migrated manifest now carries fields its governing skill does not define; library promotion criteria without instruments.
- `meta-extract/SKILL.md`: "meta-maturity-check — a separate skill the developer runs" (exists in neither kit); no reconstruction test, precedents, map entries or instruments; "Run `meta-bootstrap` in the new project — it will find the library kit" (the kept bootstrap has no library step).
- `meta-contract-artifact/SKILL.md`: "This practice already holds that a contract is drawn in chat and **never** lives as a file … That rule stands" (staged: the log entry is the record, verifier verdicts source the page); "the three tiers"; anti-pattern "A log entry that never leaves `awaiting-approval`" (no such status in either kit); "the playbook declaration".
- `meta-bootstrap/SKILL.md`: "the meta-kit-builder practice"; Step 2 writes the numbered-list CLAUDE.md block this upgrade just replaced; `kit_type: type-category`, `parent_kit: meta-kit-builder`; "four things govern"; no Steps 5–7, no `INSTALLED.sha1`, no *Upgrading an Existing Install* — M-27 (`install-or-upgrade`) points at a file that cannot do either, and with `kit-incoming/` gone the project has no upgrade procedure until the next kit is staged.
- `meta-founding-contract/SKILL.md`: lacks only the *Instance* paragraph naming the mechanised checks and bootstrap steps; nothing it says was removed.
- `templates/MANIFEST.template.yaml`: 8 base nodes in block form, no `kind`/`load`/`triggers`/`owns`, no `base_kit_version`; the next upgrade's template rule ("`.claude/skills/templates/` is the copy the last install shipped") will compare against this stale template.

**Kept instance files:**
- `MANIFEST.yaml` (kept parts): `base-bootstrap` concern "First-run installation …" with note "Runs once per project … not invoked again" (M-27 fires on upgrade too); `base-skill-builder` concern "Abstraction loop — classifying learnings"; `base-antidrift` concern "Block is self-checking on its own format (9th line added 2026-05-26)"; `base-learning` open_gaps "LEARNINGLOG.yaml does not exist" (it does, with 12 entries); `coverage_map` lists `base-embed-before-own`, `base-host-already-does-it`, `base-verify-api-shape` under "Base kit coverage (always present)".
- `DRIFTLOG.yaml`: 46 of 54 entries use aspect names outside the staged vocabulary and one `status: elevated` (§4.9); `skill_builder_notes` reference the SER process.
- `LEARNINGLOG.yaml`: `human_decision: approved | declined` values; top-level sequence.

**Project skills and agents:**
- `playbook-contract/SKILL.md` and `playbook-verify-text/SKILL.md`: the close by "How was the run?" and "three tiers" (the kept meta-contract-before-execution still has both, the staged kit has neither).
- `pattern-contract-verification-pass/SKILL.md`: "three-tier contract", "Discipline is the work".
- `principle-meta-first/SKILL.md`: "three-tier".
- `principle-stop-triggers-must-be-named/SKILL.md`: quotes "stop when discipline falls" as the aspect it critiques; the aspect is now named `stop-on-triggers` in `INTENT.md`.
- `playbook-orientation/SKILL.md`: "load the meta layer (foundation, manifest, driftlog …)" — the manifest and drift log are no longer session-loaded; the hook surfaces their counts instead.
- `dashboard-exact/SKILL.md`, `.claude/agents/dashboard-exact.md`, `dashboard-drafter.md`: "the ledger" means `CONTRACT-LOG.yaml` ("Close the ledger `implemented`", "Never edit the ledger except to enter an approved contract", "the last contract in `CONTRACT-LOG.yaml` is the model") — in the staged kit "the ledger" is `meta-ledger/LEDGER.yaml`, closed to the main session while a batch is open. A vocabulary collision with the batch-blind's deny message.
- `CLAUDE.md` body (the Classes rules): references nothing removed or renamed.
