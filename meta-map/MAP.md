# Map — base-building-kit

<!--
ALWAYS LOADED via CLAUDE.md. Governed by meta-map/SKILL.md. The base kit's own instance; projects are
seeded from templates/MAP.template.md. Entries stay `proposed` until the pioneer ratifies them.
Budget: ~40 entries and ~8 KB (contract-001 G-1) — the map prunes rather than extends.
Format: id | moment | type | channel | when | not when | load | status
Pointers: bare node name = its SKILL.md · `agent:` = .claude/agents/kit-*.md · `script:` = hooks/*.sh
· bare record filename = that node's copy.
-->

Name the moment by its id before acting, then load what it points to. Nothing fits: meta-foundation (M-03), record the miss (M-20).

## Every turn

M-01 | session-start | hook: SessionStart | must | a session begins | — | work the hook's backlog, one kit task per turn | proposed
M-02 | name-the-moment | hook: UserPromptSubmit | must | every prompt, before acting | — | this map: state the id, then load its target | proposed
M-03 | frame-uncertain | situation | must | unsure what work this is, what the pioneer's role asks, or no entry fits | a moment with a clear entry | meta-foundation, then record the miss (M-20) | proposed
M-28 | turn-close | always | must | the end of every output | — | INTENT.md → drift score block; meta-antidrift if a line is hard to fill | proposed

## Before building

M-04 | feature-request | situation | must | asked to build, change or fix anything | questions, explanations or reviews that change nothing (M-25) | meta-contract-before-execution → The Bearing, The Proposal; CASEBOOK.yaml → M-04 precedents | proposed
M-05 | design-ambiguity | situation | must | what the feature is stays open: content, direction, several realisations, tunable numbers | mechanical work; a spec locked earlier | meta-contract-before-execution → Spec Lock; CASEBOOK.yaml → M-05 precedents | proposed
M-24 | founding-question | situation | must | a bearing may sit outside the founding statement, or it is missing or amended | a bearing that plainly serves it (M-04) | meta-founding-contract | proposed
M-29 | candidate-check | situation | ambient | drawing Tier 3 guardrails where a trial or adopted candidate applies | a batch is open — the ledger is closed until the reveal | LEDGER.yaml → candidates at stage trial or adopt; cite the id | proposed
M-25 | analysis-work | situation | ambient | the work yields findings, a verdict or options, not a plan | a three-tier build plan (M-04) | meta-contract-artifact → Template A | proposed
M-06 | contract-approved | lifecycle | must | the pioneer approves a contract | silence — ask again | meta-contract-before-execution → Contract Log; meta-contract-artifact | proposed

## While building

M-07 | pioneer-correction | situation + hook cue | must | the pioneer redirects, declines, corrects a tier or bearing, overrides a recommendation, or resets the frame | answers to your own question; approvals | meta-correction-log → record verbatim first | proposed
M-08 | deviation-found | situation | must | the work must depart from the approved contract | a change already in revisions | meta-contract-before-execution → The Approval Gate; unauthorised → meta-drift-eventlog | proposed
M-09 | evidence-gap | situation | must | about to rely on an unverified API, mechanic, number or claim | a fact checked this session, with its source | INTENT.md → Evidence is the work: stop, propose the verification | proposed
M-10 | second-attempt | situation | must | about to retry a fix shape that already failed | a different hypothesis, surveyed first | INTENT.md → Stop on named triggers: name it, ask to re-orient | proposed
M-18 | drift-flagged | situation | must | a drift score line is ABSENT, a deviation is unauthorised, or the pioneer names drift | a clean score | meta-drift-eventlog | proposed
M-23 | thin-node-touched | situation | ambient | a guardrail or gap touches a node marked thin or missing | — | MANIFEST.yaml: flag it, never fill it silently | proposed

## After building

M-11 | implementation-complete | lifecycle + hook: Stop | must | code for an approved contract is done | partial work mid-contract | meta-contract-before-execution → After Implementation; agent: kit-session-auditor; agent: kit-recorder while a batch is open | proposed
M-12 | verification-evidence | hook: Stop | must | a contract is implemented, evidence or not | — | agent: kit-verifier; none yet → verification_state: awaiting-evidence | proposed
M-13 | learning-due | hook: Stop | must | contracts sit at status verified | only implemented, or corrected and open clauses outstanding (M-12 first) | meta-learning | proposed
M-14 | consolidation-due | hook: Stop | must | ledger observations are unconsolidated | — | agent: kit-consolidator | proposed
M-15 | correction-unclerked | hook: Stop | must | corrections carry clerked: false | — | agent: kit-case-clerk | proposed
M-19 | drift-analysis | situation | ambient | the pioneer asks what happened, or an audit shows one aspect ABSENT twice | a single ABSENT (M-18) | meta-antidrift-expand | proposed

## Review and the standard

M-16 | review-due | hook: Stop | must | the stop-gate says pioneer-owned items wait, no batch open | — | agent: kit-canary-author, then meta-skill-builder → Review Batch | proposed
M-17 | batch-decided | hook: Stop | must | every item in the open batch carries a decision | — | script: reveal-canaries.sh; meta-skill-builder → Reveal | proposed
M-22 | node-change | lifecycle | must | a candidate is adopted into a skill, or a skill is created, split or retired | edits that change no guidance | meta-skill-builder; meta-manifest → Manifest Update Protocol; meta-map → Node change | proposed
M-26 | extraction | situation | must | the pioneer judges type-category nodes ready, or the maturity instruments pass | one node being adopted or updated (M-22) | meta-extract; meta-casebook → Reconstruction tests; agent: kit-reconstructor | proposed
M-31 | launch-rebuild | lifecycle | must | the milestone in REBUILD.yaml is reached | — | REBUILD.yaml; meta-casebook → Reconstruction tests | proposed

## The map and the kit

M-20 | map-miss | situation | must | kit knowledge existed but did not load when it applied — noticed by you, an agent or the pioneer | knowledge the kit lacks (a gap: meta-manifest) | meta-ledger → Observations (source: map-miss) | proposed
M-21 | map-review-due | hook: Stop | ambient | three or more map misses are unstewarded | — | agent: kit-map-steward | proposed
M-30 | mechanism-change | situation | must | a hook, agent scope, the blind or the seal needs adding, changing or debugging; or a prose rule regressed twice | a node's guidance is what changes (M-22) | meta-mechanisms → Adding or changing a mechanism | proposed
M-27 | install-or-upgrade | situation | must | no manifest of its own, one still declaring a base kit_type, or a kit staged in .claude/kit-incoming/ | the manifest exists and matches the kit version | meta-bootstrap | proposed

## Project entries

<!-- Added in the same act as the node (M-22). Continue the M-NN sequence. -->
