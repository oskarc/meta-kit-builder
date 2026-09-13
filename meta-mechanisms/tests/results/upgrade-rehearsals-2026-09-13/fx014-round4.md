# Upgrade rehearsal — fx013, base kit 0.14 → 0.15

Run on 2026-09-13 in this folder (already a throwaway copy of the project). Procedure followed: the **staged** kit's
`meta-bootstrap/SKILL.md → Upgrading an Existing Install`, steps 1–9, with the pioneer's answers stubbed as step 2
says: *keep* for every differing file or template part, *remove* for the stale list, *legacy* for every existing
contract, *defer* for the ratification pass, and the report accepted at the end. `CLAUDE_PROJECT_DIR` was set to this
folder for every hook and check. The working log is reproduced in full under sections 3 and 6.

---

## 1. The three numbers

**Decisions asked: 2**
- D-1 — the stale list, one question for the whole list (step 3, standing question). Stub: *remove*.
- D-2 — the ratification pass (step 9, standing question). Stub: *defer*.
- Not counted, by the rule: the pioneer's acceptance of the report at the end (stub: accepted → `.claude/kit-incoming/` removed).
- Not asked, and therefore not counted: a per-file *overwrite / keep / port* question — no file differed (see next number); a
  per-contract *verify and audit* question — step 7's CONTRACT-LOG line adds `verification_state: legacy` and
  `audited: legacy` only *if absent*, and contract-001 already carries `none` / `false`, so nothing was asked and the
  *legacy* stub had no question to answer (see section 4, item 1).

**Files that genuinely differed: 0**
- Every one of the 70 paths in the 0.14 `INSTALLED.sha1` matched: 22 directly, 47 only after the pre-0.15 rule
  (raw-byte baseline; re-hash with CRLF endings added) — every `.md` and `.yaml` on this Windows install was re-saved
  CRLF, the `.sh` files stayed LF. `tests/walk.expected` and `templates/settings.template.json` were never listed by
  the 0.14 pattern → untouched, not evolved. No file classified *evolved here*.
- Template parts: MAP.md, MANIFEST.yaml and FOUNDING.md are byte-identical to the 0.14 templates after placeholder
  substitution; the header comment of all six YAML instance files is identical to its 0.14 template header. No template
  part was changed by the pioneer → refreshed from the staged templates, no question.

**Troubleshooting steps: 0** — nothing had to be done that steps 3–9 do not say.
- Disclosed, not counted: one execution slip of my own in step 9. My first `sed` to add `ratification: deferred`
  matched `__PROJECT_NAME__`, but MAP.md already reads `fx013`, so nothing was written; I had already run 6j once
  before noticing. I re-ran the step as written (marker with the correct pattern, then 6j again) — the step itself
  needed no change. If the pioneer counts an agent's own slip as a troubleshooting step, this number is 1 and the
  rehearsal fails on the criterion below; I do not, because the criterion is about what the *procedure* fails to say.

**Verdict against the bootstrap's own criterion** ("every decision asked belongs to a file or template part that genuinely
differed or is one of the two standing questions … and the third number is zero"): **PASS** — both decisions are the two
standing questions, and the third number is 0.

---

## 2. The classification presented (step 3)

Baseline recomputed with the 6j command into a temporary file; compared hash to hash, keyed by path, leading `*` dropped.

### Untouched here → staged version taken, no question

| Group | Files | Of which differ in content from staged (real change on take) |
|---|---|---|
| Skills | 18: `meta-antidrift`, `meta-antidrift-expand`, `meta-bootstrap`, `meta-casebook`, `meta-contract-artifact`, `meta-contract-before-execution`, `meta-correction-log`, `meta-drift-eventlog`, `meta-extract`, `meta-foundation/SKILL.md`, `meta-foundation/INTENT.md`, `meta-founding-contract`, `meta-learning`, `meta-ledger`, `meta-manifest`, `meta-map`, `meta-mechanisms`, `meta-skill-builder` | 13: bootstrap, casebook, contract-before-execution, correction-log, drift-eventlog, extract, INTENT.md, ledger, manifest, map, mechanisms, skill-builder (+ antidrift-expand/antidrift/contract-artifact/foundation SKILL/founding-contract/learning identical) |
| Agents, kit copy `skills/agents/` | 7: case-clerk, consolidator, map-steward, reconstructor, recorder, session-auditor, verifier | 5: case-clerk, consolidator, map-steward, recorder, verifier |
| Agents, deployed `.claude/agents/` | the same 7 | the same 5 |
| Hooks | 11: batch-blind, close-batch, deny-paths, lib, owner-check, post-read, prompt-submit, session-start, stop-gate, subagent-stop, write-scope | 4: batch-blind, owner-check, session-start, stop-gate |
| Templates | 10: CASEBOOK, CONTRACT-LOG, CORRECTIONS, DRIFTLOG, FOUNDING, LEARNINGLOG, LEDGER, MANIFEST, MAP, settings | 5: CONTRACT-LOG, CORRECTIONS, LEDGER, MANIFEST, MAP |
| Tests | `walk.sh`, `walk.expected` | both |

### Evolved here → none

### New in the kit → added
- `agents/kit-batch-assembler.md` → `.claude/skills/agents/` and `.claude/agents/`
- `meta-mechanisms/hooks/reveal-key.sh`
- `meta-mechanisms/checks/G1-size.sh` (folder created)

Present in the staged folder but **not part of "the kit"** and not taken: `checks/P-004.sh … P-007.sh` (base kit precedents;
none of P-004…P-007 is in this project's casebook), `tests/walk-004.sh`, `tests/walk-007.sh`, `tests/fixtures/`,
`tests/results/` (27 files), and the base kit's own instance files (its manifest, map, ledger, corrections, casebook,
logs, FOUNDING.md).

### Stale — present here, absent from the staged kit (D-1, one question; stub *remove*)
| File | Kept file still referring to it |
|---|---|
| `.claude/agents/kit-canary-author.md` | none — MAP.md M-16 and the manifest `agent-canary-author` node are template parts refreshed in step 7 |
| `.claude/skills/agents/kit-canary-author.md` | none (same) |
| `.claude/skills/meta-mechanisms/hooks/reveal-canaries.sh` | none — MAP.md M-17 refreshed; `stop-gate.sh` replaced |
| `.claude/skills/templates/REBUILD.template.yaml` | none — MAP.md M-31 withdrawn; manifest `base-casebook` line refreshed; `meta-casebook/SKILL.md` and `meta-bootstrap/SKILL.md` replaced |
| `.claude/skills/meta-mechanisms/tests/results/T-2-2026-09-12.md`, `T-7-2026-09-12.md`, `contract-004-tiers.sha1` | none — the base kit's evidence, carried by the 0.14 install |
| `.claude/skills/meta-mechanisms/tests/walk-004.sh` | none — the base kit's contract walk |
| `.claude/skills/meta-mechanisms/tests/fixtures/make-T-2.sh` | none |

`meta-manifest/INSTALLED.sha1` is also absent from the staged folder but is an instance file: never replaced, regenerated in step 9.

Kept files that still describe something the staged kit removed or renamed (for the pioneer to weigh at the real run):
**none** — no file was kept in its installed form. After the upgrade, the only mentions of `canary`, `reveal-canaries`,
`REBUILD` or `M-31` in the tree are the staged bootstrap's own history text (its stale-list example and its migration
list) and `meta-map/SKILL.md`'s budget note ("contract-004 added M-31; contract-006 withdrew it").

Also found in step 3 and recreated in step 5 (the copy had lost them): `meta-ledger/batches/`, `meta-casebook/reconstruction/`.
`.gitignore` already carried `.claude/kit-sealed/`; `.gitattributes` already carried `*.sh text eol=lf`.

---

## 3. Every change applied, file by file

### Step 5 — install (from the staged copies)
- 18 skill files overwritten with the staged version (content changes as in the "differ" column above; the five identical ones now carry LF instead of CRLF, nothing else).
- 10 templates overwritten; `templates/REBUILD.template.yaml` deleted (stale, D-1).
- 12 hooks written (11 overwritten, `reveal-key.sh` new); `hooks/reveal-canaries.sh` deleted (stale, D-1).
- `checks/G1-size.sh` added; `checks/` created.
- `tests/walk.sh`, `tests/walk.expected` overwritten; `tests/results/`, `tests/fixtures/`, `tests/walk-004.sh` deleted (stale, D-1).
- 8 agents written to `skills/agents/` and to `.claude/agents/` (`kit-batch-assembler.md` new); `kit-canary-author.md` deleted from both (stale, D-1).
- `settings.json`: every hook group carries `"_kit": "base-building-kit"`; the staged template is identical to it once CR is stripped, so the replacement changes nothing; no group names a script that no longer exists. File left as it is (CRLF).
- `CLAUDE.md`: the staged 5a block is identical to the block between the existing `kit-block` markers — no change.
- `meta-ledger/batches/`, `meta-casebook/reconstruction/` created (5e).

### Step 6 — seed missing instance files
All eight exist (DRIFTLOG, CONTRACT-LOG, LEARNINGLOG, LEDGER, FOUNDING, MAP, CORRECTIONS, CASEBOOK); none replaced, none seeded.

### Step 7 — migrations (diff, before → after; instance files keep their endings: LEDGER.yaml CRLF, the rest LF)

**`meta-contract-before-execution/CONTRACT-LOG.yaml`** — header comment refreshed from the staged template (template rule);
contract-001 gains the four contract-006 fields at the template's positions; `approval: gate` left as is; `verification_state: none` / `audited: false` present, unchanged.
```
header: approval: gate → approved-at-gate (with the pre-0.15 note); + disappointment / premortem schema lines;
        tier_4 description reworded; + red_test; verification_state gains closed-by-follow-up;
        + corrections_from_tests / corrections_from_reading under verification; + cost
body:   tier_3 … | +    disappointment: legacy
                  | +    premortem: legacy
                  | +    red_test: legacy
        revisions: [] | +    cost: legacy
```

**`meta-correction-log/CORRECTIONS.yaml`** — header refreshed; C-001 gains the three incident fields after `reason_given`.
```
header: + noticed / would_have_been_right / seen_before schema lines
body:   reason_given … | +    noticed: not asked
                       | +    would_have_been_right: not asked
                       | +    seen_before: not asked
```

**`meta-ledger/LEDGER.yaml`** — header refreshed (one-writer list, kit-batch-assembler, evidence_refs grade, `lower_bound` line gone,
`outcome` reworded, `canaries`/`canaries_caught` → `represented`, scores schema); no batches, no candidates to migrate; scores:
```
-  canary_catch_rate: null
-  brier_stated_confidence: null
-  brier_pioneer_decisions: null
+  coincidence: []
```

**`meta-drift-eventlog/DRIFTLOG.yaml`** — no entries; the 0.14 and 0.15 templates are identical → no change.
**`meta-casebook/CASEBOOK.yaml`, `meta-learning/LEARNINGLOG.yaml`, `meta-founding-contract/FOUNDING.md`** — templates identical → no change.

**`meta-manifest/MANIFEST.yaml`** — every base node line and base coverage line read as the 0.14 template wrote them → the
staged template's lines; `kit_name: fx013`, `kit_type: project`, `category: test-api`, `library_kit: null` as declared.
```
-  base_kit_version: 0.14
+  base_kit_version: 0.15
   base-skill-builder   concern: "… verdict before evidence, canaries, …" → "… re-presented items, …"
   base-casebook        owns: [CASEBOOK.yaml, reconstruction/, REBUILD.yaml, SKILL.md] → [CASEBOOK.yaml, reconstruction/, SKILL.md]
                        triggers: [M-04, M-05, M-26, M-31] → [M-04, M-05, M-26]
   base-mechanisms      triggers: + M-07
   agent-consolidator   concern: "independence-aware counters, lower bounds, fading, outcomes, scores" → "counters by reading, fading, outcomes, scores that never score the pioneer"
-  agent-canary-author  (node line)                       → + agent-batch-assembler (staged template's whole node line)
   coverage base-ledger "Evidence, candidates, canaries and maturity instruments" → "…, re-presented items and …"
-  coverage "Gate instrumentation — canaries, node_id: agent-canary-author" → + "Review batch assembly and re-presented items, node_id: agent-batch-assembler"
```
Every node already carried `kind`, `load` and (non-agent) `owns`; no project nodes exist.

**`meta-map/MAP.md`** — every base entry read as the 0.14 template wrote it → the staged template's columns, own status kept
(all `proposed`); M-31 withdrawn by the staged template and not reworded → removed; header comment as the staged template's, plus
the step 9 marker.
```
M-03  not-when "a moment with a clear entry" → "a moment with a clear entry (M-20 records the miss)"; load "meta-foundation, then record the miss (M-20)" → "meta-foundation"
M-28  not-when "—" → "a session-level analysis (M-19)"; load → "INTENT.md → Close every output with this block; meta-antidrift → The Drift Score Block"
M-24  type "situation" → "situation + hook: Stop"
M-29  load "LEDGER.yaml → candidates at stage trial or adopt; cite the id" → "LEDGER.yaml → candidates; meta-ledger → Candidates"
M-08  not-when + "; an unauthorised one is drift (M-18)"; load drops "; unauthorised → meta-drift-eventlog"
M-09  load "INTENT.md → Evidence is the work: stop, propose the verification" → "INTENT.md → The agent holds five aspects"
M-10  load "INTENT.md → Stop on named triggers: name it, ask to re-orient" → "meta-antidrift → Scoring Rules"
M-23  not-when "—" → "a node change (M-22)"; load "MANIFEST.yaml: flag it, never fill it silently" → "meta-manifest → How to Read the Manifest"
M-16  load "agent: kit-canary-author, then …" → "agent: kit-batch-assembler, then meta-skill-builder → Review Batch"
M-17  load "script: reveal-canaries.sh; …" → "script: close-batch.sh, then reveal-key.sh; meta-skill-builder → Reveal"
M-31  removed
header + "ratification: deferred" (step 9)
```
Size: 7,103 bytes / 31 entries → 6,989 bytes / 30 entries. `G1-size.sh` exit 0 before and after the marker.

**`> **Map:**` headers of kept skills** — none kept; the only header naming M-31 (`meta-casebook`) was replaced by the staged file, which no longer names it.

### Step 8
No non-base node folders → no project entries drafted; `G1-size.sh` run: exit 0.

### Step 9
- Ratification pass offered → *defer* → `ratification: deferred` added as line 6 of MAP.md, inside the header comment.
- Baseline regenerated after the marker: `INSTALLED.sha1` now 68 paths, CR-stripped hashes, no leading `*`, no `kit-incoming` path; MAP.md's recorded hash equals its current hash.
- Every check under `checks/`: `G1-size.sh` exit 0.
- Install Step 7 hook commands (all with `CLAUDE_PROJECT_DIR` set): `session-start`, `prompt-submit`, `stop-gate` → valid JSON (checked with `json.loads`); `subagent-stop`, `post-read`, `owner-check`, `batch-blind`, `deny-paths` → nothing; `write-scope` → a valid-JSON deny (correct: `src/x.cs` is outside the scope given); `close-batch.sh B-001` and `reveal-key.sh B-001` → "No batch file" (expected). Telemetry tail: `subagent|kit-verifier`, `loaded|meta-map/MAP.md`, `bypass|base-casebook|meta-casebook/CASEBOOK.yaml` — the `loaded` line and the ownership line naming base-casebook both present.
- Backlog with the marker in place (before removal): contract-001 unaudited (M-11), no verification evidence (M-12), C-001 unclerked (M-15), the staged-kit line (M-27). The "Pioneer-owned items are waiting" line that printed before the marker is gone once the marker is in. Stop-gate hands over the M-11 audit of contract-001 (transcript null → fallback text). These reflect the project's live records, as step 9 says to expect.
- Report accepted (stub) → `.claude/kit-incoming/` removed.

---

## 4. Unclear, wrong or missing in the procedure — verbatim, as hit

1. **Step 2 stub vs step 7 text.** Step 2 stubs "*legacy* for every existing contract (step 7)". Step 7 says: "`CONTRACT-LOG.yaml` — every existing entry gains `verification_state: legacy` and `audited: legacy` if absent (the pioneer may name recent implemented contracts to verify and audit; set `none` and `false` on those), and `disappointment: legacy`, `premortem: legacy`, `red_test: legacy`, `cost: legacy` if absent". On any 0.14 install `verification_state` and `audited` are always present, so the "if absent" never fires and the step asks nothing; the four contract-006 fields have a fixed value and are not a question either. The stub anticipates a question the step never asks. Either the step should ask ("which implemented contracts should be verified and audited rather than marked legacy?") and count it, or the stub line should say the answer is only needed when the fields are absent.
2. **Step 7 is self-contradictory on additivity for the ledger.** The step opens "Migrate existing instance schemas additively — add what is missing, never change what is present" and then says for LEDGER.yaml "under `scores`, `canary_catch_rate`, `brier_stated_confidence` and `brier_pioneer_decisions` are removed if present … a candidate's `lower_bound` is removed if present". I followed the specific line (removed them). The opening sentence should say the removals are the named exception.
3. **Step 7 ordering.** The MANIFEST line says "project nodes gain `triggers` from the entries step 8 drafts for them (so step 8 runs before this line)" — a step-7 line that requires step 8 to have run. Moot here (no project nodes), but as written the order of the two steps is circular for a project that has nodes.
4. **Step 5 settings merge and endings.** "the settings merge — replacing the hook groups whose `"_kit"` key marks them as the kit's" — on this install `settings.json` differs from the staged template only by CRLF endings. Step 7's note "instance files keep whatever endings they have" does not say whether `settings.json` is an instance file for that purpose. I left it as it was.
5. **Step 3's untouched rule names one example only.** "A kit file the old baseline never listed because its pattern did not cover it (`walk.expected` before 0.15) is untouched, not evolved" — `templates/settings.template.json` is the second such file (the 0.14 6j pattern had no `*.json`). The rule covers it; the example list does not name it.
6. **The 0.14 install's own bootstrap does not defer to the staged copy** (gap-032, mitigated). Its upgrade section has 8 steps, no rehearsal, no template rule, no stale list, no line-ending rule; only the pioneer's staging message and the M-27 backlog line routed this run to the staged text. Without that sentence, 47 of 70 files would have classified as *evolved* under the installed text's raw-byte comparison and yielded 47 questions.
7. **Step 9's expectation list for the hooks omits `write-scope.sh`'s output.** The install's Step 7 command `write-scope.sh "meta-ledger/LEDGER.yaml"` on `src/x.cs` prints a JSON deny by design; step 9 says "the expectation is only that each hook prints valid JSON or nothing", which it satisfies, but a reader comparing against the install's "What a correct fresh install shows" finds no line for it.

Nothing was wrong in a way that blocked the run; nothing had to be done that the steps do not say.

---

## 5. State after the upgrade

**MAP.md, lines 51–52** (M-31 no longer present; M-16/M-17 status kept as `proposed`; marker on line 6):
```
M-16 | review-due | hook: Stop | must | the stop-gate says pioneer-owned items wait, no batch open | — | agent: kit-batch-assembler, then meta-skill-builder → Review Batch | proposed
M-17 | batch-decided | hook: Stop | must | every item in the open batch carries a decision | — | script: close-batch.sh, then reveal-key.sh; meta-skill-builder → Reveal | proposed
```

**MANIFEST.yaml, `base-casebook`** (node line 45, coverage line 107):
```
- {id: base-casebook, concern: Binding precedents with their facts, scenario cards, reconstruction tests, kind: record, skill_file: meta-casebook/SKILL.md, data_file: meta-casebook/CASEBOOK.yaml, owns: [meta-casebook/CASEBOOK.yaml, meta-casebook/reconstruction/, meta-casebook/SKILL.md], layer: meta, phase: [pre-build, post-build], load: trigger, triggers: [M-04, M-05, M-26], status: thin, dependencies: [base-correction-log], open_gaps: []}
- {concern: Binding precedents and reconstruction, node_id: base-casebook, layer: meta, phase: [pre-build, post-build], status: thin}
```
`kit_identity.base_kit_version: 0.15`; `agent-batch-assembler` registered, `agent-canary-author` gone.

---

## 6. Closing checks

- **`.claude/kit-incoming/` gone:** yes. `session-start.sh` run after removal no longer prints the staged-kit line; backlog is the project's own three items (M-11, M-12, M-15).
- **`walk.sh` in the upgraded project:** passes — `walk: all 36 states match walk.expected`, run twice (before and after the folder removal), with `CLAUDE_PROJECT_DIR` set.
- Final tree: 8 agents deployed and 8 in `skills/agents/`; 18 skill files; 12 hooks; 1 check; `walk.sh` + `walk.expected`; 10 templates; the nine instance files plus `telemetry.log` (12 lines of evidence written by the hook runs) and the regenerated `INSTALLED.sha1`.
