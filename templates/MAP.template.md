# Map — __PROJECT_NAME__

<!--
ALWAYS LOADED via CLAUDE.md. Governed by meta-map/SKILL.md. Seeded from templates/MAP.template.md by
meta-bootstrap, the project name filled in; this header is refreshed at each upgrade. Entries stay `proposed` until this project's pioneer ratifies them.
Budget: ~40 entries and ~8 KB (contract-001 G-1) — the map prunes rather than extends.
Format: id | moment | type | channel | when | not when | load | status
Pointers: bare node name = its SKILL.md · `agent:` = .claude/agents/kit-*.md · `script:` = hooks/*.sh
· bare record filename = that node's copy.
-->

Name the moment by its id before acting, then load what it points to. Nothing fits: meta-foundation (M-03), record the miss (M-20).

## Every turn

M-01 | session-start | hook: SessionStart | must | a session begins | — | work the hook's backlog, one kit task per turn | proposed
M-02 | name-the-moment | hook: UserPromptSubmit | must | every prompt, before acting | — | this map: state the id, then load its target | proposed
M-03 | frame-uncertain | situation | must | unsure what work this is, what the pioneer's role asks, or no entry fits | a moment with a clear entry (M-20 records the miss) | meta-foundation | proposed
M-28 | turn-close | always | must | the end of every output | a session-level analysis (M-19) | INTENT.md → Close every output with this block; meta-antidrift → The Drift Score Block | proposed

## Before building

M-04 | feature-request | situation | must | asked to build, change or fix anything | questions, explanations or reviews that change nothing (M-25) | meta-contract-before-execution → The Bearing, The Proposal; CASEBOOK.yaml → M-04 precedents | proposed
M-05 | design-ambiguity | situation | must | what the feature is stays open: content, direction, realisations, tunable numbers | mechanical work; a spec locked earlier | meta-contract-before-execution → Spec Lock; CASEBOOK.yaml → M-05 precedents | proposed
M-24 | founding-question | situation + hook: Stop | must | a bearing may sit outside the founding statement, or it is missing or amended | a bearing that plainly serves it (M-04) | meta-founding-contract | proposed
M-29 | candidate-check | situation | ambient | drawing Tier 3 guardrails where a trial or adopted candidate applies | a batch is open — the ledger is closed until the reveal | LEDGER.yaml → candidates; meta-ledger → Candidates | proposed
M-25 | analysis-work | situation | ambient | the work yields findings, a verdict or options, not a plan | a tiered build plan (M-04) | meta-contract-artifact → Template A | proposed
M-06 | contract-approved | lifecycle | must | the pioneer approves a contract | silence — ask again | meta-contract-before-execution → Contract Log; meta-contract-artifact | proposed

## While building

M-07 | pioneer-correction | situation + hook cue | must | the pioneer redirects, declines, corrects a tier or bearing, overrides a recommendation, or resets the frame | answers to your own question; approvals | meta-correction-log → How to record | proposed
M-08 | deviation-found | situation | must | the work must depart from the approved contract | a change already in revisions; an unauthorised one is drift (M-18) | meta-contract-before-execution → The Approval Gate | proposed
M-09 | evidence-gap | situation | must | about to rely on an unverified API, mechanic, number or claim | a fact checked this session, with its source | INTENT.md → The agent holds five aspects | proposed
M-10 | second-attempt | situation | must | about to retry a fix shape that already failed | a different hypothesis, surveyed first | meta-antidrift → Scoring Rules | proposed
M-18 | drift-flagged | situation | must | a drift score line is ABSENT, a deviation is unauthorised, or the pioneer names drift | a clean score | meta-drift-eventlog | proposed
M-23 | thin-node-touched | situation | ambient | a guardrail or gap touches a node marked thin or missing | a node change (M-22) | meta-manifest → How to Read the Manifest | proposed

## After building

M-11 | implementation-complete | lifecycle + hook: Stop | must | code for an approved contract is done | partial work mid-contract | meta-contract-before-execution → After Implementation; agent: kit-session-auditor; agent: kit-recorder while a batch is open | proposed
M-12 | verification-evidence | hook: Stop | must | a contract is implemented, evidence or not | — | agent: kit-verifier; none yet → verification_state: awaiting-evidence | proposed
M-13 | learning-due | hook: Stop | must | contracts sit at status verified | only implemented, or corrected and open clauses outstanding (M-12 first) | meta-learning | proposed
M-14 | consolidation-due | hook: Stop | must | ledger observations are unconsolidated | — | agent: kit-consolidator | proposed
M-15 | correction-unclerked | hook: Stop | must | corrections carry clerked: false | — | agent: kit-case-clerk | proposed
M-19 | drift-analysis | situation | ambient | the pioneer asks what happened, or an audit shows an aspect ABSENT twice | a single ABSENT (M-18) | meta-antidrift-expand | proposed
M-32 | task-blocked | hook: Stop | must | a kit task cannot be completed, or the gate reports one three turns running | — | meta-mechanisms → Blocked tasks | proposed

## Review and the standard

M-16 | review-due | hook: Stop | must | the stop-gate says pioneer-owned items wait, no batch open | — | agent: kit-batch-assembler, then meta-skill-builder → Review Batch | proposed
M-17 | batch-decided | hook: Stop | must | every item in the open batch carries a decision | — | script: close-batch.sh, then reveal-key.sh; meta-skill-builder → Reveal | proposed
M-22 | node-change | lifecycle | must | a candidate is adopted into a skill, or a skill is created, split or retired | edits that change no guidance | meta-skill-builder; meta-manifest → Manifest Update Protocol; meta-map → Node change | proposed
M-26 | extraction | situation | must | the pioneer judges type-category nodes ready, or the maturity instruments pass | one node being adopted or updated (M-22) | meta-extract; meta-casebook → Reconstruction tests; agent: kit-reconstructor | proposed

## The map and the kit

M-20 | map-miss | situation | must | kit knowledge existed but did not load when it applied | knowledge the kit lacks (a gap: meta-manifest) | meta-ledger → Observations (source: map-miss) | proposed
M-21 | map-review-due | hook: Stop | ambient | three or more map misses unstewarded | — | agent: kit-map-steward | proposed
M-30 | mechanism-change | situation | must | a hook, agent scope, the blind or the seal needs adding or changing; or a prose rule regressed twice | a node's guidance is what changes (M-22) | meta-mechanisms → Adding or changing a mechanism | proposed
M-27 | install-or-upgrade | situation | must | no manifest of its own, one still declaring a base kit_type, or a kit staged in .claude/kit-incoming/ | the manifest matches the kit version | meta-bootstrap | proposed

## Project entries

<!-- Added in the same act as the node (M-22). Continue the M-NN sequence. -->
