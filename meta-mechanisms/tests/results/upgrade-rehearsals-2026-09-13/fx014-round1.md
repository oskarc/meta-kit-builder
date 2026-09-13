# Upgrade rehearsal — fx013 project copy (fx014), kit 0.14 → 0.15

Procedure followed: `.claude/kit-incoming/meta-bootstrap/SKILL.md` → *Upgrading an Existing Install*, steps 1–9, on this throwaway copy, with the pioneer's answers stubbed as step 2 says (*keep* for every differing file, *remove* for the stale list). Date: 2026-09-13. Running log: `rehearsal-log.md` beside this file.

## 1. The three numbers

**Decisions asked: 2**

1. `meta-casebook/SKILL.md` — classified *evolved here* (hash ≠ baseline). Shown: two hunks (header `> **Map:** M-04, M-05, M-26, M-31 … REBUILD.yaml` → `M-04, M-05, M-26`; section "The launch rebuild (M-31)" → "The rebuild — withdrawn from the map"). Question: *overwrite with the incoming, keep yours, or port by hand?* Stub answer: **keep**.
2. The stale list — `.claude/agents/kit-canary-author.md`, `.claude/skills/agents/kit-canary-author.md`, `meta-mechanisms/hooks/reveal-canaries.sh`, `templates/REBUILD.template.yaml`. Question: remove these four? Stub answer: **remove**.

**Files that genuinely differed: 0**

- `sha1sum -c INSTALLED.sha1` over the installed tree: 69 of 70 match, 1 fails — `meta-casebook/SKILL.md`.
- That file's text is byte-identical to what was installed. It is stored LF (0 carriage returns) while 53 of the installed text files are CRLF; re-rendered as CRLF it hashes to exactly the baseline value `ae6a2fef6dcf152e5a189bcfdda199d583496ab2`. Only its line endings were normalised.
- So the procedure's hash rule produced one false positive, and decision 1 was asked about a file that did not genuinely differ. By step 2's own pass criterion ("every decision asked belongs to a file that genuinely differed or is the one stale-list question") **the rehearsal does not pass.**

**Troubleshooting steps: 4** — things I had to do that the steps do not say.

1. Compared the two kits with `diff --strip-trailing-cr` and re-hashed the flagged file as CRLF. A byte-wise comparison marks 48 of 49 shared files as "differs" (installed tree CRLF, incoming tree LF); without stripping CRs I could not tell what the kit had changed, nor discover that the "evolved" file had not. The procedure mentions line endings only for `*.sh`.
2. Decided the scope of "take the incoming version" for files the baseline lists but step 3 does not name: `templates/` (10 files), `meta-mechanisms/tests/` (6 → 32 files), and the kit's own agent copy `.claude/skills/agents/`. I took all three from the incoming kit, on the sentence "Everything new comes from `.claude/kit-incoming/` — its `meta-*/` nodes, its `agents/`, its `templates/`, and its `meta-mechanisms/hooks/`". The steps never say to install them.
3. Decided what to do with the five checks the incoming kit ships under `meta-mechanisms/checks/` (`G1-size.sh`, `P-004.sh`…`P-007.sh`). Step 6 says create the folder "if absent" (the install's 6h creates it *empty*); step 4 says the incoming kit's own records never travel; P-004..P-007 encode the base kit's own precedents. I created the folder empty and copied nothing, so step 9's "run every check" ran zero checks.
4. Saved the 0.14 `INSTALLED.sha1` before step 9 regenerated it. Step 2 asks for "the resulting diff"; nothing says to keep the old baseline, and after 6j runs there is no reference left to diff against.

Not counted, but done and noted: two side probes (§5) that were not needed to complete the run.

## 2. The classification presented (step 3, before any change)

Baseline: 70 entries, every file present, no extras. Installed tree: 53 text files CRLF; incoming: LF except `meta-antidrift/SKILL.md`, `meta-antidrift-expand/SKILL.md`, `meta-contract-artifact/SKILL.md` (identical to installed) and `meta-learning/LEARNINGLOG.yaml` (all 31 lines CRLF).

**Untouched here (hash = baseline) → take the incoming version, no question**

| Group | Files | Content actually changes in |
|---|---|---|
| Skills | 17: SKILL.md of meta-antidrift, meta-antidrift-expand, meta-bootstrap, meta-contract-artifact, meta-contract-before-execution, meta-correction-log, meta-drift-eventlog, meta-extract, meta-foundation, meta-founding-contract, meta-learning, meta-ledger, meta-manifest, meta-map, meta-mechanisms, meta-skill-builder; plus meta-foundation/INTENT.md | 11 (bootstrap, contract-before-execution, correction-log, drift-eventlog, extract, INTENT.md, ledger, manifest, map, mechanisms, skill-builder); 3 identical (antidrift, antidrift-expand, contract-artifact); 3 line-endings only (foundation SKILL.md, founding-contract, learning) |
| Agents | 7 × 2 copies (`.claude/agents/`, `.claude/skills/agents/`): case-clerk, consolidator, map-steward, reconstructor, recorder, session-auditor, verifier | 5 (case-clerk, consolidator, map-steward, recorder, verifier); reconstructor and session-auditor line-endings only |
| Hook scripts | 11: batch-blind, close-batch, deny-paths, lib, owner-check, post-read, prompt-submit, session-start, stop-gate, subagent-stop, write-scope | 4 (batch-blind, owner-check, session-start, stop-gate) |
| Also in the baseline, not named by step 3 | templates/ (10), meta-mechanisms/tests/ (6) | templates: 6 content, 4 line-endings only; tests: 5 content |

**Evolved here (hash ≠ baseline) → one question**

- `meta-casebook/SKILL.md` — false positive, see §1. Kept (stub).

**New in the kit → add**

- `agents/kit-batch-assembler.md`; `meta-mechanisms/hooks/reveal-key.sh`; `meta-mechanisms/tests/walk-007.sh` and `tests/results/*` (23 files, taken with tests/).
- `meta-mechanisms/checks/{G1-size,P-004,P-005,P-006,P-007}.sh` — **not copied** (troubleshooting item 3).

**Present here, absent from the incoming kit → stale, one question**

- `.claude/agents/kit-canary-author.md`, `.claude/skills/agents/kit-canary-author.md`, `meta-mechanisms/hooks/reveal-canaries.sh`, `templates/REBUILD.template.yaml`. Removed (stub). `meta-manifest/INSTALLED.sha1` also has no incoming counterpart; it is the baseline, regenerated in step 9, not stale.

**Instance files — never replaced, migrated in step 7**: MANIFEST.yaml, MAP.md, CONTRACT-LOG.yaml (1 contract), CORRECTIONS.yaml (1 correction), LEDGER.yaml, DRIFTLOG.yaml, CASEBOOK.yaml, LEARNINGLOG.yaml (all empty), FOUNDING.md (statement given). Step 4 (new node folders): none — every incoming `meta-*/` folder already exists. Step 8 (project nodes to map): none — the manifest holds 26 nodes, all base or agent.

## 3. Every change applied, file by file

### Step 5 — install

| Action | Files |
|---|---|
| Replaced (content) | `.claude/agents/` and `.claude/skills/agents/`: kit-case-clerk.md (+`Write, Bash` tools, +`meta-mechanisms/checks/` write scope, +"From precedent to check" step, +2 Never lines), kit-consolidator.md (no lower bound, "different reading" counting, `same-family-different-inputs` grade, `coincidence` scores, "nothing scores the pioneer"), kit-map-steward.md (+`stop-deferred` and `batch-blind` telemetry events), kit-recorder.md (description drops M-20; "canaries" → "items … indistinguishable from their sources"), kit-verifier.md (evidence list "a starting point, never a boundary"; +`corrections_from_tests` / `corrections_from_reading`) |
| Replaced (line endings only) | kit-reconstructor.md, kit-session-auditor.md (both copies) |
| Added | `.claude/agents/kit-batch-assembler.md`, `.claude/skills/agents/kit-batch-assembler.md`, `meta-mechanisms/hooks/reveal-key.sh` |
| Hooks replaced (content) | batch-blind.sh (comment text only: canaries → re-presented), owner-check.sh (+3 lines: import-loaded owners INTENT/MAP/FOUNDING never count as bypass), session-start.sh (M-17 text → reveal-key.sh; casebook "stays open"; +`ratification: deferred` guard on proposed entries; +precedent conflicts and mitigated drift in the pioneer-owned flag; +staged-kit line), stop-gate.sh (question guard also checks the tail of the whole message; gate 1 cites M-17; gate 2/10 name reveal-key.sh / kit-batch-assembler) |
| Hooks re-copied, identical | close-batch, deny-paths, lib, post-read, prompt-submit, subagent-stop, write-scope |
| `.claude/settings.json` | 7 hook groups, all `_kit`-marked, replaced by the template's 7 — **no content change** (CRLF → LF only) |
| `CLAUDE.md` | block between `kit-block` markers replaced by the incoming 5a text — **no content change** |
| Removed | `.claude/agents/kit-canary-author.md`, `.claude/skills/agents/kit-canary-author.md`, `meta-mechanisms/hooks/reveal-canaries.sh`, `templates/REBUILD.template.yaml` |
| Skills replaced (content) | meta-bootstrap (upgrade section rewritten: rehearsal, stale list, one-question rule, step 7 field list; 6h no longer seeds REBUILD; Step 7 checks say reveal-key.sh; "30 map entries"), meta-contract-before-execution (Tier 4 from the pioneer's disappointment lines, red test, pre-mortem, `cost`, `closed-by-follow-up`), meta-correction-log (three incident questions; "do not ask why"; clerk writes checks), meta-drift-eventlog (canaries → tests; kit-batch-assembler), meta-extract (instruments: corrections-from-tests share replaces canary rate and Brier), meta-foundation/INTENT.md (rewritten: "The standard is already known; the kit draws it out", ratified 2026-09-13, contract-006), meta-ledger (independence = "different reading"; no bound; re-presented items; coincidence; nothing scores the pioneer), meta-manifest (promotion criterion wording), meta-map (budget paragraph: 30 entries, 6,974 B), meta-mechanisms (header lists M-07/M-24; reveal-key.sh; re-presented items; `watching` in marker table), meta-skill-builder (batch assembler; "Assume this is wrong. Why?"; reveal step 2 re-presented items) |
| Skills re-copied, identical or line-endings only | meta-antidrift, meta-antidrift-expand, meta-contract-artifact, meta-foundation/SKILL.md, meta-founding-contract, meta-learning |
| Skill kept (stub) | meta-casebook/SKILL.md — still carries `M-31` and the "launch rebuild" section |
| templates/ replaced | CONTRACT-LOG (approved-at-gate, disappointment, premortem, red_test, corrections_from_*, closed-by-follow-up, cost), CORRECTIONS (noticed / would_have_been_right / seen_before), LEDGER (one-writer list; no lower_bound; `represented`; `coincidence`; no canary/brier keys), MANIFEST (base_kit_version 0.15; batch-assembler; casebook without REBUILD/M-31; mechanisms +M-07), MAP (30 entries; M-16/M-17 targets; reworded M-03, M-08, M-09, M-10, M-23, M-24, M-28, M-29), settings (CRLF→LF only); CASEBOOK, DRIFTLOG, FOUNDING, LEARNINGLOG line-endings only |
| tests/ replaced | walk.sh (outer run diffs against walk.expected and fails), walk-004.sh (batch-assembler; T-9 replaced by contract-006 T-7), walk.expected, results/T-2 and T-7 (content), + walk-007.sh and 23 result files added |
| Created | `meta-mechanisms/checks/` (empty) |

### Step 7 — additive migrations

`meta-contract-before-execution/CONTRACT-LOG.yaml`, entry contract-001 (`verification_state: none` and `audited: false` already present, left as they were):
```
     tier_3: |
       G-1 (UC-1) it returns 200
+    disappointment: legacy
+    premortem: legacy
+    red_test: legacy
     status: implemented
     …
     revisions: []
+    cost: legacy
     work_id: null
```

`meta-correction-log/CORRECTIONS.yaml`, entry C-001:
```
     reason_given: |
       none given
+    noticed: |
+      not asked
+    would_have_been_right: |
+      not asked
+    seen_before: |
+      not asked
     supersedes: []
```

`meta-ledger/LEDGER.yaml` (no batches, no candidates — nothing to add or strip there):
```
 scores:
   updated: null
   contracts: []
-  canary_catch_rate: null
-  brier_stated_confidence: null
-  brier_pioneer_decisions: null
+  coincidence: []
```

`meta-manifest/MANIFEST.yaml` (`kind`, `load`, `triggers`, `owns` present on every node — nothing added; no new base node ids — none registered):
```
-  base_kit_version: 0.14
+  base_kit_version: 0.15
-  - {id: agent-canary-author, concern: Assembles review batches and plants canaries, sealing the key, kind: agent, agent_file: agents/kit-canary-author.md, …}
+  - {id: agent-batch-assembler, concern: Assembles review batches from real items, re-presents decided ones from the fourth batch on, and seals the key, kind: agent, agent_file: agents/kit-batch-assembler.md, …}
-  - {concern: Gate instrumentation — canaries, node_id: agent-canary-author, …}
+  - {concern: Review batch assembly and re-presented items, node_id: agent-batch-assembler, …}
```

`DRIFTLOG.yaml`: `entries: []` — nothing to migrate. Untouched and verified against the 0.14 baseline afterwards: MAP.md, FOUNDING.md, CASEBOOK.yaml, DRIFTLOG.yaml, LEARNINGLOG.yaml.

### Step 9 — baseline and checks

- `INSTALLED.sha1` regenerated: 70 → 89 lines; verifies. Against the 0.14 baseline: 50 changed, 23 added, 4 removed (listed in `rehearsal-log.md` / the shell record).
- Checks under `meta-mechanisms/checks/`: **0 run** (folder empty — troubleshooting item 3).
- Install Step 7 hook checks, all with `CLAUDE_PROJECT_DIR` set: session-start → 6 backlog lines (contract-001 unaudited → M-11; no verification evidence → M-12; C-001 unclerked → M-15; pioneer-owned items → M-16 kit-batch-assembler; **"Founding statement not given or deferred → M-24" (false, see §4 I)**; staged kit → M-27). prompt-submit → name-the-moment text. stop-gate on "Done." → M-11 audit of contract-001 (correct: highest due task). subagent-stop, post-read, owner-check, batch-blind, deny-paths → silent (correct). write-scope → deny (correct). close-batch.sh B-001 / reveal-key.sh B-001 → "No batch file" (correct). telemetry.log tail: `subagent|kit-verifier`, `loaded|meta-map/MAP.md`, `bypass|base-casebook|meta-casebook/CASEBOOK.yaml` — exactly what Step 7 says a correct install shows.
- `.claude/kit-incoming/` left in place (no stub for that confirmation; the copy is discarded anyway).

## 4. What in the procedure was unclear, wrong or missing — verbatim, as hit

**A. WRONG — step 3's evolved rule is fooled by line endings.**
> *"**evolved here** (hash differs, or no baseline exists) → **show the pioneer what differs** — the sections changed, in a few lines each — and ask one question"*

The hash of `meta-casebook/SKILL.md` differs from the baseline because the file was re-saved with LF endings; its text is unchanged. The rule asked the pioneer a question about a file that did not genuinely differ — the exact failure the pass criterion names. On a Windows checkout 53 of the installed text files are CRLF and the staged kit is LF, so a byte comparison between the two kits reports 48 of 49 shared files as different. Fix in this node: hash and compare with carriage returns stripped (both at 6j and at step 3), or say which normalisation the baseline assumes.

**B. MISSING — step 7 migrates four records and the manifest, never MAP.md.**
> *"7. **Migrate existing instance schemas additively** — add what is missing, never change what is present: `CONTRACT-LOG.yaml` … `CORRECTIONS.yaml` … `LEDGER.yaml` … `DRIFTLOG.yaml` … `MANIFEST.yaml` …"*
> *"8. **Map the project's nodes.** For each existing non-base node, draft an entry under "Project entries" …"*

After the upgrade the project's MAP.md still reads, at lines 50, 51 and 54: `M-16 … agent: kit-canary-author`, `M-17 … script: reveal-canaries.sh`, `M-31 | launch-rebuild … REBUILD.yaml`. Step 5 deleted the agent and the script as stale, and the 0.15 casebook withdrew M-31. The stop-gate now names kit-batch-assembler and reveal-key.sh while the always-loaded map points at files that no longer exist. The eight reworded base entries (M-03, M-08, M-09, M-10, M-23, M-24, M-28, M-29) also stay at their 0.14 text. Nothing in steps 3–9 touches base map entries.

**C. UNCLEAR — what step 3 classifies, and what is installed.**
> *"Classify every skill, agent and hook script against `meta-manifest/INSTALLED.sha1`"*
> *"**Everything new comes from `.claude/kit-incoming/`** — its `meta-*/` nodes, its `agents/`, its `templates/`, and its `meta-mechanisms/hooks/`."*
> *"5. **Install** from the incoming copies: agents to `.claude/agents/` …, the hook scripts into `.claude/skills/meta-mechanisms/hooks/`, and the settings merge …"*

The baseline lists `templates/` (10), `meta-mechanisms/tests/` (6) and the kit's agent copy `.claude/skills/agents/` (8); step 5 installs none of them; step 3's stale example (`kit-canary-author.md`) is in `.claude/skills/agents/`, and `REBUILD.template.yaml` is in `templates/`, so the stale rule reaches folders the install rule does not. I took all three from the incoming kit (troubleshooting item 2).

**D. CONTRADICTORY — the checks folder.**
> *"6. … Create `.claude/skills/meta-mechanisms/checks/` if absent."*
> *"9. **Regenerate the baseline** (6j), **run every check** under `meta-mechanisms/checks/` …"*
> *"4. … The incoming kit's own ledger, corrections, casebook, map and logs are never copied into the project."*

The incoming `meta-mechanisms/checks/` holds five scripts. Creating the folder "if absent" implies it arrives empty; a fresh 0.15 install (folder copy, the way this project's `tests/results/` got here) would carry all five; step 9 then runs zero checks on an upgraded project. `P-004..P-007` are the base kit's own precedents (its casebook, which never travels); `G1-size.sh` is a base mechanism ("made a mechanism by contract-007 G-9") that enforces contract-001 G-1 on every project's map and is not tied to a travelling precedent. No manifest node `owns:` the folder. Side probe: all five pass on the upgraded tree (§5).

**E. MISSING — the 5e folders are not in the upgrade path.**
> *"**5e — Folders.** Create `.claude/skills/meta-ledger/batches/` and `.claude/skills/meta-casebook/reconstruction/` — the batch files and the reconstruction inputs are the only writable paths two of the agents have."*

Both are absent in this project (empty folders do not survive a copy) and no upgrade step creates them; kit-batch-assembler's write scope is `meta-ledger/batches/`. Not created here, because no step says to.

**F. UNCLEAR — "never change what is present" leaves records contradicting their nodes.**
> *"— add what is missing, never change what is present"*
> *"`MANIFEST.yaml` — every node gains `kind`, `load` and `triggers` if absent; every non-agent base node gains `owns:` copied from the incoming template's node of the same id …"*

Left as present, therefore now wrong: `base-casebook` keeps `owns: [… meta-casebook/REBUILD.yaml …]` and `triggers: [M-04, M-05, M-26, M-31]`; `base-mechanisms` keeps triggers without `M-07` (the 0.15 template adds it); `LEDGER.yaml`'s header comment still says "batches — kit-canary-author" and documents `lower_bound`, `canaries`, `canaries_caught` and the three brier keys the migration removed; contract-001 keeps `approval: gate` where the 0.15 template enumerates `approved-at-gate`.

**G. UNCLEAR — what "renamed" includes.**
> *"base nodes renamed in the kit (`agent-canary-author` → `agent-batch-assembler`) are renamed here"*

Says nothing about `concern`, `agent_file` or the `coverage_map` entry. I replaced the node line and the coverage line with the template's.

**H. UNCLEAR — "the resulting diff" has no reference after step 9.**
> *"Present the log and the resulting diff."* … *"9. **Regenerate the baseline** (6j)"*

6j overwrites the only pre-upgrade record of the tree. Nothing says to keep the 0.14 `INSTALLED.sha1` (troubleshooting item 4).

**I. WRONG (expected output; pre-existing in 0.14) — the founding-statement line fires on every seeded project.**
> *"`session-start.sh` prints **one** backlog line — pioneer-owned items are waiting — … A correction recorded in Steps 1–5 adds a second line, and a deferred statement a third."*

Here it printed `- Founding statement not given or deferred -> M-24 surface it before drawing contracts` although FOUNDING.md records a statement given 2026-09-12. Cause: `session-start.sh:58` greps `'Not yet given|Deferred by the Pioneer'`, and `FOUNDING.md:14` — the template's own AGENT INSTRUCTIONS comment, copied into every project — contains the literal `"*Deferred by the Pioneer on [date].*"`. The 0.14 hook has the same line; `templates/FOUNDING.template.md:14` ships the same comment in 0.15. Not caused by the upgrade; surfaced by step 9's check.

**J. Step 2's two stubs contradict each other when they meet.**
> *"run steps 3–9 there with the pioneer's answers stubbed: *keep* for every differing file, *remove* for the stale list."*

*Keep* on `meta-casebook/SKILL.md` keeps text that says "The plan lives in `REBUILD.yaml`, seeded by bootstrap from `templates/REBUILD.template.yaml`"; *remove* on the stale list deletes that template. With these stubs a kept skill can always end up pointing at a removed file, and the rehearsal cannot tell whether that is a procedure fault or a stub artefact.

**K. Step 9's last action has no rehearsal stub.**
> *"Remove `.claude/kit-incoming/` on the pioneer's confirmation."*

Left in place; `session-start.sh` therefore keeps printing the staged-kit line after the upgrade.

**L. Noted, not a procedure fault:** the staged kit itself mixes endings — `meta-learning/LEARNINGLOG.yaml` is CRLF on all 31 lines, three SKILL.md files are CRLF, everything else LF.

## 5. Side probes (not procedure steps, not counted)

- The five incoming checks run against a temporary copy of the upgraded `.claude/skills` with the checks placed in `meta-mechanisms/checks/`: **all pass** (G1-size: INTENT.md 4,797 B; MAP.md 7,103 B / 31 entries; P-004, P-005, P-006, P-007 pass).
- `tests/walk.sh` with the installed 0.15 hooks: `walk: all 36 states match walk.expected`.
