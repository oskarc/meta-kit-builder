# base-building-kit

A methodology and base kit for building deterministic, standard-driven software systems using AI agents. Designed for teams who want to encode their judgment into a transferable standard — so the kit, not the person, becomes the dominant force in what gets built.

---

## What This Is

**Kit-driven development** is a pioneering practice. Its output is not a system — it is a **standard of development**, discovered through real work, distilled through discipline, and encoded into a transferable kit that can operate without its author present.

The core idea: a developer's judgment — about architecture, information architecture, cognitive load, separation of concerns, design quality — gets encoded into a structured set of skills, precedents and mechanisms. An agent operating within that kit produces results that adhere to the standard without the developer needing to guide every decision. The developer becomes an auditor and owner of the standard, not the executor of every system.

This repo contains the **base building kit** — the meta-layer that governs how any kit is built, evolved, and maintained. It is domain-agnostic. You install it first, always, regardless of what you are building.

---

## The Foundation

`meta-foundation` defines what this work is, what the human's role demands, and how the agent must orient itself to that human. Its governing lines are distilled into `INTENT.md`, which is loaded in every session.

The work rises when human judgment is present and active. It drifts when it isn't. The kit's job is to make the human's presence as effective as possible, and to preserve what that presence produces so it compounds across time. The human is a pioneer and guide — not an approver, not a corrector, not a user of a tool.

## The Governing Aspects

Ten aspects sit above all principles, patterns and implementation rules, split between agent and human deliberately.

**The agent holds five.** *Lay of the land*, *Stop on named triggers*, *Partner as orientation mirror*, *Evolution from elevation*, *Evidence is the work*. These are checkable disciplines, scored after every output by the agent and, since v0.14, from outside by the session auditor.

**The human holds five.** *Exercise judgment*, *Closeness*, *Distance*, *Re-orient*, *Hold the approval gate*. These cannot be encoded — they are what the kit is in service of. The kit can make drift visible. It cannot stop it. The human stops it.

## The Founding Contract

Each project holds its **founding contract** — the pioneer's own statement of what the project *is*, as a body of work. It is the one input the agent cannot draft: bootstrap asks for it and records it verbatim. The original is never rewritten; progress is recorded as dated amendments that name their cause and what they now bind. Every contract opens with a **bearing** — at most two sentences, read against the founding contract. Correcting a tier is a redraw; correcting the bearing is a reevaluation. See `meta-founding-contract/SKILL.md`.

---

## The Form (v0.14)

Until v0.13 the kit asked one thing — prose skills, loaded every session — to do six jobs: say when something applies, say what to do, record how sure anyone is, carry what wins in a conflict, make sure steps happen, and keep the cases that give rules their meaning. Downstream use showed the cost. Rules diluted each other in context, ceremonies were skipped when work felt routine, drift mitigated by more prose recurred up to 13 times, and learnings were approved almost without exception. A prior-art survey — agent context engineering, clinical decision support, aviation checklists, standards bodies, expert-judgement training, organisational learning — pointed the same way each time: **split by job**.

| Layer | What it holds | How it reaches the agent |
|---|---|---|
| 1 · **Intent** | `INTENT.md`, the project's `FOUNDING.md` | always loaded |
| 2 · **Map** | `MAP.md` — named moments → what to load | always loaded |
| 3 · **Nodes** | principle, pattern, implementation and meta skills | loaded when a map entry names them |
| 4 · **Casebook** | binding precedents with their facts, scenario cards | retrieved by moment |
| 5 · **Mechanisms** | hooks, agent scopes, the batch blind, the canary seal — and the kit agents they launch | fire; never loaded to work |
| 6 · **Ledger** | observations, held candidates, review batches, audits, scores | read offline by agents and scripts; its sections on trigger |

What follows from the split:
- **The kit runs itself.** Hooks hand the agent its kit tasks; nothing waits on the pioneer to invoke it.
- **The pioneer's attention goes where only the pioneer can decide.** That means contracts and review batches.
- **Learnings are held and scored before anyone asks for a decision.**
- **The pioneer's corrections become the most carefully kept record in the kit.**

---

## How It Works

The path of one feature:

1. **Name the moment.** Every prompt, the agent states the map entry that fits and loads only what it points to.
2. **Contract.** For design-open work, a **spec lock** settles *what* first. Then comes the **bearing**, a **precedent check** against the casebook, and the **four-tier proposal**: user scenario, use cases (`UC-x`), guardrails (`G-x`), and acceptance tests (`T-x`) that say how we would know each guardrail held — frozen with the contract, run by the verifier. No code before approval.
3. **Corrections.** Every redirect, decline or overridden recommendation is recorded verbatim in the correction log, with its grade.
4. **Build**, strictly against the approved contract; deviations stop the work.
5. **Record, don't present.** What the work taught goes to the ledger as observations, each with a frozen stated confidence. The pioneer sees a one-line summary, not a decision request.
6. **The lifecycle runs.** At the end of each turn the stop-gate hands over at most one due task:
   - the **session auditor** checks the transcript for evidence of what was done
   - the **verifier** checks each clause against outside evidence
   - the **consolidator** merges observations into held candidates, counted by independence
   - **meta-learning** diffs contracted against verified
   - the **case clerk** turns corrections into precedents
7. **Review batch.** When pioneer-owned items are waiting, the canary author assembles a batch and mixes in zero to two planted, flawed items. While the batch is open the ledger and casebook are closed to the presenting session, so the canaries stay indistinguishable. The pioneer reads each statement, gives a one-line verdict before seeing the evidence, then decides — including the level and tier of anything adopted.
8. **Reveal.** Once every item is decided, the sealed key opens, the catch rate is recorded, and adopted learnings are written into skills with their map entries.

---

## Agents

Eight kit agents, each defined by what it may not see and where it may write. Scopes are declared as hooks in each agent's own frontmatter.

| Agent | Runs when | Blind to | Writes |
|---|---|---|---|
| `kit-verifier` | a contract is implemented and evidence exists | the builder's account; the ledger, corrections and casebook records | clause verdicts in the contract log |
| `kit-consolidator` | observations are unconsolidated | batches, sealed keys, transcripts | candidates and scores (sole writer) |
| `kit-map-steward` | three map misses are unstewarded | batches, sealed keys, transcripts | map proposals — never the map |
| `kit-canary-author` | pioneer-owned items are waiting | sealed keys, transcripts | the batch file and its sealed key |
| `kit-case-clerk` | corrections are unclerked | batches, sealed keys, transcripts | precedents, card drafts, the fading curve |
| `kit-session-auditor` | an implemented contract is unaudited | batches | audits, missed corrections, map misses |
| `kit-reconstructor` | a reconstruction test runs | the correction log, ledger, contract log, learning log and drift log | predictions only |
| `kit-recorder` | the ledger is closed to the session by an open batch | batches, sealed keys, transcripts | observations it is handed, and nothing else |

No agent decides trial, adopt, caution or decline, overrules a precedent, amends the founding statement or ranks a scenario. Agents report; they never fix.

**The limits are stated, not implied.** Scopes cover the ordinary path: a Grep over a parent directory can still reach a denied file, an agent with Bash can write through a shell command, and each agent's own transcript records what it read. The reconstructor's blindness to the casebook rests on an excluded-precedent list it is told to honour. None of this is a security boundary; it is a discipline made cheap to keep, with an auditor as backstop for the main session.

## Mechanisms

| Hook | Event | Does |
|---|---|---|
| `session-start.sh` | SessionStart | puts the kit's backlog in context, one line per due item |
| `prompt-submit.sh` | UserPromptSubmit | forces the situation assessment; flags possible corrections |
| `stop-gate.sh` | Stop | hands over one due kit task per turn; never after a question |
| `batch-blind.sh` | PreToolUse | closes the ledger — by path and by directory search — to the session presenting a batch |
| `subagent-stop.sh` | SubagentStop | records which agents ran |
| `post-read.sh` | PostToolUse | records which kit files loaded, separating agent reads — the map's telemetry |
| `owner-check.sh` | PostToolUse | records a governed record edited while its owner's skill sat unread — ownership evidence, read by the map steward alone |
| `deny-paths.sh`, `write-scope.sh` | PreToolUse, in agent frontmatter | agent blindness and write scope |
| `close-batch.sh`, `reveal-canaries.sh` | run by the agent | close a decided batch without reading the ledger; open its key once every item is decided |

bash, sed, awk, grep, tr and date only — no jq, no python (`meta-mechanisms/SKILL.md` → Portability). State is read through flat marker keys listed there; renaming one silently switches a mechanism off.

---

## Kit Structure

```
meta-foundation/        SKILL.md (the frame) · INTENT.md (always loaded)
meta-founding-contract/ SKILL.md · FOUNDING.md (instance — this repo's statement, not yet given)
meta-map/               SKILL.md · MAP.md (always loaded)
meta-bootstrap/         SKILL.md — install and upgrade
meta-contract-before-execution/  SKILL.md · CONTRACT-LOG.yaml
meta-contract-artifact/ SKILL.md
meta-casebook/          SKILL.md · CASEBOOK.yaml
meta-correction-log/    SKILL.md · CORRECTIONS.yaml
meta-skill-builder/     SKILL.md — review batches and the abstraction loop
meta-learning/          SKILL.md · LEARNINGLOG.yaml
meta-ledger/            SKILL.md · LEDGER.yaml
meta-mechanisms/        SKILL.md · hooks/*.sh
meta-antidrift/         SKILL.md
meta-antidrift-expand/  SKILL.md
meta-drift-eventlog/    SKILL.md · DRIFTLOG.yaml
meta-extract/           SKILL.md
meta-manifest/          SKILL.md · MANIFEST.yaml
agents/                 kit-verifier · kit-consolidator · kit-map-steward · kit-canary-author ·
                        kit-case-clerk · kit-session-auditor · kit-reconstructor · kit-recorder
templates/              MANIFEST · MAP · CONTRACT-LOG · DRIFTLOG · LEARNINGLOG · LEDGER · CORRECTIONS ·
                        CASEBOOK · FOUNDING · settings (hooks, the blind and the seal)
.gitattributes          keeps the hook scripts on LF endings
```

Instance files in this repo — the manifest, logs, ledger, corrections, casebook, map and founding file — belong to the base kit itself. Its manifest reads `kit_type: base`, which is how the mechanisms know they are not installed in a project yet. Consumer projects are always seeded from `templates/`.

### What Is Loaded

- **Always:** `INTENT.md`, `FOUNDING.md`, `MAP.md` — imported by CLAUDE.md.
- **On trigger:** every other skill, named by a map entry — including the ledger's own sections when a contract cites a candidate.
- **Fires:** hooks and kit agents.
- **Offline:** the ledger's evidence and the telemetry log; agents and scripts read them, and no session loads them whole.

### Consumer Project Layout

```
CLAUDE.md                     ← kit block with three @imports, between kit-block markers
.gitignore                    ← includes .claude/kit-sealed/
.gitattributes                ← *.sh text eol=lf
.claude/
  settings.json               ← kit hooks and Read(kit-sealed/**) deny rule, merged by bootstrap
  agents/                     ← the kit agents, copied by bootstrap
  kit-sealed/                 ← canary keys (runtime, gitignored)
  kit-incoming/               ← a newer kit staged for upgrade (removed afterwards)
  skills/
    meta-*/                   ← base kit nodes, instance files seeded from templates
    meta-manifest/INSTALLED.sha1   ← per-file baseline, so an upgrade can tell evolved from untouched
    meta-ledger/batches/      ← review batches as presented
    agents/ templates/        ← as shipped
    [type-category and project nodes discovered through use]
  library/[category]/         ← placed here by the developer: META.yaml, skills, CASEBOOK.yaml
```

### Naming Convention

All skills follow `[layer]-[name]/SKILL.md`. The folder carries layer identity; the file is always `SKILL.md` for loader auto-discovery; the manifest uses the joined form. Layer prefixes: `principle-`, `pattern-`, `implementation-`, `meta-`. Kit agents are `kit-[role].md`. Every node opens with a `> **Map:**` header naming the entries that load it.

---

## Getting Started

1. **Copy the kit** into your project's `.claude/skills/`: every `meta-*/` folder, plus `agents/` and `templates/`. Copy `.gitattributes` into the project root too, or add `*.sh text eol=lf` to the one you have — CRLF endings break the hooks.
2. **Open a session.** The kit is not active yet: its own manifest declares a base `kit_type`, so every mechanism stays silent. The install cue lives in `meta-bootstrap`'s own description, because the map is not imported until bootstrap writes the CLAUDE.md block. Ask the agent to run meta-bootstrap if it doesn't offer.
3. Bootstrap introduces the practice, reads the project, asks you for the founding contract, installs the hooks and agents, writes the CLAUDE.md block, seeds every instance file from its template — replacing the base kit's own copies, with the project manifest written last — and offers one pass to ratify the map.
4. **Start a new session**, so the hooks load. From then on the kit runs itself.

### Upgrading

Never copy a new kit over `.claude/skills/`. It would overwrite your manifest, logs, ledger and corrections, and flatten any skills your project has evolved. Place the new kit in `.claude/kit-incoming/` and let bootstrap's upgrade path run: it compares versions, classifies every skill against `INSTALLED.sha1` as untouched or evolved, ports changes node by node, replaces the kit's hook groups rather than duplicating them, seeds missing instance files, and migrates older schemas additively. Contracts from before v0.14 are marked `legacy`.

---

## The Kit Lifecycle

**Phase 1 — Discovery.** No type-category kit exists yet. Every session builds the system and evolves the emerging standard. Nodes, precedents and map entries are discovered, not inherited.

**Phase 2 — Maturity.** The type-category layer separates from the project layer. Candidates per contract fall, verification diffs increasingly confirm, and the correction log shows the pioneer's interventions moving from redirecting toward reviewing.

**Phase 3 — Extraction.** When the instruments say the standard carries the pioneer's judgement, run `meta-extract`. It runs a blind reconstruction test and packages the type-category nodes, their map entries and their precedents for the library. The next project of the same type inherits the generation.

### Measuring Maturity

Silence is no longer the measure; failure produces silence too. The ledger keeps the instruments:

- **candidates created per contract** — read next to the share of sessions audited and contracts verified
- **canary catch rate** — whether the approval gate still discriminates
- **Brier scores** — for the agent's stated confidence, and for the pioneer's own decisions as their instrument
- **the fading curve** — bearing reevaluations and intervention levels over time
- **reconstruction tests** — how many of the pioneer's recorded decisions the kit alone predicts, and where it is silent

**The non-developer milestone** is reached when those instruments hold across generations: few candidates with healthy process, canaries still caught, and the kit predicting the pioneer's decisions from its own contents.

---

## What This Is Not

- A prompt library or collection of reusable snippets
- A replacement for developer judgment — it encodes judgment, it does not substitute for it
- A finished standard — the base kit is intentionally minimal; type-category kits are built through use
- A tool that works without discipline — the mechanisms make discipline cheap; they do not make it optional
- A solo endeavour — the human's presence in the work is not optional. It is what makes the standard rise rather than drift

---

## Status

The base building kit is at **v0.14** — the six-layer form, built in one step, reviewed, and not yet evaluated in real use.

The form was built under `contract-001` and then reviewed at the pioneer's request: three independent passes found 49 defects, including four that deadlocked the lifecycle at its first review batch. Those are fixed under `contract-002`, and the failure is on record as `drift-002` — every hook passed its own fixture while the loop they form did not run.

Every new and restructured node is still marked `thin`. No review batch, audit, verification or reconstruction has run in a live session. The first evaluation is planned in a downstream project. Known limits are tracked in the manifest's gap queue:
- independence with a single pioneer
- canary realism, and a pioneer who can always read the ledger themselves
- the marker-key dependency
- this repo not running its own mechanisms
- subagent inheritance of deny rules
- transcript access for the auditor, and agents' own transcripts going unaudited
- the agent-authored intent and map awaiting ratification
- the reconstruction test's blinding resting on an instruction rather than a mechanism (`gap-023`); the seventh agent was authorised on 2026-09-12 with that limit on record

Contributions, forks, and field reports welcome.
