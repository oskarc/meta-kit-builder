# Upgrade rehearsal — classes-kit, base kit 0.15

Run on a throwaway copy of the Classes project, following the **staged** kit's
`meta-bootstrap/SKILL.md` → *Upgrading an Existing Install*, with the pioneer's answers
stubbed exactly as step 2 of that section says: *keep* for every differing file, *remove*
for the stale list, *legacy* for every existing contract, *none for now* for the map
question, *defer* for the ratification pass, and the report accepted at the end (so
`.claude/kit-incoming/` was removed).

The project is pre-0.14: no `MAP.md`, no `settings.json`, no `INSTALLED.sha1`, no
`kit_identity.base_kit_version`. Treated as pre-0.14 and said so, rather than guessing a
version. Its manifest declares `kit_type: type-category`, `version: 0.2`.

---

## 1 — The three numbers

### Decisions asked: **17**

One question per kit file that genuinely differed (13):

| # | File | Stub answer |
|---|---|---|
| 1 | `meta-antidrift/SKILL.md` | keep |
| 2 | `meta-antidrift-expand/SKILL.md` | keep |
| 3 | `meta-bootstrap/SKILL.md` | keep |
| 4 | `meta-contract-artifact/SKILL.md` | keep |
| 5 | `meta-contract-before-execution/SKILL.md` | keep |
| 6 | `meta-drift-eventlog/SKILL.md` | keep |
| 7 | `meta-extract/SKILL.md` | keep |
| 8 | `meta-foundation/SKILL.md` | keep |
| 9 | `meta-founding-contract/SKILL.md` | keep |
| 10 | `meta-learning/SKILL.md` | keep |
| 11 | `meta-manifest/SKILL.md` | keep |
| 12 | `meta-skill-builder/SKILL.md` | keep |
| 13 | `templates/MANIFEST.template.yaml` | keep — **with the cost stated**: it becomes the yardstick the *next* upgrade compares against, so every base node line and base coverage line the newer template would have refreshed will instead read as pioneer-changed and be asked about again, every time, for as long as the old template is kept |

Standing questions (3 of the 4; the fourth was not needed):

| # | Question | Stub answer |
|---|---|---|
| 14 | **Contracts** (step 7): should any recent implemented contract be verified and audited instead of `legacy`? | legacy for all 80 |
| 15 | **The map** (step 8): which of the 96 drafted project entries belong in the always-loaded map, and which are reached through the nodes that already name them as a dependency? | none for now |
| 16 | **Ratification pass** (step 9) | defer |

Not asked: **the stale list**. Nothing in the project is a kit file the staged kit no longer
ships — no withdrawn agent, hook, script or template, and none of the base kit's own
evidence (`tests/results/`, `P-NNN.sh`, contract walks, `tests/fixtures/`) was ever
installed here. An empty list is nothing to confirm, so no question was put.

One further question, which belongs to neither category as the criterion defines them:

| # | Question | Stub answer |
|---|---|---|
| 17 | **`MANIFEST.yaml`** — the template rule's "asked about once per file": the 12 base node lines and 3 base coverage lines the pioneer changed relative to the installed `templates/MANIFEST.template.yaml`. One question, listing the parts, answered for the file as a whole | keep |

The pioneer's acceptance of this report at the end is not counted.

### Files that genuinely differed: **13**

The 13 in the table above. The criterion: *"A file 'genuinely differed' when it differs from
the baseline and its content differs from the staged copy."* There is no baseline here, so
every kit file had to be treated as possibly evolved — and then each was compared, content
to content, against its staged copy. 13 differ; everything else the project had installed
is byte-identical to the staged copy once CRs are stripped, or is new. **No question was
asked on a file where nothing differed.**

### Troubleshooting steps: **0**

Nothing had to be done that the steps do not say. `close-batch.sh` and `reveal-key.sh`
exited 1 with *no batch file* — step 9 names that as the expected result, so it is not
troubleshooting.

**Two slips of my own, disclosed and not counted. Both are my scripting errors, not defects
in the procedure, and both are excluded from the third number.**

1. My first roots-only budget dry run built a temporary tree and ran `G1-size.sh` from
   `<tmp>/checks/`, but the check resolves its kit root as `$here/../..`, so it resolved to
   the project root and failed on `meta-foundation/INTENT.md is missing` — the wrong
   assertion. I rebuilt the temp tree in the shape the check expects
   (`<tmp>/meta-mechanisms/checks/`) and re-ran it; it then failed on the figure it was
   meant to test.
2. My manifest pass-2 script looked the five base-coverage refresh lines up in the wrong
   array — the 14 *new* base coverage lines rather than the staged template's lines for
   those five ids — so no match was ever found, the fallback printed the originals
   unchanged, and a counter still reported "refreshed: 5". The refresh silently did nothing.
   I caught it reading the diff back: it showed 8 changed lines and **no** coverage lines,
   where a real refresh must show 25 removed and 5 added. Corrected in a separate pass and
   re-verified (see §3). **Had I trusted the counter instead of the diff, this rehearsal
   would have reported a migration it had not performed** — which is the case for the
   procedure making the diff, not the method, the requirement.

### Does it pass the bootstrap's own criterion?

> *"The rehearsal passes only when every decision asked belongs to a file that genuinely
> differed or is one of the four standing questions — the stale list (step 3), the contracts
> the pioneer may name for verification (step 7), the map question when the budget forces it
> (step 8), and the ratification pass (step 9) — with the pioneer's acceptance of the report
> at the end not counted, and the third number is zero; otherwise fix the procedure here, in
> this node, and rehearse again."*

**It does not pass as the criterion is literally written.** 16 of the 17 decisions land
cleanly (13 genuinely-differing files + 3 standing questions) and the third number is zero.
Decision 17 — the template-rule question on `MANIFEST.yaml` — is **required** by step 7 and
belongs to neither permitted category: `MANIFEST.yaml` is an instance file, so it is never
compared against a staged copy (the staged kit's manifest is the base kit's own instance
data and never travels), and there is no baseline. The criterion's definition of "genuinely
differed" cannot reach it.

This is a gap in the criterion's wording, not extra work and not a bad question — the
question is one the procedure mandates and the pioneer plainly ought to be asked. **Fix in
the node:** name the template rule's per-file question as a fifth standing question, or
widen "genuinely differed" to cover an instance file whose base-written parts differ from
the installed template. Until that is done, a clean rehearsal of any pre-0.14 fork will keep
reporting a failure it did not earn.

---

## 2 — The classification, as presented

Presented before anything was changed. **No baseline exists** (`INSTALLED.sha1` absent, an
install from before 0.15), so every kit file had to be treated as possibly evolved, and the
questions were therefore one per skill.

**Evolved here — 13 files, one question each.** The 12 installed `meta-*/SKILL.md` files and
`templates/MANIFEST.template.yaml`. Each differs in content from the staged copy; the
sections that differ were shown, and for the template the cost of keeping it was stated
plainly (see decision 13).

**Untouched here — 0 files.** Nothing that the project had installed matched the staged copy.

**New in the kit — 62 files, added without a question:**

- 5 node skills: `meta-casebook/`, `meta-correction-log/`, `meta-ledger/`, `meta-map/`, `meta-mechanisms/`
- `meta-foundation/INTENT.md`
- 9 templates: CASEBOOK, CONTRACT-LOG, CORRECTIONS, DRIFTLOG, FOUNDING, LEARNINGLOG, LEDGER, MAP, settings
- 12 hooks under `meta-mechanisms/hooks/`
- the kit's own check `meta-mechanisms/checks/G1-size.sh`
- the lifecycle walk `meta-mechanisms/tests/walk.sh` + `walk.expected`
- 8 kit agents, to `.claude/skills/agents/` **and** to `.claude/agents/`
- `.claude/settings.json` (no settings file existed, so the template was written as it is)

**Present here, absent from the staged kit (stale): none.** Nothing to remove, nothing
pointing at a removed file from that route.

**Base node / base coverage lines, compared mechanically in step 3 and written down there**
(because step 5 replaces templates before step 7 runs):

- All 12 base **node** lines were changed by the pioneer → none refreshed → part of decision 17.
- 5 base **coverage** lines still read exactly as the installed template wrote them →
  refreshed from the staged template: `base-foundation`, `base-bootstrap`, `base-extract`,
  `base-antidrift`, `base-antidrift-expand`.
- 3 base coverage lines were changed (`base-contract`, `base-skill-builder`, `base-manifest`
  — all carry shorthand phases `pre/post`, `post`, `pre`) → part of decision 17 → kept.

---

## 3 — Every migration applied, file by file, and how it was verified

Each of the three migrated files was copied before the migration and the migrated file
diffed against that copy, as step 7 requires. Tooling was awk in three passes; the
verification, not the method, was the requirement.

### `meta-contract-before-execution/CONTRACT-LOG.yaml` (662 KB, 10,650 lines, 80 entries)

Every entry gained six fields, inserted after the entry's own `status:` line:
`verification_state: legacy`, `audited: legacy`, `disappointment: legacy`,
`premortem: legacy`, `red_test: legacy`, `cost: legacy` — 480 lines.
No entry already carried any of them, so the standing question was genuinely open and was
asked once. `approval:` was absent throughout and was left absent; no value present was
changed.

**Verified:** diff against the pre-migration copy — **0 lines removed or changed**, 480
added, and the added lines are exactly the six shapes above, 80 of each. Field counts after:
`status` 80, and each of the six new fields 80.

### `meta-drift-eventlog/DRIFTLOG.yaml` (282 KB, 5,086 lines, 54 entries)

- `status: unknown` added to the 15 entries that had none (`drift-022` … `drift-036`),
  inserted after each entry's `aspect:` line.
- `mitigation_medium: unknown` added to all 65 elevations written as **maps** — 48 under an
  `elevation:` key and 17 under an `elevations:` key, treated alike as the rule says.
- The 20 elevations written as **prose strings** (`- >-` folded scalars under `elevations:`)
  were left exactly as they are, as the rule says. Still 20 afterwards.
- 8 deeper `- target:` lines nested inside elevation prose were correctly not touched.

**Verified:** diff against the pre-migration copy — **0 lines removed or changed**, 80
added (65 + 15). After: 54 entries, 54 with `status`, 65 map elevations each with
`mitigation_medium`.

### `meta-manifest/MANIFEST.yaml` (150 KB, 2,097 lines, 111 nodes)

- **`kind` and `load`** added to 108 nodes (all that were not duplicates). Base nodes took
  the staged template's values (`base-drift-eventlog` → `kind: record`); the 96 project
  nodes took `kind: skill`, `load: trigger`.
- **`triggers`** added to every node: base nodes from the staged template's node of the same
  id (`base-antidrift` → `[M-28]`, `base-contract` → `[M-04, M-05, M-06, M-08, M-11]`, …);
  project nodes → `triggers: []`, because their entries wait in `proposed-entries.md`.
- **`owns`** added to every node: base nodes from the staged template; project nodes naming
  their own skill file, e.g. `owns: [pattern-checks-fail-closed/SKILL.md]`. None of them has
  a data file.
- **The pending-entry note** added to all 96 project nodes: 91 had no `note:` and got
  `note: Entry pending the map question.`; 5 already had one and had the sentence appended
  to what it already said.
- **Id matched by skill file:** the project registered `meta-contract-artifact/SKILL.md`
  under the id `contract-artifact`. It took the staged template's id
  `base-contract-artifact`, and both `dependencies` lists that named the old id were updated
  (`base-contract`, and `dashboard-exact`).
- **Skills registered under two ids** — `principle-verify-api-shape`,
  `principle-embed-before-own`, `principle-host-already-does-it` are each registered twice.
  Each kept the id whose line names it as `skill_file` first (`base-verify-api-shape`,
  `base-embed-before-own`, `base-host-already-does-it`); the three duplicate lines
  (`verify-api-shape`, `embed-before-own`, `host-already-does-it`) were left exactly as they
  are and are listed here.
- **`base-` prefixed project nodes:** `base-embed-before-own`, `base-host-already-does-it`,
  `base-verify-api-shape` carry the prefix but their `skill_file` is not one the staged kit
  ships, so they were treated as project nodes — `triggers: []`, own skill file in `owns`,
  and the pending-entry note.
- **14 new base nodes registered** from the staged template, with their coverage lines:
  `base-intent`, `base-map`, `base-mechanisms`, `base-ledger`, `base-casebook`,
  `base-correction-log`, and the 8 agent nodes.
- **`kit_identity`:** `base_kit_version: 0.15` set, `library_kit: null` added.
  `kit_type: type-category` left exactly as the project declared it.

**Verified:** diff against the pre-migration copy — for the two main passes, 564 lines added
and **exactly 8 lines changed, every one intended and accounted for** (the coverage refresh
is the separate corrective pass below):

| Changed line | Why |
|---|---|
| `- id: contract-artifact` | id taken from the staged template, matched by `skill_file` |
| `dependencies: [contract-artifact]` | the old id updated |
| `dependencies: [… contract-artifact …]` (dashboard-exact) | the old id updated |
| 5 × `note: …` | the pending-entry sentence appended to an existing note; the original text is intact in each |

**The five base coverage refreshes needed a second, corrective pass** (slip 2 in §1). The
first pass reported them done and had not done them — the diff showed 8 changed lines and no
coverage lines at all, where a real refresh must show 25 removed and 5 added. The corrective
pass replaced each 5-line block form with the staged template's one-line flow form, verified
against a copy taken immediately before that edit:

```
lines removed/changed: 25   (the five 5-line blocks, listed in full and each accounted for)
lines added: 5              (base-foundation, base-bootstrap, base-antidrift,
                             base-antidrift-expand, base-extract)
```

Flow-form coverage lines went from 14 (the new base nodes only) to 19. Three base coverage
lines that the pioneer had changed — `base-contract` (`phase: pre/post`), `base-skill-builder`
(`phase: post`), `base-manifest` (`phase: pre`) — correctly stayed in block form, kept as the
pioneer had them, because they no longer read as the installed template wrote them. The
install baseline was regenerated afterwards so it records the manifest as it finally stands.

**Values outside a template's enumeration, left as they are and listed, as the rule says:**
`layer: playbook` (9 nodes); `status: emerging` (36), `status: seeded` (1);
`phase:` shorthands the manifest skill explicitly names as not-to-be-used —
`pre`, `post`, `pre/post`, `pre/during`, `during/post`, `pre/during/post`, `verify`,
`[pre-build, during-build, verify]`, `[during-build, verify]`. Also, in the contract log,
`type: execution-contract` and `contract_class: tooling` sit outside the marker-key
contract's listed values; the gates read `type: analysis-report` only, so these are inert.

**Header comment blocks — the file-by-file rule.** `.claude/skills/templates/` held exactly
one template, `MANIFEST.template.yaml`. So:

- `CONTRACT-LOG.yaml`, `DRIFTLOG.yaml`, `LEARNINGLOG.yaml`, `FOUNDING.md` — **no yardstick**
  → header not refreshed, and not asked about separately. It travels with the file.
- `MANIFEST.yaml` — a yardstick exists, but the pioneer's stubbed *keep* means the project
  declined to take the staged template, and *"a header is never refreshed onto a record whose
  own template the project declined to take"* → header not refreshed either.

**0 headers refreshed, 0 questions from the header rule, 5 headers left alone with the
reason recorded.**

### Not migrated because newly seeded (empty templates, nothing to migrate)

`meta-ledger/LEDGER.yaml`, `meta-correction-log/CORRECTIONS.yaml`,
`meta-casebook/CASEBOOK.yaml`, `meta-map/MAP.md`. Existing instance files were never
replaced.

### `> **Map:**` headers on kept skills

The rule *"The `> **Map:**` header of a kept skill loses any id the staged template withdrew"*
had nothing to do: **no skill in this project carries a `> **Map:**` header at all** (the
fork predates the map). Nothing was removed and nothing was added, because step 8 adds a
header only to a skill whose entry is in the map, and none is.

### `CLAUDE.md`

The old block had no `kit-block` markers. The replaced span is the contiguous text from the
kit's heading to the first horizontal rule — lines 1–22, quoted here in full as step 5
requires:

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

Replaced with the staged block between `<!-- kit-block:start -->` / `<!-- kit-block:end -->`.
The horizontal rule and the whole `# Classes mod — working rules` section below it are
untouched.

### Also done

`.gitignore` (`.claude/kit-sealed/`) and `.gitattributes` (`*.sh text eol=lf`) created;
`meta-ledger/batches/` and `meta-casebook/reconstruction/` created; `INSTALLED.sha1`
regenerated **after** the `ratification: deferred` marker, 175 files, and re-verified to
match the tree exactly; the telemetry lines the checks wrote were deleted, and the
`telemetry.log` file itself removed because the checks are what created it.

---

## 4 — Still unclear, wrong or missing in the procedure

Quoted verbatim as I hit them.

**(a) The pass criterion cannot see the template rule's own question.** Step 7:

> *"Parts the pioneer changed, and every part where no installed template exists to compare
> against (a project from before the template existed), are asked about **once per file**"*

and step 2:

> *"The rehearsal passes only when every decision asked belongs to a file that genuinely
> differed or is one of the four standing questions … **A file "genuinely differed" when it
> differs from the baseline *and* its content differs from the staged copy**"*

The first mandates a question on `MANIFEST.yaml`; the second cannot classify it, because an
instance file has no staged copy to differ from. Every pre-0.14 fork will hit this. Fix in
the node, as above.

**(b) Two clauses in step 7 give opposite instructions for a skill registered twice.**

> *"`MANIFEST.yaml` — every node gains `kind` and `load` if absent"*

against

> *"a skill registered under two ids keeps the id whose line names it as `skill_file` first,
> and the duplicate line stays as it is and is listed in the report"*

"Stays as it is" won, so three duplicate node lines now sit in the manifest without `kind`
or `load` while every other node has them. That is the right call for a record the pioneer
may still want, but the procedure should say which rule wins rather than leaving it to be
worked out — and should say whether the duplicate is expected to be resolved later.

**(c) Where new base nodes and their coverage lines go is unstated.** Step 7 says *"new base
nodes are registered"* and nothing about position. I put the 14 nodes after `base-extract`
and their coverage lines at the head of `coverage_map` under a dated comment. Position
carries no meaning, so this is harmless — but it is the one place the "do not hunt for an
anchor" licence granted for *fields* is not also granted for *entries*, and saying so would
close it.

**(d) Four base nodes are registered with no coverage line, and the list does not reach
them.** `base-founding-contract`, `base-learning`, `base-drift-eventlog` and
`base-contract-artifact` are nodes in this project's manifest with no entry in its
`coverage_map`. The migration list covers base node lines and base coverage lines that
exist, and new base nodes; it says nothing about an existing base node whose coverage line
was never written. I left them alone. Reported rather than fixed.

**(e) The nested-anchor case is not covered by the "no anchor" licence.** Step 7 says *"put a
new field where it reads naturally in the entry, and do not hunt for an anchor the old
entries may not have"* — which is about entry-level fields. `mitigation_medium` goes inside a
list **item**, not an entry, and there the item's own first key is effectively the only
anchor. It was never in doubt here, but the sentence does not say it.

---

## 5 — The project's own non-base skills, and the size check

**96 non-base skills**: 53 `pattern-*`, 34 `principle-*`, 8 `playbook-*`, 1 `dashboard-exact`.
Plus 8 of the project's own agents in `.claude/agents/` (`dashboard-*`) — **no name collides
with a kit agent**, all of which are `kit-*`.

**How they were handled.** Not one file on disk was touched. Their manifest nodes gained
`kind`, `load`, `triggers: []`, `owns`, and the pending-entry note. An entry was drafted for
each from its own description into `.claude/skills/meta-map/proposed-entries.md` (96 entries,
not loaded), and no `> **Map:**` header was added to any skill, because none of their entries
is in the map.

**The size check.** `checks/G1-size.sh` on the seeded map: **pass** — 30 entries, 6,998 bytes
against a ceiling of 40 entries and 8,192 bytes. That leaves room for 10 entries and about
1,190 bytes, so the 96 drafted entries could not go in.

Step 8's fallback was then run as written: draft one entry per skill **that no other node
names as a dependency**. That set is 16 skills — `playbook-orientation`,
`playbook-implementation`, `playbook-verify-implementation`, `playbook-verify-design`,
`playbook-verify-text`, `dashboard-exact`, `bannerlord-runtime-sprite-injection`,
`host-registry-ownership`, `quantised-progression-eats-levels`, `split-by-thing-and-job`,
`added-persisted-field-is-null`, `bannerlord-configure-then-bind`,
`widen-signature-not-overload`, `write-to-the-set-not-the-instance`,
`surface-audits-the-system`, `concurrent-session-ledger-and-commit`. With those drafted in,
the map measures **46 entries and 9,199 bytes**, and the check fails:

```
G1-size broken: meta-map/MAP.md is 9199 bytes, over the 8192-byte allowance — prune the map; the allowance does not move
```

So the roots alone still fail, and per step 8 the map keeps only its base entries and every
drafted entry waits in `proposed-entries.md` for the one question. **The map was never
written past the check** — the final map is the 30 base entries, 6,998 bytes, check passing.

---

## 6 — What a session in the upgraded project sees at start

`CLAUDE.md` now always loads three files: `meta-foundation/INTENT.md`,
`meta-founding-contract/FOUNDING.md` (the pioneer's statement of 2026-08-30, intact) and
`meta-map/MAP.md` (30 base entries, all `proposed`, with `ratification: deferred` in the
header comment). The Classes mod's own working rules follow below the kit block, unchanged.

The SessionStart hook prints:

```
Kit backlog (session-start hook):
- Drift entries watching or mitigated: 38 -> M-18 stay alert to those aspects
- Pioneer-owned items are waiting (candidates, map proposals, unratified entries, unranked
  cards, precedent conflicts or drift resolutions) -> M-16 kit-batch-assembler assembles the batch
Act on each line through its map entry, one kit task at a time. The pioneer does not need to
invoke any of this.
```

Both lines are the project's live records, not a fresh install: 38 drift entries stand at
`watching` or `mitigated`, and the pioneer-owned flag is raised by the `mitigated` entries
awaiting resolution — **not** by the 30 unratified map entries, which `ratification:
deferred` correctly suppresses. The staged-kit line is gone now that `.claude/kit-incoming/`
has been removed. The 80 contracts raise nothing, because the migration set them `legacy`.

The Stop gate hands over one task: assemble the review batch (M-16). All hooks printed valid
JSON or nothing; `close-batch.sh` and `reveal-key.sh` reported *no batch file* and exited 1,
which is the expected result; `G1-size.sh` passed.

---

## 7 — Kept files that still describe something the staged kit removed or renamed

The stubs answered *keep* to all 13. That leaves these pointing at things the 0.15 kit no
longer has. The pioneer should weigh each at the real run; none of them breaks a mechanism,
but all of them will be read as instruction by a future session.

**`meta-bootstrap/SKILL.md` (kept) — the most consequential.** It is the node M-27 routes an
upgrade to, and it still teaches the pre-map install:

- it dictates a `CLAUDE.md` block that loads six skills by name and does **not** import
  `INTENT.md`, `FOUNDING.md` or `MAP.md` — the exact block this upgrade just replaced;
- it writes `parent_kit: meta-kit-builder` into a new manifest;
- it has no Step 5c/5d/5e (hooks, seal, `.gitattributes`, agent folders), no Step 6j install
  baseline, and an upgrade section that predates the map, the mechanisms, the ledger, the
  casebook and the correction log — that is, it cannot perform the next upgrade.

The staged kit anticipates exactly this (its `gap-032`): the staged copy's own upgrade
section opens by deferring to the staged copy, and the session-start hook now names the
staged copy. Keeping the old node means the *installed* text is still the wrong one, and the
pioneer's staging message remains load-bearing for the next hop too.

**`meta-contract-before-execution/SKILL.md` (kept)** — describes a **three-tier** proposal
throughout (`## The Three-Tier Proposal`, "Tier 1 / 2 / 3", "return to spec-lock, then
re-enter three-tier"). The staged kit's contract is **four tiers**, with Tier 4 acceptance
tests, plus `disappointment`, `premortem`, `red_test` and `cost` — the very fields this
upgrade just added to all 80 log entries. The kept node never mentions them, so the schema
now carries fields the governing skill does not describe. It also still routes learnings
through a `Standard Evolution Report` presented to the human, where the staged kit records
observations to the ledger and presents them in review batches.

**`meta-skill-builder/SKILL.md` (kept)** — `## Input — Standard Evolution Report`, "the
human decides what level is right". The staged kit's skill-builder is review batches from
ledger candidates, verdict before evidence, re-presented items and a sealed key. None of the
batch vocabulary is in the kept file, yet the stop-gate now hands that session M-16 and tells
it to run `kit-batch-assembler` and follow "meta-skill-builder's review batch" — a section
the kept file does not have.

**`meta-learning/SKILL.md` (kept)** — asks that "whatever the agent reads at session start
alongside `MANIFEST.yaml` and `DRIFTLOG.yaml` also checks `CONTRACT-LOG.yaml`… and surfaces a
one-line count", described as "a visibility prompt, not an automatic run — the pioneer still
decides when to invoke it". The session-start hook now does exactly that automatically, and
M-13 is handed over by the gate rather than invoked.

**`meta-manifest/SKILL.md` (kept)** — "**For the agent**: At the start of every session, load
MANIFEST.yaml and read the full node list." The staged kit loads the manifest only on M-22 /
M-23. The kept file also describes none of `kind`, `load`, `triggers`, `owns`, the six
layers, or `base_kit_version` — every one of which this upgrade just wrote into the manifest
it governs.

**`meta-extract/SKILL.md` (kept)** — still describes extraction without map entries,
type-category precedents with `{bindings}`, or the blind reconstruction test, all of which
the staged kit's extraction carries.

**`meta-foundation/SKILL.md` and `meta-antidrift/SKILL.md` (kept)** — six governing aspects
(the fork's own "Discipline is the work" is the sixth) and a nine-line drift block with a
format-compliance check. The staged kit's always-loaded `INTENT.md`, now installed beside
them, states **five** agent aspects and a seven-line block. A session loads `INTENT.md` every
time and the kept nodes on trigger, so the two disagree in the open.

**`meta-contract-artifact/SKILL.md` (kept)** — "the three tiers as identified clauses";
same tier-count drift as the contract node.

**`templates/MANIFEST.template.yaml` (kept)** — the pre-0.14 schema: no `kind`, `load`,
`triggers`, `owns`, `base_kit_version`, and only 8 base nodes. It is now the yardstick for
the next upgrade, which is the cost that was stated when the question was asked.

**`CLAUDE.md`** no longer names `meta-kit-builder` — that line was inside the replaced span.
One reference to the old kit name survives in a comment at the top of `CONTRACT-LOG.yaml`
("Schema and lifecycle are upstream's (meta-kit-builder)"), which the template rule left
alone because that file has no installed template to compare against.

**Nothing kept refers to a file that was removed from disk.** The stale list was empty, so no
kept file points at nothing; what the kept files carry is *stale description*, not broken
references.
