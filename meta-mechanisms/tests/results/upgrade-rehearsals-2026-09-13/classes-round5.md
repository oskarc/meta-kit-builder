# Upgrade rehearsal — Classes kit, 0.2-era install → base-building-kit 0.15

Run on a throwaway copy of the project's `CLAUDE.md` and `.claude/`, following the **staged**
kit's `meta-bootstrap/SKILL.md` → *Upgrading an Existing Install*, steps 3–9, with the
pioneer's answers stubbed exactly as step 2 prescribes: *keep* for every differing file,
*remove* for the stale list, *legacy* for every existing contract, *none for now* for the map
question, *defer* for the ratification pass, and the report accepted at the end.

Date: 2026-09-13. In a rehearsal there is no one to present to, so the classification and
every offer are recorded here instead.

---

## 1. The three numbers

### Decisions asked: **21**

**One question per evolved kit file — 13.** No `INSTALLED.sha1` existed, so step 3's rule
applies: *"With no baseline, say plainly that every file must be treated as possibly evolved —
and that the questions will therefore be one per skill."* Every one was stubbed **keep**.

| # | File | What differs |
|---|---|---|
| 1 | `meta-antidrift/SKILL.md` | 95 → 109 lines. Staged drops *What ABSENT and DEGRADED Mean*; adds *Why Only the Agent's Aspects Are Scored*, *Persistence Across Sessions*, *Alongside the Session Auditor* |
| 2 | `meta-antidrift-expand/SKILL.md` | 134 → 155. *Discipline Fall Point* → *Drift Onset Point*; adds *Cross-Session Context* |
| 3 | `meta-bootstrap/SKILL.md` | 195 → 385. Whole install rewritten (Steps 2–5 renumbered, Steps 6–7 new); *Upgrading an Existing Install* added |
| 4 | `meta-contract-artifact/SKILL.md` | 328 → 362. Same headings; verifier-sourced states and log-is-the-record rework |
| 5 | `meta-contract-before-execution/SKILL.md` | 272 → 331. *The Three-Tier Proposal* → *The Proposal* + *Tier 4 — Acceptance Tests*; adds *The Bearing*, *The Precedent Check*; *After Implementation* becomes *Record, Don't Present* |
| 6 | `meta-drift-eventlog/SKILL.md` | 140 → 162. Same headings; `mitigation_medium`, agent/human aspect split, batch-owned resolution |
| 7 | `meta-extract/SKILL.md` | 215 → 242. Adds *Step 2b — Reconstruction Test*, *Instance Data — Never Extracted* |
| 8 | `meta-foundation/SKILL.md` | 136 → 185. Six aspects → five agent + five human; adds *What This Is In Service Of* |
| 9 | `meta-founding-contract/SKILL.md` | 142 → 160. Same headings; mechanised form checks |
| 10 | `meta-learning/SKILL.md` | 156 → 175. Adds *State C Comes From the Verification Record* |
| 11 | `meta-manifest/SKILL.md` | 85 → 182. Adds the entire *Schema Reference* (kind/load/triggers/owns/tier vocabularies) and *The Six Layers* |
| 12 | `meta-skill-builder/SKILL.md` | 112 → 183. *Input — Standard Evolution Report* → *Input — the Review Batch*; adds *Review Batch*, *Reveal*, *Contradictions*, *Drift Log Back-reference* |
| 13 | `templates/MANIFEST.template.yaml` | 200 → 134. 8 base nodes → 26; gains `base_kit_version`, `kind`, `load`, `triggers`, `owns` |

On #13 the pioneer was told, as step 3 requires, that keeping it *"makes it the yardstick the
next upgrade compares against, so a kept old template quietly disables the template rule next
time."* See §4.3 — here that is not a theoretical cost.

**One question per instance file whose header the template rule could not refresh — 5.**
All stubbed **keep**.

| # | File | Why a question |
|---|---|---|
| 14 | `meta-manifest/MANIFEST.yaml` | An installed template exists, but the header no longer reads as that template wrote it, and neither do any of its base node lines — so all of it is a pioneer-changed part |
| 15 | `meta-contract-before-execution/CONTRACT-LOG.yaml` | No installed template ever shipped for it |
| 16 | `meta-drift-eventlog/DRIFTLOG.yaml` | No installed template |
| 17 | `meta-learning/LEARNINGLOG.yaml` | No installed template |
| 18 | `meta-founding-contract/FOUNDING.md` | No installed template |

**Standing questions — 3.**

| # | Question | Stub |
|---|---|---|
| 19 | Step 7: should any recent implemented contract be verified and audited instead of `legacy`? | *legacy* for all 80 |
| 20 | Step 8: which drafted entries belong in the always-loaded map? | *none for now* |
| 21 | Step 9: the ratification pass | *defer* |

**Not asked:** the stale list. Nothing qualified — every kit file installed here still ships in
0.15, and this project predates the hooks, so it carried none of the base kit's own evidence
(`tests/results/`, `P-NNN.sh`, contract walks, fixtures). **Not counted:** acceptance of the
report at the end.

### Files that genuinely differed: **13**

The criterion: *"A file 'genuinely differed' when it differs from the baseline **and** its
content differs from the staged copy."* With no baseline the first clause cannot be evaluated,
so the second was measured directly — SHA-1 over each file with carriage returns stripped,
against its staged counterpart. All 13 kit files in the table above differ in content. None
was identical-after-the-fact, so no question was spent on a file the kit had already made the
same.

The five instance files (#14–18) also differ from the staged kit's own copies, but they are
this project's records and are never replaced; their questions come from the template rule,
not from the untouched/evolved classification. Whether they are admissible under the pass
criterion is itself unclear — see §4.1.

### Troubleshooting steps: **3**

These are things the procedure does not say, which had to be decided or built to make the
upgrade work. All three are procedure defects, not accidents.

1. **The contract log's field positions are unreachable as written.** Step 7 says new values
   are *"written as plain scalars, each field at the position the staged template gives it."*
   The template positions `disappointment` and `premortem` before `tier_4`, `red_test` after
   it, then `status`, `verification_state`, … `audited`, … `cost`, `work_id`. Of this
   project's 80 entries, **none** has `tier_4`, **none** has `transcript`, and only 9 have
   `verification`. The only entry-level key all 80 share is `status:`. I had to pick an anchor
   the procedure does not name: the three fields the template puts above `status` go
   immediately above it, the three below it immediately below. The result is right, but the
   choice was mine, not the procedure's.

2. **No method is given for a migration of this size.** The step reads as a small edit. On
   this project it is 480 field insertions into a 662 KB contract log, 65 into a 282 KB drift
   log, and 432 fields plus 91 notes into a 150 KB manifest — 1,068 insertions in all. The
   only tooling guidance anywhere in the upgrade is for the settings merge: *"done by hand with
   the file tools (no jq ships with the kit)."* Taken literally for these records it is not
   feasible; I wrote awk scripts and verified each by stripping the added keys back out and
   diffing against a pre-migration copy (all three came back identical). Building that tooling
   is work the steps do not describe.

3. **Where a `note:` goes when the node has none.** Step 7 says a project node *"gets
   `triggers: []` and, appended to any `note:` it already has rather than replacing it, `entry
   pending the map question`."* It says how to append to an existing note and nothing about
   where a new one goes. 5 of the 96 project nodes had a note; 91 did not. The template puts
   `note` last, but a node ends in an `open_gaps` list often followed by trailing comments, so
   there is no reliable last-line anchor. I placed the new note directly after `triggers:`.

### My own slips — 2, disclosed, and I am **not** counting them

Neither is a defect in the procedure, and neither survived into the result.

- My first survey of the contract log keyed on `^  - id:` when the entries open with
  `- contract_id:`. It reported 0 entries and 0 of every field. I noticed the impossibility
  (the file is 10,650 lines), re-ran with the right key, and got the real figures: 80 entries,
  none carrying the six fields. Nothing was written from the wrong numbers.
- One verification command returned exit 1 because a `grep -c` legitimately counted zero
  occurrences of `mitigation_medium` before the migration. Cosmetic; the output was correct.

### Verdict: **FAIL**

The criterion: *"The rehearsal passes only when every decision asked belongs to a file that
genuinely differed or is one of the four standing questions … and the third number is zero;
otherwise fix the procedure here, in this node, and rehearse again."*

- Every decision asked is admissible — 13 to genuinely differing files, 5 to instance files
  that differ in content, 3 standing questions. **First half: holds.**
- Third number is 3, not 0. **Second half: fails.**

So the procedure should be fixed in `meta-bootstrap` and rehearsed again before the real run.
The three fixes are small and all in step 7: name an anchor key that every entry actually has,
say how a migration of this size is to be performed, and say where a new `note:` goes.

---

## 2. The classification, as it would have been presented

> **No baseline exists.** `meta-manifest/INSTALLED.sha1` is absent, so I cannot tell what this
> project changed from what the kit changed. Every kit file must be treated as possibly
> evolved, and the questions will therefore be one per skill.
>
> **This project is pre-0.14.** Its manifest has no `kit_identity.base_kit_version`, so I am
> not guessing a version. It declares `kit_type: type-category`, `kit_name: classes-kit`,
> `version: 0.2`, `parent_kit: base-building-kit`. The staged kit is 0.15.
>
> It also predates the map, the hooks, `settings.json` and the install baseline: there is no
> `MAP.md`, no `.claude/settings.json`, no `.gitignore`, no `.gitattributes`, and no
> `meta-ledger/`, `meta-casebook/`, `meta-correction-log/`, `meta-mechanisms/` or
> `skills/agents/`. What is missing is installed and seeded as on a first install.
>
> **Untouched here (take the staged version, no question):** none. Without a baseline nothing
> can be shown untouched.
>
> **Evolved here (one question each):** the 13 files in §1. For each I would show the sections
> that changed, or — since most of these files changed substantially — the headings that
> changed and the plain statement that *keep* leaves a file which no longer describes the
> installed lifecycle.
>
> **New in the kit (added, no question):** 43 files — `meta-foundation/INTENT.md`;
> `meta-map/SKILL.md`; `meta-mechanisms/SKILL.md` with 12 hooks, the kit's own `G1-size.sh`
> and the travelling `walk.sh` + `walk.expected`; `meta-casebook/SKILL.md`;
> `meta-correction-log/SKILL.md`; `meta-ledger/SKILL.md`; 9 templates; and 8 kit agents,
> deployed to `.claude/agents/` and kept as the kit's own copy under `.claude/skills/agents/`.
>
> **Present here, absent from the staged kit (stale):** none.
>
> **Not installed, deliberately:** the base kit's own evidence — `checks/P-004…P-007.sh`,
> `tests/results/`, `tests/fixtures/`, `walk-004.sh`, `walk-007.sh` — and the staged kit's own
> instance files (`CASEBOOK.yaml`, `CORRECTIONS.yaml`, `LEDGER.yaml`, `MAP.md`), which are the
> base kit's records, not this project's.
>
> **Agent name collisions:** none. The kit ships `kit-*.md`; this project has eight
> `dashboard-*.md`.

---

## 3. Every migration applied, file by file

### Installed (step 5)

| Target | What landed |
|---|---|
| `.claude/skills/meta-foundation/INTENT.md` | new, 4,820 bytes |
| `.claude/skills/meta-map/SKILL.md` | new |
| `.claude/skills/meta-mechanisms/SKILL.md` | new |
| `.claude/skills/meta-mechanisms/hooks/` | 12 scripts |
| `.claude/skills/meta-mechanisms/checks/` | `G1-size.sh` only |
| `.claude/skills/meta-mechanisms/tests/` | `walk.sh`, `walk.expected` only |
| `.claude/skills/meta-casebook/SKILL.md` | new |
| `.claude/skills/meta-correction-log/SKILL.md` | new |
| `.claude/skills/meta-ledger/SKILL.md` | new |
| `.claude/skills/templates/` | 9 new templates; `MANIFEST.template.yaml` kept |
| `.claude/skills/agents/` | 8 kit agents (the copy the checks read) |
| `.claude/agents/` | 8 kit agents added beside the 8 existing dashboard agents |
| `.claude/settings.json` | created from `settings.template.json` — no settings file existed, so the template was written as it is, `_kit` keys and `Read(kit-sealed/**)` intact |
| `.gitignore` | created with `.claude/kit-sealed/` |
| `.gitattributes` | created with `*.sh text eol=lf` |
| `meta-ledger/batches/`, `meta-casebook/reconstruction/` | created |

**`CLAUDE.md`** had no `kit-block` markers, so per step 5 the replaced span is the contiguous
text from the kit's heading to the first horizontal rule, and it is quoted here in full:

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

It was replaced with the marked block importing `INTENT.md`, `FOUNDING.md` and `MAP.md`. The
project's own "Classes mod — working rules" section below the rule is untouched.

### Seeded (step 6) — only what was missing

| File | Source | Result |
|---|---|---|
| `meta-map/MAP.md` | `MAP.template.md`, `__PROJECT_NAME__` → `Classes` | 30 base entries, no placeholders left |
| `meta-casebook/CASEBOOK.yaml` | template | empty, 3 top-level keys |
| `meta-correction-log/CORRECTIONS.yaml` | template | empty, 2 keys |
| `meta-ledger/LEDGER.yaml` | template | empty, 6 keys |

`MANIFEST.yaml`, `CONTRACT-LOG.yaml`, `DRIFTLOG.yaml`, `LEARNINGLOG.yaml` and `FOUNDING.md`
already existed and were never replaced.

### Migrated additively (step 7)

**`CONTRACT-LOG.yaml`** — 10,650 → 11,130 lines. All 80 entries gained six fields:
`verification_state: legacy`, `audited: legacy` (the step-7 standing question, answered
*legacy*), and `disappointment/premortem/red_test/cost: legacy`. Verified: stripping those 480
lines back out reproduces the original file exactly. No existing value was changed. Three of
the 80 are `type: analysis-report` entries, which the gates skip; they received the fields too,
since the step says *every* existing entry.

**`DRIFTLOG.yaml`** — 5,086 → 5,151 lines. All 65 elevations written as maps gained
`mitigation_medium: unknown`, under both spellings of the key (48 under `elevation:`, 17 under
`elevations:`). The 8 items under `recurrences:` are not elevations and were left alone. No
elevation is written as a prose string, so that clause did not apply. Verified by the same
strip-and-diff.

**`MANIFEST.yaml`** — 2,097 → 2,620 lines, 111 → 125 registered nodes.

- `kit_identity` gained `base_kit_version: 0.15` and `library_kit: null`; `kit_type` left as
  the project declared it (`type-category`).
- 108 nodes gained `kind`, `load`, `triggers` and `owns`. The other 3 are duplicate
  registrations (below) and were left exactly as they were.
- **12 base nodes** took `kind`, `load`, `triggers` and `owns` from the staged template's node
  of the same id: `base-foundation`, `base-founding-contract`, `base-bootstrap`,
  `base-contract`, `base-skill-builder`, `base-learning`, `base-manifest`, `base-antidrift`,
  `base-antidrift-expand`, `base-drift-eventlog`, `base-extract`, and `base-contract-artifact`.
- **One rename, matched by `skill_file` rather than id.** The project registered
  `meta-contract-artifact/SKILL.md` under the id `contract-artifact`; the staged template calls
  it `base-contract-artifact`. The node took the template's id, and both `dependencies` lists
  naming the old id were updated (`base-contract` and `dashboard-exact`).
- **96 project nodes** got `kind: skill`, `load: trigger`, `triggers: []`, `owns:` naming their
  own skill file, and the marker `entry pending the map question` — appended to the existing
  note for the 5 that had one (`native-boundary-has-no-catch`,
  `gate-the-count-not-the-credit`, `in-world-voice`, `flavor-composition`,
  `commitment-gates-earning`), added as a new note for the other 91.
- **Three ids with the `base-` prefix are project nodes**, because the staged kit does not
  carry their skill files: `base-embed-before-own`, `base-host-already-does-it`,
  `base-verify-api-shape`. They were treated as project nodes, as step 7 directs.
- **Three skills are registered under two ids each.** The id whose line names the file first
  keeps it; the duplicate stays as it is and is listed here:
  `principle-verify-api-shape/SKILL.md` (`base-verify-api-shape` keeps it, `verify-api-shape`
  is the duplicate), `principle-embed-before-own/SKILL.md` (`base-embed-before-own` /
  `embed-before-own`), `principle-host-already-does-it/SKILL.md`
  (`base-host-already-does-it` / `host-already-does-it`).
- **14 new base nodes registered** with their 14 coverage lines, verbatim from the staged
  template: `base-intent`, `base-map`, `base-casebook`, `base-correction-log`, `base-ledger`,
  `base-mechanisms`, and the eight `agent-*` nodes. All 26 staged base nodes are now
  registered.
- **Values outside a template's enumeration were left as they are, and are listed here** as
  step 7 requires: `layer: playbook` (9 nodes, outside principle/pattern/implementation/meta);
  `status: emerging` (36), `seeded` (1), `open` (4), `in-progress` (1), all outside
  mature/thin/missing/retired; phase shorthand the manifest node explicitly forbids —
  `pre/during` (21), `pre/during/post` (4), `during/post` (4), `pre/post`, `pre`, `post` (1
  each) — and a `verify` phase that is not in the vocabulary at all (3 nodes); and four
  non-schema node fields: `enforcement` (7), `verified_by` (2), `correction_history` (1),
  `origin` (1).

**Headers.** Every header comment block was kept, per the *keep* stub. None was refreshed.

### The map (step 8)

The budget check was run for real at each stage, in an isolated tree so an over-budget map was
never written into the project.

| Attempt | Entries | Bytes | `G1-size.sh` |
|---|---|---|---|
| All 96 project skills drafted in | 126 | 26,244 | **fails** — over the 8,192-byte allowance |
| Fallback: one per skill no other node names as a dependency (16) | 46 | 10,046 | **fails** |
| Base entries only | 30 | 6,971 | **passes** |

So the map keeps only its base entries, and all 96 drafted entries wait in
`meta-map/proposed-entries.md` (not loaded) for the pioneer's one question. No `> **Map:**`
header was added to any project skill, since no project entry is in the map. After the
`ratification: deferred` marker was added, `MAP.md` is 6,994 bytes / 30 entries and the check
still passes; `INTENT.md` is 4,820 of its 5,120 allowance.

### Step 9

- `ratification: deferred` added inside `MAP.md`'s header comment.
- Baseline regenerated with the 6j command after the marker: `INSTALLED.sha1`, 175 lines,
  every line well-formed, covering the 8 kit agents under `.claude/skills/agents/` and all 16
  deployed agents.
- `G1-size.sh` run: exit 0.
- All 11 hook commands run with `CLAUDE_PROJECT_DIR` set. Each printed valid JSON or nothing.
  `close-batch.sh` and `reveal-key.sh` reported *no batch file* and exited 1, which is the
  expected result. `telemetry.log` gained its `loaded|meta-map/MAP.md` line and an ownership
  line naming `base-casebook`, confirming `owns:` survived the manifest write.
- The 6 telemetry lines the checks wrote were deleted, and `telemetry.log` itself removed —
  the checks created it; it did not exist before.
- `.claude/kit-incoming/` removed on the stubbed acceptance of this report.

---

## 4. What is still unclear, wrong or missing

### 4.1 The header-refresh rule, for a project with no installed templates

Verbatim, from step 3's *template rule*:

> On an upgrade a header comment block is refreshed from the staged template — it is
> instruction, never record — **but only where an installed template exists to compare
> against**. A project older than `templates/` has no yardstick, so its headers are not
> refreshed: they go into that file's one question along with the rest of it.

Three problems, all live here:

1. **The condition is written per project; the thing it governs is per file.** This project is
   not "older than `templates/`" — it has a `templates/` folder. That folder contains exactly
   one template, `MANIFEST.template.yaml`. So a yardstick exists for `MANIFEST.yaml` and for
   nothing else. The rule as written does not cover the common case of a project that took
   some templates and not others. I read it per file, which is the only reading that produces
   an answer.

2. **"That file's one question" presumes a question that no step creates.** Step 3's one-
   question-per-file loop runs over *kit* files classified evolved. Instance files are not in
   that loop — they are "this project's and are never replaced", handled by step 7's additive
   list. So for `CONTRACT-LOG.yaml`, `DRIFTLOG.yaml`, `LEARNINGLOG.yaml` and `FOUNDING.md`
   there is a rule pointing at a question that the procedure never asks. I asked it (4 of the
   21), because the alternative is to silently decide the pioneer's records for them. **This
   single ambiguity moves the decision count by 5** — the four above plus `MANIFEST.yaml`,
   whose header exists but no longer matches its installed template. A rehearsal whose headline
   number swings 16 → 21 on a reading is not yet a measurement.

3. **One clause could not be exercised and may be unreachable.** *"A comment line found in a
   header that the installed template never had (someone kept a note there) is carried over
   beneath the refreshed block."* Nothing was refreshed here, so nothing was carried over. Note
   this clause can only ever fire where a template *did* ship — and a header that matches its
   template has no extra comment line to carry. It is not obvious when it applies.

A fourth clause did resolve cleanly and is worth recording as working: *"a header is never
refreshed onto a record whose own template the project declined to take."* `FOUNDING.md` has no
installed template, so its header was left alone without needing a judgement.

### 4.2 Nodes that already carry a `note:`

Verbatim, from step 7's `MANIFEST.yaml` list:

> a project node whose entry waits in `proposed-entries.md` gets `triggers: []` and, appended
> to any `note:` it already has rather than replacing it, `entry pending the map question`

The append half is unambiguous and worked — 5 project nodes had notes, and the marker was
appended to each rather than replacing what was there. The other half is missing: **91 of the
96 project nodes had no `note:` at all**, and the step does not say whether to create one or
where to put it. The template's field order puts `note` last, but a node here ends in an
`open_gaps` list often followed by trailing `#` comments, so "last" has no reliable anchor. I
created the note and placed it immediately after `triggers:`, where the marker sits beside the
thing it explains. That is my choice, not the procedure's, and it is troubleshooting step 3.

There is a related gap the step does not mention: base nodes get `triggers` from the template
and so are not "pending the map question", but the rule never says the marker is
project-nodes-only. I read it that way because a base node's entry is already in the map.

### 4.3 What you are told when you keep a file under `templates/`

Verbatim, from step 3:

> and when the differing file is under `templates/`, say plainly that keeping it makes it the
> yardstick the *next* upgrade compares against, so a kept old template quietly disables the
> template rule next time

The warning is exactly right, and the rehearsal shows it is not a small cost. The kept
`templates/MANIFEST.template.yaml` contains **no** `base_kit_version`, and **no** `kind`,
`load`, `triggers` or `owns` — the very fields this upgrade just added to 108 nodes. At the
next upgrade, the template rule compares each base node line against that template, finds none
of them matching, and classifies every base node line as a part the pioneer changed. The
practical effect: **the *keep* answer on one file guarantees the manifest question will be
asked again next time, and guarantees no base node line can ever be mechanically refreshed.**

What the procedure does not say, and should: that for this file *keep* and *port* are not
equivalent choices at the same price, and that the warning applies with particular force when
the kept template is the manifest's, because that is the one the base-node-line rule depends
on. Stating the consequence in the terms above — "next time, every base node line becomes a
question" — would let the pioneer price the answer. As written, the warning names the mechanism
but not the bill.

### 4.4 Other things the procedure does not handle

- **Field positions on records the project invented.** Covered as troubleshooting step 1. The
  contract log here carries roughly 60 project-invented entry keys (`reference`, `phases`,
  `contract_class`, `anchors`, `rulings`, `playbooks`, `locked_spec`, `gate`,
  `approval_quote`, `scope_boundaries`, …) and none of the template's anchors. "The position
  the staged template gives it" assumes a record shaped like the template.
- **`approval:` is not in the additive list.** Step 7 says *"An older `approval: gate` stays as
  it is; the template lists it as the pre-0.15 value."* This project has no `approval:` key at
  all — it uses a project-invented `gate:` on 16 entries. Nothing tells the upgrade whether to
  add `approval`, map `gate` onto it, or leave it. I left it, since the step only speaks to an
  `approval` that already exists.
- **15 drift entries carry no `status:` field.** `drift-022` through `drift-036`. The step-7
  list does not add one, and `status` is a marker key the hooks read — so those 15 entries are
  invisible to the backlog. The session-start hook reports 38 entries watching or mitigated;
  the file holds 54. A 16th entry, `meta-resolution-v0.9.4`, carries `status: elevated`, which
  is outside the template's enumeration; I left it and list it, as instructed. Nothing in the
  upgrade notices that a marker key the mechanisms depend on is simply missing.
- **The rehearsal's own scale.** Step 2 asks for three numbers and a discarded copy. It does
  not say that on a real project the rehearsal involves a thousand-plus record insertions, or
  that the copy must be made before any of it. Worth one sentence, so the pioneer knows the
  rehearsal is not a five-minute dry run.

---

## 5. The project's own non-base skills

**96 skill folders**, all registered in the manifest, none of them base kit files:
53 `pattern-*`, 33 `principle-*`, 8 `playbook-*`, 1 `dashboard-exact`. Every one of the 96 is
registered, there are no dangling dependency references, and no skill file on disk lacks a
manifest node.

**How they were handled.** Not touched. No project skill file was written to during the
upgrade. Each got a drafted map entry under step 8 and a manifest node carrying
`kind: skill`, `load: trigger`, `triggers: []`, `owns:` naming its own file, and the pending
marker. Their 8 project agents under `.claude/agents/` were left in place; the kit's 8 agents
were added beside them with no name collision.

**The size check's result on the map** is in §3 — 126 entries / 26,244 bytes fails, the
16-root fallback / 46 entries / 10,046 bytes fails, 30 base entries / 6,971 bytes passes. The
map cannot absorb this project's skills at all: the base entries alone use 6,971 of the 8,192
allowance, leaving room for roughly six project entries against 96 candidates. The question
that reaches the pioneer is therefore not "which of these few" but "which six of ninety-six",
and the honest answer may be that this project needs the prune-rather-than-extend rule
exercised, or a second index the map points to. That is a decision the upgrade correctly
refuses to take on its own.

---

## 6. What a session in the upgraded project sees at start

`CLAUDE.md` now imports three files and nothing else: `meta-foundation/INTENT.md` (4,820
bytes), `meta-founding-contract/FOUNDING.md` (the pioneer's statement, unchanged), and
`meta-map/MAP.md` (30 base entries, 6,994 bytes). The project's own "Classes mod — working
rules" follow below the rule, unchanged.

The SessionStart hook prints, verbatim:

```
Kit backlog (session-start hook):
- Drift entries watching or mitigated: 38 -> M-18 stay alert to those aspects
- Pioneer-owned items are waiting (candidates, map proposals, unratified entries, unranked
  cards, precedent conflicts or drift resolutions) -> M-16 kit-batch-assembler assembles the batch
Act on each line through its map entry, one kit task at a time. The pioneer does not need to
invoke any of this.
```

Two lines, and both are worth reading closely:

- **The drift line counts 38 of 54 entries**, because 15 carry no `status:` and one carries
  `elevated` (§4.4).
- **The pioneer-owned line is fired by the 17 `mitigated` drift entries**, not by the map —
  the `ratification: deferred` marker is working, so the 30 unratified base entries are
  correctly excluded and the first session does not open a ratification batch.
- **No contract lines appear at all.** All 80 entries now read `verification_state: legacy` and
  `audited: legacy`, which is what `legacy` is for: history is not re-audited. Had the
  standing question been answered any other way, 54 implemented contracts would have queued
  for the verifier and the auditor on the first turn.
- The staged-kit line is gone, because `.claude/kit-incoming/` was removed.

A first prompt then gets the UserPromptSubmit hook asking for the moment to be named from the
map, and the turn closes on the Stop gate handing over the batch task (M-16).

---

## 7. Kept files that still describe something the staged kit removed or renamed

The *keep* stub answered 13 file questions, and this is what *keep* leaves behind. The stubs
count decisions; they do not show whether *keep* leaves a usable kit. This list is for the
pioneer to weigh at the real run.

| Kept file | Still describes |
|---|---|
| `meta-bootstrap/SKILL.md` | The old kit name (*"the meta-kit-builder practice"*, and `parent_kit: meta-kit-builder`); a three-tier proposal; the Standard Evolution Report as something presented. It has **no *Upgrading an Existing Install* section at all**, and its Step 2 writes the numbered-list `CLAUDE.md` block this upgrade just replaced. Map entry **M-27 points here** — so with `kit-incoming/` gone, the project's own upgrade route is a file that cannot perform an upgrade and would undo the CLAUDE.md block if followed. This is the most consequential *keep* on the list. |
| `meta-contract-before-execution/SKILL.md` | A three-tier proposal with no Tier 4, no bearing, no precedent check, and the SER presented rather than recorded. The migrated log now carries `disappointment`, `premortem`, `red_test` and `cost` fields that this skill never mentions and would never write. |
| `meta-manifest/SKILL.md` | 85 lines with no schema reference: no `kind`, `load`, `triggers`, `owns`, `tier` or `retired` vocabulary — the exact fields this upgrade just wrote onto 108 nodes. A session reading this skill has no definition of most of its own manifest. |
| `meta-skill-builder/SKILL.md` | The SER as its input, rather than review batches, the reveal, contradictions and drift back-references. Nothing in it describes the batch lifecycle the hooks now drive. |
| `meta-foundation/SKILL.md` | Six governing aspects including *"Discipline is the work, not overhead on it"*, where 0.15 splits five agent and five human aspects. `INTENT.md`, which is always loaded, states the 5+5 split — so the two always-available descriptions of the aspects now disagree. |
| `meta-antidrift/SKILL.md` | A nine-line score block with a `DEGRADED` format-compliance signal; the block in `INTENT.md` that sessions actually load has seven lines and no `DEGRADED`. Same disagreement as above, on the artefact produced every turn. |
| `meta-learning/SKILL.md` | The SER as presented output. |
| `meta-contract-artifact/SKILL.md` | A three-tier proposal. |
| `meta-drift-eventlog/SKILL.md` | Its schema has no `mitigation_medium`, the field this upgrade just added to all 65 elevations, and no agent/human aspect split. |
| `meta-extract/SKILL.md` | No reconstruction test and no instance-data table. |
| `meta-founding-contract/SKILL.md` | Closest to current; no mechanised form checks described. |
| `meta-antidrift-expand/SKILL.md` | *Discipline Fall Point* rather than *Drift Onset Point*; no cross-session drift-log reading. |
| `templates/MANIFEST.template.yaml` | 8 base nodes where the kit now has 26; no `base_kit_version`, `kind`, `load`, `triggers` or `owns`. See §4.3 — it is now the next upgrade's yardstick. |

**And a structural consequence of all thirteen:** not one kept file mentions `meta-ledger`,
`meta-casebook`, `meta-correction-log`, `meta-map` or `meta-mechanisms`. Six new nodes, twelve
hooks and eight agents are installed and firing, and every kept skill is silent about them. The
lifecycle now runs from the hooks and from `INTENT.md` + `MAP.md`; the kept nodes describe the
kit as it was two generations ago. *Keep* on all thirteen produces a working installation whose
own documentation describes a different kit — which is the finding the stub was designed to
surface, and the reason the real run should answer *port* or *overwrite* on at least
`meta-bootstrap`, `meta-manifest`, `meta-contract-before-execution` and `meta-skill-builder`.
