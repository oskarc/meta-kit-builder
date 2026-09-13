# Upgrade rehearsal — fx013, kit 0.14 → 0.15

Run against the staged kit's `meta-bootstrap/SKILL.md` → *Upgrading an Existing Install*.
This folder is itself the throwaway copy the procedure's step 2 calls for, so steps 3–9 were run on it
directly with the pioneer's answers stubbed: *keep* for every differing file, *remove* for the stale list,
*legacy* for every existing contract, *none for now* for the map question, *defer* for the ratification
pass, and the report accepted at the end.

In a rehearsal there is no one to present to, so the classification and every offer are recorded here.

---

## 1. The three numbers

| | Count |
|---|---|
| **Decisions asked** | **3** |
| **Files that genuinely differed** | **1** |
| **Troubleshooting steps** | **0** |

### Decisions asked — 3

| # | Decision | What it is | Stubbed answer |
|---|---|---|---|
| 1 | The stale list, nine files, one question for the whole list | standing question (step 3) | remove |
| 2 | `.claude/skills/meta-casebook/SKILL.md` | a file that genuinely differed | keep |
| 3 | The ratification pass | standing question (step 9) | defer |

Two of the four standing questions were **not** asked, correctly:

- **The contracts question (step 7)** was skipped by the procedure's own rule. `contract-001` already
  carries `verification_state: none` and `audited: false`, and step 7 says to *"skip the question entirely
  when every existing entry already carries these fields, since then both answers write the same file."*
- **The map question (step 8)** was never reached. The manifest registers no non-base node, so step 8
  drafted no entries, the map stayed at 30 entries / 6,992 bytes, and `G1-size.sh` passed.

The pioneer's acceptance of the report at the end is not counted, per the criterion.

### Files that genuinely differed — 1

`.claude/skills/meta-casebook/SKILL.md`. It differs from the baseline **and** its content differs from the
staged copy, which is the procedure's two-part test. No other file met both halves.

### Troubleshooting steps — 0

Nothing had to be done that the procedure does not say. Every step ran as written.

### My own slips — 2, disclosed, not counted

Both are mine, not defects in the procedure, and the task's framing is explicit that a slip of my own is
not a procedure defect. Each cost one retry and changed no output.

1. An `Edit` `old_string` for `MAP.md` carried a stray character I introduced (`ല`) that is nowhere in the
   file. The call would have failed on that alone.
2. The same call failed first for a different reason: I had rewritten `MAP.md` with `sed` after last
   reading it, so the harness refused the edit as stale. I re-read the file and the edit applied.

I am **not** counting either in the third number: the procedure's definition is *"anything you had to do
that these steps do not say"*, and neither was the procedure's doing.

### Does it pass the bootstrap's own criterion?

> *"The rehearsal passes only when every decision asked belongs to a file that genuinely differed or is one
> of the four standing questions … with the pioneer's acceptance of the report at the end not counted, and
> the third number is zero."*

Decision 1 is a standing question. Decision 2 is a file that genuinely differed. Decision 3 is a standing
question. The third number is zero.

**PASS.**

---

## 2. The classification, as it was presented

### The baseline comparison

`meta-manifest/INSTALLED.sha1` held **70** entries, each path marked with a leading `*` — a baseline
written before 0.15, so it hashed raw bytes. The 6j command was re-run into `.upgrade-baseline.tmp` in the
project root and compared hash to hash, keyed by path, with the `*` dropped.

| Result | Count |
|---|---|
| Matched the baseline directly (LF hashing) | 20 |
| Matched **only** after re-hashing with CRLF endings | **49** |
| Differed under both | 1 |

**The line-ending fallback carried 49 of the 70 baseline entries.** Without it those 49 would every one
have been classified *evolved here*, and the rehearsal would have asked 49 file questions instead of one —
50 decisions in place of 3. The install was made on Windows and the files were re-saved with the other
ending; they differ by nothing.

The 20 that matched directly are the twelve hooks, `make-T-2.sh`, `walk-004.sh`, `walk.sh`, and the five
instance files the install wrote itself (CONTRACT-LOG.yaml, CORRECTIONS.yaml, FOUNDING.md, MANIFEST.yaml,
MAP.md). The one that differed under both is `meta-casebook/SKILL.md`.

Two kit files the old baseline never listed because its pattern did not cover them —
`meta-mechanisms/tests/walk.expected` and `templates/settings.template.json` — are untouched, not evolved,
as step 3 says.

### Untouched here → take the staged version, no question asked (58 files)

- **Skills and INTENT.md (17):** meta-antidrift, meta-antidrift-expand, meta-bootstrap,
  meta-contract-artifact, meta-contract-before-execution, meta-correction-log, meta-drift-eventlog,
  meta-extract, meta-foundation/SKILL.md, meta-foundation/INTENT.md, meta-founding-contract,
  meta-learning, meta-ledger, meta-manifest, meta-map, meta-mechanisms, meta-skill-builder
- **Templates (10):** CASEBOOK, CONTRACT-LOG, CORRECTIONS, DRIFTLOG, FOUNDING, LEARNINGLOG, LEDGER,
  MANIFEST, MAP, settings
- **Hooks (11):** batch-blind, close-batch, deny-paths, lib, owner-check, post-read, prompt-submit,
  session-start, stop-gate, subagent-stop, write-scope
- **Lifecycle walk (2):** tests/walk.sh, tests/walk.expected
- **Agents, both copies (7 each = 14):** kit-case-clerk, kit-consolidator, kit-map-steward,
  kit-reconstructor, kit-recorder, kit-session-auditor, kit-verifier

Of these, 26 arrived byte-identical to what was installed; the rest carried the kit's 0.15 changes.

### Evolved here → one question (1 file)

**`.claude/skills/meta-casebook/SKILL.md`.** What differs, as the question showed it:

1. Its `> **Map:**` header names **M-31** and points at `REBUILD.yaml`; the staged header names only
   M-04, M-05, M-26.
2. The section `### The launch rebuild (M-31)` (11 lines) is replaced in the staged copy by
   `### The rebuild — withdrawn from the map`, which records that contract-006 withdrew the rebuild and
   why, and points at `docs/rebuild-design.md`.
3. A section the kit never shipped has been appended: `## Project addition` — *"In this project,
   precedents about response shapes are reviewed with the API owner."*

Not under `templates/`, so keeping it does not disable the template rule at the next upgrade.

**Question:** overwrite with the staged, keep yours, or port the staged changes into yours by hand?
**Stubbed answer: keep.**

**What *keep* leaves, for the pioneer to weigh at the real run.** The kept file still describes the launch
rebuild as live — a milestone in `REBUILD.yaml`, a frozen plan, three arms — and both `REBUILD.yaml` and
its template are on the stale list. After this upgrade the file's body names two paths that no longer
exist:

- line 6 (header): *"or the milestone in REBUILD.yaml has been reached"*
- line 63: *"The plan lives in `REBUILD.yaml`, seeded by bootstrap from `templates/REBUILD.template.yaml`"*

M-31 was removed from its header in step 7 because the header is the map's. The rest of the line is the
kept file's and stays. Nothing mechanical catches the two stale paths in the body — this report is the
only place they surface.

### New in the kit → add (3 files)

- `agents/kit-batch-assembler.md` → `.claude/skills/agents/` and `.claude/agents/`
- `meta-mechanisms/hooks/reveal-key.sh`
- `meta-mechanisms/checks/G1-size.sh`, with the `checks/` folder this install lacked

### Present here, absent from the staged kit → the stale list (one question, answered *remove*)

| File | Why | What being kept still refers to it |
|---|---|---|
| `.claude/agents/kit-canary-author.md` | replaced by kit-batch-assembler | — |
| `.claude/skills/agents/kit-canary-author.md` | same | — |
| `.claude/skills/meta-mechanisms/hooks/reveal-canaries.sh` | renamed `reveal-key.sh` | — |
| `.claude/skills/templates/REBUILD.template.yaml` | rebuild withdrawn (contract-006) | **the kept `meta-casebook/SKILL.md`**, line 63 |
| `.claude/skills/meta-mechanisms/tests/walk-004.sh` | the base kit's own contract walk | — |
| `.claude/skills/meta-mechanisms/tests/fixtures/make-T-2.sh` | the base kit's own fixtures | — |
| `.claude/skills/meta-mechanisms/tests/results/T-2-2026-09-12.md` | the base kit's own evidence | — |
| `.claude/skills/meta-mechanisms/tests/results/T-7-2026-09-12.md` | the base kit's own evidence | — |
| `.claude/skills/meta-mechanisms/tests/results/contract-004-tiers.sha1` | the base kit's own evidence | — |

No `P-NNN.sh` check was installed here, so none was on the list. The staged kit's own `P-004`–`P-007`
checks and its contract walks (`walk-004.sh`, `walk-007.sh`, `tests/fixtures/`, `tests/results/`) were
**not** installed — they read the base repository's templates, docs and manifest.

### The template-rule comparison, made in step 3 and written down before anything changed

| Instance file | Compared against the installed template | Result |
|---|---|---|
| `CONTRACT-LOG.yaml` | CONTRACT-LOG.template.yaml, lines 1–74 | header block **identical** → refreshable |
| `CORRECTIONS.yaml` | CORRECTIONS.template.yaml, lines 1–44 | header block **identical** → refreshable |
| `DRIFTLOG.yaml` | DRIFTLOG.template.yaml | whole file **identical** → refreshable |
| `LEARNINGLOG.yaml` | LEARNINGLOG.template.yaml | whole file **identical** → refreshable |
| `LEDGER.yaml` | LEDGER.template.yaml | whole file **identical** → refreshable |
| `CASEBOOK.yaml` | CASEBOOK.template.yaml | whole file **identical** → refreshable |
| `MAP.md` | MAP.template.md | differs only where the project name was filled in (2 lines). All 31 base entries read exactly as the installed template wrote them → all refreshable, status column kept |
| `MANIFEST.yaml` | MANIFEST.template.yaml | differs only in three filled-in values and the two `__INHERITED_*` comment lines the install removed. Every base node line and base coverage line reads exactly as the installed template wrote it → all refreshable |
| `FOUNDING.md` | FOUNDING.template.md | differs only where the project name, date and statement were filled in; header block otherwise identical → refreshable. The statement block is the pioneer's and was never touched |

No comment line was found in any header that the installed template did not have, so nothing had to be
carried over beneath a refreshed block. No instance file's template had been declined, so no header was
refreshed onto a record whose template the project had refused. **Every instance file had a yardstick and
every one matched**, so no part of any instance file went into a per-file question.

---

## 3. Every migration applied, file by file

### Files replaced from the staged kit (steps 4–5)

58 kit files taken wholesale (the list above), the nine stale files removed, `checks/` created with
`G1-size.sh`, and `meta-ledger/batches/` and `meta-casebook/reconstruction/` recreated — both had been
lost by the copy (5e).

**`.claude/settings.json`** — merged by hand: no group lacked a `"_kit"` key, so nothing was kept; every
kit group was dropped and the staged template's group for that event appended; `permissions.deny` kept
`Read(kit-sealed/**)`. The staged template is byte-identical to what was installed, so the merge produced
no change. Verified by diff.

**`CLAUDE.md`** — the `kit-block:start` / `kit-block:end` markers were present, so the span between them
was replaced. The staged block is the same text; no change. Verified by diff.

**`.gitignore` / `.gitattributes`** — already carried `.claude/kit-sealed/` and `*.sh text eol=lf` (5d);
nothing to recreate.

### `CONTRACT-LOG.yaml`

- Header comment block refreshed from the staged template. Verified identical to it afterwards.
- `contract-001` gained, at the positions the staged template gives them:
  `disappointment: legacy`, `premortem: legacy` (after `tier_3`), `red_test: legacy` (before `status`),
  `cost: legacy` (between `revisions` and `work_id`).
- `approval: gate` **left as it is** — the template now lists it as the pre-0.15 value.
- `verification_state: none` and `audited: false` were already present, so the standing question was
  skipped and neither value was changed.

### `CORRECTIONS.yaml`

- Header comment block refreshed from the staged template. Verified identical to it afterwards.
- `C-001` gained `noticed`, `would_have_been_right` and `seen_before`, each `not asked`, between
  `reason_given` and `supersedes`.
- `trajectory` untouched.

### `LEDGER.yaml`

- Header comment block refreshed from the staged template (it now carries the one-writer list).
- Under `scores`: `canary_catch_rate`, `brier_stated_confidence` and `brier_pioneer_decisions` **removed**;
  `coincidence: []` **added**. `updated: null` and `contracts: []` kept.
- No batch existed, so no `represented: []` was due; no candidate existed, so no `lower_bound` was removed.
- Every data list was empty (0 entries in the file before migration), so nothing of the project's was lost.

### `DRIFTLOG.yaml`, `LEARNINGLOG.yaml`, `CASEBOOK.yaml`

No change. `entries` / `precedents` were empty, and each file's staged template is byte-identical to the
installed one, so the header refresh was a no-op. Confirmed identical to their staged templates afterwards.

### `MANIFEST.yaml`

- `base_kit_version: 0.14` → `0.15`
- `base-skill-builder` — concern now reads *"re-presented items"* where it read *"canaries"*
- `base-casebook` — `owns` drops `meta-casebook/REBUILD.yaml`; `triggers` drop `M-31`
- `base-mechanisms` — `triggers` gain `M-07`
- `agent-consolidator` — concern now *"counters by reading, fading, outcomes, scores that never score the
  pioneer"*
- `agent-canary-author` → **`agent-batch-assembler`**, taking the staged template's whole node line
  (renamed node rule)
- coverage: *"Evidence, candidates, canaries and maturity instruments"* → *"…re-presented items…"*
- coverage: *"Gate instrumentation — canaries, node_id: agent-canary-author"* → *"Review batch assembly
  and re-presented items, node_id: agent-batch-assembler"*
- `kind`, `load`, `triggers` and `owns` were already present on every node; `library_kit: null` already
  present; `kit_type: project` left as the project declared it. No `dependencies` list named the old id.
  No value sat outside a template enumeration. No duplicate node line.
- **Verified:** the migrated manifest now differs from the staged template *only* in `kit_name: fx013`,
  `category: test-api`, `library_kit: null`, and the two `__INHERITED_*` comment lines the install removed.

### `MAP.md`

- Every base entry read as the installed template wrote it, so each took the staged template's columns and
  kept its own status. All 30 surviving entries still read `proposed`.
- **`M-31` removed** — withdrawn by the staged template and not reworded by the pioneer.
- Header comment block refreshed; the line that read *"replaces fx013"* (the install had substituted the
  project name inside the instruction comment) now reads *"fills in the project name"*.
- `ratification: deferred` added inside the header comment (step 9 deferral).
- 30 entries, 6,992 bytes.

### `meta-casebook/SKILL.md` (the kept file)

`M-31` removed from its `> **Map:**` header. Nothing else touched.

### `meta-manifest/INSTALLED.sha1`

Regenerated with the 6j command **after** the ratification marker, so the baseline records the map as it
stands. 68 entries, no `*` prefixes — the 0.15 form. The temporary `.upgrade-baseline.tmp` was removed.

---

## 4. The procedure — what was clear, and what is still worth fixing

### The ordering between steps 3, 5 and 7 — clear enough, no yardstick ever missing

The instruction was clear enough to follow without working it out myself. Step 3's template-rule paragraph
says, verbatim:

> *"…`.claude/skills/templates/` is the copy the last install shipped, so the comparison is mechanical —
> **make it in step 3 and write the result down, because step 5 replaces those templates before step 7
> runs**…"*

and step 5 names the same dependency from the other side:

> *"…`templates/` (whose old copies step 7 needs as its yardstick, so step 3's comparison must already be
> recorded)…"*

Two statements of the same constraint, one at each end. I made the comparison in step 3 against the
installed templates, wrote the nine-row table above into this log before changing anything, and step 7 read
its result rather than the replaced templates. **I was never left without a yardstick I needed:** every
instance file had an installed template to compare against, and every one matched, so no header, base map
entry or base node line went into a per-file question for want of a comparison.

### The line-ending fallback — load-bearing, and it worked

**49 of the 70 baseline entries matched only through the fallback.** The command as written
(`tr -d '\r' < file | sed 's/$/\r/' | sha1sum` — strip first, so the command reads the same on every sed)
worked unmodified under Git Bash. Without it this rehearsal asks 50 decisions instead of 3 and fails its
own criterion.

### Still unclear, wrong or missing

**(a) A file the old baseline never covered *and* the staged kit does not carry matches two step 3 bullets
at once.** Step 3 says:

> *"A kit file the old baseline never listed because its pattern did not cover it (`walk.expected` and
> `settings.template.json` before 0.15) is untouched, not evolved"*

and, in the next bullet:

> *"**present here, absent from the staged kit** → list it as stale"*

`meta-mechanisms/tests/results/contract-004-tiers.sha1` is both: a `.sha1` file, so the 0.14 pattern never
listed it, and absent from the staged kit. Read by the first bullet it is *untouched → take the staged
version*, and there is no staged version to take. I resolved it by location — it sits under the base kit's
`tests/results/`, which the stale bullet names by category — and put it on the stale list. That is plainly
right, but the text does not say which bullet wins, and an agent that applied them in order would stall on
a file with nothing to take.

**(b) An evolved *agent* would raise two questions for one decision. Not exercised here.** Every kit agent
is listed twice in the baseline — once at `.claude/skills/agents/kit-x.md` and once at
`.claude/agents/kit-x.md` — because 6j covers both trees. Step 3 asks *"one question per differing file"*.
An agent evolved in place would therefore differ at two paths and be asked about twice, for what is one
decision about one agent. It did not arise in this rehearsal, because no agent was evolved. It would at a
real run on a project that edited a deployed agent, and the fix is one clause saying the deployed copy and
the kit's copy of the same agent are one file for the purpose of the question.

**(c) Nothing mechanical catches what *keep* leaves pointing at nothing.** Step 3 requires the report to
name, beside each stale file, any kept file that still refers to it, and step 7 requires the same for a
kept `> **Map:**` header. Both were done. But the kept `meta-casebook/SKILL.md` also names `REBUILD.yaml`
and `templates/REBUILD.template.yaml` in its *body*, and no step reads a kept file's body. This report is
the only safeguard. That may be the right design — the pioneer decides at the real run — but it is worth
saying plainly that *keep* is not checked, only reported.

**(d) Minor: the node does not say what to do with an agent's own slip.** The third number is defined as
*"anything you had to do that these steps do not say"*, which does not distinguish a gap in the procedure
from a mistake by the agent following it. The task framing supplied that distinction; the node does not.

### Noted, not a defect

The bootstrap warns that *"An upgrade runs in a live session, so the hooks fire throughout it against a
half-migrated project… That is expected."* In this rehearsal they did not: `telemetry.log` did not exist
before the step 9 checks, so this thread's file writes fired no kit hook. That is a property of the
environment, not of the procedure — and it means this run did not exercise the half-migrated-hooks state
the paragraph describes.

I read `meta-mechanisms/tests/fixtures/make-upgrade-fixtures.sh` as part of step 3's *"read both kits in
full"* (the step excepts only `tests/results/`). It is the script that built this fixture, and it states
that fx013 carries one evolved skill and the stale canary-era files. I had already computed the
classification from the baseline before reading it, and it changed nothing; I record that I saw it.

---

## 5. MAP.md's M-07, M-16, M-17, and the kept skill's header

```
M-07 | pioneer-correction | situation + hook cue | must | the pioneer redirects, declines, corrects a tier or bearing, overrides a recommendation, or resets the frame | answers to your own question; approvals | meta-correction-log → How to record | proposed
M-16 | review-due | hook: Stop | must | the stop-gate says pioneer-owned items wait, no batch open | — | agent: kit-batch-assembler, then meta-skill-builder → Review Batch | proposed
M-17 | batch-decided | hook: Stop | must | every item in the open batch carries a decision | — | script: close-batch.sh, then reveal-key.sh; meta-skill-builder → Reveal | proposed
```

- **M-07** — load field refreshed from *"meta-correction-log → record verbatim first"* to
  *"meta-correction-log → How to record"*, a real heading in the node.
- **M-16** — now routes to **kit-batch-assembler**, the agent that replaced kit-canary-author. The agent
  file exists at `.claude/agents/kit-batch-assembler.md`.
- **M-17** — now names **close-batch.sh, then reveal-key.sh**. Both exist under `hooks/`;
  `reveal-canaries.sh`, which the old line named, was removed as stale. No map entry points at a removed
  file.
- **M-31** — gone. `grep -c '^M-31 '` returns 0.
- All three still read `proposed`; the ratification marker sits at line 10, inside the header comment.

**The kept skill's header:**

```
> **Map:** M-04, M-05, M-26 · **Load:** retrieved on trigger by moment tag · **Recognise it by:** "we have decided a situation like this before" — or the milestone in REBUILD.yaml has been reached · **Not when:** the question is what the rule says (that is the node) rather than how it was applied
```

`M-31` removed, because the header is the map's and the staged template withdrew that entry. The rest of
the line is the kept file's and stays — including *"or the milestone in REBUILD.yaml has been reached"*,
which now names a file the upgrade removed. Reported, not asked, as step 3 directs.

---

## 6. Final state

| Check | Result |
|---|---|
| `.claude/kit-incoming/` removed | **Gone.** The project root now holds `.claude`, `.gitattributes`, `.gitignore`, `CLAUDE.md`, `UPGRADE-REHEARSAL.md` |
| `walk.sh` in the upgraded project | **Passes** — *"walk: all 36 states match walk.expected"*, exit 0 |
| `checks/G1-size.sh` | **Passes**, exit 0 — INTENT.md 4,820 B (≤ 5,120), MAP.md 6,992 B / 30 entries (≤ 8,192 / 40) |
| Install Step 7 hook commands | Every hook printed valid JSON or nothing. `close-batch.sh B-001` and `reveal-key.sh B-001` both reported *no batch file* at exit 1, the expected result |
| `telemetry.log` | Gained its `loaded\|meta-map/MAP.md` line and an ownership line naming `base-casebook`, exactly as Step 7 describes. The checks created the file, so the file was deleted afterwards |
| session-start backlog after the upgrade | Three project lines (unaudited contract, no verification evidence, unclerked correction). The staged-kit line is **gone**. No line mentions ownership counts |
| Install baseline | Regenerated after the marker: 68 entries, 0.15 form, no `*` prefixes. `.upgrade-baseline.tmp` removed |
