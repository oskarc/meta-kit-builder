# Upgrade rehearsal — fx013, base kit 0.14 -> 0.15

Rehearsal log kept as `.claude/kit-incoming/meta-bootstrap/SKILL.md` -> *Upgrading an Existing Install*, step 2 directs.
This folder is the throwaway copy; steps 3–9 were run on it directly with the pioneer's answers stubbed
(*keep* / *remove* / *legacy* / *none for now* / *defer* / report accepted). Moment named: M-27. Date: 2026-09-13.

---

## 1. The three numbers

**Decisions asked: 4**
1. `meta-casebook/SKILL.md` is evolved here — *overwrite with the staged, keep yours, or port?* -> stubbed **keep**. (Belongs to the one file that genuinely differed.)
2. The stale list (step 3, standing question) — *remove every file on the list?* -> stubbed **remove**.
3. The contracts the pioneer may name for verification (step 7, standing question) — *should any recent implemented contract be verified and audited instead of legacy?* -> stubbed **legacy / none named**.
4. The ratification pass (step 9, standing question) -> stubbed **defer**.

Not asked: the map question (step 8) — the project has no non-base nodes, nothing was drafted, and `G1-size.sh` passed. The pioneer's acceptance of the report at the end was stubbed and is not counted, as the criterion says.

**Files that genuinely differed: 1**
1. `.claude/skills/meta-casebook/SKILL.md` — hash matched neither the raw-byte baseline nor its CRLF re-hash. It carries a `## Project addition` section the kit never shipped ("In this project, precedents about response shapes are reviewed with the API owner.").

Every other baseline path (69 of 70) matched: 23 by the LF hash, 46 by the CRLF re-hash the procedure prescribes for a pre-0.15 baseline. `walk.expected` and `settings.template.json` were not in the old baseline and are untouched by rule.

**Troubleshooting steps: 0**
Nothing had to be done that the steps do not say: every file the steps name was where they said, every copy, merge, migration, check, hook command and the 36-state walk succeeded on the first run, and no procedure text had to be worked around. Disclosed in full so the pioneer can weigh it: I spent three extra shell probes on my own tooling, not on the procedure — my first baseline comparison diffed the two files' line *formats* instead of comparing hash to hash keyed by path (redone correctly at once), and later two plain `diff` outputs showed whole files as changed where only a line-ending had changed, which I chased until `tr -cd '\r' | wc -c` showed the fixture's files had been CRLF and my `grep $'\r'` probe could not see CRs. No file was altered by any of that, and the bootstrap's own text already anticipates the mixed endings ("a mixed tree is expected and harmless, and no step checks or repairs endings"). I count it as zero because the procedure never failed and nothing was fixed; if the pioneer reads "had to do" as "did", the count is one and the rehearsal fails on their reading, not on the criterion as written.

**Criterion:** every decision asked belongs to a file that genuinely differed (decision 1) or is one of the four standing questions (decisions 2, 3, 4 — the map question was not needed), and the third number is zero. **The rehearsal PASSES.**

---

## 2. The classification presented (step 3, into this log — no one to present to)

Step 1 first: staged `kit_identity.version` **0.15**, project `base_kit_version` **0.14**, field present -> upgrade.

Baseline `meta-manifest/INSTALLED.sha1`: 70 lines, every path with a leading `*` (pre-0.15, raw-byte hashes). The 6j recompute went to `RECOMPUTED.sha1.tmp` in the project root (72 lines) and was removed at the end.

### Untouched here -> take the staged version, no question
- Skills (16 SKILL.md + INTENT.md): `meta-antidrift-expand`, `meta-antidrift`, `meta-bootstrap`, `meta-contract-artifact`, `meta-contract-before-execution`, `meta-correction-log`, `meta-drift-eventlog`, `meta-extract`, `meta-foundation` (SKILL.md, INTENT.md), `meta-founding-contract`, `meta-learning`, `meta-ledger`, `meta-manifest`, `meta-map`, `meta-mechanisms`, `meta-skill-builder`
- Agents (kit copy `.claude/skills/agents/` and deployed `.claude/agents/`): `kit-case-clerk`, `kit-consolidator`, `kit-map-steward`, `kit-reconstructor`, `kit-recorder`, `kit-session-auditor`, `kit-verifier`
- Hooks (11): `batch-blind`, `close-batch`, `deny-paths`, `lib`, `owner-check`, `post-read`, `prompt-submit`, `session-start`, `stop-gate`, `subagent-stop`, `write-scope`
- Templates (10): `CASEBOOK`, `CONTRACT-LOG`, `CORRECTIONS`, `DRIFTLOG`, `FOUNDING`, `LEARNINGLOG`, `LEDGER`, `MANIFEST`, `MAP`, `settings.template.json`
- Tests: `walk.sh`, `walk.expected`

Of these the staged copy is text-different from the installed one for 5 agents (case-clerk, consolidator, map-steward, recorder, verifier), 11 skill files (bootstrap, contract-before-execution, correction-log, drift-eventlog, extract, INTENT.md, ledger, manifest, map, mechanisms, skill-builder), 4 hooks (batch-blind, owner-check, session-start, stop-gate), walk.sh, walk.expected and 5 templates (CONTRACT-LOG, CORRECTIONS, LEDGER, MANIFEST, MAP). The remaining copies were content no-ops.

### Evolved here -> one question (asked, stubbed keep)
- `meta-casebook/SKILL.md`. What differs from the staged copy, in a few lines: (a) header line 6 names `M-31` and "— or the milestone in REBUILD.yaml has been reached", staged names `M-04, M-05, M-26` only; (b) section `### The launch rebuild (M-31)` (11 lines on REBUILD.yaml, milestone, oracle, arms, frozen_on) where the staged copy has `### The rebuild — withdrawn from the map` (one paragraph pointing at `docs/rebuild-design.md`); (c) a `## Project addition` section at the end that the kit never shipped — the local evolution.

### New in the kit -> add
- `agents/kit-batch-assembler.md` (kit copy and deployed), `meta-mechanisms/hooks/reveal-key.sh`, `meta-mechanisms/checks/G1-size.sh` (folder created).
- Present in the staged folder but not installed, per *What "the kit" is*: `checks/P-004.sh … P-007.sh` (their precedent ids are not in this project's casebook, which is empty), `tests/results/` (24 files), `tests/walk-004.sh`, `tests/walk-007.sh`, `tests/fixtures/make-T-2.sh`, `tests/fixtures/make-upgrade-fixtures.sh`, and the staged kit's own instance files.

### Present here, absent from the staged kit -> stale list (asked once, stubbed remove)
| Stale file | Kept file that still referred to it at classification time |
|---|---|
| `.claude/agents/kit-canary-author.md` and `.claude/skills/agents/kit-canary-author.md` | `MANIFEST.yaml` node `agent-canary-author` + coverage line (rename rule, step 7); `MAP.md` M-16 (template rule); `LEDGER.yaml` header line 11 (template rule). After step 7: nothing. |
| `.claude/skills/meta-mechanisms/hooks/reveal-canaries.sh` | `MAP.md` M-17 (template rule). After step 7: nothing. |
| `.claude/skills/templates/REBUILD.template.yaml` | **`meta-casebook/SKILL.md` (kept) line 63**; `MANIFEST.yaml` base-casebook `owns` and `triggers` (template rule); `MAP.md` M-31 (withdrawn). After step 7: the kept casebook skill only. |
| `tests/results/T-2-2026-09-12.md`, `tests/results/T-7-2026-09-12.md`, `tests/results/contract-004-tiers.sha1` | nothing kept |
| `tests/walk-004.sh` | nothing kept (the installed mechanisms node named it; it is replaced by the staged node, which says it does not travel) |
| `tests/fixtures/make-T-2.sh` | nothing kept |

### Instance files — never replaced
`MANIFEST.yaml`, `MAP.md`, `FOUNDING.md`, `CONTRACT-LOG.yaml` (1 contract), `LEARNINGLOG.yaml`, `DRIFTLOG.yaml`, `LEDGER.yaml`, `CORRECTIONS.yaml` (1 correction), `CASEBOOK.yaml`, `INSTALLED.sha1`. No `telemetry.log` existed. Template-rule findings: `MAP.md` equalled the installed template with the name substituted (every base entry as the template wrote it); `MANIFEST.yaml` equalled the installed template with three placeholders substituted and the two placeholder comment lines removed (every base node and coverage line as the template wrote it, no project or inherited nodes); every instance header block equalled its installed template's. Nothing had been reworded by the pioneer, so no per-file question arose for an instance file.

### Other state found
`meta-ledger/batches/` and `meta-casebook/reconstruction/` missing (5e); `.gitignore` and `.gitattributes` entries present (5d); `settings.json` content-identical to the staged template, every group `_kit`-marked, every script it names exists in the staged kit; `CLAUDE.md` has the markers and its block equals the staged 5a block. No hooks fired mid-upgrade: this rehearsal ran as an agent session outside the project's own Claude Code session, so the half-migrated state the bootstrap warns about was not observed.

---

## 3. Every migration applied, file by file (diff summaries)

Step 5 (install) and step 7 (migrate). "->" is before -> after.

- **`.claude/skills/meta-*/SKILL.md` (16) and `meta-foundation/INTENT.md`** — replaced by the staged copies. Content changes summarised: INTENT.md rewritten to the contract-006 form (new header comment, "The standard is already known" opening, "The pioneer is named for the journey", stop-triggers list moved to meta-antidrift, four new "how work moves" bullets: contract is the pioneer's test, corrections are where the standard gets written, precedents are learned from, record the cost); bootstrap gains the whole 0.15 upgrade section and 6j's CR-stripping baseline; contract-before-execution gains disappointment, pre-mortem, red test, cost; correction-log gains the three incident questions; drift-eventlog, extract, ledger, manifest, map, mechanisms, skill-builder: canaries -> re-presented items, canary-author -> batch-assembler, reveal-canaries -> reveal-key, no computed bound, nothing scores the pioneer, budget text 30 entries / 6,974 bytes. `meta-antidrift`, `meta-antidrift-expand`, `meta-contract-artifact`, `meta-foundation/SKILL.md`, `meta-founding-contract/SKILL.md`, `meta-learning/SKILL.md`: byte-identical after CR stripping (no-op).
- **`.claude/skills/agents/*.md` and `.claude/agents/*.md`** — 7 replaced (case-clerk: tools + `meta-mechanisms/checks/` write scope + "From precedent to check"; consolidator: no bound, coincidence, verifier grade; map-steward: reads `stop-deferred` and `batch-blind` lines; recorder: wording; verifier: launch carries only the id, `corrections_from_tests/reading`; reconstructor and session-auditor no-op), 1 added (`kit-batch-assembler.md`), 1 removed (`kit-canary-author.md`).
- **`meta-mechanisms/hooks/`** — 11 replaced (batch-blind: wording; owner-check: import-loaded owners `INTENT.md|MAP.md|FOUNDING.md` count as loaded; session-start: `ratification: deferred` respected, conflicts and mitigated drift counted, founding-deferral grep anchored, staged-kit line; stop-gate: question guard checks both sides of the block, M-17 in the close message, reveal-key wording; 7 no-op), `reveal-key.sh` added, `reveal-canaries.sh` removed.
- **`meta-mechanisms/checks/G1-size.sh`** — added (folder created). **`tests/walk.sh`, `walk.expected`** — replaced (walk now fails on mismatch; expected text names batch-assembler and reveal-key). **`tests/walk-004.sh`, `tests/fixtures/`, `tests/results/`** — removed.
- **`templates/`** — 10 replaced (CONTRACT-LOG: `approval: approved-at-gate`, disappointment, premortem, red_test, closed-by-follow-up, corrections_from_*, cost; CORRECTIONS: noticed/would_have_been_right/seen_before; LEDGER: one-writer list, batch-assembler, evidence grade, no lower_bound, outcome unobserved, represented, coincidence; MANIFEST: 0.15 and the base lines below; MAP: the entry columns below; 5 no-op), `REBUILD.template.yaml` removed.
- **`.claude/settings.json`** — every `_kit` hook group replaced by the staged group. Content diff after CR stripping: none. (The file was CRLF; it is LF now.)
- **`CLAUDE.md`** — block between `kit-block` markers replaced by the staged 5a block. Diff: none.
- **Folders** — `meta-ledger/batches/`, `meta-casebook/reconstruction/`, `meta-mechanisms/checks/` created.
- **`CONTRACT-LOG.yaml`** — header comment block refreshed from the staged template (21 changed lines: `approval: approved-at-gate` note, disappointment/premortem, tier_4 wording, red_test, `closed-by-follow-up`, corrections_from_tests/reading, cost). Entry contract-001: `verification_state: none` and `audited: false` present -> unchanged ("never change a value that is present"); added `disappointment: legacy`, `premortem: legacy`, `red_test: legacy` after `tier_3` (no `tier_4` exists) and `cost: legacy` after `revisions`, at the template's positions; `approval: gate` left as is.
- **`CORRECTIONS.yaml`** — header refreshed (6 added comment lines). Entry C-001: added `noticed: not asked`, `would_have_been_right: not asked`, `seen_before: not asked` after `reason_given`, before `supersedes`.
- **`LEDGER.yaml`** — header refreshed (one-writer list, batch-assembler, evidence_refs grade, `lower_bound` line dropped, outcome, represented, scores). `scores`: `canary_catch_rate`, `brier_stated_confidence`, `brier_pioneer_decisions` removed, `coincidence: []` added. No batches, no candidates to touch.
- **`DRIFTLOG.yaml`, `CASEBOOK.yaml`, `LEARNINGLOG.yaml`** — header refreshed from staged templates that are identical to the installed ones: content diff none (these three came out LF where they had been CRLF). No entries, so no elevation to touch. **`FOUNDING.md`** — untouched (its template is identical between versions; the statement is the pioneer's).
- **`MANIFEST.yaml`** — regenerated by the template rule (every base line equalled the installed template's); 7 hunks: `base_kit_version: 0.14 -> 0.15`; `base-skill-builder` concern "canaries" -> "re-presented items"; `base-casebook` `owns` loses `meta-casebook/REBUILD.yaml`, `triggers` loses `M-31`; `base-mechanisms` `triggers` gains `M-07`; `agent-consolidator` concern -> "counters by reading, fading, outcomes, scores that never score the pioneer"; node `agent-canary-author` -> `agent-batch-assembler` (whole line: concern, `agent_file: agents/kit-batch-assembler.md`); coverage line `base-ledger` concern "canaries" -> "re-presented items"; coverage line "Gate instrumentation — canaries / agent-canary-author" -> "Review batch assembly and re-presented items / agent-batch-assembler". `kind`, `load`, `triggers`, `owns`, `library_kit` were all already present. No placeholder left; no duplicate id.
- **`MAP.md`** — regenerated by the template rule (every base entry equalled the installed template's), status column `proposed` on all 30 kept: M-03, M-28, M-24, M-29, M-08, M-09, M-10, M-23 take the staged columns; M-16 `agent: kit-canary-author` -> `agent: kit-batch-assembler`; M-17 `script: reveal-canaries.sh` -> `script: close-batch.sh, then reveal-key.sh`; M-31 removed (withdrawn, not reworded). Step 9: `ratification: deferred` added as a line inside the header comment. 6,989 bytes, 30 entries.
- **`meta-casebook/SKILL.md` (kept)** — header line 6: `M-04, M-05, M-26, M-31 ·` -> `M-04, M-05, M-26 ·`; nothing else touched (the file came out LF where it had been CRLF).
- **`INSTALLED.sha1`** — regenerated after the marker: 68 lines, CR-stripped hashes, no leading `*`.
- **`telemetry.log`** — created by the step 9 hook run (`session-start`, `prompt`, `stop-gate`, `subagent|kit-verifier`, `loaded|meta-map/MAP.md`, `bypass|base-casebook|meta-casebook/CASEBOOK.yaml`).
- **Removed at the end:** `.claude/kit-incoming/`, `RECOMPUTED.sha1.tmp`.

### Kept files that still describe something the staged kit removed or renamed (for the pioneer at the real run)
- `meta-casebook/SKILL.md` line 6: "… — or the milestone in REBUILD.yaml has been reached …" (REBUILD.yaml no longer exists in the kit; M-31 is gone from the map).
- `meta-casebook/SKILL.md` lines 59–69: `### The launch rebuild (M-31)` — names `REBUILD.yaml`, `templates/REBUILD.template.yaml`, `frozen_on`, `M-31`. The staged node replaced this with a withdrawal note pointing at `docs/rebuild-design.md`.
- Its `## Project addition` (the reason it was kept) survives intact.

---

## 4. Unclear, wrong or missing in the procedure, verbatim as hit

1. **Step 7, CONTRACT-LOG, against the step 2 stub.** Step 2 says to stub *"legacy for every existing contract (step 7)"*; step 7 says *"every existing entry gains `verification_state: legacy` and `audited: legacy` if absent"* and *"never change a value that is present"*. contract-001 already carries `verification_state: none` and `audited: false`, so the stub and the additive rule pull apart. I followed "never change a value that is present" and left both, asked the standing question anyway (stubbed: none named). The stub text assumes pre-0.14 entries that lack the fields; it should say what "legacy" means for an entry that already has them.
2. **Step 5, the settings merge, has no mechanics.** *"the settings merge — replacing the hook groups whose `"_kit"` key marks them as the kit's (never appending a second group for the same event), and removing groups whose scripts no longer exist"* — with bash/sed/awk only (meta-mechanisms → Portability: no jq) there is no stated way to replace a JSON group inside a file that also holds the project's own hooks. Here it reduced to copying the template because the file held only kit groups plus the deny entry. A project with its own hooks would need a command this step does not give.
3. **Step 7, line endings:** *"kit files arrive with LF endings"* did not hold: three staged skill files — `meta-antidrift/SKILL.md`, `meta-antidrift-expand/SKILL.md`, `meta-contract-artifact/SKILL.md` — arrived CRLF (`cp` is byte-exact; they carry 109, 155 and 362 CR bytes now). Harmless per the same paragraph, and they are .md not .sh, but the sentence is a claim the staging did not meet. Also observed, and anticipated by the text: `settings.json`, the kept casebook skill, `LEDGER.yaml`, `DRIFTLOG.yaml`, `CASEBOOK.yaml`, `LEARNINGLOG.yaml` came out LF where they had been CRLF.
4. **Step 3, the stale list vs "new in the kit":** *"P-NNN.sh checks whose precedent id is not in this project's casebook … goes on the same list"* reads as if such checks are already installed. On a 0.14 install no `checks/` folder exists, so the P-checks are neither stale nor new-to-add; I listed them under "new in the kit, not installed" by *What "the kit" is*. The two passages could say which list a never-installed P-check belongs on (or that it belongs on neither).
5. **Step 3, "Read both kits in full":** done as full reads of every instance file, template, hook, check and the walk, plus full `diff`s of every kit file that differs between the installed and staged copies; files identical after CR stripping were not re-read twice. If "in full" means every byte of every SKILL.md regardless of a clean diff, say so.
6. **The rehearsal cannot see the live-session state the text warns about:** *"An upgrade runs in a live session, so the hooks fire throughout it against a half-migrated project … the rehearsal on a copy is where that state is first seen"* — a rehearsal run by an agent outside the project's own Claude Code session (as here) has no hooks firing, so that state was not seen. The real run will be the first time.
7. Nothing else was unclear: the 6j command, the CRLF re-hash, the leading-`*` rule, the template rule, the additive field list, the marker placement, the check and hook expectations (`exit 1` for close/reveal, the `loaded` line, the staged-kit line until removal) all read correctly and matched what happened.

---

## 5. State after the upgrade

**`MAP.md` M-16 and M-17:**
```
M-16 | review-due | hook: Stop | must | the stop-gate says pioneer-owned items wait, no batch open | — | agent: kit-batch-assembler, then meta-skill-builder → Review Batch | proposed
M-17 | batch-decided | hook: Stop | must | every item in the open batch carries a decision | — | script: close-batch.sh, then reveal-key.sh; meta-skill-builder → Reveal | proposed
```
No `M-31` in the map. Header comment carries `ratification: deferred`. 6,989 bytes, 30 entries.

**Manifest `base-casebook` node and coverage line:**
```
- {id: base-casebook, concern: Binding precedents with their facts, scenario cards, reconstruction tests, kind: record, skill_file: meta-casebook/SKILL.md, data_file: meta-casebook/CASEBOOK.yaml, owns: [meta-casebook/CASEBOOK.yaml, meta-casebook/reconstruction/, meta-casebook/SKILL.md], layer: meta, phase: [pre-build, post-build], load: trigger, triggers: [M-04, M-05, M-26], status: thin, dependencies: [base-correction-log], open_gaps: []}
- {concern: Binding precedents and reconstruction, node_id: base-casebook, layer: meta, phase: [pre-build, post-build], status: thin}
```
`base_kit_version: 0.15`; `agent-batch-assembler` registered (node + coverage); no "canary" anywhere in the manifest.

**Kept `meta-casebook/SKILL.md` header:**
```
> **Map:** M-04, M-05, M-26 · **Load:** retrieved on trigger by moment tag · **Recognise it by:** "we have decided a situation like this before" — or the milestone in REBUILD.yaml has been reached · **Not when:** the question is what the rule says (that is the node) rather than how it was applied
```

---

## 6. Folder and walk

- `.claude/kit-incoming/` — **gone** (removed after the stubbed acceptance of the report). The session-start hook run afterwards no longer prints the staged-kit line; its backlog is the project's live records: 1 contract implemented and unaudited (M-11), 1 without verification evidence (M-12), 1 correction unclerked (M-15).
- `RECOMPUTED.sha1.tmp` — gone.
- `checks/G1-size.sh` — passes (exit 0; INTENT.md 4,820 bytes, MAP.md 6,989 bytes / 30 entries).
- Install Step 7 hook commands — every hook printed valid JSON or nothing; `close-batch.sh B-001` and `reveal-key.sh B-001` reported "No batch file" with exit 1 (the expected result); `telemetry.log` gained its `loaded|meta-map/MAP.md` line and the `bypass|base-casebook|…` ownership line.
- `tests/walk.sh` in the upgraded project — **passes**: `walk: all 36 states match walk.expected`, exit 0.
- Stale names left in the upgraded tree: only the two lines of the kept casebook skill listed in section 3, and the bootstrap's own sentence that names the stale files as examples.
