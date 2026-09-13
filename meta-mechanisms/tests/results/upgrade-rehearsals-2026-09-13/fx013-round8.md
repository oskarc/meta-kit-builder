# Upgrade rehearsal — fx013, base kit 0.14 → 0.15

Run on 2026-09-13 against a throwaway copy of the project, following the **staged** kit's
`meta-bootstrap/SKILL.md` → *Upgrading an Existing Install*, steps 3–9, with the pioneer's answers
stubbed exactly as step 2 prescribes: *keep* for every differing file, *remove* for the stale list,
*legacy* for every existing contract, *none for now* for the map question, *defer* for the
ratification pass, report accepted at the end.

Step 1 (version compare): project `kit_identity.base_kit_version: 0.14`, staged
`kit_identity.version: 0.15`. Not equal — the upgrade proceeds.

---

## 1. The three numbers

### Decisions asked — 3

| # | Decision | Belongs to | Stub answer |
|---|---|---|---|
| 1 | `meta-casebook/SKILL.md` — overwrite with the staged, keep yours, or port by hand? | a file that genuinely differed | keep |
| 2 | The stale list — remove these 9 files? (one question for the whole list) | standing question, step 3 | remove |
| 3 | The ratification pass — run it now or defer? | standing question, step 9 | defer |

**Not asked, and correctly so:**

- **The contract-log standing question** (step 7: "whether any recent implemented contract should be
  verified and audited instead"). Its own escape clause fired — *"skip the question entirely when
  every existing entry already carries these fields, since then both answers write the same file"*.
  `contract-001` already carried `verification_state: none` and `audited: false`. The rule worked and
  saved a decision.
- **The map question** (step 8). The project has no non-base nodes — `.claude/skills/` holds only
  `meta-*` folders, `agents/` and `templates/` — so no entries were drafted, the budget was never
  pressed, and there was nothing to put to the pioneer.
- **The pioneer's acceptance of the report** at the end. Excluded by the criterion itself.

### Files that genuinely differed — 1

The criterion: *differs from the baseline **and** its content differs from the staged copy.*

| File | Differs from baseline | Differs from staged | Genuinely differed |
|---|---|---|---|
| `.claude/skills/meta-casebook/SKILL.md` | yes | yes | **yes** |

That is the whole list. What differs in it: the project added a `## Project addition` section
("In this project, precedents about response shapes are reviewed with the API owner."), and the file
still carries the pre-0.15 launch-rebuild material that contract-006 withdrew.

**Twenty-eight further kit files differ between the installed kit and the staged kit but did *not*
genuinely differ** — the project never touched them, so the kit's own changes are taken without a
question: 10 `SKILL.md` (`meta-bootstrap`, `meta-contract-before-execution`, `meta-correction-log`,
`meta-drift-eventlog`, `meta-extract`, `meta-ledger`, `meta-manifest`, `meta-map`, `meta-mechanisms`,
`meta-skill-builder`), `meta-foundation/INTENT.md`, 6 templates (CONTRACT-LOG, CORRECTIONS, FOUNDING,
LEDGER, MANIFEST, MAP), 4 hooks (`batch-blind`, `owner-check`, `session-start`, `stop-gate`), `walk.sh`,
`walk.expected`, and 5 agents (`kit-case-clerk`, `kit-consolidator`, `kit-map-steward`, `kit-recorder`,
`kit-verifier`) — 33 installed paths, since each changed agent is deployed twice. Treating "the kit
changed it" as "it differs" would have produced 28 questions instead of one.

Two files the old baseline never listed because its pattern did not cover them —
`meta-mechanisms/tests/walk.expected` and `templates/settings.template.json` — are **untouched, not
evolved**, by the rule step 3 states explicitly. Neither raised a question.

The baseline was a pre-0.15 one (paths marked with a leading `*`, raw-byte hashes). The CRLF fallback
was needed and worked: **49** of the 70 baseline entries matched only after re-hashing with CRLF
endings, 20 matched directly, and 1 differed. Without that fallback every one of those 49 would have
been misread as evolved, and this rehearsal would have asked 50 questions instead of 3.

### Troubleshooting steps — 0

Nothing had to be done that the steps do not say. Every command came from the procedure: the 6j
baseline command, the checks under `checks/`, the install's Step 7 hook commands, `walk.sh`.

### Verdict against the bootstrap's own criterion

> *"The rehearsal passes only when every decision asked belongs to a file that genuinely differed or is
> one of the four standing questions … with the pioneer's acceptance of the report at the end not
> counted, and the third number is zero."*

Decision 1 belongs to the one file that genuinely differed. Decisions 2 and 3 are standing questions.
The third number is zero.

**PASS.**

### Separating procedure defects from my own slips

**My own slip — one, disclosed, and I am not counting it as a troubleshooting step.** At step 5 I
copied the staged `templates/` over the installed `templates/` before step 7 needed the installed
copies as the template rule's yardstick. It cost nothing here because I had already captured every
instance-vs-installed-template comparison during step 3, so no judgement was lost and no recovery work
was needed. But it exposed a real ordering trap in the procedure, recorded as finding (a) in section 4.
I am reporting it as both: my sequencing was careless, and the procedure invites it.

**My own slip — two, in this report rather than in the run.** The first draft of this document stated
three counts I had not recounted against the tool output: "50 of the 70" CRLF matches (it is 49),
"63 files" untouched (54 kit files; the figure 63 silently folded in the 9 instance files, which are
never taken from the staged kit), and "sixteen files differ" (28). All three were caught by recounting
before delivery and are corrected above. Recording it because finding (b) below chides the kit for
exactly this, and the same standard applies to the report that raises it.

No other slip. Nothing was re-run, nothing was repaired, nothing was worked around. Neither slip
touched the upgrade itself — the files on disk were produced by the classification, not by these
figures.

---

## 2. The classification, as presented

In a rehearsal there is no one to present to, so the classification goes here.

**Untouched here → take the staged version, no question asked (54 kit files)**
16 of the 17 `meta-*/SKILL.md` (all but `meta-casebook`); `meta-foundation/INTENT.md`; all 10 templates
carried forward; all 11 surviving hooks; `walk.sh`; `walk.expected`; all 7 surviving agents in both
`.claude/skills/agents/` and `.claude/agents/` (14 paths).

The project's 9 instance files — MANIFEST, MAP, FOUNDING, CONTRACT-LOG, CORRECTIONS, LEDGER, DRIFTLOG,
LEARNINGLOG, CASEBOOK — also matched the baseline, but they are records, never replaced from the staged
kit. They are migrated in place at step 7 instead (section 3).

**Evolved here → one question (1 file)**
`.claude/skills/meta-casebook/SKILL.md`. What differs from the staged copy, in three parts: the
`> **Map:**` header names the withdrawn `M-31`; the section `### The launch rebuild (M-31)` (11 lines)
stands where the staged copy has `### The rebuild — withdrawn from the map`; and a `## Project
addition` section the project wrote, which the staged copy naturally does not have. It is not under
`templates/`, so the yardstick warning does not apply. *Keep* was stubbed.

**New in the kit → add (4 files)**
- `agents/kit-batch-assembler.md` → deployed to `.claude/agents/` and kept under `.claude/skills/agents/`
- `meta-mechanisms/hooks/reveal-key.sh`
- `meta-mechanisms/checks/G1-size.sh` (the `checks/` folder did not exist and was created)

**Present here, absent from the staged kit → stale, one question for the whole list (9 files)**

| Stale file | Kept files that still refer to it |
|---|---|
| `.claude/agents/kit-canary-author.md` | none |
| `.claude/skills/agents/kit-canary-author.md` | none |
| `.claude/skills/meta-mechanisms/hooks/reveal-canaries.sh` | none |
| `.claude/skills/templates/REBUILD.template.yaml` | **`meta-casebook/SKILL.md`** (kept) |
| `.claude/skills/meta-mechanisms/tests/walk-004.sh` | none |
| `.claude/skills/meta-mechanisms/tests/fixtures/make-T-2.sh` | none |
| `.claude/skills/meta-mechanisms/tests/results/T-2-2026-09-12.md` | none |
| `.claude/skills/meta-mechanisms/tests/results/T-7-2026-09-12.md` | none |
| `.claude/skills/meta-mechanisms/tests/results/contract-004-tiers.sha1` | none |

The last five are the base kit's own evidence that the earlier install carried — its contract walk,
its fixtures, its `tests/results/`. No `P-NNN.sh` check was present, so none needed removing. The
base kit's own `P-004`–`P-007` checks and `tests/results/` in the staged folder were **not** installed.

**What *keep* leaves the pioneer to weigh at the real run.** `meta-casebook/SKILL.md` is the one kept
file, and it still describes something the staged kit removed:

- line 63 points at `REBUILD.yaml` (never existed here) and `templates/REBUILD.template.yaml` (removed
  as stale by decision 2)
- lines 59 and 69 still name `M-31`, an entry the staged map template withdrew
- its `> **Map:**` "Recognise it by" clause still reads *"— or the milestone in REBUILD.yaml has been
  reached"*

The header's `M-31` was removed automatically (reported, not asked — see section 5). The body was not:
the procedure touches only the header. So *keep* leaves a node whose body describes a mechanism the kit
withdrew and two files that no longer exist. That is the designed output of *keep*, not a fault, but it
is exactly what the pioneer should see before answering this question for real.

---

## 3. Every migration applied, file by file

**`.claude/skills/meta-manifest/MANIFEST.yaml`**
Every base node line and base coverage line still read exactly as the installed template wrote them
(verified before the templates were replaced: the instance differed from its template only in
`kit_name`, `category`, `library_kit` and the two removed `__INHERITED_*__` placeholder lines), so all
of them were refreshed from the staged template. Applied:
- `base_kit_version: 0.14` → `0.15`
- node `agent-canary-author` → `agent-batch-assembler`, taking the staged template's whole node line
  (new concern, `agent_file: agents/kit-batch-assembler.md`), and its coverage line
  "Gate instrumentation — canaries" → "Review batch assembly and re-presented items"
- `base-casebook`: `owns` loses `meta-casebook/REBUILD.yaml`; `triggers` loses `M-31`
- `base-mechanisms`: `triggers` gains `M-07`
- `base-skill-builder`, `agent-consolidator`, `base-ledger` coverage: concern text refreshed
  ("canaries" → "re-presented items")
- `library_kit: null` already present; `kit_type: project` left as the project declared it
- project values carried over unchanged: `kit_name: fx013`, `category: test-api`, `version: 0.1`,
  `parent_kit`, `status`, `gap_queue: []`, `library_entry: null`
- header comment block: identical in both templates, so unchanged
- no project nodes existed, so nothing gained `triggers` from step 8 and no `proposed-entries.md` was
  written

**`.claude/skills/meta-map/MAP.md`**
Every base entry read as the installed template wrote it, so every entry took the staged template's
columns and kept its own status — all were `proposed` and all still are. `M-31 | launch-rebuild` was
withdrawn by the staged template and is removed. Header comment refreshed ("replaces fx013" → "fills in
the project name"). Title `# Map — fx013` preserved. `ratification: deferred` added inside the header
comment on the step 9 deferral. 30 entries, 6,969 bytes → inside the 40-entry / 8,192-byte allowance.

**`.claude/skills/meta-contract-before-execution/CONTRACT-LOG.yaml`**
Header comment block refreshed from the staged template. `contract-001` gained, each at the position
the staged template gives it and each written as a plain scalar: `disappointment: legacy`,
`premortem: legacy`, `red_test: legacy` (after `tier_3`, where `tier_4` would sit) and `cost: legacy`
(after `revisions`, before `work_id`). `verification_state: none` and `audited: false` were already
present and were **not** changed. `approval: gate` left exactly as it is — the staged template lists it
as the pre-0.15 value. Every other recorded value untouched.

**`.claude/skills/meta-correction-log/CORRECTIONS.yaml`**
Header comment block refreshed. `C-001` gained `noticed`, `would_have_been_right` and `seen_before`,
each `not asked`, positioned after `reason_given`. The pioneer's verbatim `agent_offered`,
`pioneer_said` and `reason_given` untouched. `trajectory` block unchanged.

**`.claude/skills/meta-ledger/LEDGER.yaml`**
Header comment block refreshed (it now carries the one-writer list and names `kit-batch-assembler`).
Under `scores`: `canary_catch_rate`, `brier_stated_confidence` and `brier_pioneer_decisions` removed;
`coincidence: []` added. No batches existed, so no `represented: []` was needed; no candidates existed,
so no `lower_bound` to remove. All record sections were empty and remain empty.

**`.claude/skills/meta-drift-eventlog/DRIFTLOG.yaml`** — `entries: []`, nothing to migrate. Its template
is unchanged between the two kits, so the header was not refreshed.

**`.claude/skills/meta-learning/LEARNINGLOG.yaml`**, **`.claude/skills/meta-casebook/CASEBOOK.yaml`** —
empty, templates unchanged between the two kits, nothing applied.

**`.claude/skills/meta-founding-contract/FOUNDING.md`**
Header comment block refreshed from the staged template ("replacing fx013 and 2026-09-12" → "filling in
the project name and the date"). **The statement is untouched, byte for byte:**
`*Given by the Pioneer, 2026-09-12. Recorded verbatim.*` / `> We build a small test API.`
`## Amendments` / `*None ratified.*` unchanged.

**`.claude/skills/meta-casebook/SKILL.md`** (the kept file)
Only its `> **Map:**` header was touched, and only to drop the withdrawn id. Body untouched.

**`.claude/settings.json`** — merged by hand: under each event, groups without a `"_kit"` key kept
(there were none), groups carrying it dropped and the staged template's group for that event appended,
`permissions.deny` entries all kept. The result is byte-identical to the previous file, because the
staged `settings.template.json` is identical to the installed one. The kit's groups were replaced, not
appended twice.

**`CLAUDE.md`** — the `kit-block` markers were present and the block between them is identical to the
staged bootstrap's Step 5a text. Replaced with itself; no change, no span to quote.

**`.gitignore` / `.gitattributes`** — `.claude/kit-sealed/` and `*.sh text eol=lf` both already present.

**Folders** — `meta-ledger/batches/` and `meta-casebook/reconstruction/` were missing from this install
and were recreated (5e). `meta-mechanisms/checks/` created (6h) and `G1-size.sh` installed into it.

**`.claude/skills/meta-manifest/INSTALLED.sha1`** — regenerated with the 6j command after the
ratification marker was written, so the baseline records the map as it is. 68 entries, no leading `*`
(0.15 form). Verified to match the tree exactly afterwards.

---

## 4. What in the procedure is still unclear, wrong or missing

Verbatim as I hit it.

**(a) Step 5 destroys the yardstick step 7 depends on.** The template rule says a template-written part
is refreshed *"only where an installed template exists to compare against"*, and that
*"`.claude/skills/templates/` is the copy the last install shipped, so the comparison is mechanical."*
But step 5 installs `templates/` from the staged kit, and step 7 — which is where the template rule is
actually applied to MANIFEST.yaml, MAP.md and every instance header — runs afterwards. By then
`.claude/skills/templates/` is the **staged** copy, and comparing an instance file against it no longer
answers "does this still read as the installed template wrote it?"; it answers a different question, and
answers it wrongly. I survived this only because I had made every instance-vs-installed-template
comparison during step 3, before step 5 ran. The procedure never says to do that. It should either say
so explicitly in step 3, or tell step 5 to preserve the installed `templates/` until step 7 is done.
This is the one thing in this rehearsal I would fix before the real run.

**(b) A measured figure in the node that forbids unmeasured figures is wrong.**
`meta-map/SKILL.md` states: *"The 30 base entries measure **6,974 bytes** (contract-004 added M-31;
contract-006 withdrew it)"* — in the same paragraph as *"Measure, never estimate: `wc -c` on MAP.md is
the only figure worth quoting, and a stated size that was never measured has already been wrong twice
(C-006, drift-003)."* The shipped `templates/MAP.template.md` measures **6,980 bytes**; the MAP.md this
upgrade produced measures **6,969**. Neither is 6,974. The figure is 6 bytes out, in the sentence that
exists because this has already gone wrong twice. It breaks nothing — `G1-size.sh` passes on the real
measurement — but it is the third instance of the pattern drift-003 records.

**(c) `keep` fixes the header and leaves the body dangling, and the procedure only half-says so.**
Step 3 says *"A kept file whose `> **Map:**` header names an entry the staged template withdrew has
that id removed from its header in step 7, because the header is the map's … this is reported, not
asked."* Step 7 repeats it for the header. Nothing addresses the body. Here the kept file's header was
cleaned of `M-31` while lines 59, 63 and 69 still describe the launch rebuild, still name `M-31`, and
still point at `REBUILD.yaml` and `templates/REBUILD.template.yaml` — the second of which decision 2
deleted. The rehearsal report is required to list this, and does, so the design does catch it — but the
asymmetry is worth stating plainly to the pioneer: *keep* leaves a node that is internally inconsistent
with its own header.

**(d) The baseline pattern cannot see every kit file.** The 6j command matches
`*.md *.yaml *.sh *.expected *.json`. `tests/results/contract-004-tiers.sha1` is none of those, so it
never appeared in the baseline and could not be classified; it was removed only because the stale rule
names the whole `tests/results/` folder. Any future kit file with an unlisted extension is invisible to
the untouched-vs-evolved test and will be silently treated as untouched. Step 3 already handles the
known case of this (`walk.expected`, `settings.template.json` before 0.15) by naming those two files —
a rule about extensions rather than a list of filenames would not need amending next time.

**(e) A cosmetic mismatch between step 2's stub list and step 7's question.** Step 2 says to stub
*"legacy for every existing contract (step 7)"*, which reads as though a question is always asked. Step 7
then skips the question entirely when the fields are already present, as happened here. The stub had
nothing to answer. Not a defect — but a reader following step 2 literally will expect a decision that
never comes, and may count it.

**(f) Expected mid-upgrade noise, confirmed.** The procedure warns that *"an upgrade runs in a live
session, so the hooks fire throughout it against a half-migrated project."* Confirmed: the session-start
backlog printed three live items throughout (unaudited contract, no verification evidence, unclerked
correction) plus the staged-kit line. Nothing needed to be done about it, and nothing was.

---

## 5. State of MAP.md's M-07, M-16 and M-17, and the kept skill's header

All three lines took the staged template's columns and kept their `proposed` status. All three now
point at files that exist.

**M-07** — the load pointer changed from `meta-correction-log → record verbatim first` to a real heading
in the node:
```
M-07 | pioneer-correction | situation + hook cue | must | the pioneer redirects, declines, corrects a tier or bearing, overrides a recommendation, or resets the frame | answers to your own question; approvals | meta-correction-log → How to record | proposed
```
`## How to record` exists at line 37 of `meta-correction-log/SKILL.md`. Confirmed.

**M-16** — retargeted from the retired agent to its replacement:
```
M-16 | review-due | hook: Stop | must | the stop-gate says pioneer-owned items wait, no batch open | — | agent: kit-batch-assembler, then meta-skill-builder → Review Batch | proposed
```
`.claude/agents/kit-batch-assembler.md` exists. The old target `kit-canary-author.md` was removed as
stale, so this line would have pointed at nothing had it not been refreshed.

**M-17** — retargeted from the withdrawn script to the two that replaced it:
```
M-17 | batch-decided | hook: Stop | must | every item in the open batch carries a decision | — | script: close-batch.sh, then reveal-key.sh; meta-skill-builder → Reveal | proposed
```
Both `close-batch.sh` and `reveal-key.sh` exist. The old target `reveal-canaries.sh` was removed as
stale — the same trap, avoided the same way.

This is the check step 7 names: *"An entry that names a file step 5 removes and was not refreshed here
is an error in this list, not a judgement call."* No such error remains. `M-31` no longer appears in
MAP.md at all.

**The kept skill's header** — `M-31` removed, the rest of the line left as the project's:
```
> **Map:** M-04, M-05, M-26 · **Load:** retrieved on trigger by moment tag · **Recognise it by:** "we have decided a situation like this before" — or the milestone in REBUILD.yaml has been reached · **Not when:** the question is what the rule says (that is the node) rather than how it was applied
```
Reported, not asked, as step 3 requires. Note the "Recognise it by" clause still names `REBUILD.yaml`:
that half of the line is the kept file's own wording and stays, per *"the rest of the line is the kept
file's and stays"* — and it is listed here because it still names something withdrawn.

---

## 6. End state

**`.claude/kit-incoming/` — gone.** Removed after the report was accepted (stubbed). Confirmed absent.
The session-start hook was run before and after: before removal it printed
`- A newer kit is staged in .claude/kit-incoming/ -> M-27 …`; after removal that line is gone and the
backlog shows only the project's three live items. The M-27 trigger no longer fires.

**`walk.sh` — passes.** `bash .claude/skills/meta-mechanisms/tests/walk.sh` → exit 0,
`walk: all 36 states match walk.expected`.

**Everything else step 9 asks for:**

| Check | Result |
|---|---|
| `checks/G1-size.sh` | exit 0 (INTENT.md 4,820 B ≤ 5,120; MAP.md 6,969 B ≤ 8,192; 30 entries ≤ 40) |
| `session-start.sh` | valid JSON, exit 0 |
| `prompt-submit.sh` | valid JSON, exit 0 |
| `stop-gate.sh` | valid JSON, exit 0 — hands over the M-11 audit task for contract-001 |
| `subagent-stop.sh` | silent, exit 0 |
| `post-read.sh` | silent, exit 0 |
| `owner-check.sh` | silent, exit 0 |
| `batch-blind.sh` | silent, exit 0 (no batch open) |
| `deny-paths.sh` | silent, exit 0 |
| `write-scope.sh` | valid JSON deny, exit 0 |
| `close-batch.sh B-001` | "No batch file", exit 1 — the expected result |
| `reveal-key.sh B-001` | "No batch file", exit 1 — the expected result |
| `telemetry.log` | gained its `loaded\|meta-map/MAP.md` line, and a `bypass\|base-casebook` line |

`telemetry.log` did not exist before these checks, so the file itself was deleted afterwards, as step 9
directs. The temporary baseline file was removed from the project root. The regenerated
`INSTALLED.sha1` was verified to match the tree hash for hash after everything above.

**Line endings.** A mixed tree is expected and harmless, and no step checks or repairs them; none were
checked or repaired here.
