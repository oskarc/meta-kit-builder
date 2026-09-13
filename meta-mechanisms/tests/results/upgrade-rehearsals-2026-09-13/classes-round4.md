# Upgrade rehearsal — classes-kit, base-building-kit v0.13-or-earlier → v0.15

Run 2026-09-13 on a throwaway copy of the project, following the **staged** kit's
`meta-bootstrap/SKILL.md` → *Upgrading an Existing Install*, steps 3–9, with the pioneer's answers
stubbed exactly as step 2 prescribes: *keep* for every differing file, *remove* for the stale list,
*legacy* for every existing contract, *none for now* for the map question, *defer* for the
ratification pass, and the report accepted at the end.

**Step 1 (stage it).** Staged kit `kit_identity.version: 0.15`. The project's manifest has **no
`base_kit_version` field at all**, so the project is treated as pre-0.14 and no version is guessed.

In a rehearsal there is no one to present to, so the classification and every offer are recorded
here instead of being shown.

---

## 1. The three numbers

### Decisions asked — 17

One question per file that genuinely differed (14):

| # | File | The question put |
|---|---|---|
| 1 | `meta-antidrift/SKILL.md` | overwrite / keep / port |
| 2 | `meta-antidrift-expand/SKILL.md` | overwrite / keep / port |
| 3 | `meta-bootstrap/SKILL.md` | overwrite / keep / port |
| 4 | `meta-contract-artifact/SKILL.md` | overwrite / keep / port |
| 5 | `meta-contract-before-execution/SKILL.md` | overwrite / keep / port |
| 6 | `meta-drift-eventlog/SKILL.md` | overwrite / keep / port |
| 7 | `meta-extract/SKILL.md` | overwrite / keep / port |
| 8 | `meta-foundation/SKILL.md` | overwrite / keep / port |
| 9 | `meta-founding-contract/SKILL.md` | overwrite / keep / port |
| 10 | `meta-learning/SKILL.md` | overwrite / keep / port |
| 11 | `meta-manifest/SKILL.md` | overwrite / keep / port |
| 12 | `meta-skill-builder/SKILL.md` | overwrite / keep / port |
| 13 | `templates/MANIFEST.template.yaml` | overwrite / keep / port |
| 14 | `meta-manifest/MANIFEST.yaml` | the template rule, one question for the file: its base node lines and base coverage lines do not read as any installed template wrote them, and there is no pre-0.14 template for them to be compared against — overwrite them, keep them, or port |

Standing questions (3 of the four):

| # | Question | Stub |
|---|---|---|
| 15 | Step 7 — should any recent implemented contract be verified and audited rather than marked legacy? | legacy for all 80 |
| 16 | Step 8 — which drafted project entries belong in the always-loaded map, and which are reached through the nodes that already name them? | none for now |
| 17 | Step 9 — the ratification pass on the 30 base map entries | defer |

**Not asked: the stale-file question (step 3).** The list came back empty — no agent, hook, script,
template, `P-NNN.sh` check, contract walk, fixture or `tests/results/` folder is present here that the
staged kit no longer ships, because this install predates all of them. There was nothing to confirm,
so no question was put. If that standing question is counted as always asked, the number is 18; the
rehearsal passes either way, since it is one of the four permitted standing questions.

### Files that genuinely differed — 14

The 13 kit files in rows 1–13 above, plus `meta-manifest/MANIFEST.yaml`. Every one was verified by
content hash against the staged copy with carriage returns stripped, not by assumption. Nothing was
byte-identical: with no `INSTALLED.sha1` to compare against, every kit file had to be treated as
possibly evolved, and the comparison against the staged copy is what separated "differs" from
"identical". The four remaining instance files — `CONTRACT-LOG.yaml`, `DRIFTLOG.yaml`,
`LEARNINGLOG.yaml`, `FOUNDING.md` — are the project's and are never replaced, so they are not
classified and no question was asked about them.

### Troubleshooting steps — 0

Nothing the procedure does not say had to be done to make the upgrade work. Every step ran as
written, and all three schema migrations passed their verification on first execution.

**Two slips of my own, disclosed, and not counted in that number.** Neither is a gap in the
procedure and neither touched the project:

1. The first draft of my manifest migration script referenced two lookup sets it never populated and
   mishandled being given more than one control input. I caught it by reading the script back before
   running it and rewrote it; the faulty version never executed.
2. I re-read a region of `MANIFEST.yaml` at a line offset that had gone stale after an earlier
   insertion, and got the wrong region back. Cost: one extra lookup. No write was made from it.

I am counting neither, because the third number measures the procedure, not my scripting. Had either
reached a file, I would have counted it and said so.

**Method note.** `CONTRACT-LOG.yaml` (10,650 lines), `DRIFTLOG.yaml` (5,086) and `MANIFEST.yaml`
(2,097) are too large to migrate by hand, so the additive field insertions were made by three small
`awk` passes. Choosing `awk` over several hundred manual edits is a means of doing what step 7 says,
not a step step 7 omits. Each pass was verified the same way: strip exactly the inserted lines from
the result and diff against the original. All three came back **identical**, so nothing but the named
fields changed.

### Verdict — **PASS**

The bootstrap's own criterion: *"The rehearsal passes only when every decision asked belongs to a
file that genuinely differed or is one of the four standing questions … with the pioneer's acceptance
of the report at the end not counted, and the third number is zero."*

All 17 decisions qualify — 14 belong to files that genuinely differed, 3 are standing questions. The
third number is zero. The report's acceptance was not counted.

---

## 2. The classification, as it would have been presented

> **No install baseline exists.** `meta-manifest/INSTALLED.sha1` is absent — this project was
> installed before it existed. Every kit file must therefore be treated as possibly evolved here, and
> the questions will be one per skill. I can only diff against the staged copy, because a baseline
> holds hashes, not text.
>
> **Untouched here → take the staged version, no question asked:** none. Every kit file this project
> carries differs from the staged one.
>
> **Evolved here → one question each (14):** the 12 `meta-*/SKILL.md` files, `templates/MANIFEST.template.yaml`,
> and `meta-manifest/MANIFEST.yaml` under the template rule. Sizes give the shape of the gap:
>
> | File | Installed | Staged | What changed |
> |---|---|---|---|
> | `meta-manifest/SKILL.md` | 4,804 | 11,627 | gains the six-layer model and the whole schema reference — `kind`, `load`, `triggers`, `owns`, status and tier vocabularies |
> | `meta-skill-builder/SKILL.md` | 7,640 | 18,795 | input changes from the Standard Evolution Report to the review batch; gains Reveal, drift back-reference, contradictions |
> | `meta-contract-before-execution/SKILL.md` | 19,225 | 29,672 | gains The Bearing, The Precedent Check, Tier 4; "Standard Evolution Report" becomes "Record, Don't Present" |
> | `meta-foundation/SKILL.md` | 15,011 | 20,736 | six aspects become five agent + five human; gains "What This Is In Service Of" |
> | `meta-bootstrap/SKILL.md` | 10,920 | 43,875 | the install is rewritten and the entire upgrade path is new |
> | `meta-drift-eventlog/SKILL.md` | 8,275 | 12,168 | aspect vocabulary split agent/human; `mitigation_medium` added to elevations |
> | `meta-extract/SKILL.md` | 9,715 | 12,284 | gains the reconstruction test and instrumented maturity |
> | `meta-antidrift-expand/SKILL.md` | 5,628 | 8,324 | "Discipline Fall Point" renamed "Drift Onset Point"; gains cross-session drift reading |
> | `meta-contract-artifact/SKILL.md` | 17,100 | 19,424 | verification status now sourced from the verifier's verdicts |
> | `meta-antidrift/SKILL.md` | 7,136 | 8,129 | block drops to five aspects and loses the format-compliance line; gains the auditor pairing |
> | `meta-learning/SKILL.md` | 9,328 | 10,038 | State C now comes only from the verification record |
> | `meta-founding-contract/SKILL.md` | 6,744 | 7,901 | same section shape, tightened |
> | `templates/MANIFEST.template.yaml` | 6,885 | 16,604 | 8 base nodes become 26; gains `base_kit_version`, `kind`, `load`, `triggers`, `owns` |
>
> **Keeping these leaves files that no longer describe the installed lifecycle.** Section 7 below
> lists exactly what each kept file still describes that the staged kit removed or renamed.
>
> **New in the kit → added, no question (51 files):** `meta-foundation/INTENT.md`; the five new nodes
> `meta-map`, `meta-mechanisms`, `meta-ledger`, `meta-casebook`, `meta-correction-log`; 12 hooks; the
> kit's own check `G1-size.sh`; the travelling walk `walk.sh` + `walk.expected`; 9 templates; the 8 kit
> agents, deployed to `.claude/agents/` and kept as the kit's own copy under `.claude/skills/agents/`.
>
> **Present here, absent from the staged kit → stale:** nothing. The list is empty.
>
> **Not installed, because they are the base kit's own evidence and do not travel:** `P-004.sh`,
> `P-005.sh`, `P-006.sh`, `P-007.sh`, `walk-004.sh`, `walk-007.sh`, `tests/fixtures/`, `tests/results/`.
>
> **Agent name collisions:** none. The project's 8 `dashboard-*` agents share no name with the kit's 8
> `kit-*` agents.

---

## 3. Every migration applied, file by file

### Installed from the staged kit (51 files)

| Path | Was | Now |
|---|---|---|
| `meta-foundation/INTENT.md` | absent | 4,820 B — always loaded by CLAUDE.md |
| `meta-map/SKILL.md`, `meta-mechanisms/SKILL.md`, `meta-ledger/SKILL.md`, `meta-casebook/SKILL.md`, `meta-correction-log/SKILL.md` | absent | 5 new nodes |
| `meta-mechanisms/hooks/*.sh` | absent | 12 hooks |
| `meta-mechanisms/checks/G1-size.sh` | absent | the kit's only travelling check |
| `meta-mechanisms/tests/walk.sh`, `walk.expected` | absent | the lifecycle walk |
| `templates/` ×9 | 1 template | 10 templates |
| `.claude/agents/kit-*.md` ×8 | absent | deployed |
| `.claude/skills/agents/kit-*.md` ×8 | absent | the kit's own copy, which the checks read |
| `.claude/settings.json` | **absent** | written from `settings.template.json` as-is; 6 hook groups each carrying `"_kit": "base-building-kit"`, plus `Read(kit-sealed/**)` in `permissions.deny` |
| `.gitignore` | absent | `.claude/kit-sealed/` |
| `.gitattributes` | absent | `*.sh text eol=lf` |
| `meta-ledger/batches/`, `meta-casebook/reconstruction/` | absent | created |

Every copied file was re-hashed against its staged source: **all match**.

### Seeded — instance files that were missing (4)

`meta-ledger/LEDGER.yaml`, `meta-correction-log/CORRECTIONS.yaml`, `meta-casebook/CASEBOOK.yaml` from
their staged templates as empty seeds; `meta-map/MAP.md` from `MAP.template.md` with
`__PROJECT_NAME__` → `classes-kit`. No placeholder remains in any of them.

### Kept, untouched (13)

The 12 `meta-*/SKILL.md` files and `templates/MANIFEST.template.yaml`, on the stubbed *keep*.
Confirmed after the run: `templates/MANIFEST.template.yaml` still hashes differently from the staged
copy, so it was not silently replaced.

### Existing instance files — never replaced, migrated additively

**`meta-contract-before-execution/CONTRACT-LOG.yaml`** — 10,650 → 11,130 lines (**+480**), 679,653 B.

- 80 entries (77 contracts + 3 analysis reports) each gained six fields, none of which existed anywhere
  in the file: `disappointment: legacy`, `premortem: legacy`, `red_test: legacy` immediately before the
  entry's `status:`; `verification_state: legacy`, `audited: legacy` immediately after it; `cost: legacy`
  immediately before `work_id:` where present (54 entries), otherwise at the end of the entry (26).
- `approval:` was **not** added — the step says an older `approval: gate` stays as it is, and does not
  ask for one where it is absent. No entry here has one.
- Header comment block refreshed from the staged template (86 lines) with the project's own 11 header
  lines carried over beneath it.
- Verified: stripping exactly the 480 inserted lines reproduces the original **byte for byte**.

**`meta-drift-eventlog/DRIFTLOG.yaml`** — 5,086 → 5,151 lines (**+65**), 287,033 B.

- 54 entries. All 65 elevations written as maps gained `mitigation_medium: unknown`, positioned between
  `kind:` and `date:` as the staged template orders them.
- 15 elevations written as `elevation: []` or as a flow list of a bare name (`elevation:
  [feedback_never_discard_uncommitted_work]`) were left exactly as they are — the step says a prose
  elevation is not touched.
- Both key spellings were handled: 38 entries use `elevation:`, 16 use `elevations:`.
- Header refreshed (44 template lines + 27 carried over).
- Verified: stripping the 65 inserted lines reproduces the original byte for byte.

**`meta-manifest/MANIFEST.yaml`** — 2,097 → 2,620 lines from the node pass, then the structural edits;
173,294 B final.

- **108 of 111 registered nodes** gained `kind`, `owns`, `load`, `triggers`, each at the position the
  staged template gives it (`kind` before `skill_file`; `owns` after `skill_file`/`data_file`; `load`
  and `triggers` after `phase`, before `status`).
- Base nodes took their `kind`/`load`/`triggers`/`owns` from the staged template verbatim. Project nodes
  took `kind: skill`, `load: trigger`, `owns: [<own skill file>]`, `triggers: []`.
- **91 project nodes** also gained `note: entry pending the map question`. Five did not — see defect (c).
- **3 nodes were left exactly as they are**, being the later of two registrations of one skill file:
  `verify-api-shape`, `embed-before-own`, `host-already-does-it`. Each duplicates an earlier `base-`
  prefixed line naming the same `skill_file` (`principle-verify-api-shape/SKILL.md`,
  `principle-embed-before-own/SKILL.md`, `principle-host-already-does-it/SKILL.md`). The earlier line
  keeps the id; the duplicate stays and is reported, exactly as step 7 says.
- **Renamed by `skill_file` match:** `contract-artifact` → `base-contract-artifact`, because its
  `skill_file` is `meta-contract-artifact/SKILL.md`, which the staged template registers under that id.
  Both `dependencies` lists naming the old id were updated — `base-contract`'s and `dashboard-exact`'s.
- **14 new base nodes registered**, node lines taken verbatim from the staged template in its one-line
  flow form: `base-intent`, `base-map`, `base-correction-log`, `base-casebook`, `base-mechanisms`,
  `base-ledger`, and the 8 agent nodes. Registered count: 111 block-form + 14 flow-form = **125**.
- **15 new base coverage lines** added, likewise verbatim.
- `kit_identity` gained `base_kit_version: 0.15` and `library_kit: null`. `kit_type: type-category` was
  **left as the project declared it**, as the step requires. It is not `base`, so the mechanisms treat
  this project as installed and fire.
- Header comment block refreshed, project header line carried over beneath.
- Checked afterwards: no node carries two `note:` keys, no bare `contract-artifact` remains.
- **Values outside the staged template's enumerations, left as they are and listed here** — `phase`:
  `pre/during` (21), `[during-build]` (25), `[pre-build]` (11), `pre/during/post` (4), `during/post` (4),
  `pre/post`, `pre`, `post`, `[verify]`, `[pre-build, during-build, verify]`, `[during-build, verify]`,
  `[post-build, pre-build]`; `layer`: `playbook` (9); `status`: `emerging` (36), `seeded` (1).
- Verified: stripping exactly the 523 inserted lines from the node pass reproduces the pre-pass file
  byte for byte.

**`meta-learning/LEARNINGLOG.yaml`** and **`meta-founding-contract/FOUNDING.md`** — untouched. Step 7
names neither, and FOUNDING.md already exists, so step 6e did not fire.

### The map

**`meta-map/MAP.md`** — created from the staged template: 30 base entries, 6,975 B. Then step 9's
deferral added `ratification: deferred` inside the header comment block, with a three-line note saying
why: **7,188 B, 30 entries**. No base entry was modified — they arrive from the template, so the
template rule has nothing to refresh and no entry was withdrawn. **No project entry was written into
the map** (section 5).

**`meta-map/proposed-entries.md`** — created, 13,083 B, 99 drafted entries, not loaded.

### CLAUDE.md

The old block had **no `kit-block` markers**, so the replaced span is the contiguous text from the
kit's heading to the first horizontal rule. Quoted in full, as step 5 requires:

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

Replaced by the staged block with `<!-- kit-block:start -->` / `<!-- kit-block:end -->` markers added.
Everything below the first horizontal rule — the whole "Classes mod — working rules" section, 8,583 B
of project content — is untouched.

### The baseline

`meta-manifest/INSTALLED.sha1` written after the deferral marker, as step 9 orders it: **175 files**
(124 before the upgrade). Hashes are taken over content with carriage returns removed, so a file
re-saved with other line endings still matches at the next upgrade.

### Checks and mechanisms run at step 9

- `checks/G1-size.sh` — **exit 0**. The only check that travels.
- All 11 Step 7 hook commands ran. Each printed valid JSON or nothing.
  `close-batch.sh B-001` and `reveal-key.sh B-001` both reported *no batch file* and exited 1, which is
  the expected result.
- `telemetry.log` gained its `loaded|meta-map/MAP.md` line and an ownership line naming `base-casebook`
  — the proof that `owns:` survived the manifest migration.
- Those lines were then deleted, since they are the check's and not a session's.
- `.claude/kit-incoming/` removed on the stubbed acceptance of the report; the step-3 temporary
  baseline file removed with it.

---

## 4. What was unclear, wrong or missing — quoted as I hit it

**(a) The header-block rule and the one-question rule contradict each other for a pre-0.14 project.**

> "On an upgrade a header comment block is always refreshed from the staged template — it is
> instruction, never record; a comment line found in it that the installed template never had (someone
> kept a note there) is carried over beneath the refreshed block."

against, three sentences later:

> "Parts the pioneer changed, and every part where no installed template exists to compare against (a
> project from before the template existed), are asked about **once per file**."

This project has no installed template for `CONTRACT-LOG.yaml` or `DRIFTLOG.yaml`. So "a comment line
that the installed template never had" has no referent: either every line in those headers qualifies,
or none does. I took the reading that loses nothing — refresh from the staged template, carry the
whole existing header beneath it under a marked line — and asked no question, because the first
sentence says *always*. A pioneer could reasonably read it the other way and expect two more questions.

**(b) Refreshing an instance file's header from a template installs template-only instructions into a
file full of real records.** The rule calls the header "instruction, never record", which is true of
the staged template's header — but that header is written *to* a template. After the refresh,
`CONTRACT-LOG.yaml`, which holds 80 real contracts, opens with "meta-bootstrap copies this file as the
empty seed", and `MANIFEST.yaml`, which holds 125 nodes, opens with "This file is a template …
replaces every value written in double-underscore form". Both are now false statements at the top of
the project's own records. The step has no way to say "refresh the parts that are instruction, drop
the parts that describe a template".

**(c) Step 7 tells you to write a `note:` onto project nodes that may already have one, and forbids
the only other option.** The instruction:

> "a project node whose entry waits in `proposed-entries.md` gets `triggers: []` and `note: entry
> pending the map question`"

against the rule that governs the whole list:

> "add what is missing, remove only the retired keys this list names, **never change a value that is
> present**"

Eleven nodes already carry a `note:`. Adding a second one shadows the first — YAML is last-wins, which
is the base kit's own `gap-008`. Appending to the existing note changes a value that is present. No
third option is offered. I added the marker to the 91 nodes that had no note and left these five
project nodes without it: `native-boundary-has-no-catch`, `gate-the-count-not-the-credit`,
`in-world-voice`, `flavor-composition`, `commitment-gates-earning`. They now carry `triggers: []` with
nothing saying why.

**(d) `cost: legacy` does not fit the shape the template documents.** Step 7 asks for `cost: legacy`;
the template defines `cost: {turns: 0, tokens: null, pioneer_minutes: null}`. "new values are written
as plain scalars" resolves the conflict in favour of the scalar, which is what I wrote — but `cost` is
not in the marker-key table, so nothing will ever notice that 80 entries hold a string where a map
belongs.

**(e) The field positions assume an entry shape this project's entries do not have.** "each field at
the position the staged template gives it" puts `disappointment` and `premortem` between `tier_3` and
`tier_4`. No legacy entry has a `tier_4`, and these entries carry 60-odd project-specific keys the
template never described (`phases`, `anchors`, `rulings`, `locked_spec`, `flagged_judgements`,
`approval_quote`, …). I anchored on `status:`, which every entry has exactly once, and put the three
pre-status fields immediately before it and the two post-status fields immediately after. The step
gives no rule for an entry shape the template does not cover.

**(f) The stale question has no defined behaviour when the list is empty.** Step 3 says to remove stale
files "only on the pioneer's confirmation, in one question for the whole list", and the rehearsal stub
supplies an answer for it — but the list here is empty. The pass criterion counts it among the four
standing questions, which reads as though it is always asked. Asking a pioneer to confirm the removal
of nothing is noise, so I did not ask. The count differs by one depending on the reading.

**(g) Step 8 produces 99 drafted entries that no one will read, and leaves every project skill without
the header the map calls co-owned.** The step says to draft an entry "from its description" for each
non-base node. With 96 skills the drafts are placeholders — I generated each from the node's own
`concern` field, with the moment name, channel and "not when" as agent placeholders, and said so at the
top of `proposed-entries.md`. And because "a `> **Map:**` header is added only to a skill whose entry is
in the map", **not one of the 96 project skills carries a `> **Map:**` header after the upgrade**,
while all 17 kit nodes that ship with one do. `meta-map` calls the header and the entry co-owned; here
they are co-absent, project-wide, and nothing flags it.

**(h) Nothing seeds `meta-ledger/telemetry.log`, and step 9 does not say what to leave behind.** The
file is named in `base-ledger`'s `owns:` and is refused by `batch-blind.sh` by path, but it does not
exist until a hook writes to it. The check commands created it; step 9 then says "delete those lines
afterwards", which leaves the question of whether a file that did not exist before should end up empty
or absent. I truncated it to empty.

**(i) A limit of this rehearsal, not a defect.** The procedure warns that on a real run the hooks fire
throughout against a half-migrated project, and says that state "is first seen" in the rehearsal. It
was not seen here: this copy has no live session bound to it, so the hooks only ran when I ran them
explicitly at step 9. A real upgrade will hit backlog lines and gate tasks mid-migration that this
rehearsal did not exercise.

---

## 5. The project's own skills, and the size check

**96 project skill folders**, registered under **99 manifest node lines** (3 skill files are registered
twice), plus 8 project agents under `.claude/agents/`.

- **Not one project skill file was read into, edited, moved or deleted.** They are outside everything
  "the kit" means.
- 96 of the 99 registrations gained `kind: skill`, `load: trigger`, `owns: [<own skill file>]`,
  `triggers: []`; 91 also gained the pending-entry note. The 3 duplicate registrations were left
  untouched and are named in section 3.
- The 8 `dashboard-*` project agents were left in place. No name collides with the kit's `kit-*` agents.
- One project skill folder, `dashboard-exact/`, carries two extra files (`LESSONS.md`,
  `RUN_CLOSE_TEMPLATE.md`) — untouched, and now included in the install baseline.

**The size check, measured and not estimated** — `checks/G1-size.sh`, run three times:

| Map contents | Bytes | Entries | `G1-size.sh` |
|---|---|---|---|
| 30 base entries + all 99 drafted project entries | 18,656 | 129 | **exit 1** — over the 8,192-byte allowance |
| 30 base entries + the 16 dependency-root entries only | 8,824 | 46 | **exit 1** — over both the byte and the 40-entry allowance |
| 30 base entries only (**the state left on disk**) | 6,975 | 30 | **exit 0** |
| …plus the `ratification: deferred` marker (final) | 7,188 | 30 | **exit 0** |

Step 8's fallback therefore applied in full: the roots alone still fail, so the map keeps only its base
entries and **every** drafted entry waits in `proposed-entries.md` for the one map question. The map was
never written past the check — each over-budget state was measured on a copy and reverted. The 16
dependency roots are marked in `proposed-entries.md` so the pioneer can see which entries the rest are
reachable through.

---

## 6. What a session in the upgraded project sees at start

**Always loaded, via the three CLAUDE.md imports:** `meta-foundation/INTENT.md` (4,820 B),
`meta-founding-contract/FOUNDING.md` (the pioneer's statement of 2026-08-30, verbatim and unchanged),
`meta-map/MAP.md` (7,188 B, 30 base entries, all `proposed`, ratification deferred). Below the kit
block, the project's own "Classes mod — working rules" section, unchanged.

**The `SessionStart` hook prints** (captured after the staged folder was removed):

```
Kit backlog (session-start hook):
- Drift entries watching or mitigated: 38 -> M-18 stay alert to those aspects
- Pioneer-owned items are waiting (candidates, map proposals, unratified entries, unranked cards,
  precedent conflicts or drift resolutions) -> M-16 kit-batch-assembler assembles the batch
Act on each line through its map entry, one kit task at a time. The pioneer does not need to
invoke any of this.
```

Two lines, both from the project's live records — 38 drift entries in `watching` or `mitigated` from
five months of real work, and the pioneer-owned line, which fires on those same mitigated entries
rather than on the map. The deferral marker is doing its job: the 30 unratified base entries are
**not** opening a batch. While `.claude/kit-incoming/` was still present a third line named the staged
kit and pointed at M-27; it stopped once the folder was removed.

**On the first prompt**, `UserPromptSubmit` adds: *"before acting, name this moment by its map id
(meta-map/MAP.md) and load what that entry points to. Close the turn with the drift score block from
INTENT.md."*

**At the end of the first turn**, the stop-gate hands over one task — assemble a review batch
(M-16) — and will keep handing it over until the batch is assembled, presented, closed and revealed.
So the first thing the upgraded project asks of its pioneer is a review batch built from five months of
drift history.

**Also live but silent until used:** 8 kit agents in `.claude/agents/`, 6 hook groups in
`.claude/settings.json`, `Read(kit-sealed/**)` denied, and an empty ledger, casebook and correction log.

---

## 7. Every kept file that still describes something the staged kit removed or renamed

This is what *keep* costs, and it is the part the stubs cannot measure. Thirteen files were kept; **all
thirteen** now describe a lifecycle that is no longer installed.

| Kept file | Still describes | The staged kit's position |
|---|---|---|
| `meta-antidrift/SKILL.md` | a 9-line block with `stop when falls`, `discipline is work` and `format compliance … DEGRADED` (lines 27, 31, 34); "maximum 11 lines" (line 22) | the block moved to `INTENT.md` and has **7** lines with five agent aspects; `discipline is work` and the whole format-compliance/DEGRADED layer are gone; `stop when falls` is `stop on triggers`. A session following the kept file will emit a block the new `INTENT.md` does not define |
| `meta-antidrift-expand/SKILL.md` | `### 4 — Discipline Fall Point` (line 76) | renamed *Drift Onset Point*; the node also gains a cross-session drift-log section the kept file lacks |
| `meta-bootstrap/SKILL.md` | "This project operates within the **meta-kit-builder** practice" (line 76) and `parent_kit: meta-kit-builder` (line 171) — the CLAUDE.md block it would write, which is the one just replaced; **and an upgrade section that predates every field this upgrade migrated** | the kit is `base-building-kit`; the staged upgrade section is what was followed. This is `gap-032` made concrete: M-27 routes an upgrade to the *installed* bootstrap, so the next upgrade of this project will follow this stale text unless the pioneer is told again to use the staged copy |
| `meta-contract-before-execution/SKILL.md` | `## The Three-Tier Proposal` (line 77); `implemented` set when "the Standard Evolution Report is produced" (line 149); `## Closing the Contract` with **How was the run?** (line 233); a status table with no `verification_state`, no `audited`, no `cost`; no bearing, no precedent check, no Tier 4 | four tiers ending in acceptance tests; the SER is *recorded to the ledger, not presented*; the close is the stop-gate's, not a question. **The contract log this file governs now carries six fields this file never mentions** — the migration wrote them, the skill cannot explain them |
| `meta-skill-builder/SKILL.md` | `## Input — Standard Evolution Report` (line 10) | input is the review batch; Reveal, re-presented items, contradictions and the retire exit are all absent from the kept file. The kit agent `kit-batch-assembler` is installed and will produce batches this skill does not describe how to run |
| `meta-manifest/SKILL.md` | frontmatter "**Load this file at the start of every session**" (line 3) and "At the start of every session, load MANIFEST.yaml and read the full node list" (line 47) | the manifest loads on trigger (M-22, M-23) and is explicitly "no longer read every session". The kept file also has no six-layer model and no schema for `kind`, `load`, `triggers` or `owns` — **the four fields this upgrade just added to 108 nodes** |
| `meta-drift-eventlog/SKILL.md` | `aspect: lay-of-the-land \| stop-when-falls \| partner-mirror \| elevation-not-recovery \| meta` (line 43); the elevation schema with no `mitigation_medium`; a cross-reference to the expand skill's "Discipline Fall Point" (line 128) | the vocabulary splits into five agent and five human aspects; `mitigation_medium` is required — **this upgrade wrote it onto all 65 elevations in a log whose governing skill does not define it** |
| `meta-foundation/SKILL.md` | six governing aspects including "**Discipline is the work, not overhead on it**" (line 91), undivided between agent and human; a closing "Principles" section holding a Bannerlord-specific rule about host VMs | five agent aspects and five human aspects, split deliberately; no sixth aspect; no project-specific principles. `INTENT.md`, now always loaded beside it, states the five-and-five split — the two disagree in every session |
| `meta-learning/SKILL.md` | "invoked explicitly by the pioneer — it is not part of the continuous load order" (line 25), and a "Goal and meaning" section framing the diff against the SER | the learning sweep is handed over by the stop-gate at M-13, not invoked by the pioneer; State C comes only from the verification record |
| `meta-extract/SKILL.md` | promotion criteria ending in "A non-developer has successfully used it" | criteria are instrumented — candidates per contract falling while sessions are audited and contracts verified — and a reconstruction test must have run. The kept file has no Step 2b and no reconstruction |
| `meta-contract-artifact/SKILL.md` | "It changes nothing about **the three tiers**, the spec lock, the playbook declaration" (line 7); status sourced from the page | four tiers; verification status is taken from the verifier's clause verdicts |
| `meta-founding-contract/SKILL.md` | the same sections as the staged copy, in older wording | the least costly keep of the thirteen; no removed or renamed thing is described |
| `templates/MANIFEST.template.yaml` | **8 base nodes**, and no `base_kit_version`, `kind`, `load`, `triggers` or `owns` | 26 base nodes and all five fields. This is the sharpest one: the template is the yardstick the *next* upgrade uses to tell "as the template wrote it" from "the pioneer changed it". Keeping the pre-0.14 template means the next upgrade compares the migrated manifest against a template that predates the fields it now holds, and will classify correctly-migrated base node lines as pioneer-changed — asking the question again, forever |

**Two consequences that are not per-file:**

- **No kept file carries a `> **Map:**` header** — confirmed, zero of the thirteen. The map's 30 base
  entries point at nodes whose files do not name the entries that load them, so the co-ownership
  `meta-map` requires cannot be checked in either direction for any kept node.
- **Nothing here is reported as a stale-file removal**, because every one of these files still exists in
  the staged kit. *Keep* leaves them pointing at a lifecycle that is installed and running around them.

For the real run, the honest reading of the stub is that *keep* on all thirteen produces a working set
of mechanisms wrapped around a set of skills that describe the previous kit. The mechanisms will fire
correctly — they read the records, and the records were migrated — but the prose the agent loads when
a map entry routes it to a node will, in eleven of the thirteen cases, describe the wrong lifecycle.
The two files where *keep* is cheap are `meta-founding-contract/SKILL.md` and, arguably,
`meta-contract-artifact/SKILL.md`.

---

*Rehearsal complete. The copy is disposable; nothing here was run against the real project.*
