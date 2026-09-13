# Upgrade rehearsal — fx013, base kit 0.14 → 0.15

Run on 2026-09-13 in the throwaway copy at `scratchpad/fx013`, following the **staged** kit's
`meta-bootstrap/SKILL.md` → *Upgrading an Existing Install*, steps 3–9, with the pioneer's answers stubbed as
step 2 says (*keep* for every differing file, *remove* for the stale list). The running log is
`UPGRADE-REHEARSAL.log` beside this file.

**Result: the rehearsal fails its own pass condition.** Every decision asked belongs to a genuinely differing
file or is the stale-list question, but the third number is 1, not 0. Per step 2 the procedure is fixed in the
node and rehearsed again before the real run.

---

## 1. The three numbers

### Decisions asked: 2

| # | Question | Belongs to | Stubbed answer |
|---|---|---|---|
| Q1 | `meta-casebook/SKILL.md` differs from the incoming — overwrite with the incoming, keep yours, or port the incoming changes into yours by hand? | the one genuinely differing file | keep |
| Q2 | Remove the stale list: `.claude/agents/kit-canary-author.md`, `.claude/skills/agents/kit-canary-author.md`, `.claude/skills/meta-mechanisms/hooks/reveal-canaries.sh`, `.claude/skills/templates/REBUILD.template.yaml`? | the one stale-list question | remove |

### Files that genuinely differed: 1

| File | What differs from the incoming (three hunks, content-only) |
|---|---|
| `.claude/skills/meta-casebook/SKILL.md` | (1) `> **Map:**` header lists M-31; incoming does not — a kit change (contract-006). (2) `### The launch rebuild (M-31)` section here vs `### The rebuild — withdrawn from the map` in the incoming — a kit change. (3) `## Project addition` — "In this project, precedents about response shapes are reviewed with the API owner." — present here only. **This third hunk is the local evolution**; the first two are what the kit changed underneath it. |

Everything else classified **untouched here**: `sha1sum -c` over the 70-line baseline reported 69 OK and exactly
this one FAILED. (The installed `.md`/`.yaml` files are CRLF — 50 of them — while the incoming kit is LF; the
baseline was hashed over the CRLF bytes, so the hash check is sound. Byte diffs against the incoming are noisy
for that reason; content diffs with `--strip-trailing-cr` are small.)

### Troubleshooting steps: 1

| # | What I had to do that the procedure does not say | Why it was necessary |
|---|---|---|
| T1 | Retarget two lines in `.claude/skills/meta-map/MAP.md`: M-16 `agent: kit-canary-author` → `agent: kit-batch-assembler`; M-17 `script: reveal-canaries.sh` → `script: close-batch.sh, then reveal-key.sh` (the incoming template's wording). | Step 5 removes the stale files on the pioneer's answer; step 7 lists five files to migrate and `MAP.md` is not one of them; step 8 maps only *project* nodes. Followed literally, the upgraded map hands M-16 to an agent that no longer exists and M-17 to a script that no longer exists, while the new `stop-gate.sh` says "Launch the kit-batch-assembler". The first review batch would break. |

---

## 2. The classification presented (step 3, before any change)

**Untouched here** — hash matches the baseline → take the incoming version, no question asked:

- Agents (both `.claude/agents/` and the kit's `.claude/skills/agents/` copy): `kit-case-clerk`, `kit-consolidator`,
  `kit-map-steward`, `kit-reconstructor`, `kit-recorder`, `kit-session-auditor`, `kit-verifier`.
- Skills: `meta-antidrift`, `meta-antidrift-expand`, `meta-bootstrap`, `meta-contract-artifact`,
  `meta-contract-before-execution`, `meta-correction-log`, `meta-drift-eventlog`, `meta-extract`, `meta-foundation`
  (`SKILL.md` and `INTENT.md`), `meta-founding-contract`, `meta-learning`, `meta-ledger`, `meta-manifest`, `meta-map`,
  `meta-mechanisms`, `meta-skill-builder` — `SKILL.md` of each.
- Hooks: `batch-blind`, `close-batch`, `deny-paths`, `lib`, `owner-check`, `post-read`, `prompt-submit`,
  `session-start`, `stop-gate`, `subagent-stop`, `write-scope`.
- Tests: `fixtures/make-T-2.sh`, `walk-004.sh`, `walk.sh`, `walk.expected`, `results/T-2-2026-09-12.md`,
  `results/T-7-2026-09-12.md`, `results/contract-004-tiers.sha1`.
- Templates: `CASEBOOK`, `CONTRACT-LOG`, `CORRECTIONS`, `DRIFTLOG`, `FOUNDING`, `LEARNINGLOG`, `LEDGER`, `MANIFEST`,
  `MAP`, `settings`.

Of these, the ones whose *content* actually changed between 0.14 and 0.15 (the rest differ only by line endings):
`kit-case-clerk` (+Write, Bash; +checks/ write scope; precedent-to-check step), `kit-consolidator` (no bounds, no
pioneer score, coincidence), `kit-map-steward` (+stop-deferred and batch-blind telemetry), `kit-recorder`,
`kit-verifier` (+corrections_from_tests/reading), `meta-bootstrap` (the upgrade section itself, 6h, Step 7),
`meta-contract-before-execution` (disappointment, premortem, red test, cost), `meta-correction-log` (three incident
questions), `meta-drift-eventlog`, `meta-extract`, `INTENT.md` (rewritten opening, ratification note, precedents
"instruct, do not bind", cost), `meta-ledger` (independence redefined, bounds removed, re-presented items),
`meta-manifest`, `meta-map` (budget figures), `meta-mechanisms` (reveal-key, batch-assembler, M-07 cue),
`meta-skill-builder` (Against: question, reveal without canaries), hooks `batch-blind`, `owner-check` (import-loaded
owners), `session-start` (props/conflicts/mitigated in the pending count, staged-kit line), `stop-gate` (question
guard reads both ends; M-17 label), tests `walk-004.sh`, `walk.sh`, `walk.expected`, templates `CONTRACT-LOG`,
`CORRECTIONS`, `LEDGER`, `MANIFEST`, `MAP`.

**Evolved here** — one question: `meta-casebook/SKILL.md` (see section 1; answered *keep*).

**New in the kit** → add: `agents/kit-batch-assembler.md`; `hooks/reveal-key.sh`; `meta-mechanisms/checks/`
(`G1-size.sh`, `P-004.sh`, `P-005.sh`, `P-006.sh`, `P-007.sh`); `tests/walk-007.sh`; 23 files under
`tests/results/` (`T-1-T-3-2026-09-13.md`, `T-10-2026-09-13.md`, `T-1-T-3-fx010/`, `T-1-T-3-fx011/`,
`T-1-T-3-fx012/`, `T-10-fx009/`).

**Present here, absent from the incoming kit** → stale, one question: `.claude/agents/kit-canary-author.md`,
`.claude/skills/agents/kit-canary-author.md`, `.claude/skills/meta-mechanisms/hooks/reveal-canaries.sh`,
`.claude/skills/templates/REBUILD.template.yaml` (answered *remove*).

**Instance files** — never replaced, migrated in step 7: `CASEBOOK.yaml`, `CONTRACT-LOG.yaml`, `CORRECTIONS.yaml`,
`DRIFTLOG.yaml`, `FOUNDING.md`, `LEARNINGLOG.yaml`, `LEDGER.yaml`, `MANIFEST.yaml`, `MAP.md`, `telemetry.log`,
`INSTALLED.sha1`.

Also established before changing anything: `.claude/settings.json` is byte-identical to the incoming
`settings.template.json` and the CLAUDE.md `kit-block` is identical to the incoming Step 5a block (both step-5
merges are no-ops); `.gitignore` and `.gitattributes` already carry 5d; the 5e folders `meta-ledger/batches/` and
`meta-casebook/reconstruction/` and the 6h folder `meta-mechanisms/checks/` did not exist in the copy.

---

## 3. Every migration applied, file by file

### Step 5 — install (from `.claude/kit-incoming/`)

- **84 files copied** into `.claude/skills/` at their kit paths: 8 agents into `agents/`, 16 `meta-*` skill files
  (15 `SKILL.md` + `INTENT.md`), 12 hooks, 5 checks, 32 test files, 10 templates. Skipped: the 9 incoming instance
  files (the base kit's own ledger, corrections, casebook, map, logs, founding, manifest) and the kept
  `meta-casebook/SKILL.md`.
- **8 agents deployed** to `.claude/agents/` (7 refreshed, `kit-batch-assembler.md` new).
- **4 stale files removed** (the list in Q2).
- **Folders created:** `meta-ledger/batches/`, `meta-casebook/reconstruction/`, `meta-mechanisms/checks/`
  (the last populated by the copy).
- `settings.json`, `CLAUDE.md`, `.gitignore`, `.gitattributes`: no change (already identical / present).
- After install, `diff -rq --strip-trailing-cr` between `.claude/skills` and `kit-incoming`, instance files
  excluded, shows only the kept `meta-casebook/SKILL.md` and the two empty folders. No `.sh` has CRLF.

### Step 6 — seed: nothing (every instance file exists).

### Step 7 — additive schema migrations

`meta-contract-before-execution/CONTRACT-LOG.yaml` — entry `contract-001`
(`verification_state: none` and `audited: false` already present, left as they were):
```
     tier_3: |
       G-1 (UC-1) it returns 200
+    disappointment: legacy
+    premortem: legacy
+    red_test: legacy
     status: implemented
     ...
     revisions: []
+    cost: legacy
     work_id: null
```

`meta-correction-log/CORRECTIONS.yaml` — entry `C-001`:
```
     reason_given: |
       none given
+    noticed: not asked
+    would_have_been_right: not asked
+    seen_before: not asked
     supersedes: []
```

`meta-ledger/LEDGER.yaml` — `scores` (no batches, no candidates, so no `represented`/`lower_bound` work):
```
 scores:
   updated: null
   contracts: []
-  canary_catch_rate: null
-  brier_stated_confidence: null
-  brier_pioneer_decisions: null
+  coincidence: []
```

`meta-drift-eventlog/DRIFTLOG.yaml` — `entries: []`, nothing to add.

`meta-manifest/MANIFEST.yaml`:
```
-  base_kit_version: 0.14
+  base_kit_version: 0.15

-  - {id: agent-canary-author, concern: Assembles review batches and plants canaries, sealing the key, kind: agent, agent_file: agents/kit-canary-author.md, layer: meta, phase: post-build, load: fires, triggers: [M-16], status: thin, dependencies: [base-ledger, base-mechanisms], open_gaps: []}
+  - {id: agent-batch-assembler, concern: Assembles review batches from real items, re-presents decided ones from the fourth batch on, and seals the key, kind: agent, agent_file: agents/kit-batch-assembler.md, layer: meta, phase: post-build, load: fires, triggers: [M-16], status: thin, dependencies: [base-ledger, base-mechanisms], open_gaps: []}

-  - {concern: Gate instrumentation — canaries, node_id: agent-canary-author, layer: meta, phase: post-build, status: thin}
+  - {concern: Review batch assembly and re-presented items, node_id: agent-batch-assembler, layer: meta, phase: post-build, status: thin}
```
`kind`, `load`, `triggers` and `owns` were present on every node → untouched. The incoming template registers
no base node id that this manifest lacks (the only id change is the rename).

### Troubleshooting T1 — `meta-map/MAP.md` (not in the procedure)
```
-M-16 | review-due | hook: Stop | must | the stop-gate says pioneer-owned items wait, no batch open | — | agent: kit-canary-author, then meta-skill-builder → Review Batch | proposed
-M-17 | batch-decided | hook: Stop | must | every item in the open batch carries a decision | — | script: reveal-canaries.sh; meta-skill-builder → Reveal | proposed
+M-16 | review-due | hook: Stop | must | the stop-gate says pioneer-owned items wait, no batch open | — | agent: kit-batch-assembler, then meta-skill-builder → Review Batch | proposed
+M-17 | batch-decided | hook: Stop | must | every item in the open batch carries a decision | — | script: close-batch.sh, then reveal-key.sh; meta-skill-builder → Reveal | proposed
```
M-31 was left in place: with *keep* on `meta-casebook/SKILL.md` the kept skill still has its M-31 section, so the
entry is consistent with the node it points at (see 4c for what is not consistent).

### Step 8 — project nodes: none in the manifest → nothing drafted.

### Step 9 — baseline, checks, hooks

- `INSTALLED.sha1` regenerated with the 6j command: 94 lines; `sha1sum -c` verifies.
- Checks: `G1-size.sh`, `P-004.sh`, `P-005.sh`, `P-006.sh`, `P-007.sh` → all exit 0
  (`MAP.md` 7,121 bytes / 31 entries; `INTENT.md` 4,797 bytes).
- Hook checks (`CLAUDE_PROJECT_DIR` set): every script prints valid JSON or nothing; `stop-gate.sh` hands M-11
  (contract-001 is implemented and unaudited, which outranks the batch task); `batch-blind.sh` silent;
  `close-batch.sh`/`reveal-key.sh` → "No batch file"; telemetry ends `loaded|meta-map/MAP.md` then
  `bypass|base-casebook|meta-casebook/CASEBOOK.yaml`, as the bootstrap says it should.
- `.claude/kit-incoming/` **left in place** — its removal needs the pioneer's confirmation and step 2 stubs no
  answer for it. The session-start line about the staged kit therefore still prints.

---

## 4. Unclear, wrong or missing in the procedure — as hit

**4a — Missing: step 7 does not migrate `MAP.md`.** Verbatim, step 7 lists `CONTRACT-LOG.yaml`,
`CORRECTIONS.yaml`, `LEDGER.yaml`, `DRIFTLOG.yaml`, `MANIFEST.yaml`. The map is an instance file ("never
replaced"), it is the project's copy of a template that changed in 0.15, and two of its base entries name the
files step 5 removes. Nothing in steps 3–9 says what happens to base map entries whose target the kit renamed or
withdrew. This is T1. The same gap covers the eight other base lines the 0.15 template reworded (M-03, M-08,
M-09, M-10, M-23, M-24, M-28, M-29) and the withdrawn M-31: after a literal run they stay as 0.14 wrote them.

**4b — Unclear: what "the kit" is in step 3.** "Classify every skill, agent and hook script against
`INSTALLED.sha1`" names three kinds. The baseline also hashes `templates/`, `meta-mechanisms/tests/` and the kit's
own `.claude/skills/agents/` copy of the agents, and the paragraph above the steps says everything new comes from
the incoming `templates/` and `agents/`. I read "untouched → take the incoming version" as covering all of them.
Note that `P-004.sh` and `P-005.sh` scan `.claude/skills/agents/` first (`if [ -d "$kit/agents" ]`), so a
procedure that refreshed only `.claude/agents/` would have the checks reading stale agent copies. The procedure
should say which folders are the kit.

**4c — Missing: base node lines that changed in the template are not refreshed.** Step 7's manifest rule is
"gains `kind`, `load`, `triggers` if absent; gains `owns:` … ; renamed nodes renamed; new nodes registered;
`base_kit_version` set". All present here, so after a literal run: `base-skill-builder` concern still says
"canaries"; `agent-consolidator` still says "lower bounds"; the `base-ledger` coverage line still says
"canaries"; `base-mechanisms` `triggers` lacks the M-07 the 0.15 template adds; `base-casebook` still carries
`M-31` in `triggers` and `meta-casebook/REBUILD.yaml` in `owns` — and `REBUILD.yaml` has never existed in this
project (the 0.14 install did not seed it although 0.14's own 6h said to). `meta-manifest/SKILL.md` says the
template's base nodes and `base_kit_version` are "updated with every base kit release", but the upgrade step
carries only the version.

**4d — Unclear: instance-file header comments.** "Add what is missing, never change what is present" leaves the
schema comments at the top of `LEDGER.yaml` describing `kit-canary-author`, `lower_bound`, `canaries`,
`canary_catch_rate` and the two Brier scores that the same step removes from the file's data; `CONTRACT-LOG.yaml`'s
header does not list the four fields the step adds; `CORRECTIONS.yaml`'s header does not list the three probes.
The procedure does not say whether the header block counts as "present" or as template text to refresh.

**4e — Unclear: value shapes.** Step 7 gives values (`legacy`, `not asked`) but not forms. The template shows
`red_test` and `cost` as maps and `noticed` etc. as block scalars; I wrote plain scalars. Nothing reads them, but
the next migration or a schema check (gap-025) would need to know which form is canonical.

**4f — Wrong, in a hook the upgrade installs (pre-existing, observed at the Step 7 hook check):**
`session-start.sh` line 58 greps FOUNDING.md for `Not yet given|Deferred by the Pioneer`, and
`FOUNDING.template.md`'s own AGENT INSTRUCTIONS comment contains the literal `"*Deferred by the Pioneer on
[date].*"`. Every project whose FOUNDING.md keeps that comment — this one does, with a statement recorded — gets
"Founding statement not given or deferred -> M-24" every session. Same grep in 0.14, so not an upgrade effect,
but the upgrade re-ships it.

**4g — Missing: line endings.** The 0.14 install left 50 `.md`/`.yaml` files CRLF; the incoming is LF; after the
upgrade the tree is mixed (kit files LF, untouched instance files CRLF). The procedure mentions endings only for
`.sh` (5d). Harmless for the hooks, but it is why `diff -rq` between the two kits lists every file, and a future
"show the pioneer what differs" step that does not strip CRs would show whole-file diffs for files that differ
by nothing.

**4h — Unclear: the expected hook output on an upgrade.** Step 9 says run "the install's Step 7 hook checks";
Step 7's expectations describe a *fresh* install ("`stop-gate.sh` hands over the batch task (M-16)", "one backlog
line"). On an upgraded project with live records the gate hands whatever outranks it (here M-11) and the
backlog has several lines. The procedure should say what an upgrade is expected to show, or say that only
"valid JSON or nothing" is the check.

**4i — Minor:** the incoming `tests/results/` tree carries `T-1-T-3-fx010/kit-sealed/B-003.key` and
`T-1-T-3-fx011/kit-sealed/B-004.key`; `.gitignore`'s `.claude/kit-sealed/` does not match those nested paths, so
two "sealed" keys from the kit's own fixtures now sit in the project tree, committable. Also the 5e folders were
absent from the copy; step 5's "5b–5e … read the incoming copies instead" covers recreating them, so this is not
counted, but an upgrade should expect it (empty folders do not survive every copy).

**4j — Observation, not a procedure defect:** the incoming `INTENT.md` header reads "ratified by the pioneer
2026-09-13 (contract-006)". Taken as an untouched kit file, the project's always-loaded intent now states a
ratification this project's pioneer did not give.

---

## Final tally

- decisions asked: **2** (Q1 `meta-casebook/SKILL.md`; Q2 the stale list)
- files that genuinely differed: **1** (`meta-casebook/SKILL.md`)
- troubleshooting steps: **1** (T1, `MAP.md` M-16/M-17 retarget)
