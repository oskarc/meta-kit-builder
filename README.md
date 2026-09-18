# base-building-kit

A kit for Claude Code that draws an organisation's standard of development out of the person who already knows it, while that person builds real software with an agent. The standard is written down as skills the agent reads and checks that fail when it is broken. A kit built this way is meant to travel: installed in the next project, it reproduces the same standard — the same patterns, logging, error handling and the rest — and, when it is mature, lets someone who is not a developer build with it.

This repository holds the **base building kit**: the part that governs how any such kit is built, evolved and carried to the next project. It is domain-agnostic. You install it first, whatever you are building. The kit's own founding statement is in `meta-founding-contract/FOUNDING.md`; the short version of how it works, drawn for a newcomer, is `docs/kit-flow.html`.

---

## What this is

An organisation's standards are rarely written down or top of mind, but they are always known. They live as the developer's theory of the work — what good looks like here, and what would be wrong. The kit's job is to draw that theory out, progressively, as the work is done. What the developer notices, corrects and decides becomes skills that explain and checks that enforce. Those skills and checks together *are* the standard, and a kit that carries them can operate without its author present for every decision. The developer becomes the auditor and owner of the standard, not the executor of every system.

We call that developer the **pioneer**, because the end result is not known at the start. The journey is exploration, and collaboration between a human and an agent: the practice guides the pioneer, while the pioneer guides and directs the kit being built.

## The foundation

`meta-foundation/SKILL.md` defines what this work is, what the pioneer's role demands, and how the agent orients itself to that person. Its governing lines are distilled into `meta-foundation/INTENT.md`, which is loaded in every session.

The work rises when the pioneer's judgement is present and active. It drifts when it is not. The kit's job is to make that presence as effective as possible and to preserve what it produces, so that it compounds across time.

## The governing aspects

Ten aspects sit above every principle, pattern and rule, split between agent and human deliberately.

**The agent holds five.** *Lay of the land*, *Stop on named triggers*, *Partner as orientation mirror*, *Evolution from elevation*, *Evidence is the work*. These are checkable disciplines: the agent scores itself on them after every output, and the session auditor scores it from outside.

**The human holds five.** *Exercise judgement*, *Closeness*, *Distance*, *Re-orient*, *Hold the approval gate*. These cannot be encoded — they are what the kit is in service of. The kit stops what a check can stop, and makes the rest visible. What no check can see, the human stops, and the agent accepts the stop without resistance.

## The founding contract

Each project holds its **founding contract**: the pioneer's own statement of what the project *is*, as a body of work. It is the one input the agent cannot draft — bootstrap asks for it and records it verbatim. The original is never rewritten; progress is recorded as dated amendments that name their cause and what they now bind. Every contract opens with a **bearing** of at most two sentences, read against that statement. Correcting a tier of a contract is a redraw; correcting the bearing is a reevaluation. See `meta-founding-contract/SKILL.md`.

---

## The form

The kit is split by job into six layers. Each layer reaches the agent differently, so that rules do not dilute each other in context and the steps that must happen are made to happen by a mechanism rather than by memory.

| Layer | What it holds | How it reaches the agent |
|---|---|---|
| 1 · **Intent** | `INTENT.md`, the project's `FOUNDING.md` | always loaded |
| 2 · **Map** | `MAP.md` — named moments → what to load | always loaded |
| 3 · **Nodes** | principle, pattern, implementation and meta skills | loaded when a map entry names them |
| 4 · **Casebook** | binding precedents with their facts, scenario cards, and the checks precedents became | retrieved by moment |
| 5 · **Mechanisms** | hooks, agent scopes, the batch blind, the sealed key, the checks — and the kit agents they launch | fire; never loaded to work |
| 6 · **Ledger** | observations, held candidates, review batches, audits, scores | read offline by agents and scripts; its sections on trigger |

What follows from the split:
- **The kit runs itself.** Hooks hand the agent its kit tasks; nothing waits on the pioneer to invoke it.
- **The pioneer's attention goes where only the pioneer can decide:** contracts and review batches.
- **Learnings are held, and read against the skill they would change, before anyone asks for a decision.**
- **The pioneer's corrections become the most carefully kept record in the kit.**

---

## How one feature moves

1. **Name the moment.** Every prompt, the agent states the map entry that fits and loads only what it points to.
2. **Contract.** For design-open work a **spec lock** settles *what* first. Then the **bearing**, a **precedent check** against the casebook, and the **four-tier proposal**: the user's story, use cases (`UC-x`), guardrails (`G-x`), and acceptance tests (`T-x`) that say how we would know each guardrail held. The agent drafts the tests with the tiers, from its picture of the land after the work, so its reading shows. At the gate the pioneer says, in their own words, what would disappoint them per guardrail, and names what failure would look like — the pre-mortem — and the tests are realigned to those words. They are frozen with the approval and run by the verifier; one is seen to fail after the build, before the contract reads implemented. No code before approval.
3. **Corrections.** Every redirect, decline or overridden recommendation is recorded verbatim, then the pioneer is asked three short questions: what did you notice, what would have been right, where have you seen this before. The case clerk turns the answer into a precedent and, where it can be tested, into a check under `meta-mechanisms/checks/`.
4. **Build**, strictly against the approved contract. Deviations stop the work.
5. **Record, don't present.** What the work taught goes to the ledger as observations. The pioneer sees a one-line summary, not a decision request.
6. **The lifecycle runs.** At the end of each turn the stop-gate hands over at most one due task:
   - the **session auditor** checks the transcript for evidence of what was done
   - the **verifier** runs the acceptance tests and checks each clause against outside evidence
   - the **consolidator** merges observations into held candidates, kept apart by whether a different reading produced them, and quotes any passage of a skill the candidate would contradict
   - **meta-learning** diffs what was contracted against what was verified
   - the **case clerk** turns corrections into precedents and checks
7. **Review batch.** When items only the pioneer can decide are waiting, the batch assembler builds a batch from real items. From the fourth batch on it may include up to two items the pioneer already decided, shown again as if new. While the batch is open the ledger is closed to the session presenting it, which is what keeps those items indistinguishable; the casebook stays open. The pioneer reads each statement, answers one question — *assume this is wrong: why?* — before seeing the evidence, then decides.
8. **Reveal.** Once every item is decided, the sealed key opens and each re-presented item's earlier decision is shown beside the new one, recorded per item and never as a rate. Each adopted learning becomes an update to a skill, the retirement of a rule, or a new rule, with its map entry.

---

## The kit agents, in the order things happen

The agent you talk to is the **main agent**. It draws contracts with you, builds, and records. Eight other agents do the kit's housekeeping, and none of them is started by you: at the end of a turn the stop-gate looks at the records, finds the first task that is due, and tells the main agent to launch the agent for it. Each of those agents is deliberately blind to something, because a check made by the same eyes that did the work confirms intentions, not outcomes. Here is what each one is for, when it wakes, and what it must not see.

**Where observations come from.** Everything the kit learns starts as an observation: one sentence, one claim, written to the ledger with a note of how sure the writer was. The main agent writes most of them, when a feature is finished and the work taught it something. Others come from meta-learning, which compares what a contract promised with what verification found; from the session auditor, when it sees a correction that nobody recorded; from the map steward, when a piece of kit knowledge existed but did not load; from the case clerk, one for every correction you make, in your words; and from you, when you say something about the standard unprompted. Observations are cheap and raw. Nothing acts on one directly.

**The session auditor** wakes when a contract has been implemented and its session has not been audited. It reads the transcript of that session from outside, looks for evidence of what was actually done rather than what was said, scores the agent on the five aspects, and compares that score with the one the session gave itself. It also lists corrections that were made but never recorded. It never reads a batch that is open, so nothing it writes can leak what is in one.

**The verifier** wakes when a contract has been implemented and there is something to verify. It reads the contract, runs each acceptance test exactly as written, and then reads the code and the outputs for the clauses no test covers. It records a verdict per clause: verified, corrected, or open. It is told the contract id and nothing else, so the builder's account of how the work went cannot steer it. It never reads the ledger, the corrections or the casebook, because those are evidence records and the verifier's job is to produce evidence, not to lean on it.

**The consolidator** wakes when observations sit unconsolidated. It is the slow store behind the fast one: it merges observations that make the same claim into a single candidate, keeps a count of how many different readings have seen the same thing, and opens the skill the candidate would change to quote any sentence the candidate would make false. It works away from the session that produced the observations, so the agent that builds never writes to what the standard learns from. It computes no score over your decisions.

**The case clerk** wakes when a correction of yours has not been clerked. A correction is any time you redirect, decline, or override what the agent proposed. The clerk turns each one into a precedent: the facts that made that situation this one, the question that had to be decided, and what you decided, in your own words and never with a reason you did not give. Where the precedent can be tested it writes a check that fails when the rule is broken. It also writes one observation per correction, so what you said reaches the review batch as a candidate. It is blind to batches and transcripts so that it cannot be steered by what is under review.

**The map steward** wakes when three or more map misses have piled up. It reads those misses, the firing telemetry, and the map itself, and proposes entries: add, narrow, retarget. It proposes only; it never edits the map, because the map is always loaded and every line of it is yours to ratify.

**The batch assembler** wakes when items only you can decide are waiting: candidates ready for review, map proposals, unratified entries, scenario cards to rank, precedent conflicts, drift resolutions. It builds the batch from real items, stripped of their ledger ids so that the presenting session cannot tell where each one came from, and seals the mapping in a key. From the fourth batch on it may put in up to two items you already decided, shown as if new; after the reveal you see both decisions side by side, and nothing scores you on it.

**The recorder** exists for one situation: a batch is open, so the ledger is closed to the session presenting it, and a feature finishes anyway. The main agent dictates its observations to the recorder, which appends them and reports back the ids. It judges nothing and reads neither the batch nor the key.

**The reconstructor** runs only when you ask whether the standard carries your judgement, or before extraction. It is given past situations with the outcomes removed and the precedents that came from them withheld, and it predicts what you decided, from the kit alone. Where it is right, the kit carries you; where it is silent or wrong, it does not yet.

No agent decides trial, adopt, caution or decline, overrules a precedent, amends the founding statement or ranks a scenario. Agents report; they never fix. Nothing in the kit scores you.

For reference, the same eight in one table:

| Agent | Wakes when | Must not see | Writes |
|---|---|---|---|
| `kit-session-auditor` | an implemented contract is unaudited | open batches | audits, missed corrections, map misses |
| `kit-verifier` | a contract is implemented and evidence exists | the builder's account; the ledger, corrections and casebook | test results and clause verdicts in the contract log |
| `kit-consolidator` | observations are unconsolidated | batches, sealed keys, transcripts | candidates and counts (sole writer) |
| `kit-case-clerk` | corrections are unclerked | batches, sealed keys, transcripts | precedents, checks, card drafts, the fading curve |
| `kit-map-steward` | three map misses are unstewarded | batches, sealed keys, transcripts | map proposals, never the map |
| `kit-batch-assembler` | pioneer-owned items are waiting | sealed keys, transcripts | the batch file and its sealed key |
| `kit-recorder` | a batch is open and a feature finishes | batches, sealed keys, transcripts | the observations it is handed |
| `kit-reconstructor` | you ask, or before extraction | the correction log, ledger, contract log, learning log, drift log | predictions only |

**The limits are stated, not implied.** Scopes cover the ordinary path: a Grep over a parent directory can still reach a denied file, an agent with Bash can write through a shell command, and each agent's own transcript records what it read. The reconstructor's blindness to the casebook rests on an excluded-precedent list it is told to honour. None of this is a security boundary; it is a discipline made cheap to keep, with an auditor as backstop for the main session.

## Mechanisms

| Hook | Event | Does |
|---|---|---|
| `session-start.sh` | SessionStart | puts the kit's backlog in context, one line per due item |
| `prompt-submit.sh` | UserPromptSubmit | forces the situation assessment; flags possible corrections |
| `stop-gate.sh` | Stop | hands over one due kit task per turn; never while a question to the pioneer is open |
| `batch-blind.sh` | PreToolUse | closes the ledger — by path and by directory search — to the session presenting a batch; keeps telemetry out of the main session always |
| `subagent-stop.sh` | SubagentStop | records which agents ran |
| `post-read.sh` | PostToolUse | records which kit files loaded, separating agent reads — the map's telemetry |
| `owner-check.sh` | PostToolUse | records a governed record edited while its owning skill sat unread — ownership evidence, read by the map steward alone |
| `deny-paths.sh`, `write-scope.sh` | PreToolUse, in agent frontmatter | agent blindness and write scope |
| `close-batch.sh`, `reveal-key.sh` | run by the agent | close a decided batch without reading the ledger; open its key once every item is decided |
| `mark-done.sh` | run by the agent at the end of an install or upgrade | holds the first review batch until the next session starts |
| `checks/P-NNN.sh` | run by the verifier and on upgrade | one check per precedent the case clerk could make testable |
| `checks/G1-size.sh` | run by the verifier and on upgrade | fails when `INTENT.md` or the map outgrow their allowance |
| `checks/G2-migration.sh` | run on upgrade | fails when a migrated record is malformed, a field or a base node or coverage line is missing |
| `checks/G3-retired.sh` | run by the verifier and on upgrade | fails when a wording the kit has retired still stands in any of its texts |
| `checks/G4-pointers.sh` | run by the verifier and on upgrade | fails when a pointer names a heading its target does not have |
| `checks/roots.sh`, `checks/residue.sh` | run on upgrade | the project's root nodes by id; the lines of a kit skill that are the project's own, re-wrapping set aside |

bash, sed, awk, grep, tr and date only — no jq, no python (`meta-mechanisms/SKILL.md` → Portability). State is read through flat marker keys listed there; renaming one silently switches a mechanism off. The hooks and the lifecycle are exercised by the walks under `meta-mechanisms/tests/`, which exit non-zero when a state differs from what is expected.

---

## Kit structure

```
meta-foundation/        SKILL.md (the frame) · INTENT.md (always loaded)
meta-founding-contract/ SKILL.md · FOUNDING.md (instance — this repo's own statement)
meta-map/               SKILL.md · MAP.md (always loaded)
meta-bootstrap/         SKILL.md — install and upgrade · history/ (the line history an upgrade measures against)
meta-contract-before-execution/  SKILL.md · CONTRACT-LOG.yaml
meta-contract-artifact/ SKILL.md
meta-casebook/          SKILL.md · CASEBOOK.yaml
meta-correction-log/    SKILL.md · CORRECTIONS.yaml
meta-skill-builder/     SKILL.md — review batches and the abstraction loop
meta-learning/          SKILL.md · LEARNINGLOG.yaml
meta-ledger/            SKILL.md · LEDGER.yaml
meta-mechanisms/        SKILL.md · hooks/*.sh · checks/*.sh · tests/
meta-antidrift/         SKILL.md
meta-antidrift-expand/  SKILL.md
meta-drift-eventlog/    SKILL.md · DRIFTLOG.yaml
meta-extract/           SKILL.md
meta-manifest/          SKILL.md · MANIFEST.yaml
agents/                 kit-verifier · kit-consolidator · kit-map-steward · kit-batch-assembler ·
                        kit-case-clerk · kit-session-auditor · kit-reconstructor · kit-recorder
templates/              MANIFEST · MAP · CONTRACT-LOG · DRIFTLOG · LEARNINGLOG · LEDGER · CORRECTIONS ·
                        CASEBOOK · FOUNDING · settings (hooks, the blind and the seal)
docs/                   kit-flow.html (the flow for a newcomer) · readme-review.md · rebuild-design.md · reports/
.gitattributes          keeps the hook scripts on LF endings
```

Instance files in this repo — the manifest, logs, ledger, corrections, casebook, map and founding file — belong to the base kit itself. Its manifest reads `kit_type: base`, which is how the mechanisms know they are not installed in a project yet. Consumer projects are always seeded from `templates/`.

### What is loaded

- **Always:** `INTENT.md`, `FOUNDING.md`, `MAP.md` — imported by CLAUDE.md.
- **On trigger:** every other skill, named by a map entry — including the ledger's own sections when a contract cites a candidate.
- **Fires:** hooks, checks and kit agents.
- **Offline:** the ledger's evidence and the telemetry log; agents and scripts read them, and no session loads them whole.

### Consumer project layout

```
CLAUDE.md                     ← kit block with three @imports, between kit-block markers
.gitignore                    ← includes .claude/kit-sealed/
.gitattributes                ← *.sh text eol=lf
.claude/
  settings.json               ← kit hooks and Read(kit-sealed/**) deny rule, merged by bootstrap
  agents/                     ← the kit agents, copied by bootstrap
  kit-sealed/                 ← batch keys (runtime, gitignored)
  kit-incoming/               ← a newer kit staged for upgrade (removed afterwards)
  skills/
    meta-*/                   ← base kit nodes, instance files seeded from templates
    meta-manifest/INSTALLED.sha1   ← per-file baseline, so an upgrade can tell evolved from untouched
    installed/                ← the kit's skills as last shipped: the yardstick your own lines are measured against
    meta-mechanisms/checks/   ← checks the case clerk writes from the pioneer's corrections
    meta-ledger/batches/      ← review batches as presented
    agents/ templates/        ← as shipped
    [type-category and project nodes discovered through use]
  library/[category]/         ← placed here by the developer: META.yaml, skills, CASEBOOK.yaml
```

### Naming convention

All skills follow `[layer]-[name]/SKILL.md`. The folder carries layer identity; the file is always `SKILL.md` for loader auto-discovery; the manifest uses the joined form. Layer prefixes: `principle-`, `pattern-`, `implementation-`, `meta-`. Kit agents are `kit-[role].md`. Every node opens with a `> **Map:**` header naming the entries that load it.

---

## Getting started

1. **Copy the kit** into your project's `.claude/skills/`: every `meta-*/` folder, plus `agents/` and `templates/`. Copy `.gitattributes` into the project root too, or add `*.sh text eol=lf` to the one you have — CRLF endings break the hooks.
2. **Open a session.** The kit is not active yet: its own manifest declares a base `kit_type`, so every mechanism stays silent. The install cue lives in `meta-bootstrap`'s own description, because the map is not imported until bootstrap writes the CLAUDE.md block. Ask the agent to run meta-bootstrap if it doesn't offer.
3. Bootstrap reads the project first, then puts everything to you once: the practice, its reading of the project, and one sheet of questions — each with a default and what each answer changes — covering the applications your system spans, a library kit if it found one, the CLAUDE.md block, the settings merge, and whether to ratify the map now or later. *Defaults* is a complete answer. Then it asks for the founding contract, which has its own moment. After that nothing asks: it installs the hooks and agents, writes the CLAUDE.md block, seeds every instance file from its template — replacing the base kit's own copies, with the project manifest written last — and ends on a done block: what was verified, what waits on you and the words that summon it, what was not checked, start working.
4. **Start a new session**, so the hooks load. From then on the kit runs itself.

### Upgrading

Never copy a new kit over `.claude/skills/`. It would overwrite your manifest, logs, ledger and corrections, and flatten any skill your project has evolved. Instead, place the new kit in `.claude/kit-incoming/` and open a session; the session-start hook names the upgrade, and the agent follows the *staged* kit's `meta-bootstrap` — the copy that knows what it added. The upgrade is rehearsed on a copy of your `.claude/` first, silently, with a log of three numbers: decisions asked, files that genuinely differed, and troubleshooting steps. The rehearsal produces one sheet: every question the real run would meet, each with the rehearsal's answer as its default and what each choice changes. A kit skill is asked about only where you wrote lines of your own in it — the upgrade measures them against the copy the kit last installed, takes a re-wrapped line for the kit's, and shows you exactly those lines: reapply them on top of the upgraded skill, or replace. Beside those come at most eight standing questions, each only when it applies: tree or commit, the files the kit no longer ships, which older contracts you want verified, drift entries awaiting review, base lines you changed in a record, the applications your system spans, which project skills belong in the always-loaded map, and whether to ratify the map now or later. You answer once; the real run takes every answer from the sheet, asks nothing, and ends on the same done block as an install. Existing records are never replaced; new fields are added with a default that says they were not there before, and a migration check fails the run if a record came out incomplete. A project from before the map and the hooks existed is upgraded by the same steps, measured against the line history the kit ships.

---

## The kit lifecycle

**Phase 1 — Discovery.** No type-category kit exists yet. Every session builds the system and evolves the emerging standard. Nodes, precedents and map entries are discovered, not inherited.

**Phase 2 — Maturity.** The type-category layer separates from the project layer. Candidates per contract fall, verification diffs increasingly confirm, and the correction log shows the pioneer's interventions moving from redirecting toward reviewing.

**Phase 3 — Extraction.** When the instruments say the standard carries the pioneer's judgement, run `meta-extract`. It runs a blind reconstruction test and packages the type-category nodes, their map entries and their precedents for the library. The next project of the same type inherits the generation.

### Measuring maturity

Silence is not the measure; failure produces silence too. The ledger and the contract log keep the instruments, and every number in them is a count of things that happened, never a score of the pioneer:

- **candidates created per contract** — read next to the share of sessions audited and contracts verified, so a fall in candidates is not mistaken for a fall in attention
- **corrections from tests versus from reading** — whether the acceptance tests are doing the finding, or the pioneer still is
- **re-presented decisions** — per item, whether the pioneer decided a real item the same way twice; recorded, never scored
- **cost per contract** — turns, tokens where known, the pioneer's minutes; nothing estimated
- **the fading curve** — how often a bearing has to be reevaluated, and how far the pioneer's interventions move from redirecting toward reviewing
- **reconstruction tests** — how many of the pioneer's recorded decisions the kit alone predicts, and where it is silent

**The non-developer milestone** is reached when those instruments hold across generations: few candidates with healthy process, corrections moving from reading toward tests, and the kit predicting the pioneer's decisions from its own contents.

---

## What this is not

- A prompt library or collection of reusable snippets
- A replacement for developer judgement — it draws judgement out and writes it down; it does not substitute for it
- A finished standard — the base kit is intentionally minimal; type-category kits are built through use
- A tool that works without discipline — the mechanisms make discipline cheap; they do not make it optional
- A solo endeavour — the human's presence in the work is not optional. It is what makes the standard rise rather than drift

---

## Status

The base building kit is at **v0.21**. Since the six-layer form was built and reviewed (contracts 001 and 002), eleven contracts have moved it:

- **Contract-003** ratified the founding statement's place in every contract: the bearing, read against `FOUNDING.md`, with redraw and reevaluation told apart.
- **Contract-004** gave every skill the records it owns and a hook that notices when a record is edited without its skill being read, and made the consolidator read each candidate against the text of the skill it would change — so a learning can update or retire a rule as readily as add one. It also made acceptance tests the fourth tier of every contract, frozen at approval.
- **Contract-005** made the pioneer's corrections the place where the standard gets written: three questions asked at the moment of a correction, and a case clerk that turns the answer into a precedent and, where it can be tested, into a check that fails.
- **Contract-006** subtracted what the kit's own research could not support. Scores computed over evidence from one person, one model and one codebase were removed rather than tuned; nothing in the kit scores the pioneer; the rebuild experiment was withdrawn to `docs/rebuild-design.md` with the conditions for its return; the intent was aligned to the founding statement and ratified.
- **Contract-007** made the kit ready to travel: the version moves, the upgrade migrates everything 004–006 added, stale files are listed and removed only on confirmation, and the upgrade is rehearsed on a copy before it touches a project. It also corrected the hooks where they told the agent something false, made the lifecycle walks fail when a state is wrong, added the size check, and re-evaluated this README line by line (`docs/readme-review.md`).
- **Contract-008** made the upgrade compare by mechanism after the first real fork lost three of its own evolutions and eight registry nodes without a question: the kit keeps an installed copy of every meta skill as the yardstick, asks only where a project wrote lines of its own (reapply on top, or replace), checks a migration for completeness and validity as well as preservation, computes the map's roots by id, lets a deferred drift entry rest at `legacy`, and keeps the rehearsal log.
- **Contract-009** closed the four gaps the first real upgrade run logged, each where the log found it: the staged folder is the travel set and may be cloned and copied at a short path, an absent base coverage line is added and checked, an empty ratification pass asks nothing, and the record templates' headers read as the record's; the tree-or-commit question became the seventh standing question, and the kit's own log and corrections were backfilled so its own migration check passes on its own tree.
- **Contract-010** let a kit govern a system that spans repositories from the one it is installed in: the applications are named once at install, the agent writes the manifest's `workspace` list, the `additionalDirectories` grant and the kit-block line itself, and the hooks act on the kit their event belongs to, found by walking up from the working directory, so a session moved into the pilot with `/cd` runs its hooks and another kit's reads are never this kit's evidence.
- **Contract-011** made the install and the upgrade read everything first and ask everything once: one sheet with the default and the impact of each choice, a run that cannot stop after it, a done block that says what was verified, what waits and what was not checked, and a `done` line in telemetry that holds the first review batch until the next session.
- **Contract-012** drafts Tier 4 with the tiers: the acceptance tests arrive with the bearing and Tiers 1 to 3, drawn from the agent's picture of the land after implementation so its reading shows before any code; the pioneer's disappointment line per guarantee is still asked and still wins, the tests it moves are realigned before approval and named on a `realigned:` line, and the gate is one stop.
- **Contract-013** made the kit say one thing everywhere, after the verifier read contracts 008 to 012 and found one kind of miss in all five — a sentence changed beside a sentence left saying the opposite, and tests that searched only for the new words: the contract order, the doctrine that a matching precedent decides, the silent run and the nine seeded templates now read the same in every file; a script measures which lines of a kit skill are the project's own and sets re-wrapping aside; the hooks bring a path's two Windows spellings to one; and two checks fail on the class — a list of retired wordings that must not survive anywhere, and pointers that must name a heading that exists.

The first evaluation in a project other than this one is under way and not yet reported. Known limits are tracked in the manifest's gap queue: independence with a single pioneer; a pioneer who can always read the ledger themselves; the marker-key dependency; this repository not running its own mechanisms in a session; subagent inheritance of deny rules; transcript access for the auditor, and agents' own transcripts going unaudited; the reconstruction test's blinding resting on an instruction rather than a mechanism; the rebuild experiment awaiting its conditions; and a contradicting correction that is due at once still waiting for a batch to open.

Contributions, forks, and field reports welcome.
