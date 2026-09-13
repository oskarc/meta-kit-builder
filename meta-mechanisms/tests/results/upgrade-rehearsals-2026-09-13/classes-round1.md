# Upgrade rehearsal — Classes copy, pre-0.14 kit → base-building-kit 0.15

Run on 2026-09-13 on this throwaway copy, following `.claude/kit-incoming/meta-bootstrap/SKILL.md` →
"Upgrading an Existing Install", steps 1–9, with the pioneer's answers stubbed exactly as step 2 says:
*keep* for every differing file, *remove* for the stale list. Nothing under `D:\projects\meta-base-building-kit`
was read or changed; the procedure was not edited.

## 1. The three numbers

**Decisions asked: 12.** One per skill whose content differs between the install and the incoming kit, all
answered *keep* by the stub. No baseline (`INSTALLED.sha1`) existed, so the procedure's own rule applied: every
file is possibly evolved and the question is one per differing skill.

1. meta-foundation/SKILL.md
2. meta-founding-contract/SKILL.md
3. meta-manifest/SKILL.md
4. meta-contract-before-execution/SKILL.md
5. meta-skill-builder/SKILL.md
6. meta-antidrift/SKILL.md
7. meta-antidrift-expand/SKILL.md
8. meta-bootstrap/SKILL.md
9. meta-contract-artifact/SKILL.md
10. meta-drift-eventlog/SKILL.md
11. meta-extract/SKILL.md
12. meta-learning/SKILL.md

The stale-list question was not asked: the stale list is empty (every installed meta-* skill exists in the
incoming kit; the project's eight agents are its own `dashboard-*` agents, not kit agents; no hooks or
settings existed to be stale).

**Files that genuinely differed: 12.** The same twelve. Every shared skill differs; there is no shared skill
whose content matches. `templates/MANIFEST.template.yaml` also differs but is not a skill, agent or hook script
(step 3's three categories), so it was neither asked about nor installed — see section 4.

**Troubleshooting steps: 2.** Things I had to do that the steps do not say, to end with a manifest the kit's
own schema accepts:

1. **Renamed the manifest node `contract-artifact` to `base-contract-artifact`.** Step 7 says "base nodes renamed
   in the kit (`agent-canary-author` → `agent-batch-assembler`) are renamed here" and names only that one. This
   project's node for `meta-contract-artifact/SKILL.md` is called `contract-artifact`; the incoming template
   calls it `base-contract-artifact`. Without the rename, step 7 copies no `owns:` onto it (the copy is "from
   the incoming template's node of the same id") and then registers `base-contract-artifact` as a "new base
   node", leaving two nodes on one skill file. I renamed instead. The mechanisms would have run either way,
   which is why this is a judgement the procedure did not make for me rather than a crash.
2. **Ran step 8 before finishing step 7's `triggers`.** Step 7 says every node gains `triggers` if absent;
   for the 99 project nodes the only correct value is the map id step 8 assigns, and step 8 comes after step 7
   and never says to write the id back onto the node. Followed literally, every project node ends with
   `triggers: []`, which the incoming manifest node calls "a defect" ("a node with `load: trigger` and no
   triggers will not be found"). I assigned the ids first and wrote them into `triggers`.

By the procedure's own criterion — "the rehearsal passes only when every decision asked belongs to a file that
genuinely differed or is the one stale-list question, and the third number is zero" — the first condition
holds (12 = 12) and the third number is 2, so **the rehearsal does not pass**. The procedure should be fixed
before the real run (section 4 lists what to fix).

Not counted as troubleshooting, stated so the count is checkable: one bug of my own during execution (the
DRIFTLOG script inserted `mitigation_medium: unknown` into 20 elevation items that are prose strings, not maps;
verification caught it and the 20 lines were removed; the final diff is purely additive — section 3). It is
listed because it points at a real gap in the migration rule (section 4, item 7), not because the procedure
required the action.

## 2. The classification presented (step 3)

### Evolved here → asked, stub: keep (12)

| skill | lines (installed / incoming) | what differs |
|---|---|---|
| meta-foundation | 136 / 184 | incoming adds the Map header and "What This Is In Service Of"; splits the aspects into five agent and five human; renames "Stop when discipline falls" to "Stop on named triggers" with a trigger register; drops the Classes-added sixth aspect "Discipline is the work" and the Classes-added "Principles — Host VMs do not own feature-specific state" section; rewrites the maturity signal around the instruments |
| meta-founding-contract | 142 / 160 | Map header; Instance section gains the mechanised-form paragraph (stop-gate and session-start flags, gap-009) and cross-references to the contract node |
| meta-manifest | 85 / 182 | Map header, Six Layers, inheritance fields, full schema (kind / status / load / triggers / phase / tier, `owns`), retirement in the update protocol, template-drift note, instrumented promotion; drops "the manifest is read-only for the agent during a session" |
| meta-contract-before-execution | 272 / 331 | Map header, precedent check, The Bearing, Tier 4 (disappointment / premortem / red_test), two grades of correction at the gate, marker keys, verification_history, "Record, Don't Present"; drops the Classes-added Playbook Pipeline section, the "How was the run?" close, the prototype sentence in the spec lock, and the contract-id/compaction paragraph |
| meta-skill-builder | 112 / 183 | Map header, Review Batch and Reveal, tier decision, retirement, drift back-reference with `mitigation_medium`, contradictions, new anti-patterns; drops the Classes-extended runtime co-ownership clause of "Template drift" |
| meta-antidrift | 95 / 109 | the block is 7 lines for 5 agent aspects, not 9; drops the Classes-added "discipline is work" and "format compliance / DEGRADED" lines (drift-003); adds "Why only the agent's aspects", persistence, alongside-the-auditor |
| meta-antidrift-expand | 134 / 155 | Map header, ledger-audit triggers, "Drift Onset Point", §6 records observations with a compromised-session code instead of recommending elevate/discard, cross-session drift-log reading |
| meta-bootstrap | 195 / 377 | the incoming file is the 0.15 install + upgrade procedure; the installed file is the five-step first-run introduction |
| meta-contract-artifact | 328 / 362 | Map header, page states sourced from the verifier's verdicts, "the log entry is the record" replaces "never a file"; drops the Classes cross-references (bannerlord-subagent-verification, checks-fail-closed, verify-the-output) and the CONTRACT_LOG.yaml history note |
| meta-drift-eventlog | 140 / 162 | Map header, agent/human aspect vocabulary, `mitigation_medium` and `reviewed`, batch route to resolution, contract-mitigated entries, ladder on recurrence, hook-driven How to Read |
| meta-extract | 215 / 242 | Map header, precedents and map entries travel, reconstruction test, instruments in META.yaml, "Instance Data — Never Extracted" table |
| meta-learning | 156 / 175 | Map header, hook-triggered sweep, State C from the verification record only, ledger observations, fictional-id example; drops the Classes-added "Goal and meaning" section |

Consequence of the stub: the twelve old skills stay. The upgraded copy therefore mixes two forms — the old
`meta-antidrift` prescribes a 9-line block while the new always-loaded `INTENT.md` prescribes a 7-line one; the
old `meta-manifest` says the manifest is read-only in a session while the new mechanisms write to it; the old
`meta-contract-before-execution` still asks "How was the run?" and declares playbooks; none of the twelve
carries a `> **Map:**` header although the map now points at them. The real run's answers decide this.

### New in the kit → added

- skills: meta-map, meta-casebook, meta-correction-log, meta-ledger, meta-mechanisms (SKILL.md, hooks/, tests/
  minus the recorded runs under tests/results/); meta-foundation/INTENT.md
- agents (8, no name collision with the project's eight dashboard-* agents): kit-batch-assembler, kit-case-clerk,
  kit-consolidator, kit-map-steward, kit-reconstructor, kit-recorder, kit-session-auditor, kit-verifier
- hook scripts (12): batch-blind, close-batch, deny-paths, lib, owner-check, post-read, prompt-submit, reveal-key,
  session-start, stop-gate, subagent-stop, write-scope

### Present here, absent from the incoming kit → stale

- none

### Untouched here

- none can be established: there is no baseline, and no shared skill's content matches the incoming one

### Instance files

- kept, migrated in step 7: MANIFEST.yaml, CONTRACT-LOG.yaml (79 entries), DRIFTLOG.yaml (54 entries)
- kept, no migration listed: LEARNINGLOG.yaml (12 entries), FOUNDING.md
- absent, seeded from the incoming templates: LEDGER.yaml, CORRECTIONS.yaml, CASEBOOK.yaml, MAP.md, settings.json
- written last: INSTALLED.sha1 (158 files, the 16 deployed agents included)

## 3. Every migration applied, file by file

Measured against pre-migration copies; "removed" means lines deleted, "added" means lines inserted.

| file | removed | added | what |
|---|---|---|---|
| CLAUDE.md | 22 | 14 | the old un-marked block (lines 1–22, "# Kit-Driven Development" through the explicitly-invoked list) replaced by the marked block importing INTENT.md, FOUNDING.md, MAP.md; the `---` rule and the "Classes mod — working rules" section untouched |
| .claude/settings.json | new | 66 | the incoming settings template verbatim (no settings file existed): six hook events, seven `_kit` groups, `Read(kit-sealed/**)` deny |
| .gitignore | 0 | 3 | `.claude/kit-sealed/` |
| .gitattributes | new | 1 | `*.sh text eol=lf` |
| .claude/agents/kit-*.md | new | 8 files | copied from kit-incoming/agents |
| .claude/skills/meta-mechanisms/ | new | SKILL.md, 12 hooks, tests/walk.sh, walk-004.sh, walk-007.sh, walk.expected, fixtures/make-T-2.sh, empty checks/ | tests/results/ (recorded runs, fixture ledgers, sealed keys) not copied |
| .claude/skills/meta-{map,casebook,correction-log,ledger}/SKILL.md | new | 4 files | |
| .claude/skills/meta-foundation/INTENT.md | new | 1 file (4,797 bytes) | |
| meta-ledger/LEDGER.yaml, meta-correction-log/CORRECTIONS.yaml, meta-casebook/CASEBOOK.yaml | new | seeded from the incoming templates | empty instances; step 7's LEDGER and CORRECTIONS rules had nothing to migrate |
| meta-map/MAP.md | new | template + 96 project entries (M-31..M-126) | `__PROJECT_NAME__` → Classes; result 24,137 bytes, 126 entry lines |
| meta-ledger/batches/, meta-casebook/reconstruction/ | new | folders | |
| CONTRACT-LOG.yaml | 0 | 474 | every one of the 79 entries (72 contracts, 3 analysis reports, 4 standard-evolution-reports) gained, directly after its `status:` line: `verification_state: legacy`, `audited: legacy`, `disappointment: legacy`, `premortem: legacy`, `red_test: legacy`, `cost: legacy` — none of the six existed anywhere before |
| DRIFTLOG.yaml | 0 | 72 | `mitigation_medium: unknown` inserted after `kind:` in every elevation item that is a map (72 items: 65 `- target:` at entry level or nested under recurrences, 7 more nested items). The 14 `elevation: []` lists and the 10 `elevations:` lists whose items are prose strings (`- >-`) are unchanged — a string cannot gain a key |
| MANIFEST.yaml | 1 | 541 | `base_kit_version: 0.15` under `kit_identity`; the 12 existing base nodes gained `kind`, `owns` (from the incoming template's node of the same id), `load`, `triggers`; the 99 project nodes gained `kind: skill`, `load: trigger`, `triggers: [M-NN]`; 14 new base nodes registered in block form after `base-extract` (base-intent, base-map, base-correction-log, base-casebook, base-mechanisms, base-ledger, and the 8 agent-* nodes), each with a `note` naming this upgrade; the one removed line is `  - id: contract-artifact`, replaced by `  - id: base-contract-artifact` (troubleshooting step 1). `kit_type: type-category`, `version: 0.2`, the coverage map, the gap queue and the three pre-existing duplicate node pairs (base-embed-before-own/embed-before-own, base-host-already-does-it/host-already-does-it, base-verify-api-shape/verify-api-shape) are untouched. Manifest now 125 nodes, parses |
| 96 project SKILL.md files | 0 | 2 each | one `> **Map:** M-NN · **Load:** on trigger · **Recognise it by:** … · **Not when:** … (M-NN)` line after the frontmatter, matching the node's map entry |
| meta-manifest/INSTALLED.sha1 | new | 158 hashes | the 6j command as written |

Not changed, deliberately: the twelve old skills (stub: keep), templates/MANIFEST.template.yaml (not a
step-3 category), FOUNDING.md, LEARNINGLOG.yaml, the dashboard-exact support files, all project code.

### What the mechanisms did on the upgraded copy (the install's Step 7 hook checks, step 9)

All eleven commands ran; every one that emits printed valid JSON or nothing; the two batch scripts printed
"No batch file" as the install text expects. What differs from "a correct fresh install":

- `session-start.sh` printed three lines, not one: `Drift entries watching or mitigated: 38 -> M-18`,
  `Pioneer-owned items are waiting … -> M-16`, and `A newer kit is staged … -> M-27`. The install text says
  a session-start that "mentions … drift entries" means "Step 6 did not complete" — on an upgrade it means
  the project's own drift log, which is correct.
- `stop-gate.sh` hands over M-16 (batch assembler): 38 mitigated/watching entries and 126 `proposed` map
  entries are pioneer-owned items. Nothing from the 79 contracts reaches a gate — `legacy` is honoured.
- telemetry ends `subagent|kit-verifier`, `loaded|meta-map/MAP.md`, `bypass|base-casebook|meta-casebook/CASEBOOK.yaml`
  — the `loaded` line and the ownership line the install text asks for are both present, so `owns:` survived
  the manifest migration.
- `meta-mechanisms/checks/` is empty, so "run every check" ran nothing.

Extra evidence, not a step: the kit's own fixture walks run from the installed hooks. `walk.sh`: all 36 states
match `walk.expected`. `walk-004.sh`: 43 passed, 8 failed (53, 55 read `templates/MANIFEST.template.yaml`, which
in this project is still the pre-0.14 template; 75 fails because the project map now contains an `M-31`; 76
map 24,137 bytes; 77 `docs/rebuild-design.md` absent; 86 every `kind: skill` node must carry `owns:` — the 99
project nodes do not; 88 reads `skills/agents/`, which an upgrade never creates). `walk-007.sh`: 18 passed, 8
failed (98 and 110 read `skills/agents/` and the template; 101–102 no `G1-size.sh` installed; 103 reads the
project's drift-003; 105 the project manifest's `version: 0.2`; 106 the stale template; 111 the map differs from
the template because it has project entries). The walks are written against the base repo's tree, not a
project's; the first walk is the only one that applies as shipped.

## 4. What in the procedure was unclear, wrong or missing — verbatim, as hit

1. Step 3: *"Classify every skill, agent and hook script against `meta-manifest/INSTALLED.sha1`"* and *"present
   here, absent from the incoming kit → list it as stale"*. The three categories leave out templates, checks and
   tests, and the stale rule read literally would list the project's own 96 skills and 8 agents as stale (they
   are present here and absent from the incoming kit). I read "stale" as kit-owned namespaces only; the text
   does not say that.
2. Step 3: *"With no baseline, say plainly that every file must be treated as possibly evolved — and that the
   questions will therefore be one per skill."* Every one of the twelve shared skills differs, so the twelve
   questions are unavoidable — but *keep* on all twelve leaves a kit that mixes two forms (section 2). The
   rehearsal stub cannot show the pioneer that consequence; the real run should expect twelve substantive
   decisions, not twelve confirmations.
3. Step 5: *"Everything new comes from `.claude/kit-incoming/` — its `meta-*/` nodes, its `agents/`, its
   `templates/`, and its `meta-mechanisms/hooks/`."* and *"Steps 5b–5e and 6a–6j read from `.claude/skills/` and
   `.claude/skills/templates/`; on an upgrade, read the incoming copies instead."* Reading from the incoming
   templates is stated; installing them is not. After step 9's *"Remove `.claude/kit-incoming/`"* the project
   keeps a pre-0.14 `templates/MANIFEST.template.yaml` and has none of the nine new templates, although
   `base-bootstrap` owns `templates/`, the shipped tests read them (walk-004 53/55, walk-007 106/110 fail on
   exactly this), and `meta-mechanisms/checks/P-007.sh`-style checks look for them.
4. Step 5: *"the hook scripts into `.claude/skills/meta-mechanisms/hooks/`"* — says nothing about
   `meta-mechanisms/SKILL.md`, `tests/` or `checks/`. Step 3's "new in the kit → add it" covers the SKILL.md.
   I copied `tests/` without `tests/results/` (recorded runs holding fixture ledgers and sealed keys) on the
   strength of the node's `owns:`; the procedure should say what of a new node's folder travels.
5. Step 6 / 6h: *"Create the empty `.claude/skills/meta-mechanisms/checks/` folder"* and step 9: *"run every check
   under `meta-mechanisms/checks/`"*. The kit ships `G1-size.sh` (a mechanism from contract-007, referenced by
   drift-003 and walk-007) and `P-004..P-007.sh` (the base repo's own precedent checks). The upgrade installs
   none of them, so step 9 runs nothing and the map budget is enforced nowhere in a project. Which checks are
   kit mechanisms and which are the base repo's instance records is not stated anywhere.
6. Step 7, `MANIFEST.yaml`: *"every node gains `kind`, `load` and `triggers` if absent"* — the value of
   `triggers` for a project node is only known after step 8 (troubleshooting step 2). *"every non-agent base node
   gains `owns:`"* — but the incoming meta-manifest node says *"for every node that is not an agent, `owns`"* is
   required and walk-004 state 86 checks it for every `kind: skill` node, so the 99 project nodes come out of the
   upgrade violating the schema the same upgrade installed. *"base nodes renamed in the kit (`agent-canary-author`
   → `agent-batch-assembler`) are renamed here"* — does not cover a downstream project whose base node ids differ
   from the kit's (troubleshooting step 1). Nothing is said about `kit_type` (this project says
   `type-category`; the template seeds `project`), the coverage map (the manifest node says a new node is added
   "with its coverage entry"), or `library_kit`.
7. Step 7, `DRIFTLOG.yaml`: *"existing elevations gain `mitigation_medium: unknown` if absent"* — assumes every
   elevation item is a `{target, kind, date}` map. In this project 10 entries carry `elevations:` as lists of
   prose strings (`- >-`), and 8 items open with `- date:`. The rule cannot be applied to a string; the
   procedure should say to leave those or to say what they become.
8. Step 7, `CONTRACT-LOG.yaml`: *"the pioneer may name recent implemented contracts to verify and audit; set
   `none` and `false` on those"* — a decision the rehearsal stubs do not cover (only *keep* and *remove* are
   stubbed). I set `legacy` on all 79 and asked nothing; the real run has a question the stub list omits.
9. Step 8: *"For each existing non-base node, draft an entry under 'Project entries' from its description, as
   `proposed`"* against `meta-map/SKILL.md`: *"Budget. At most ~40 entries and ~8 KB … the map prunes rather than
   extends"* and the template header *"Budget: ~40 entries and ~8 KB (contract-001 G-1)"*. This project has 96
   non-base skills. Followed as written the map is 126 entries and 24,137 bytes — three times the byte allowance
   and 86 entries over — and it is always loaded. The procedure does not say what to do when a project's node
   count exceeds the map's budget; the obvious alternative (one entry per playbook stage, patterns and
   principles reached through the playbooks that already list them as dependencies — 20 of the 96 are named by
   no playbook) is a design decision the pioneer has to take, not the agent.
10. Step 8: *"The pioneer ratifies them in the first review batch, or in a ratification pass as at Step 7 of the
    install."* The upgrade never offers the pass or the `ratification: deferred` marker, so immediately after
    the upgrade the stop-gate opens a batch on 126 proposed entries (observed: `stop-gate.sh` hands over M-16).
11. Step 9: *"the install's Step 7 hook checks"* — the install text's expectations (*"prints one backlog line"*,
    *"If … `session-start.sh` mentions contracts, observations or drift entries, the base kit's records are still
    in place and Step 6 did not complete"*) are wrong for an upgrade, where the project's own records
    legitimately produce backlog lines (observed: three lines, 38 drift entries).
12. Step 5: *"Replace the CLAUDE.md block between its `kit-block` markers, adding the markers if the old block has
    none."* How far the old block extends is not said. This project's old block ran to a `---` rule after an
    "invoked explicitly" list; I replaced lines 1–22 and kept the rule.
13. Step 2's stub *"keep for every differing file"* silently keeps files that no longer describe the installed
    lifecycle (the old `meta-bootstrap`, old `meta-antidrift` block shape); the rehearsal measures the
    procedure's decision count, not whether *keep* is survivable. Worth saying in the step.
14. The shipped tests (`walk-004.sh`, `walk-007.sh`) and `G1-size.sh` compute `kit` as `$here/../..` and read
    `templates/`, `agents/`, `docs/rebuild-design.md` and the base manifest's version, so as shipped they fail in
    any project (section 3). `meta-mechanisms` says *"The walks ship with the kit"* — they do, but only
    `walk.sh` runs clean outside the base repo.

## 5. The project's own non-base skills mapped, and how

96 skill folders (99 manifest nodes; three folders carry two nodes each — both nodes of a pair got the same
`triggers`). Each got one map entry, `situation` type, ids M-31..M-126 in this order: the 8 playbooks in
pipeline order, `dashboard-exact`, the 34 principles alphabetically, the 53 patterns alphabetically. `channel`
is `must` except for ten principles that are ambient (they bear on work rather than name a moment). `when`
and `not when` were drafted from each skill's `description` and manifest `concern`; every `not when` names a
sibling by map id, base entries included (M-03, M-18, M-25). The same text is the `> **Map:**` header written
into each SKILL.md. The entries are `proposed` and nothing ratified them. The lines below are the "Project
entries" section of `.claude/skills/meta-map/MAP.md` as written.

```
M-31 | orient-before-work | situation | must | a task begins and nothing has been surveyed yet | the tiers are already being drawn (M-33) | playbook-orientation | proposed
M-32 | design-questions | situation | must | a feature's shape is open and the design questions have not been asked | mechanical work with no design content (M-34) | playbook-design | proposed
M-33 | draw-the-contract | situation | must | the tiers are about to be drawn for a settled direction | the design is still open (M-32) | playbook-contract | proposed
M-34 | build-to-contract | situation | must | code is being written against an approved contract | checking what was built (M-36) | playbook-implementation | proposed
M-35 | author-player-text | situation | must | a player-facing string is written or changed | code with no player-facing strings (M-34) | playbook-text | proposed
M-36 | verify-is-it-real | situation | must | implementation is done and the loaded binary must be shown to match it | judging whether the design is right (M-37) | playbook-verify-implementation | proposed
M-37 | verify-is-it-right | situation | must | a built feature's triggers, numbers and surfaces are judged against the player's loop | checking the build is real (M-36) | playbook-verify-design | proposed
M-38 | verify-does-it-read | situation | must | shipped strings are swept and the contract is about to close | authoring the strings (M-35) | playbook-verify-text | proposed
M-39 | dashboard-exactness | situation | must | a class dashboard is audited or built against its drawing | a screen with no drawing (M-34) | dashboard-exact | proposed
M-40 | reference-artifact | situation | ambient | a surface has a reference artifact the human rules on through renders | no artifact exists for the surface (M-67) | principle-artifact-as-living-reference | proposed
M-41 | negative-lookup | situation | must | a search returned nothing and absence is about to be claimed | the lookup scope is known complete (M-71) | principle-ask-vs-guess-on-domain-gaps | proposed
M-42 | analysis-to-doc | situation | ambient | an analysis spans many entities or will be cited by later loops | a one-off answer nobody will cite (M-25) | principle-audit-doc-as-artifact | proposed
M-43 | static-init-trigger | situation | must | about to trigger a host type's static initialiser | choosing when patches are applied (M-56) | principle-cctor-prewarm-is-aggressive | proposed
M-44 | central-gate | situation | must | adding or changing a gate that protects a shared resource | per-key registration checks (M-121) | principle-central-gate-exhaustive-coverage | proposed
M-45 | multi-path-progression | situation | ambient | designing accrual for paths a player can hold several of at once | the counting mechanism itself (M-52) | principle-commitment-gates-earning | proposed
M-46 | dashboard-state | situation | ambient | drawing or judging what a progression surface answers in each state | the fixed six-area layout (M-100) | principle-dashboard-as-journey | proposed
M-47 | lookup-table | situation | must | about to author a table derivable from system state | a UI readability question (M-114) | principle-derived-beats-cached | proposed
M-48 | extend-host-surface | situation | must | adding a surface to a host screen | asking whether the host already does it (M-53) | principle-embed-before-own | proposed
M-49 | rule-recurred | situation | must | the same rule has been broken three times despite text | a first occurrence (M-18) | principle-enforcement-layer-below-rules | proposed
M-50 | visible-surface | situation | must | authoring anything a player sees that implies runtime behaviour | prose with no runtime promise (M-57) | principle-engagement-contract | proposed
M-51 | predicate-design | situation | must | designing a predicate the runtime must observe | auditing an authored predicate (M-119) | principle-event-surface-is-the-spec | proposed
M-52 | delta-credit | situation | must | crediting progress from a periodic delta of an external tally | the accrual policy itself (M-45) | principle-gate-the-count-not-the-credit | proposed
M-53 | host-infrastructure-claim | situation | must | about to claim the host needs new infrastructure | embedding in a known host surface (M-48) | principle-host-already-does-it | proposed
M-54 | host-thread | situation | must | mod state is reachable from a host-invoked path | a screen mutating world state (M-92) | principle-host-concurrency-is-unannounced | proposed
M-55 | host-failure-guard | situation | must | writing a guard around a host call's failure | the API's declared shape (M-71) | principle-host-failure-shape-is-unannounced | proposed
M-56 | patch-timing | situation | must | choosing when to apply patches against host types | one static initialiser (M-43) | principle-host-prerequisite-aware-patching | proposed
M-57 | in-world-prose | situation | must | writing flavour, lore, intro or blurb | mechanical lines and objectives (M-35) | principle-in-world-voice | proposed
M-58 | undecided-case | situation | ambient | one evidence source cannot decide and a question to the human is forming | the scope was never complete (M-41) | principle-intersect-before-asking | proposed
M-59 | set-level-check | situation | ambient | a set-level pass is being read as per-element sanction | a check that cannot see the whole (M-99) | principle-membership-is-per-element | proposed
M-60 | meta-load | situation | must | work touches design, code or decisions before the meta layer is loaded | the frame itself is in question (M-03) | principle-meta-first | proposed
M-61 | native-call | situation | must | calling across a managed-to-native boundary | a managed failure representation (M-55) | principle-native-boundary-has-no-catch | proposed
M-62 | class-trigger-audit | situation | must | designing or auditing what makes a class progress | surface honesty (M-50) | principle-natural-engagement | proposed
M-63 | adopt-pattern | situation | ambient | a pattern is about to become a domain default | an external recommendation (M-65) | principle-pattern-evidence-audit | proposed
M-64 | choose-under-uncertainty | situation | ambient | a tiebreak, exemption or floor is made under uncertainty | a check that cannot see the whole (M-99) | principle-prefer-the-failure-that-shows | proposed
M-65 | external-recommendation | situation | must | consuming a recommendation from a subagent, review or doc | a pattern's own evidence (M-63) | principle-prescription-vs-diagnosis | proposed
M-66 | failure-recurs | situation | must | a failure returns with a signature matching a fixed one | a first-time crash (M-107) | principle-recurrence-means-incomplete-fix | proposed
M-67 | size-from-render | situation | must | sizing or positioning a visual element | a vertical text stack's pitch (M-125) | principle-render-vs-declared | proposed
M-68 | reveal-change | situation | must | a change reveals content a layout or gate was hiding | an ordinary change (M-36) | principle-revealed-content-carries-latent-bugs | proposed
M-69 | stop-moment | situation | must | one of the register's named moments appears | the moment is not in the register (M-03) | principle-stop-triggers-must-be-named | proposed
M-70 | applied-value-surface | situation | ambient | a subsystem with many producers has never shown what it applies | a derivable table (M-47) | principle-surface-audits-the-system | proposed
M-71 | closed-api | situation | must | coding against a closed library member from recall | the Bannerlord decompile recipe (M-105) | principle-verify-api-shape | proposed
M-72 | derived-dataset | situation | must | a component derives a dataset and only its mechanism is tested | one screenshot's colours (M-122) | principle-verify-the-output-not-the-mechanism | proposed
M-73 | shared-surface-string | situation | must | a string on a shared surface is fitted to the visible instance | prose voice (M-57) | principle-write-to-the-set-not-the-instance | proposed
M-74 | new-saveable-field | situation | must | adding a field to a persisted type | retiring ids from a persisted set (M-115) | pattern-added-persisted-field-is-null | proposed
M-75 | silent-failure-api | situation | ambient | removing a silent-failure mode from an API with callers | breaking every caller on purpose (M-126) | pattern-api-split-warn-and-pure | proposed
M-76 | substitute-predicate | situation | must | substituting an unobservable predicate with an observable one | classifying feasibility (M-119) | pattern-approximation-policy | proposed
M-77 | registration-line | situation | must | ordering work whose visibility hangs on one registration line | guarding a source edit (M-110) | pattern-atomic-ship-gate | proposed
M-78 | brush-per-item | situation | must | a Brush must vary per item | a numeric attribute binding (M-89) | pattern-bannerlord-brush-literal | proposed
M-79 | vm-opt-in-slot | situation | must | a view model exposes opt-in slots without change notification | a nested list's root binding (M-88) | pattern-bannerlord-configure-then-bind | proposed
M-80 | hit-test-blocked | situation | must | a widget does not receive input | a HintWidget used as a wrapper (M-84) | pattern-bannerlord-event-block-subtree | proposed
M-81 | height-inflation | situation | must | a StretchToParent height sits inside CoverChildren ancestors | width inflation (M-83) | pattern-bannerlord-gauntlet-height-chain | proposed
M-82 | layout-pre-flight | situation | must | a Gauntlet layout change is about to be called ready | non-UI work (M-36) | pattern-bannerlord-gauntlet-pre-flight-audit | proposed
M-83 | width-inflation | situation | must | a StretchToParent width sits inside CoverChildren ancestors | height inflation (M-81) | pattern-bannerlord-gauntlet-width-chain | proposed
M-84 | hint-overlay | situation | must | a HintWidget is used as a container | input blocked by a flag (M-80) | pattern-bannerlord-hintwidget-role | proposed
M-85 | variable-label-row | situation | must | a row template holds data-driven labels of unbounded length | the width-chain audit (M-83) | pattern-bannerlord-horizontal-row-with-variable-labels | proposed
M-86 | gate-vanilla-widget | situation | must | a vanilla widget needs a binding it does not declare | a Brush attribute (M-78) | pattern-bannerlord-inject-binding-for-conditional-gating | proposed
M-87 | patch-interface-method | situation | must | patching an explicit interface implementation | a DLC sibling model (M-106) | pattern-bannerlord-interface-method-patch | proposed
M-88 | itemtemplate-root | situation | must | an ItemTemplate root would carry a DataSource | opt-in VM slots (M-79) | pattern-bannerlord-itemtemplate-root-binding | proposed
M-89 | float-attribute-binding | situation | must | binding a VM property to a float-typed attribute | a Brush attribute (M-78) | pattern-bannerlord-numeric-attribute-coercion | proposed
M-90 | custom-sprite | situation | must | shipping UI art without a .tpac archive | how the host reports failure (M-55) | pattern-bannerlord-runtime-sprite-injection | proposed
M-91 | new-screen-feature | situation | must | adding a tab, panel or mode to a Bannerlord screen | gating one vanilla widget (M-86) | pattern-bannerlord-screen-extension | proposed
M-92 | screen-mutates-world | situation | must | a full-screen campaign screen mutates world state | general host threading (M-54) | pattern-bannerlord-screen-mutation-guards-visual-managers | proposed
M-93 | push-game-state | situation | must | pushing a GameState | choosing panel vs owned screen (M-91) | pattern-bannerlord-state-push | proposed
M-94 | subagent-recommendation | situation | must | a Bannerlord subagent prescribes an attribute, patch or class | the general principle (M-65) | pattern-bannerlord-subagent-verification | proposed
M-95 | authoring-mixin | situation | must | authoring a ViewModelMixin on a host VM | choosing panel vs owned screen (M-91) | pattern-bannerlord-viewmodelmixin-handle-derived | proposed
M-96 | new-behavior-state | situation | must | adding gameplay state to a campaign behavior | a registry the host saves (M-112) | pattern-behavior-local-vs-published-state | proposed
M-97 | did-it-load | situation | must | a running process may hold the old binary after a build | a crash to diagnose (M-107) | pattern-build-sentinel | proposed
M-98 | challenge-targets | situation | must | authoring tiered-counter challenge targets | trigger placement (M-62) | pattern-challenge-target-pacing | proposed
M-99 | check-cannot-see | situation | must | writing a verification check | a per-element judgement (M-59) | pattern-checks-fail-closed | proposed
M-100 | dashboard-layout | situation | must | laying out a class dashboard's areas | what a state must answer (M-46) | pattern-class-dashboard-ia | proposed
M-101 | two-sessions | situation | must | another session shares the checkout | a single session claiming an id (M-33) | pattern-concurrent-session-ledger-and-commit | proposed
M-102 | anchor-scoring | situation | must | a contract's anchoring claims must be re-verified before implementation | auditing predicates (M-119) | pattern-contract-verification-pass | proposed
M-103 | amount-control | situation | must | a dashboard commits a quantity from a pool | a binary action (M-100) | pattern-dashboard-amount-allocation | proposed
M-104 | extract-dashboard-vm | situation | must | pulling a dashboard out of ClassScreenVM | dashboard layout (M-100) | pattern-dashboard-extraction | proposed
M-105 | decompile | situation | must | a TaleWorlds or mod type signature is needed | the principle behind it (M-71) | pattern-decompile-vanilla | proposed
M-106 | dlc-sibling | situation | must | a postfix targets a vanilla concrete a DLC shadows | an interface method (M-87) | pattern-dlc-sibling-model-dual-bind | proposed
M-107 | crash | situation | must | investigating a crash | a recurring one (M-66) | pattern-dump-first-crash-diagnosis | proposed
M-108 | flavour-cut | situation | must | cutting machine tells from in-world prose | the why of voice (M-57) | pattern-flavor-composition | proposed
M-109 | glyph-sweep | situation | must | player-visible strings carry non-ASCII glyphs | prose voice (M-57) | pattern-font-safe-glyphs | proposed
M-110 | source-edit | situation | must | editing a source file not held entirely in view | the registration line (M-77) | pattern-guarded-source-mutation | proposed
M-111 | finance-line | situation | must | a mod amount should appear in the host finance UI | surveying consumers of a hook (M-118) | pattern-host-finance-integration | proposed
M-112 | host-registry | situation | must | writing into a host registry | local behaviour state (M-96) | pattern-host-registry-ownership | proposed
M-113 | attach-to-host | situation | must | attaching to a host whose lifecycle is unobservable | a handoff across a transition (M-117) | pattern-idempotent-attach-with-retry | proposed
M-114 | readability-question | situation | must | a UI readability question is really about data distribution | a derivable table (M-47) | pattern-measure-the-data-before-the-surface | proposed
M-115 | retire-saved-ids | situation | must | a migration retires ids from a persisted set | a new persisted field (M-74) | pattern-migration-by-removal | proposed
M-116 | introspectable-predicate | situation | must | a predicate needs clause-by-clause introspection | a predicate's feasibility (M-119) | pattern-named-clause-decomposition | proposed
M-117 | handoff-across-lifecycle | situation | must | a consumer is created during a lifecycle transition | attach with retry (M-113) | pattern-pending-handoff-on-activation | proposed
M-118 | hook-touches-host-data | situation | must | a postfix, prefix or handler touches host-owned data | the producer's signature (M-105) | pattern-postfix-callgraph-survey | proposed
M-119 | predicate-audit | situation | must | authoring runtime-observed content | designing the predicate (M-51) | pattern-predicate-feasibility-audit | proposed
M-120 | float-to-int-curve | situation | must | a progression curve is consumed as integers | the validator alone (M-121) | pattern-quantised-progression-eats-levels | proposed
M-121 | registry-keys | situation | must | handlers register by string key against a central registry | the gate's coverage (M-44) | pattern-registration-time-validator | proposed
M-122 | render-claim | situation | must | a render claim must be settled by pixels | whether the new build loaded (M-97) | pattern-render-census-against-the-palette | proposed
M-123 | aggregation-cache | situation | must | designing a cache that sums contributions | local state (M-96) | pattern-source-attributed-aggregation | proposed
M-124 | vocabulary-migration | situation | must | migrating names onto a vocabulary | a per-element check (M-59) | pattern-split-by-thing-and-job | proposed
M-125 | text-stack | situation | must | stacking text widgets in a fixed-height container | general sizing (M-67) | pattern-text-stack-row-pitch | proposed
M-126 | wrong-question-function | situation | must | a shared function answered the wrong question | an API's silent-failure split (M-75) | pattern-widen-signature-not-overload | proposed
```
