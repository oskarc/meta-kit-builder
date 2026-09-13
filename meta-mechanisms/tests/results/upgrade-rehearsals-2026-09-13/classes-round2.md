# Upgrade rehearsal — Classes kit copy, pre-0.14 install → base-building-kit 0.15

Run 2026-09-13 on this throwaway copy, following the STAGED kit's `meta-bootstrap/SKILL.md` → *Upgrading an
Existing Install*, steps 1–9, with the pioneer's answers stubbed exactly as step 2 prescribes (*keep* for every
differing file or template part, *remove* for the stale list, *legacy* for every existing contract, *defer* for the
ratification pass, *yes* to removing `.claude/kit-incoming/`). Hooks and checks were run with `CLAUDE_PROJECT_DIR`
set to this folder, under Git Bash.

Step 1 result: the project manifest has no `base_kit_version` — treated as pre-0.14, as the step says (it also has
no `MAP.md`, no `settings.json`, no `INSTALLED.sha1`, so it is a v0.13-or-earlier install). Staged kit: 0.15.

---

## 1. The three numbers

### Decisions asked: 32

**A. One per kit file that differed (13)** — every one answered *keep*:

1. `meta-antidrift/SKILL.md` (installed 95 lines, staged 109)
2. `meta-antidrift-expand/SKILL.md` (134 / 155)
3. `meta-bootstrap/SKILL.md` (195 / 382)
4. `meta-contract-artifact/SKILL.md` (328 / 362)
5. `meta-contract-before-execution/SKILL.md` (272 / 331)
6. `meta-drift-eventlog/SKILL.md` (140 / 162)
7. `meta-extract/SKILL.md` (215 / 242)
8. `meta-foundation/SKILL.md` (136 / 184)
9. `meta-founding-contract/SKILL.md` (142 / 160)
10. `meta-learning/SKILL.md` (156 / 175)
11. `meta-manifest/SKILL.md` (85 / 182)
12. `meta-skill-builder/SKILL.md` (112 / 183)
13. `templates/MANIFEST.template.yaml` (200 / 134)

**B. One per template part the pioneer changed (15)** — the template rule, applied against the installed
`.claude/skills/templates/` (which holds only `MANIFEST.template.yaml`); every one answered *keep*:

14. `MANIFEST.yaml` header comment block (installed: "Instance data for the Classes kit. Governed by SKILL.md in the same directory." — not what the installed template wrote)
15. base node line `base-foundation` (concern extended, `phase: [pre-build, during-build, post-build]`, `generation_evolved: 4`, four open gaps, a note)
16. base node line `base-bootstrap` (concern, `phase: [pre-build]`, note)
17. base node line `base-contract` (concern, `generation_evolved`, `dependencies: [contract-artifact]`, `verified_by`, four open gaps)
18. base node line `base-skill-builder` (`phase: [post-build]`, three open gaps)
19. base node line `base-manifest` (`phase: [pre-build]`, two open gaps)
20. base node line `base-extract` (note)
21. base node line `base-antidrift` (concern, `generation_evolved: 2`, open gap, note)
22. base node line `base-antidrift-expand` (note)
23. base coverage line `base-contract` (`phase: pre/post` shorthand instead of the template's list)
24. base coverage line `base-manifest` (`phase: pre`)
25. base coverage line `base-skill-builder` (`phase: post`)
26. `CONTRACT-LOG.yaml` header comment block (project-written; no installed template exists to compare it with — see troubleshooting 2)
27. `DRIFTLOG.yaml` header comment block (same; it also documents the old aspect vocabulary and an elevation schema without `mitigation_medium`)
28. `LEARNINGLOG.yaml` header comment block (same)

Five base coverage lines still read as the installed template wrote them (`base-foundation`, `base-bootstrap`,
`base-antidrift`, `base-antidrift-expand`, `base-extract`) and were refreshed from the staged template without a
question. The four base nodes the installed template never carried (`base-founding-contract`, `contract-artifact`,
`base-learning`, `base-drift-eventlog`) are not template parts and were touched only by the additive list.

**C. The procedure's own questions (4):**

29. Step 7 — which recent implemented contracts to verify and audit: *legacy* for all 79 entries.
30. Step 8 — which drafted entries belong in the always-loaded map: **no stub exists for this question** (see troubleshooting 8); stand-in answer: none in the map, all 96 to the pioneer.
31. Step 9 — the ratification pass: *defer*.
32. Step 9 — remove `.claude/kit-incoming/`: *yes*.

Stale-list question: **not asked** — nothing present here is absent from the staged kit (see classification).

### Files that genuinely differed: 13

The 13 kit files in list A above. Beyond files, 15 template parts inside three instance files also genuinely
differed (list B) — 28 differing things in all. No file was classified *untouched*: there is no `INSTALLED.sha1`
to compare against, so the 13 are "evolved here" by the step-3 rule ("hash differs, **or no baseline exists**"),
and the recomputed baseline (124 files before the upgrade) had nothing to be diffed with.

Against the pass rule in step 2 — *"every decision asked belongs to a file or template part that genuinely
differed or is the one stale-list question"* — 28 of the 32 decisions belong; the 4 in list C are the procedure's
own stubbed questions and belong to neither. Read literally, the rehearsal fails its own criterion on questions
the procedure itself instructs the rehearsal to stub. See section 4, item b.

### Troubleshooting steps: 9

Things I had to do that steps 1–9 do not say:

1. **No baseline to copy.** Step 2 says "copy the old `INSTALLED.sha1` to `INSTALLED.sha1.prev`; the report's list of what was taken, ported, removed and migrated is the difference between the two." A pre-0.15 project has no `INSTALLED.sha1`. I built that list from the step-3 classification instead (section 3).
2. **Instance-file headers with no installed template.** The template rule refreshes a part "when it still reads as the installed template wrote it (`.claude/skills/templates/` is the copy the last install shipped)". This install shipped only `MANIFEST.template.yaml`, so for `CONTRACT-LOG.yaml`, `DRIFTLOG.yaml` and `LEARNINGLOG.yaml` the comparison is impossible. I chose to ask (three *keep* answers, decisions 26–28). Silently leaving them would have hidden that the DRIFTLOG header documents a schema the staged kit renamed.
3. **`elevations:` (plural).** Step 7 says "existing elevations written as maps gain `mitigation_medium: unknown`". Sixteen DRIFTLOG entries keep their elevations under a key spelled `elevations:`, not `elevation:`. I migrated both keys (65 map items got the field; 20 prose items under the same keys were left as they are, per the step).
4. **Base nodes get no `triggers`.** Step 7's manifest line gives every node `kind` and `load`, project nodes `triggers` and `owns`, and base nodes `owns` — but not `triggers`. That leaves the 12 kept base nodes at `load: trigger` with no triggers, which `meta-manifest/SKILL.md` calls "a defect". I added `triggers` from the staged template's node of the same id.
5. **Renamed id, dangling dependents.** "A base node the project registered under another id … takes the template's id" — `contract-artifact` became `base-contract-artifact`. Two nodes named the old id in `dependencies` (`base-contract`, `dashboard-exact`); the step says nothing about them. I updated both references.
6. **Skills registered twice.** Three skill files are registered under two ids each (`base-embed-before-own`/`embed-before-own`, `base-host-already-does-it`/`host-already-does-it`, `base-verify-api-shape`/`verify-api-shape`). Step 8 says "for each existing non-base node, draft an entry". I drafted one entry per skill file (96, not 99) and gave both nodes the same trigger.
7. **Roots-only map still over budget.** Step 8: "draft into the map one entry per node that no other node names as a dependency, run the check again, and put the rest to the pioneer as one question … The map is never written past the check." The 16 root entries alone put the map at 9,532 bytes (allowance 8,192). The step does not say what happens then. I wrote zero project entries into the map and put all 96 to the pioneer.
8. **No stub for the step-8 question.** The rehearsal's stub list (keep / remove / legacy / defer / yes) has no answer for "which of these belong in the always-loaded map". I stood in with "none in the map".
9. **Baseline before the marker.** Step 9 regenerates the baseline (6j), then offers the ratification pass, then on a deferral writes `ratification: deferred` into `MAP.md` — after the baseline. At the next upgrade `MAP.md` would then hash as "evolved here" and be asked about. I regenerated the baseline a second time after the marker.

Not counted (my own scripting errors, fixed before the report, disclosed so the count is auditable): an awk
dynamic-regex escape that silently dropped `triggers`/`owns` on the 12 base nodes in the first pass; a gsub
replacement that wrote a literal `\001` byte into one `dependencies` line; `xargs` stripping apostrophes from 12
of the 96 `> **Map:**` headers. All three were re-done and verified (no control bytes remain in any migrated file;
101 skills carry a header with a non-empty recognise clause; every base node has `owns` and `triggers`).

---

## 2. The classification (step 3), as it would have been presented

Recomputed baseline: 124 files under `.claude/skills` and `.claude/agents` before the upgrade. **No
`INSTALLED.sha1` exists**, so — as the step requires me to say plainly — every kit file had to be treated as
possibly evolved, and the questions were one per skill. Hashes were taken with carriage returns removed; no CRLF
files were found on either side.

**Untouched here (hash matches the baseline): none** — there is no baseline.

**Evolved here (no baseline; every one also differs from its staged counterpart by `diff`): 13** — list A above.
What differs, in a few lines each, is section 2a below.

**New in the kit: 42 files** — added without a question:
- `agents/` 8: `kit-batch-assembler`, `kit-case-clerk`, `kit-consolidator`, `kit-map-steward`, `kit-reconstructor`, `kit-recorder`, `kit-session-auditor`, `kit-verifier` (no name collides with the project's eight `dashboard-*` agents)
- skills 6: `meta-casebook/SKILL.md`, `meta-correction-log/SKILL.md`, `meta-ledger/SKILL.md`, `meta-map/SKILL.md`, `meta-mechanisms/SKILL.md`, `meta-foundation/INTENT.md`
- hooks 12: `batch-blind`, `close-batch`, `deny-paths`, `lib`, `owner-check`, `post-read`, `prompt-submit`, `reveal-key`, `session-start`, `stop-gate`, `subagent-stop`, `write-scope`
- checks 1: `G1-size.sh`
- tests 2: `walk.sh`, `walk.expected`
- templates 9: `CASEBOOK`, `CONTRACT-LOG`, `CORRECTIONS`, `DRIFTLOG`, `FOUNDING`, `LEARNINGLOG`, `LEDGER`, `MAP`, `settings`
- new nodes whose instance files are seeded from the staged templates (step 4): `meta-casebook/CASEBOOK.yaml`, `meta-correction-log/CORRECTIONS.yaml`, `meta-ledger/LEDGER.yaml`, `meta-map/MAP.md`

**Present here, absent from the staged kit (stale): none.** The project's `dashboard-*` agents and `dashboard-exact` skill are project files, not kit files.

**In the staged folder but not "the kit" (never copied):** `checks/P-004..P-007.sh`, `tests/results/**`, `tests/walk-004.sh`, `tests/walk-007.sh`, `tests/fixtures/**`, and the base kit's own instance files (`meta-manifest/MANIFEST.yaml`, `meta-map/MAP.md`, `meta-founding-contract/FOUNDING.md`, `CONTRACT-LOG.yaml`, `LEARNINGLOG.yaml`, `DRIFTLOG.yaml`, `LEDGER.yaml`, `CORRECTIONS.yaml`, `CASEBOOK.yaml`).

### 2a. What differs in each kept file, and what *keep* leaves pointing at nothing

The rehearsal step asks for "every kept file that still describes something the staged kit removed or renamed".
Checked by grep against the kept files after the upgrade:

| Kept file | What the staged version changed | What *keep* leaves broken |
|---|---|---|
| `meta-contract-before-execution/SKILL.md` | Adds the Bearing, the Precedent Check, Tier 4, the pre-mortem, `record, don't present` after implementation; drops the playbook pipeline and "How was the run?" | Map M-04 loads "→ The Bearing, The Proposal": **both headings absent**. M-11 "→ After Implementation" resolves to the old SER section, which presents candidates instead of recording observations. Sections "Tier 4", "The Precedent Check" absent. |
| `meta-skill-builder/SKILL.md` | Replaces the SER-driven loop with the review batch and the reveal | M-16 "→ Review Batch" and M-17 "→ Reveal": **both headings absent**. The kept file's Step 2 asks the human to decide per candidate in chat — the practice the staged kit removed. |
| `meta-antidrift/SKILL.md` | Five agent aspects, 7-line block, no format-compliance line | INTENT.md's block (always loaded) has 7 lines; the kept skill prescribes 9 with "format compliance … 8/8". INTENT.md says "the five shapes are listed in `meta-antidrift/SKILL.md` → Scoring Rules"; the kept Scoring Rules list "Stop when discipline falls", not "Stop on named triggers". |
| `meta-foundation/SKILL.md` | Five agent aspects + five human aspects; "Stop on named triggers" | Kept file has six aspects including "Discipline is the work, not overhead on it" and "Stop when discipline falls". M-03 loads it; it contradicts INTENT.md on the aspect list. |
| `meta-manifest/SKILL.md` | Six layers, kind/load/triggers/owns schema, retirement | Kept file says "At the start of every session, load MANIFEST.yaml and read the full node list" — the staged kit stops that. No schema for `kind`, `load`, `triggers`, `owns`, which the migrated MANIFEST.yaml now carries. |
| `meta-drift-eventlog/SKILL.md` | New aspect vocabulary, `mitigation_medium`, the ladder, batch-driven resolution | Kept schema lists `stop-when-falls`, `evidence-is-the-work` and elevation kinds without `mitigation_medium`; the migrated DRIFTLOG now carries `mitigation_medium: unknown` on 65 items the kept skill does not define. |
| `meta-learning/SKILL.md` | Trigger moved to the stop-gate; State C from the verification block | Kept file: "invoked explicitly by the pioneer"; M-13 fires from the hook. |
| `meta-extract/SKILL.md` | Reconstruction test, map entries and precedents travel | M-26 loads "meta-extract; meta-casebook → Reconstruction tests; agent: kit-reconstructor": kept file has **no "Reconstruction"** section. |
| `meta-bootstrap/SKILL.md` | Install rewritten; "Upgrading an Existing Install" added | Kept file has **no upgrade section**; its Step 2 tells the pioneer to paste the OLD CLAUDE.md block ("meta-kit-builder practice"), which the upgrade just replaced. M-27 loads it. |
| `meta-antidrift-expand/SKILL.md` | Reads ledger audits; records to the ledger rather than filtering | Kept "Discipline Fall Point" (four aspects) vs staged "Drift Onset Point" (five); kept section 6 recommends elevate/discard, which the staged kit removed as "a second gate held by the agent". |
| `meta-contract-artifact/SKILL.md` | The log entry is the record; verifier verdicts source the page's states | Kept file keeps "a contract … **never** lives as a file" as the standing rule and knows nothing of `verification_state`. |
| `meta-founding-contract/SKILL.md` | Names the mechanised form checks and the CLAUDE.md import | Kept Instance section says nothing of them; no `> **Map:**` header (M-24). |
| `templates/MANIFEST.template.yaml` | 0.15 shape: `base_kit_version`, flow-form base nodes with `kind`/`load`/`triggers`/`owns`, 26 base nodes | The kept template has 8 base nodes and none of those fields. **The next upgrade's template rule will compare against this outdated template**, so every refreshed part will read as "changed by the pioneer" and be asked about again. |

Also: none of the 12 kept skills carries a `> **Map:**` header, so the co-ownership rule in `meta-map` (header
and entry say the same thing) holds for none of the base entries M-03 to M-30 that point at them.

---

## 3. Every change applied, file by file

Taken from the staged kit (42 new files, listed in section 2). Ported by hand: none (every differing file was
*kept*). Asked: 32 (section 1). Removed: `.claude/kit-incoming/` only (stale list empty). Migrated:

| File | Change |
|---|---|
| `CLAUDE.md` | The old block had no markers. Replaced the contiguous span from `# Kit-Driven Development` up to the first horizontal rule (22 lines; quoted in 3a) with the staged block between `<!-- kit-block:start -->` / `<!-- kit-block:end -->`. The `---` and everything after it ("# Classes mod — working rules" …) untouched. |
| `.claude/settings.json` | Did not exist → written as the staged template (6 hook groups, each `"_kit": "base-building-kit"`, `permissions.deny: ["Read(kit-sealed/**)"]`). |
| `.gitignore` | Appended `.claude/kit-sealed/` with a one-line comment. |
| `.gitattributes` | Created: `*.sh text eol=lf`. |
| `.claude/agents/` | +8 `kit-*.md`; the project's 8 `dashboard-*.md` untouched. |
| `.claude/skills/agents/` | Created; the kit's own copy of the 8 agents. |
| `.claude/skills/meta-{casebook,correction-log,ledger,map,mechanisms}/SKILL.md`, `meta-foundation/INTENT.md` | Added. |
| `.claude/skills/meta-mechanisms/{hooks,checks,tests}/` | +12 hooks, +`G1-size.sh`, +`walk.sh`, +`walk.expected`. Folders `meta-ledger/batches/`, `meta-casebook/reconstruction/` created. |
| `.claude/skills/templates/` | +9 templates; `MANIFEST.template.yaml` kept (old). |
| `meta-casebook/CASEBOOK.yaml`, `meta-correction-log/CORRECTIONS.yaml`, `meta-ledger/LEDGER.yaml` | Seeded from the staged templates (empty lists). |
| `meta-map/MAP.md` | Seeded from the staged template with `__PROJECT_NAME__` → `Classes` (30 base entries, all `proposed`, 6,970 bytes). Then `ratification: deferred` added to the header comment (step 9 deferral). **Zero project entries** (section 5). |
| `meta-map/proposed-entries.md` | New, not loaded: 96 drafted entries + the one question for the pioneer. |
| 96 project `*/SKILL.md` | One `> **Map:** M-NN (proposed — drafted by the 0.15 upgrade, not yet in MAP.md) · **Load:** on trigger · **Recognise it by:** … · **Not when:** …` line inserted after the frontmatter. No other content touched. |
| `meta-contract-before-execution/CONTRACT-LOG.yaml` | +474 lines: every one of the 79 entries (72 execution contracts, 3 analysis reports, 4 standard-evolution reports) gained, directly after its entry-level `status:` line: `verification_state: legacy`, `audited: legacy`, `disappointment: legacy`, `premortem: legacy`, `red_test: legacy`, `cost: legacy`. Nothing else changed; no entry had any of the six before (verified by census). 10,553 → 11,027 lines. |
| `meta-drift-eventlog/DRIFTLOG.yaml` | +65 lines: `mitigation_medium: unknown` at the end of every map-form elevation item (`- target: …`) under `elevation:` or `elevations:` across 40 entries. 20 prose items (`- >-`) in drift-027…036 and 14 `elevation: []` lists untouched. 5,086 → 5,151 lines. Aspect values (`evidence-is-the-work`, `stop-when-falls`) left as written — the additive list does not rename values. |
| `meta-learning/LEARNINGLOG.yaml`, `meta-founding-contract/FOUNDING.md` | Untouched (exist; no additive fields listed for them). |
| `meta-manifest/MANIFEST.yaml` | 2,097 → 2,537 lines. Detail in 3b. |
| `meta-manifest/INSTALLED.sha1` | Written (173 files: every `.md`, `.yaml`, `.sh` under `.claude/skills` and `.claude/agents`, hashed with CRs removed), regenerated after the deferral marker. No `.prev` (none existed). |
| `meta-ledger/telemetry.log` | Created by the step-9 hook runs. Carries, besides the expected lines, two `bypass` lines from two extra `owner-check.sh` probes I ran to confirm the migrated manifest parses in both node forms (`bypass|decompile-vanilla|…`, `bypass|base-contract|…`). In the real run those probes should not be made — they would be read by the map steward as evidence. |
| `.claude/kit-incoming/` | Removed. |

### 3a. The CLAUDE.md span that was replaced (verbatim)

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

### 3b. MANIFEST.yaml diff summary

- `kit_identity`: `+ base_kit_version: 0.15`, `+ library_kit: null`; `kit_type: type-category` left as declared; `version: 0.2`, `kit_name: classes-kit` untouched. Header comment kept.
- 12 existing base nodes (matched by `skill_file`): each `+ kind`, `+ load`, `+ triggers`, `+ owns`, copied from the staged template's node of the same id, inserted after `skill_file:`. `contract-artifact` → id `base-contract-artifact` (its concern, origin and open_gaps kept); the two `dependencies` lists naming the old id updated. Node lines otherwise kept (they were asked about).
- 14 new base nodes inserted in the staged template's flow form after `base-extract`, under a comment "added by the 0.15 upgrade": `base-intent`, `base-map`, `base-correction-log`, `base-casebook`, `base-mechanisms`, `base-ledger`, `agent-verifier`, `agent-consolidator`, `agent-map-steward`, `agent-batch-assembler`, `agent-case-clerk`, `agent-session-auditor`, `agent-reconstructor`, `agent-recorder`.
- 99 project nodes: each `+ kind: skill`, `+ load: trigger`, `+ triggers: [M-NN]` (from the drafted entry), `+ owns: [<its skill_file>]`. No `tier`/`inherited` added (not in the additive list; the staged schema requires them).
- `coverage_map`: 18 flow-form lines added at the top (the 14 new nodes plus `base-founding-contract`, `base-contract-artifact`, `base-learning`, `base-drift-eventlog`, which had nodes but no coverage line); 5 lines refreshed to the staged flow form; 3 kept; all project coverage entries untouched.
- `gap_queue`, `library_entry`: untouched.
- Verified after: 111 block nodes + 14 flow nodes; every node has `owns` and `triggers`; `owner-check.sh` resolves owners in both forms; no control bytes; no duplicate ids (the three doubly-registered skills remain, as they were).

---

## 4. Unclear, wrong or missing in the procedure — verbatim, as hit

a. Step 2: *"Before step 3, copy the old `INSTALLED.sha1` to `INSTALLED.sha1.prev`; the report's list of what was taken, ported, removed and migrated is the difference between the two, and `.prev` is deleted once the report is accepted."* — A pre-0.15 project has no `INSTALLED.sha1`; the step it opens with ("A project from before the map and the hooks existed … no baseline") has no `.prev` and no difference to report from.

b. Step 2: *"The rehearsal passes only when every decision asked belongs to a file or template part that genuinely differed or is the one stale-list question, and the third number is zero."* — The same step stubs *legacy*, *defer* and *yes*, and step 8 puts one more question; none of those four belongs to a differing file. The criterion excludes the procedure's own questions from passing.

c. Step 2's stub list: *"keep for every differing file or template part, remove for the stale list, legacy for every existing contract (step 7), defer for the ratification pass (step 9), yes to removing `.claude/kit-incoming/`"* — no stub for step 8's *"put the rest to the pioneer as one question — which of these belong in the always-loaded map"*.

d. The template rule: *"each such part is refreshed from the staged template when it still reads as the installed template wrote it (`.claude/skills/templates/` is the copy the last install shipped, so the comparison is mechanical)"* — the pre-0.13 install shipped one template. For `CONTRACT-LOG.yaml`, `DRIFTLOG.yaml`, `LEARNINGLOG.yaml` (and the base map entries, had there been a map) there is nothing to compare against; "a part the pioneer changed" cannot be told from "a part written by a template that no longer ships".

e. *"One question per differing file; none where nothing differs (contract-007 G-3)"* beside *"A part the pioneer changed is asked about like a differing file"* — at part granularity one file (`MANIFEST.yaml`) produced 12 questions (header, 8 node lines, 3 coverage lines). The pioneer's failure condition ("many manual decisions") is met by the rule's own granularity on any project whose manifest has evolved, which is every project that has used the kit.

f. Step 7: *"`DRIFTLOG.yaml` — existing elevations written as maps gain `mitigation_medium: unknown` if absent; an elevation written as a prose string is left as it is."* — silent on the `elevations:` key sixteen entries use.

g. Step 7: *"`MANIFEST.yaml` — every node gains `kind` and `load` if absent; project nodes gain `triggers` … and `owns:` …; every non-agent base node gains `owns:` copied from the staged template's node of the same id"* — base nodes gain no `triggers`; the staged `meta-manifest/SKILL.md` calls a `load: trigger` node without triggers a defect.

h. Step 7: *"a base node the project registered under another id is matched by its `skill_file` and takes the template's id"* — nothing about the `dependencies` lists that name the old id (two here).

i. Step 8: *"draft into the map one entry per node that no other node names as a dependency, run the check again, and put the rest to the pioneer as one question … The map is never written past the check."* — no rule for the case where the root entries alone fail the check (16 roots, 9,532 bytes here). And *"add the matching `> **Map:**` header"* — the header names an entry that, by the same step, is not in the map.

j. Step 8: *"For each existing non-base node, draft an entry"* — three skills are registered as two nodes each; one entry per node would give one skill two map entries.

k. Step 9: *"**Regenerate the baseline** (6j), run every check … and **report** … Offer the ratification pass exactly as Step 7 of the install does, and on a deferral add the `ratification: deferred` marker"* — the marker edits `MAP.md` after the baseline that covers it was written.

l. Step 3: *"Present the classification before changing anything."* and step 9 *"Offer the ratification pass"* — in a stubbed rehearsal there is no one to present to or offer to; the steps do not say the rehearsal skips the presenting or where the presentation goes (here: this report).

m. *"What 'the kit' is"*: *"`agents/` — deployed to `.claude/agents/` and kept as the kit's own copy under `.claude/skills/agents/`, which the checks read"* — only `P-004.sh`/`P-005.sh` read that copy, and those are "the base kit's own precedents" that do not travel; `G1-size.sh`, the one check that travels, does not read it. The copy is installed for readers that are not installed.

n. Step 7's contract-log line adds six `legacy` fields to *"every existing entry"* — including the seven `report-NNN` entries the gates skip. Harmless, but the marker-key contract's `type` enumeration (`contract` | `analysis-report`) does not cover this log's `execution-contract` and `standard-evolution-report` values; the gates skip the four SERs only because they happen to carry `report-` ids. Not covered by any migration line.

o. The install's guarantee *"nothing fires during it"* rests on the manifest being written last; on an upgrade `kit_installed` is already true (`kit_type: type-category` ≠ `base`), so in a live session every hook fires against a half-migrated project from the first copied file. The upgrade section does not say so.

p. *"the settings merge — replacing the hook groups whose `"_kit"` key marks them"* — fine; here no `settings.json` existed and 5c's "no settings file → write the template" applied. Not a defect, recorded because the upgrade text never says which of 5c's branches applies.

---

## 5. The project's own non-base skills, and the map size check

99 non-base nodes → 96 skill files (three registered twice). One entry drafted per skill, ids `M-31`…`M-126`
in manifest order, all `situation`/`lifecycle`, `proposed`, load = the bare node name, "not when" naming the
nearest sibling in the same family. The full lines are in `.claude/skills/meta-map/proposed-entries.md`; the
id → skill table:

M-31 principle-embed-before-own · M-32 principle-host-already-does-it · M-33 principle-verify-api-shape · M-34 pattern-decompile-vanilla · M-35 principle-artifact-as-living-reference · M-36 principle-render-vs-declared · M-37 pattern-text-stack-row-pitch · M-38 principle-prescription-vs-diagnosis · M-39 pattern-bannerlord-subagent-verification · M-40 principle-engagement-contract · M-41 pattern-predicate-feasibility-audit · M-42 pattern-source-attributed-aggregation · M-43 pattern-idempotent-attach-with-retry · M-44 pattern-named-clause-decomposition · M-45 pattern-behavior-local-vs-published-state · M-46 pattern-atomic-ship-gate · M-47 pattern-migration-by-removal · M-48 principle-event-surface-is-the-spec · M-49 pattern-approximation-policy · M-50 principle-meta-first · M-51 pattern-font-safe-glyphs · M-52 principle-pattern-evidence-audit · M-53 principle-revealed-content-carries-latent-bugs · M-54 pattern-bannerlord-screen-extension · M-55 pattern-bannerlord-viewmodelmixin-handle-derived · M-56 pattern-bannerlord-state-push · M-57 pattern-bannerlord-brush-literal · M-58 pattern-bannerlord-event-block-subtree · M-59 pattern-bannerlord-hintwidget-role · M-60 pattern-build-sentinel · M-61 pattern-bannerlord-interface-method-patch · M-62 pattern-pending-handoff-on-activation · M-63 pattern-bannerlord-numeric-attribute-coercion · M-64 pattern-bannerlord-inject-binding-for-conditional-gating · M-65 pattern-bannerlord-horizontal-row-with-variable-labels · M-66 pattern-bannerlord-gauntlet-width-chain · M-67 pattern-bannerlord-gauntlet-height-chain · M-68 pattern-bannerlord-gauntlet-pre-flight-audit · M-69 pattern-class-dashboard-ia · M-70 pattern-dashboard-extraction · M-71 principle-natural-engagement · M-72 principle-audit-doc-as-artifact · M-73 principle-ask-vs-guess-on-domain-gaps · M-74 pattern-registration-time-validator · M-75 pattern-api-split-warn-and-pure · M-76 pattern-dlc-sibling-model-dual-bind · M-77 principle-enforcement-layer-below-rules · M-78 principle-central-gate-exhaustive-coverage · M-79 principle-host-concurrency-is-unannounced · M-80 principle-recurrence-means-incomplete-fix · M-81 pattern-bannerlord-screen-mutation-guards-visual-managers · M-82 pattern-challenge-target-pacing · M-83 principle-cctor-prewarm-is-aggressive · M-84 principle-host-prerequisite-aware-patching · M-85 pattern-postfix-callgraph-survey · M-86 pattern-dump-first-crash-diagnosis · M-87 pattern-contract-verification-pass · M-88 pattern-host-finance-integration · M-89 pattern-dashboard-amount-allocation · M-90 principle-native-boundary-has-no-catch · M-91 principle-gate-the-count-not-the-credit · M-92 principle-in-world-voice · M-93 pattern-flavor-composition · M-94 principle-commitment-gates-earning · M-95 playbook-orientation · M-96 playbook-design · M-97 playbook-contract · M-98 playbook-implementation · M-99 playbook-text · M-100 playbook-verify-implementation · M-101 playbook-verify-design · M-102 playbook-verify-text · M-103 dashboard-exact · M-104 pattern-guarded-source-mutation · M-105 principle-stop-triggers-must-be-named · M-106 principle-host-failure-shape-is-unannounced · M-107 pattern-bannerlord-runtime-sprite-injection · M-108 pattern-measure-the-data-before-the-surface · M-109 pattern-host-registry-ownership · M-110 pattern-quantised-progression-eats-levels · M-111 pattern-checks-fail-closed · M-112 pattern-split-by-thing-and-job · M-113 principle-intersect-before-asking · M-114 principle-membership-is-per-element · M-115 principle-prefer-the-failure-that-shows · M-116 principle-verify-the-output-not-the-mechanism · M-117 principle-derived-beats-cached · M-118 pattern-added-persisted-field-is-null · M-119 pattern-bannerlord-itemtemplate-root-binding · M-120 pattern-bannerlord-configure-then-bind · M-121 pattern-render-census-against-the-palette · M-122 pattern-widen-signature-not-overload · M-123 principle-write-to-the-set-not-the-instance · M-124 principle-surface-audits-the-system · M-125 pattern-concurrent-session-ledger-and-commit · M-126 principle-dashboard-as-journey.

**The size check (`checks/G1-size.sh`, allowance 8,192 bytes / 40 entries):**

| Map contents | Bytes | Entries | Result |
|---|---|---|---|
| 30 base entries + all 96 drafted | 23,934 | 126 | FAIL |
| 30 base + the 16 root entries (M-95, M-98, M-100…M-103, M-107, M-109, M-110, M-112, M-118, M-120, M-122…M-125) | 9,532 | 46 | FAIL |
| 30 base entries only | 6,970 | 30 | PASS |

The map was left at the third row. Room under the allowance: 1,222 bytes — six to eight of these lines at most.
The one question to the pioneer is written at the top of `proposed-entries.md`. Consequences carried in the
upgraded copy: all 96 skills carry a `> **Map:**` header naming an id that is not in `MAP.md`; all 99 project
nodes carry `triggers: [M-NN]` for the same ids. Both were done because step 8 says to do them; both point at
nothing until the pioneer answers.

Other checks: `walk.sh` — "all 36 states match walk.expected". `INTENT.md` is 4,820 bytes (allowance 5,120).

---

## 6. What a session in the upgraded project sees at start

Final state (after the deferral marker and the removal of `.claude/kit-incoming/`), `CLAUDE_PROJECT_DIR` set to this folder.

**`session-start.sh`** (`{"source":"startup"}`) — `additionalContext`, unescaped:

```
Kit backlog (session-start hook):
- Drift entries watching or mitigated: 38 -> M-18 stay alert to those aspects
- Pioneer-owned items are waiting (candidates, map proposals, unratified entries, unranked cards, precedent conflicts or drift resolutions) -> M-16 kit-batch-assembler assembles the batch
Act on each line through its map entry, one kit task at a time. The pioneer does not need to invoke any of this.
```

Before the marker and the removal (the step-9 run, procedure order) it carried a third line: `- A newer kit is
staged in .claude/kit-incoming/ -> M-27 follow the STAGED kit's meta-bootstrap/SKILL.md, Upgrading an Existing
Install: rehearse on a copy first`. Every other hook printed valid JSON or nothing; `close-batch.sh B-001` and
`reveal-key.sh B-001` answered "No batch file" (correct: no batch). `telemetry.log` gained
`loaded|meta-map/MAP.md` from `post-read.sh` and `bypass|base-casebook|meta-casebook/CASEBOOK.yaml` from
`owner-check.sh`, as the install's Step 7 says it should.

**`stop-gate.sh`'s first task** (`{"stop_hook_active":false,"last_assistant_message":"Done."}`):

```
Kit mechanism (stop-gate): Pioneer-owned items are waiting: candidates, map proposals, unratified entries, unranked cards, precedent conflicts or drift resolutions. Launch the kit-batch-assembler subagent to assemble a batch, then present it per meta-skill-builder's review batch (M-16). Never read .claude/kit-sealed/, and while the batch is open your reads of the ledger are blocked so re-presented items stay indistinguishable. One kit task per turn. The pioneer does not need to invoke this.
```

Why this is the first task, read from the live records, not from the fresh-install expectation:

- 38 = 21 `watching` + 17 `mitigated` drift entries in the project's DRIFTLOG (one entry reads `status: elevated`, outside the enumeration, and is counted by nothing).
- The **17 `mitigated` entries are pioneer-owned drift-resolution items**. They alone make "Pioneer-owned items are waiting" true and put M-16 at the head of the gate. `ratification: deferred` suppresses only the 30 `proposed` base map entries; it does not touch drift resolutions. The first session after the real upgrade will therefore be asked to assemble a review batch — up to two drift resolutions per batch, from a backlog of seventeen — before any feature work, and `meta-skill-builder → Review Batch`, which that task loads, **does not exist in the kept skill** (section 2a).
- No contract line fires: with `verification_state: legacy` and `audited: legacy` on all 79 entries, the 14 `approved` and 46 `implemented` contracts are excluded from the audit, verifier, no-bearing and learning lines (12 `learned`, 0 `verified`). Without the legacy migration the output would have been identical: those lines key on `none`/`false`, which no entry carried either.
- No correction, ledger, casebook or founding line fires: the seeded files are empty, and `FOUNDING.md` holds a statement with no amendments.

`prompt-submit.sh` adds, every turn: "Kit: before acting, name this moment by its map id (meta-map/MAP.md) and
load what that entry points to. Close the turn with the drift score block from INTENT.md." — the INTENT.md block
(7 lines), while the kept `meta-antidrift/SKILL.md` prescribes 9.
