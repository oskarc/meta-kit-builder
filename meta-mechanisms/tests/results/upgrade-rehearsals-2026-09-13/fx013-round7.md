# Upgrade rehearsal — fx013, kit 0.14 → 0.15

Run 2026-09-13, following **the staged kit's** `meta-bootstrap/SKILL.md` → *Upgrading an Existing
Install* (map M-27), as the session-start backlog directed. This folder is itself the throwaway copy
step 2 calls for, so steps 3–9 ran here directly with the pioneer's answers stubbed: *keep* for every
differing file, *remove* for the stale list, *legacy* for every existing contract, *none for now* for
the map question, *defer* for the ratification pass, and the report accepted at the end.

In a rehearsal there is nobody to present to, so the classification and every offer are recorded here
instead of being shown.

**Step 1 — stage it.** Staged `kit_identity.version` **0.15**; project `kit_identity.base_kit_version`
**0.14**. The field is present, so the project is not pre-0.14 and no version was guessed. They
differ, so the upgrade proceeded.

---

## 1. The three numbers

### Decisions asked: **4**

| # | Decision | Belongs to | Stub answer |
|---|---|---|---|
| 1 | `.claude/skills/meta-casebook/SKILL.md` — overwrite with the staged, keep yours, or port by hand? | a file that genuinely differed | **keep** |
| 2 | The stale list (9 files) — remove them? | standing question, step 3 | **remove** |
| 3 | Should any recent implemented contract be verified and audited instead of left legacy? | standing question, step 7 | **legacy** |
| 4 | The ratification pass — run it now, or defer? | standing question, step 9 | **defer** |

Not asked: the **map question** (step 8). It is only put when the map budget forces it; fx013 has no
project nodes, so no entries were drafted and the map stayed inside its budget. Not counted: the
pioneer's acceptance of the report at the end, which the criterion excludes.

### Files that genuinely differed: **1**

- `.claude/skills/meta-casebook/SKILL.md` — the only file whose hash differs from the install
  baseline *and* whose content differs from the staged copy. Every other kit file either matched the
  baseline (so it was taken from the staged kit with no question) or is new in the kit.

### Troubleshooting steps: **0**

Nothing had to be done that the procedure does not describe. Every command in it ran as written; the
two scripts that exit 1 (`close-batch.sh`, `reveal-key.sh`) did so for the stated reason — no batch
file — which step 9 names as the expected result.

### Verdict: **the rehearsal passes**

The bootstrap's own criterion: *"The rehearsal passes only when every decision asked belongs to a file
that genuinely differed or is one of the four standing questions … with the pioneer's acceptance of
the report at the end not counted, and the third number is zero."* Decision 1 belongs to the one file
that genuinely differed; decisions 2–4 are three of the four standing questions; the third number is
zero.

---

## 2. The classification, as presented

**Baseline.** `INSTALLED.sha1` existed: 70 paths, pre-0.15 format (each path prefixed `*`, hashes over
raw bytes). The `*` was dropped and the tree recomputed with the staged 6j command into
`.upgrade-now.sha1` (72 files, removed at the end). Paths that did not match first time were hashed
again with CRLF endings, as the procedure directs: 57 matched that way — this install was made on
Windows and its files were re-saved with the other ending, which differs by nothing.

**Untouched here — taken from the staged kit, no question asked (69 of 70 baseline paths).**
All eight deployed agents and their eight kit copies, 16 of the 17 `meta-*/SKILL.md`,
`meta-foundation/INTENT.md`, all 12 hooks, `tests/walk.sh`, all 11 templates and the nine instance
files. Two further kit files — `tests/walk.expected` and `templates/settings.template.json` — are
missing from the baseline only because the pre-0.15 find pattern did not cover them; the procedure
names both and says they are untouched, not evolved, and they were treated so.

**Evolved here — one file, one question.** `.claude/skills/meta-casebook/SKILL.md`:

- its `> **Map:**` header names **M-31** and the milestone in `REBUILD.yaml`; the staged header names
  M-04, M-05, M-26 only;
- an 11-line section **"The launch rebuild (M-31)"** — the empty-folder rebuild, the frozen
  `REBUILD.yaml` with its milestone/oracle/arms, what to run at the milestone. The staged kit replaces
  the whole section with **"The rebuild — withdrawn from the map"**, recording that contract-006
  withdrew it and pointing at `docs/rebuild-design.md`;
- a closing section the staged copy does not have: *"## Project addition — In this project, precedents
  about response shapes are reviewed with the API owner."*

Question put: overwrite, keep, or port? **Stub: keep.**

**New in the kit — added, no question.** `agents/kit-batch-assembler.md` (deployed and kept as the
kit's copy), `meta-mechanisms/hooks/reveal-key.sh`, `meta-mechanisms/checks/G1-size.sh` with the
`checks/` folder this install lacked.

**Stale — present here, absent from the staged kit. One question for the whole list.**

| Stale file | Why | Kept files pointing at it |
|---|---|---|
| `.claude/agents/kit-canary-author.md` | renamed `kit-batch-assembler` | none after step 7 |
| `.claude/skills/agents/kit-canary-author.md` | same | none after step 7 |
| `.claude/skills/meta-mechanisms/hooks/reveal-canaries.sh` | renamed `reveal-key.sh` | none after step 7 |
| `.claude/skills/templates/REBUILD.template.yaml` | withdrawn by contract-006 | **the kept `meta-casebook/SKILL.md`** names it |
| `.claude/skills/meta-mechanisms/tests/walk-004.sh` | the base kit's own contract walk | none |
| `.claude/skills/meta-mechanisms/tests/fixtures/make-T-2.sh` | the base kit's own fixtures | none |
| `.claude/skills/meta-mechanisms/tests/results/T-2-2026-09-12.md` | the base kit's own evidence | none |
| `.claude/skills/meta-mechanisms/tests/results/T-7-2026-09-12.md` | the base kit's own evidence | none |
| `.claude/skills/meta-mechanisms/tests/results/contract-004-tiers.sha1` | the base kit's own evidence | none |

No `P-NNN.sh` check was present — this install had no `checks/` folder at all — so none went on the
list. **Stub: remove.** All nine were removed, and the two now-empty folders (`tests/fixtures/`,
`tests/results/`) with them.

**What *keep* leaves pointing at nothing** — the list the rehearsal owes the pioneer, because the
stubs count decisions but do not show whether *keep* leaves a usable kit:

- `.claude/skills/meta-casebook/SKILL.md` still describes the launch rebuild at lines 59–69: a map
  entry (M-31) that 0.15 withdrew, a data file (`meta-casebook/REBUILD.yaml`) that was never created
  here, and a template (`templates/REBUILD.template.yaml`) this upgrade removed as stale. At the real
  run the pioneer should weigh *port* against *keep*: keeping it preserves their "Project addition"
  paragraph at the cost of a node describing a lifecycle the installed kit no longer has. Porting
  would take the staged section and re-append that paragraph.

---

## 3. Every migration applied, file by file

### Taken from the staged kit (no question) — content that actually changed

Lines added/removed against the installed copy. Files not listed were copied and are byte-identical
to what was there (`meta-antidrift`, `meta-antidrift-expand`, `meta-contract-artifact`,
`meta-foundation/SKILL.md`, `meta-founding-contract/SKILL.md`, `meta-learning`, `kit-reconstructor`,
`kit-session-auditor`, eight hooks, and the CASEBOOK / DRIFTLOG / FOUNDING / LEARNINGLOG / settings
templates).

| File | + | − | What changed |
|---|---|---|---|
| `meta-bootstrap/SKILL.md` | 43 | 41 | the upgrade section itself — staged-copy rule, the template rule, the rehearsal's three numbers |
| `meta-ledger/SKILL.md` | 38 | 37 | re-presented items replace canaries; counts not bounds; the independence definition |
| `meta-foundation/INTENT.md` | 16 | 22 | the standard-is-already-known framing; contract/correction/cost lines; 4,666 → 4,820 bytes |
| `meta-mechanisms/SKILL.md` | 15 | 15 | `reveal-key.sh` in the inventory; the blind; the question guard |
| `meta-contract-before-execution/SKILL.md` | 15 | 8 | disappointment, pre-mortem, red test, cost |
| `meta-skill-builder/SKILL.md` | 11 | 10 | update/retire/add at the quoted passage; re-presented items |
| `meta-extract/SKILL.md` | 4 | 4 | instrument names |
| `meta-correction-log/SKILL.md` | 4 | 3 | the three incident questions |
| `meta-drift-eventlog/SKILL.md` | 2 | 2 | batch-assembler naming |
| `meta-manifest/SKILL.md` | 1 | 1 | wording |
| `meta-map/SKILL.md` | 1 | 1 | budget measurement |
| `hooks/session-start.sh` | 30 | 10 | the staged-kit backlog line; the gate-matching rule for pioneer-owned items |
| `hooks/stop-gate.sh` | 7 | 5 | question guard on both sides of the block; `closed-by-follow-up` |
| `hooks/owner-check.sh` | 3 | 0 | lookback rule |
| `hooks/batch-blind.sh` | 3 | 3 | telemetry refusal |
| `tests/walk.sh` | 14 | 1 | the walk now fails on a mismatch |
| `tests/walk.expected` | 9 | 9 | new gate messages |
| `agents/kit-consolidator.md` | 8 | 7 | counters by reading; no computed bound |
| `agents/kit-case-clerk.md` | 6 | 3 | checks written from precedents |
| `agents/kit-verifier.md` | 4 | 2 | corrections from tests vs reading |
| `agents/kit-recorder.md` | 2 | 2 | wording |
| `agents/kit-map-steward.md` | 2 | 0 | bypass evidence |
| `templates/CONTRACT-LOG.template.yaml` | 16 | 5 | see the contract-log migration below |
| `templates/LEDGER.template.yaml` | 17 | 17 | see the ledger migration below |
| `templates/MAP.template.md` | 12 | 13 | see the map migration below |
| `templates/MANIFEST.template.yaml` | 8 | 8 | see the manifest migration below |
| `templates/CORRECTIONS.template.yaml` | 6 | 0 | the three incident probes |

Each agent file was written to both `.claude/agents/` and `.claude/skills/agents/`.

### `MAP.md` (step 7 — base entries follow the template rule)

Every base entry still read exactly as the installed template wrote it, so each took the staged
template's columns and kept its own status. All 31 statuses were `proposed` — the pioneer had ratified
none — so no status changed, and no entry had been reworded, so nothing here needed asking.

- **Removed:** `M-31 | launch-rebuild | …` — a base entry the staged template withdrew, not reworded
  by the pioneer, so removed without a question. **31 entries → 30.**
- **Columns refreshed on 11 entries:** M-03, M-28, M-24, M-29, M-07, M-08, M-09, M-10, M-23, M-16,
  M-17. The substantive ones: M-16 now loads `agent: kit-batch-assembler` instead of
  `kit-canary-author`; M-17 now loads `script: close-batch.sh, then reveal-key.sh` instead of
  `reveal-canaries.sh`; M-24 gains `hook: Stop`; M-07 points at `meta-correction-log → How to record`.
- **Header comment block refreshed** from the staged template: "meta-bootstrap copies this file and
  replaces fx013" → "…and fills in the project name". The title line `# Map — fx013` is the record and
  stayed.
- **Step 9 added** `ratification: deferred` inside that comment block, on the deferral.
- Size 7,103 → **6,992 bytes**, 30 entries. `checks/G1-size.sh` passes (8,192-byte and 40-entry
  allowances).

### `MANIFEST.yaml` (step 7)

`kit_identity` is the project's and only one field moved: **`base_kit_version: 0.14` → `0.15`**.
`kit_name`, `kit_type: project`, `category: test-api`, `version`, `parent_kit`, `library_kit: null`
and `status` were left exactly as the project declared them. `gap_queue: []` and `library_entry: null`
untouched. There are no project or inherited nodes, so nothing there needed `triggers`, `note` or a
pending-entry marker.

Every base node line and base coverage line still read as the installed template wrote it, so each was
refreshed from the staged template:

- **Renamed node** `agent-canary-author` → **`agent-batch-assembler`**: the whole node line and the
  whole coverage line taken from the staged template (`agent_file: agents/kit-batch-assembler.md`,
  concern "Assembles review batches from real items, re-presents decided ones from the fourth batch
  on, and seals the key"; coverage "Review batch assembly and re-presented items").
- **`base-casebook`**: `owns` loses `meta-casebook/REBUILD.yaml`; `triggers` loses `M-31` →
  `[M-04, M-05, M-26]`.
- **`base-mechanisms`**: `triggers` gains `M-07`.
- **`base-skill-builder`** concern: "canaries" → "re-presented items".
- **`agent-consolidator`** concern: "independence-aware counters, lower bounds" → "counters by
  reading, fading, outcomes, scores that never score the pioneer".
- **`base-ledger`** coverage concern: "Evidence, candidates, canaries and maturity instruments" →
  "…re-presented items…".
- No new base node and no retired base node beyond that rename; every node already carried `kind`,
  `load`, `triggers` and (where not an agent) `owns`, so nothing was added blind.
- The two library placeholder comment lines (`__INHERITED_NODES__`, `__INHERITED_COVERAGE__`) stay
  removed, as bootstrap 6i leaves them when no library kit is integrated. No placeholder remains.
- The header comment block is identical in both templates, so it was left alone.

### `CONTRACT-LOG.yaml` (step 7 — additive)

Header comment block refreshed from the staged template (+16/−5): `approval: approved-at-gate` with
the note that `gate` on pre-0.15 entries is left as is, the `disappointment` / `premortem` /
`red_test` / `cost` schema lines, `closed-by-follow-up` in the verification_state list, and
`corrections_from_tests` / `corrections_from_reading`.

`contract-001` gained four plain scalars at the positions the staged template gives them:

```
    disappointment: legacy      # after tier_3, where tier_4 would sit
    premortem: legacy
    red_test: legacy
    cost: legacy                # after revisions
```

Untouched: `approval: gate` (the template says pre-0.15 values stay), `status: implemented`,
`verification_state: none`, `audited: false`, `bearing`, the three tiers, `transcript`,
`observations`, `revisions`, `work_id`. Nothing gained `verification_state: legacy` or
`audited: legacy`, because the entry already carried both fields — see finding (a) below.

### `CORRECTIONS.yaml` (step 7 — additive)

Header refreshed (+6 lines: the three incident probes). `C-001` gained, between `reason_given` and
`supersedes`:

```
    noticed: not asked
    would_have_been_right: not asked
    seen_before: not asked
```

The pioneer's quoted words (`agent_offered: "return 204"`, `pioneer_said: "return 200 with a body"`),
the grade, the intervention, `clerked: false` and the `trajectory` block are untouched.

### `LEDGER.yaml` (step 7)

Header refreshed: the one-writer list (contract-007 G-8), `kit-canary-author` → `kit-batch-assembler`,
the verifier-grade note on `evidence_refs`, `lower_bound` dropped from the candidate schema,
`represented` replacing `canaries` on batches, the new `outcome` shape and the new `scores` shape.

In the data: `scores` lost **`canary_catch_rate`**, **`brier_stated_confidence`** and
**`brier_pioneer_decisions`**, and gained **`coincidence: []`**. `updated: null` and `contracts: []`
stayed. There are no batches (so no `represented: []` to add) and no candidates (so no `lower_bound`
to remove); `observations`, `candidates`, `batches`, `map_proposals` and `audits` are empty and were
not touched.

### Instance files with no migration

`DRIFTLOG.yaml`, `LEARNINGLOG.yaml`, `CASEBOOK.yaml`, `FOUNDING.md` — their templates are
byte-identical between 0.14 and 0.15 and their data needed nothing from the step 7 list (the drift
log has no entries, so no `mitigation_medium` to add). The founding statement and its "*None
ratified*" amendments block are exactly as the pioneer left them.

### The kept skill's header

```
- > **Map:** M-04, M-05, M-26, M-31 · **Load:** retrieved on trigger by moment tag · …
+ > **Map:** M-04, M-05, M-26 · **Load:** retrieved on trigger by moment tag · …
```

Only the withdrawn id was removed — the header is the map's. The rest of the line, including
"or the milestone in REBUILD.yaml has been reached", is the kept file's and stays. Reported here,
not asked.

### Mechanisms, authority and folders

- **`settings.json`** merged by hand: all seven hook groups carry `"_kit": "base-building-kit"` and
  were dropped and re-appended from the staged template; there was no non-kit group to keep; the
  `permissions.deny` entry `Read(kit-sealed/**)` was kept. The result is byte-identical to what was
  there — the kit's hook groups did not change between 0.14 and 0.15.
- **`CLAUDE.md`** kit block replaced between its `kit-block` markers with the staged Step 5a text.
  The markers were present and the text is identical, so the file did not change; the project's own
  heading below the block is untouched.
- **5d** — `.gitignore` already had `.claude/kit-sealed/` and `.gitattributes` already had
  `*.sh text eol=lf`; nothing added.
- **5e** — `meta-ledger/batches/` and `meta-casebook/reconstruction/` were missing (empty folders do
  not survive a copy) and were recreated. `meta-mechanisms/checks/` was created.
- **Step 6** — no instance file was missing, so nothing was seeded and nothing was replaced.
- **Baseline** — `INSTALLED.sha1` regenerated after the ratification marker, in 0.15 format (no `*`,
  hashes over CR-stripped content): **68 paths**, down from 70 (nine stale files removed, four new
  files added, two files the old pattern had missed now covered). Re-checked against the tree
  afterwards: every path matches.

### Step 9 checks

- `checks/G1-size.sh` — exit 0. INTENT.md 4,820 bytes (allowance 5,120); MAP.md 6,992 bytes and 30
  entries (allowances 8,192 and 40).
- Every Step 7 hook command printed valid JSON or nothing. `close-batch.sh B-001` and
  `reveal-key.sh B-001` both printed "No batch file …" and exited 1 — the result step 9 names as
  expected. `telemetry.log` gained its `loaded|meta-map/MAP.md` line and the
  `bypass|base-casebook|…` ownership line.
- The check's telemetry lines were deleted afterwards. The file had not existed before the checks ran,
  so removing the file restored the prior state exactly — see finding (d).
- **Raised mid-upgrade and left for afterwards**, as the procedure says to note rather than act on:
  the backlog and the gate named contract-001 as implemented-and-unaudited (M-11), implemented with no
  verification evidence (M-12), and correction C-001 as unclerked (M-15). These are fx013's real
  lifecycle work, untouched by the upgrade. The staged-kit line also printed, because the folder was
  still present at that moment — the procedure says it prints until the folder is removed at the end.

---

## 4. What was unclear, wrong or missing in the procedure

Quoted as I hit it.

**(a) The contract standing question cannot change anything when the entry already carries the two
fields.** Step 7, verbatim: *"`CONTRACT-LOG.yaml` — every existing entry gains `verification_state:
legacy` and `audited: legacy` if absent (ask once, as a standing question, whether any recent
implemented contract should be verified and audited instead; set `none` and `false` on those)."*
fx013's `contract-001` was written under 0.14 and already carries `verification_state: none` and
`audited: false`. Nothing gains `legacy`, so both answers to the question produce the identical file.
I asked it anyway — it is one of the four standing questions and the rehearsal stubs name it — but on
the real run the pioneer would be asked a question with no possible effect. The procedure does not say
to skip it when no entry gained `legacy`, and the pioneer's own failure condition for an upgrade is
*"if it human is required to make many manual decisions"*.

**(b) The template rule would push placeholders back into `FOUNDING.md`.** Step 7: *"The header
comment block of every instance file above follows the template rule"*, and the template rule: *"On an
upgrade a header comment block is always refreshed from the staged template — it is instruction, never
record."* fx013's `FOUNDING.md` header comment reads *"replacing fx013 and 2026-09-12 and pasting the
pioneer's statement verbatim"*, because bootstrap Step 6e's substitution hit the instruction comment
as well as the record. Refreshing that block verbatim from the staged template would put
`__PROJECT_NAME__ and __DATE__` back into a live instance file. I did not refresh it — the two
FOUNDING templates are byte-identical, so there was nothing to carry — but an agent following the rule
literally on a hop where that template *does* change would reintroduce placeholders. The kit has
already fixed exactly this for the map (`MAP.template.md` now says "fills in the project name" rather
than naming the placeholder); `FOUNDING.template.md` has not had the same fix.

**(c) "Files that genuinely differed" is never defined against a stated comparison.** Step 3
classifies *evolved here* as *"hash differs, or no baseline exists"* — a comparison with the baseline.
G-3 says *"One question per differing file; none where nothing differs"* — a comparison with the
staged copy. Those are different tests: a file can be evolved here yet identical to the staged copy
(no question is owed), or untouched here yet different from staged (taken silently, no question). For
fx013 exactly one file is both, so the number was unambiguous — but the procedure does not say which
comparison the rehearsal's second number counts. I counted files that are *both* evolved here and
different from the staged copy, which is the only reading that makes the pass criterion checkable.

**(d) Step 9 assumes `telemetry.log` already exists.** Verbatim: *"The hook commands append real lines
to `telemetry.log` (a `loaded` line and a `bypass` line among them); delete those lines afterwards,
since they are the check's, not the session's."* In fx013 the file did not exist before the checks —
this project has never run a live session — so the hook run created it. Deleting "those lines" would
leave an empty file that was not there before; I removed the file instead, which restores the prior
state. The procedure does not name that case.

**(e) Read accurately, worth recording as correct rather than as a defect.** Step 3's examples of
stale files — *"`kit-canary-author.md`, `reveal-canaries.sh` and the withdrawn rebuild template from
before 0.15, for instance"* — matched this project's tree exactly, as did its note that
`walk.expected` and `settings.template.json` are absent from a pre-0.15 baseline because the pattern
did not cover them, and its CRLF allowance, which accounted for 57 of the 69 untouched files. Step 5's
*"Recreate the 5d–5e entries and folders where a copy lost them"* caught two folders a copy had
indeed lost.

**My own slips, disclosed — not defects in the procedure.** I used the Git Bash `/tmp` directory for
six scratch diff files instead of keeping everything inside the project or the session scratchpad;
they were deleted at the end and nothing in the project depended on them. One of my inspection
scripts carried a stray empty `python` heredoc and printed a mislabelled count ("groups WITHOUT a
`_kit` key" above a number that was in fact the count of groups *with* one); I confirmed the
substance by reading `settings.json` in full instead, and neither touched the project.

---

## 5. `MAP.md` M-07, M-16, M-17 after the upgrade

```
M-07 | pioneer-correction | situation + hook cue | must | the pioneer redirects, declines, corrects a tier or bearing, overrides a recommendation, or resets the frame | answers to your own question; approvals | meta-correction-log → How to record | proposed
M-16 | review-due | hook: Stop | must | the stop-gate says pioneer-owned items wait, no batch open | — | agent: kit-batch-assembler, then meta-skill-builder → Review Batch | proposed
M-17 | batch-decided | hook: Stop | must | every item in the open batch carries a decision | — | script: close-batch.sh, then reveal-key.sh; meta-skill-builder → Reveal | proposed
```

M-07's load moved from "meta-correction-log → record verbatim first" to a named section. M-16 and
M-17 are the two entries that pointed at the renamed agent and the renamed script; both now name what
the 0.15 kit actually ships, and neither points at a removed file. All three keep `proposed`, since
the pioneer has ratified nothing and the ratification pass was deferred.

---

## 6. End state

- **`.claude/kit-incoming/` is gone.** Removed on the stubbed acceptance of the report, as step 9
  directs. The temporary baseline `.upgrade-now.sha1` was removed too.
- **`walk.sh` passes in the upgraded project:** `walk: all 36 states match walk.expected`, exit 0.
- `checks/G1-size.sh` passes. The regenerated `INSTALLED.sha1` matches the tree path for path.
- The project now carries: 17 skills (16 from the staged kit, one kept), eight deployed agents with
  their eight kit copies, 12 hooks, one check, `walk.sh` + `walk.expected`, ten templates, and its own
  nine instance records with their history intact — one contract, one correction, an empty ledger,
  drift log, learning log and casebook, and the founding statement unchanged.
