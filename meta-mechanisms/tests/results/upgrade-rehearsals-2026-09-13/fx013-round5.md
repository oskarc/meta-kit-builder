# Upgrade rehearsal — fx013, base kit 0.14 → 0.15

Run on this folder (already the throwaway copy) following the **staged** kit's `meta-bootstrap/SKILL.md → Upgrading an
Existing Install`, steps 3–9, with the pioneer's answers stubbed as step 2 says. The running log is `UPGRADE-REHEARSAL.log`.

## 1. The three numbers

**Decisions asked: 4**

1. `meta-casebook/SKILL.md` — evolved here: *overwrite with the staged, keep yours, or port?* → **keep** (stub). The one file that genuinely differed.
2. The stale list (standing question) — *remove these?* → **remove** (stub). List: `.claude/agents/kit-canary-author.md`, `.claude/skills/agents/kit-canary-author.md`, `hooks/reveal-canaries.sh`, `templates/REBUILD.template.yaml`, `tests/walk-004.sh`, `tests/results/` (T-2, T-7, contract-004-tiers.sha1), `tests/fixtures/make-T-2.sh`.
3. Contracts to verify and audit (standing, step 7) → **legacy / none named** (stub). It changed nothing: contract-001 already carries `verification_state: none`, `audited: false`, and the migration is additive.
4. The ratification pass (standing, step 9) → **defer** (stub); `ratification: deferred` written into the map header.

Not asked: the step 8 map question — no project nodes exist, G1-size passed, so the budget did not force it. The report's acceptance is not counted.

**Files that genuinely differed: 1**

- `meta-casebook/SKILL.md` (CR-stripped hash `f7ae1711…` vs baseline `ae6a2fef…`). Every other kit file matched the baseline either by the 6j hash or by the text's CRLF fallback; `walk.expected` and `settings.template.json` had no baseline line and are untouched by the text's rule.

**Troubleshooting steps: 1**

- The endings rule in step 7 — *"every refresh or edit of an instance file or a kept skill is written in that file's existing endings"* — gives no way to find a file's endings, and under Git Bash the kit's own portability tools behave in a way the text does not say: `sed` and `awk` strip every CR on read (a passthrough of a CRLF file comes out LF; `sed -i` on the kept `meta-casebook/SKILL.md` stripped its 86 CRs), and `grep` cannot see a CR at all. My first check (`grep $'\r'`) reported every file LF; my second (`od -c | grep`) reported every file CRLF; both were wrong. To satisfy the rule I had to: (a) test `sed`/`awk`/`grep`/`od` on synthetic CRLF input; (b) derive each file's original endings from the baseline evidence (a file whose raw-byte hash equals its CR-stripped hash had no CR); (c) count CRs with `tr -cd '\r' | wc -c`; (d) rewrite six files a second time in their original endings — `CONTRACT-LOG.yaml`, `CORRECTIONS.yaml`, `MANIFEST.yaml`, `MAP.md`, `CLAUDE.md` back to LF; `meta-casebook/SKILL.md` back to CRLF body (lines 1–86) + LF tail (87–90). One gap, four actions; any nonzero count fails.

**Verdict against the bootstrap's own criterion: FAIL.** Every decision asked belongs to a file that genuinely differed or is a standing question, but the third number is 1, not 0. The text says: fix the procedure in the node and rehearse again. A second rehearsal needs a fresh copy of the 0.14 fixture; this folder is no longer one. The fix is written out in section 4.

## 2. The classification presented (into the log; no one to present to)

| Class | Files |
|---|---|
| **untouched** → take staged | 7 agents (both copies); every `meta-*/SKILL.md` except meta-casebook; `INTENT.md`; 10 templates; 11 hooks; `walk.sh`, `walk.expected`; `meta-bootstrap/SKILL.md` |
| **evolved** → ask once | `meta-casebook/SKILL.md`: (a) header names M-31 and "or the milestone in REBUILD.yaml has been reached"; (b) section "### The launch rebuild (M-31)" (9 lines) where the staged has "### The rebuild — withdrawn from the map" (1 paragraph); (c) a trailing "## Project addition" section the staged lacks |
| **new** → add | `agents/kit-batch-assembler.md`, `hooks/reveal-key.sh`, `checks/G1-size.sh`. Not taken (not "the kit"): `checks/P-004..P-007.sh`, `tests/walk-007.sh`, `tests/fixtures/make-upgrade-fixtures.sh`, `tests/results/` |
| **stale** → one question | as listed under decision 2. Beside each: `kit-canary-author` and `reveal-canaries.sh` were referred to only by files step 5 replaces or step 7 refreshes (MAP.md M-16/M-17, manifest, hooks, walk.expected, ledger/skill-builder skills) — nothing kept refers to them afterwards. `REBUILD.template.yaml` is still referred to by the **kept** `meta-casebook/SKILL.md` — that is what *keep* leaves pointing at nothing |

Instance files checked against the installed templates: `MAP.md` and every manifest base line read exactly as the installed template wrote them; the CONTRACT-LOG, CORRECTIONS and LEDGER headers equal their installed template headers; DRIFTLOG, CASEBOOK, LEARNINGLOG, FOUNDING templates are identical between 0.14 and 0.15; the CLAUDE.md block is identical to the staged 5a block; `settings.json` is identical in text to the staged template.

## 3. Migrations applied, file by file

**`.claude/skills/meta-map/MAP.md`** (LF, kept LF) — header comment refreshed (identical) then `ratification: deferred` added as its last line; 10 base entries took the staged template's columns, status kept (`proposed` throughout); M-31 removed.
```
- M-03 … | a moment with a clear entry | meta-foundation, then record the miss (M-20) |
+ M-03 … | a moment with a clear entry (M-20 records the miss) | meta-foundation |
- M-28 … | — | INTENT.md → drift score block; meta-antidrift if a line is hard to fill |
+ M-28 … | a session-level analysis (M-19) | INTENT.md → Close every output with this block; meta-antidrift → The Drift Score Block |
- M-24 | founding-question | situation | …
+ M-24 | founding-question | situation + hook: Stop | …
- M-29 … | LEDGER.yaml → candidates at stage trial or adopt; cite the id |
+ M-29 … | LEDGER.yaml → candidates; meta-ledger → Candidates |
- M-08 … | a change already in revisions | meta-contract-before-execution → The Approval Gate; unauthorised → meta-drift-eventlog |
+ M-08 … | a change already in revisions; an unauthorised one is drift (M-18) | meta-contract-before-execution → The Approval Gate |
- M-09 … | INTENT.md → Evidence is the work: stop, propose the verification |
+ M-09 … | INTENT.md → The agent holds five aspects |
- M-10 … | INTENT.md → Stop on named triggers: name it, ask to re-orient |
+ M-10 … | meta-antidrift → Scoring Rules |
- M-23 … | — | MANIFEST.yaml: flag it, never fill it silently |
+ M-23 … | a node change (M-22) | meta-manifest → How to Read the Manifest |
- M-16 … | agent: kit-canary-author, then meta-skill-builder → Review Batch |
+ M-16 … | agent: kit-batch-assembler, then meta-skill-builder → Review Batch |
- M-17 … | script: reveal-canaries.sh; meta-skill-builder → Reveal |
+ M-17 … | script: close-batch.sh, then reveal-key.sh; meta-skill-builder → Reveal |
- M-31 | launch-rebuild | lifecycle | must | the milestone in REBUILD.yaml is reached | — | REBUILD.yaml; meta-casebook → Reconstruction tests | proposed
```
Size after: 6,966 bytes, 30 entries (G1-size passes).

**`.claude/skills/meta-manifest/MANIFEST.yaml`** (LF, kept LF) — header identical; all 26 base node lines and 26 coverage lines replaced by the staged template's (template rule: they read as the installed template wrote them); 8 lines differ:
```
- base_kit_version: 0.14                        + base_kit_version: 0.15
- base-skill-builder  concern: … verdict before evidence, canaries, adoption …
+ base-skill-builder  concern: … verdict before evidence, re-presented items, adoption …
- base-casebook       owns: [CASEBOOK.yaml, reconstruction/, REBUILD.yaml, SKILL.md]  triggers: [M-04, M-05, M-26, M-31]
+ base-casebook       owns: [CASEBOOK.yaml, reconstruction/, SKILL.md]                triggers: [M-04, M-05, M-26]
- base-mechanisms     triggers: [M-01, M-02, M-11, …]      + triggers: [M-01, M-02, M-07, M-11, …]
- agent-consolidator  concern: … independence-aware counters, lower bounds, fading, outcomes, scores
+ agent-consolidator  concern: … counters by reading, fading, outcomes, scores that never score the pioneer
- {id: agent-canary-author, concern: Assembles review batches and plants canaries, sealing the key, agent_file: agents/kit-canary-author.md …}
+ {id: agent-batch-assembler, concern: Assembles review batches from real items, re-presents decided ones from the fourth batch on, and seals the key, agent_file: agents/kit-batch-assembler.md …}
- coverage base-ledger: Evidence, candidates, canaries and maturity instruments
+ coverage base-ledger: Evidence, candidates, re-presented items and maturity instruments
- coverage: {concern: Gate instrumentation — canaries, node_id: agent-canary-author …}
+ coverage: {concern: Review batch assembly and re-presented items, node_id: agent-batch-assembler …}
```
`kind`, `load`, `triggers`, `owns`, `library_kit: null` were already present; `kit_type: project` untouched. Result is byte-equal to the staged template rendered for fx013 (LF).

**`meta-contract-before-execution/CONTRACT-LOG.yaml`** (LF, kept LF) — header comment (lines 1–75) replaced by the staged template's (lines 1–86): `approval: approved-at-gate` documented with `gate` as the pre-0.15 value; `disappointment`, `premortem`, `red_test`, `cost`, `corrections_from_tests/reading` and `closed-by-follow-up` added to the schema comment. Entry contract-001, additive, plain scalars at the template's positions:
```
      tier_3: | … G-1 (UC-1) it returns 200
+     disappointment: legacy
+     premortem: legacy
+     red_test: legacy
      status: implemented
      …
      revisions: []
+     cost: legacy
      work_id: null
```
`verification_state: none`, `audited: false`, `approval: gate` unchanged.

**`meta-correction-log/CORRECTIONS.yaml`** (LF, kept LF) — header replaced by the staged template's (+6 comment lines for the three probes). C-001:
```
      reason_given: | none given
+     noticed: not asked
+     would_have_been_right: not asked
+     seen_before: not asked
      supersedes: []
```

**`meta-ledger/LEDGER.yaml`** (CRLF, kept CRLF) — header replaced by the staged template's (ONE WRITER LIST naming kit-batch-assembler; `lower_bound` gone; `represented: []` replaces `canaries`/`canaries_caught`; `coincidence` replaces the canary/Brier scores). Body:
```
  scores:
    updated: null
    contracts: []
-   canary_catch_rate: null
-   brier_stated_confidence: null
-   brier_pioneer_decisions: null
+   coincidence: []
```
No batches, no candidates to migrate.

**`meta-drift-eventlog/DRIFTLOG.yaml`**, **`CASEBOOK.yaml`**, **`LEARNINGLOG.yaml`**, **`FOUNDING.md`** — no change (templates identical between versions; `entries: []`).

**`meta-casebook/SKILL.md`** (kept; CRLF body + LF tail, restored to exactly that) — one edit, reported not asked:
```
- > **Map:** M-04, M-05, M-26, M-31 · **Load:** …
+ > **Map:** M-04, M-05, M-26 · **Load:** …
```
The rest of the line, and the body's "### The launch rebuild (M-31)" section with its `REBUILD.yaml` / `templates/REBUILD.template.yaml` references, stay — they now describe something the kit removed (lines 6, 59, 63, 69).

**`.claude/settings.json`** (CRLF, kept CRLF) — 7 kit groups replaced by the staged template's; text unchanged. **`CLAUDE.md`** (LF, kept LF) — block between the markers replaced; text unchanged. **`.gitignore`/`.gitattributes`** — already correct. **Folders** created: `meta-ledger/batches/`, `meta-casebook/reconstruction/`, `meta-mechanisms/checks/`. **`INSTALLED.sha1`** — regenerated with 6j: 68 lines, no leading `*`, now covers `walk.expected` and `settings.template.json`.

## 4. Unclear, wrong or missing in the procedure — verbatim as hit

1. **Step 7, the endings rule** — *"Kit files arrive with LF endings; instance files keep whatever endings they have — a mixed tree is expected and harmless — and every refresh or edit of an instance file or a kept skill is written in that file's existing endings."* No way to determine a file's endings is given, and under Git Bash `sed` and `awk` strip CRs on read (`printf 'a\r\nb\r\n' | sed 's/x/y/'` → 0 CRs; same for `awk '{print}'`), `sed -i` therefore converts a CRLF file to LF, and `grep $'\r'` matches nothing. This is the troubleshooting step. **Proposed fix, in this node:** "Find a file's endings with `tr -cd '\r' < file | wc -c` against `wc -l < file` (equal: CRLF; zero: LF; between: mixed). Under Git Bash `sed` and `awk` strip carriage returns, so edit a CRLF file as `tr -d '\r' < file | <edit> | sed 's/$/\r/'` and never with `sed -i`."
2. **Step 3, the baseline fallback** — *"hash it once more with CRLF endings added (`sed 's/$/\r/' file | sha1sum`), and if that matches, the file is untouched"* — matched every CRLF file here (DRIFTLOG.yaml: fallback `e5fee924…` = baseline) **only because** this sed strips the existing CRs first. On a sed that keeps them (Linux, macOS) the same command yields CRCRLF and cannot match a file that is CRLF on disk; what matches there is the raw-bytes hash (`sha1sum file`, also `e5fee924…`). Not counted as troubleshooting (the text's method worked here), but the sentence should say "or the raw bytes match".
3. **Step 2's stub list vs its pass criterion** — the stubs name *"none for now for the map question (step 8)"* unconditionally; the criterion counts that question only *"when the budget forces it"*. With no project nodes it is not due, so the stub had nothing to answer. Say "if asked".
4. **Step 7, CONTRACT-LOG** — *"every existing entry gains `verification_state: legacy` and `audited: legacy` if absent (the pioneer may name recent implemented contracts to verify and audit; set `none` and `false` on those)"* and the step 2 stub *"legacy for every existing contract"*: on a 0.14 install every entry already carries `none`/`false`, the migration is additive, so "legacy" cannot be applied and the contract stays live for the gate (session-start and stop-gate both hand contract-001 to the auditor/verifier after the upgrade). The stub and the sentence assume the pre-0.14 shape; for a 0.14→0.15 hop the question is moot and should say so.
5. **Step 5, `settings.json`** — the text lists which instance files keep their endings; `settings.json` is not among them and is also not a kit file. It was CRLF (the 0.14 install copied the template as CRLF); I restored CRLF after the merge. Say which rule it follows.
6. **Step 3, "recompute the baseline … into a temporary file"** — no location is named and nothing says to remove it; I used `PROJECT/.rehearsal-tmp/` and deleted it at the end.
7. **Step 9, the hook expectations** — `close-batch.sh` and `reveal-key.sh` "report *no batch file*" and exit 1; the text does not mention the exit code. Harmless, noted so the next run does not count it as an error.
8. **Mid-upgrade hooks** — *"the hooks fire throughout it against a half-migrated project … a backlog line or a gate task raised mid-upgrade is noted in the log"*: run as a subagent, I saw no hook output between steps; nothing to note. A rehearsal run by the main session would see them.

## 5. State after the upgrade

`MAP.md` M-16 and M-17:
```
M-16 | review-due | hook: Stop | must | the stop-gate says pioneer-owned items wait, no batch open | — | agent: kit-batch-assembler, then meta-skill-builder → Review Batch | proposed
M-17 | batch-decided | hook: Stop | must | every item in the open batch carries a decision | — | script: close-batch.sh, then reveal-key.sh; meta-skill-builder → Reveal | proposed
```
(M-31 is gone; header comment ends with `ratification: deferred`.)

Manifest `base-casebook` node:
```
- {id: base-casebook, concern: Binding precedents with their facts, scenario cards, reconstruction tests, kind: record, skill_file: meta-casebook/SKILL.md, data_file: meta-casebook/CASEBOOK.yaml, owns: [meta-casebook/CASEBOOK.yaml, meta-casebook/reconstruction/, meta-casebook/SKILL.md], layer: meta, phase: [pre-build, post-build], load: trigger, triggers: [M-04, M-05, M-26], status: thin, dependencies: [base-correction-log], open_gaps: []}
```
(`base_kit_version: 0.15`; `agent-batch-assembler` registered, `agent-canary-author` gone.)

Kept `meta-casebook/SKILL.md` header (line 6):
```
> **Map:** M-04, M-05, M-26 · **Load:** retrieved on trigger by moment tag · **Recognise it by:** "we have decided a situation like this before" — or the milestone in REBUILD.yaml has been reached · **Not when:** the question is what the rule says (that is the node) rather than how it was applied
```
Its body still carries "### The launch rebuild (M-31)" and the `REBUILD.yaml` references (lines 59, 63, 69) — the kept-but-orphaned text for the pioneer to weigh at the real run.

## 6. Kit-incoming and the walk

- `.claude/kit-incoming/` — **gone** (removed on the stubbed acceptance); `session-start.sh` afterwards prints the project's three live backlog lines and no staged-kit line.
- Checks: `G1-size.sh` — pass (INTENT 4,820 B; MAP 6,966 B, 30 entries).
- Hooks (Step 7 commands, `CLAUDE_PROJECT_DIR` set): each printed valid JSON or nothing; `close-batch.sh`/`reveal-key.sh` said *No batch file*; `telemetry.log` gained `loaded|meta-map/MAP.md` and `bypass|base-casebook|meta-casebook/CASEBOOK.yaml`.
- `walk.sh` in the upgraded project: **"walk: all 36 states match walk.expected"** — passes.
