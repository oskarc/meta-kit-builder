# README review — contract-007 G-12

The pioneer, 2026-09-13: *"As part of this we must reevaluate every line in the readme file, the approach has evolved."*

Method. The README as of commit fe44461 (239 lines) was read in full, section by section. Every sentence was judged against three things: the founding statement (`meta-founding-contract/FOUNDING.md`), the ratified intent (`meta-foundation/INTENT.md`), and the kit as it is on disk after contracts 003–007. Each sentence got one of three dispositions — **keep** (the sentence stands, possibly moved), **rewrite** (the claim is right but the words are stale, wrong in detail, or unreadable by a newcomer), **drop** (the claim is false, retired, or belongs in a node rather than the README). The table has one row per section; the notes under it list every sentence whose disposition is not *keep*, with the reason. A sentence not named in the notes was kept.

Structure check on the rewritten README (the same kind of check `docs/kit-flow.html` passed under contract-006): every file path the README names exists on disk; every section here has a counterpart in the new README or is recorded as dropped; the census over the README finds none of the retired terms (the instruments retired by contract-006, the renamed agent and script, "binding" precedents, the old version number). The check is run by `meta-mechanisms/tests/walk-007.sh` state 112.

| # | Section (old README) | Disposition | Reason |
|---|---|---|---|
| 1 | Title and opening paragraph | rewrite | "deterministic, standard-driven software systems" and "the kit, not the person, becomes the dominant force" contradict the founding statement, where the practice guides the pioneer and the pioneer guides the kit. The opening now says what the kit is for in the founding statement's own terms. |
| 2 | What This Is | rewrite | "operate without its author present" is the travelling goal and stays; "a developer's judgment … gets encoded" becomes "the standard the developer already knows gets drawn out", which is the intent's first sentence. The auditor-and-owner line stays. |
| 3 | The Foundation | keep | Aligned. One phrase moved: the pioneer is "named for the journey" (INTENT). |
| 4 | The Governing Aspects | rewrite | "The kit can make drift visible. It cannot stop it." is now "The kit stops what a check can stop, and makes the rest visible" (INTENT, since contract-005 the clerk writes checks). "since v0.14, from outside by the session auditor" dropped: version-stamped history in a description. |
| 5 | The Founding Contract | keep | Aligned with `meta-founding-contract/SKILL.md`. "See …" pointer kept. |
| 6 | The Form (v0.14) | rewrite | Heading versioned; "binding precedents" contradicts INTENT ("it instructs, it does not bind"); the history paragraph ("Until v0.13 … drift mitigated by more prose recurred up to 13 times") is unsourced in the repo and drops. The six-layer table stays, with layer 4 reworded and the "what follows" list kept. |
| 7 | How It Works | rewrite | Right shape, stale detail: the contract step gains the pioneer's disappointment words, the pre-mortem and the red test (contract-006); step 3 gains the three questions and the clerk-to-check route (contract-005); "frozen stated confidence" dropped from step 5 — it is recorded, not scored; step 7 rewritten so a newcomer can follow what a batch is; step 8 "adopted learnings" now says update, retire or add. |
| 8 | Agents | rewrite (second pass) | First kept as a table; the pioneer, after approving the README: "It still hides steps ... what is the clerk? consolidator checks observations, but who makes the observations? ... it reads more like a formula and should read like a guide, the point is to teach not to state fact" (C-011). Rewritten as a guide in the order things happen, opening with where observations come from, one paragraph per agent; the table kept at the end for reference. |
| 9 | Mechanisms | rewrite | Table correct; adds the `checks/` folder (contract-005) and `G1-size.sh` (contract-007). The portability sentence kept. |
| 10 | Kit Structure | rewrite | Adds `meta-mechanisms/checks/` and `tests/`, `docs/`; "FOUNDING.md (… not yet given)" was false since 2026-09-13 — the statement exists. |
| 11 | What Is Loaded | keep | Verified against `templates/settings.template.json` and the CLAUDE.md block. |
| 12 | Consumer Project Layout | keep | One line added for `meta-mechanisms/checks/`. |
| 13 | Naming Convention | keep | Unchanged. |
| 14 | Getting Started | keep | Unchanged in substance; "30 map entries" is now the number on disk. |
| 15 | Upgrading | rewrite | Contract-007 changed the procedure: rehearsal on a copy, one question per file that genuinely differs, the stale-file list, follow the staged kit's bootstrap. "Contracts from before v0.14 are marked legacy" widened to the 006 fields. |
| 16 | The Kit Lifecycle | keep | Three phases unchanged. |
| 17 | Measuring Maturity | rewrite | The list was already the post-006 list; the sentence "Silence is no longer the measure; failure produces silence too" kept; "re-presented decisions … recorded, never scored" kept. Reworded so a newcomer knows what each instrument is for; "Nothing scores the pioneer" added (INTENT). |
| 18 | What This Is Not | keep | Unchanged. |
| 19 | Status | rewrite | Every line was v0.14-specific: "not yet evaluated in real use", the contract-002 review, "no review batch … has run". Now narrates 003–007 in one paragraph each and lists the limits still open in the gap queue. |

## Sentences dropped or rewritten, by section

**1 · Opening.** *"A methodology and base kit for building deterministic, standard-driven software systems using AI agents."* — rewrite: "deterministic" is not a claim the kit makes anywhere; the founding statement's claim is that a standard travels. *"Designed for teams who want to encode their judgment into a transferable standard — so the kit, not the person, becomes the dominant force in what gets built."* — rewrite: contradicts FOUNDING paragraph five.

**2 · What This Is.** *"Its output is not a system — it is a standard of development, discovered through real work, distilled through discipline, and encoded into a transferable kit that can operate without its author present."* — keep, reworded to "drawn out of the people who already know it" (FOUNDING paragraph two). *"The core idea: a developer's judgment … gets encoded into a structured set of skills, precedents and mechanisms."* — rewrite: "encoded" → "written down as skills that explain and checks that enforce" (INTENT). *"An agent operating within that kit produces results that adhere to the standard without the developer needing to guide every decision."* — keep. *"The developer becomes an auditor and owner of the standard, not the executor of every system."* — keep. *"This repo contains the base building kit … You install it first, always."* — keep.

**4 · Governing Aspects.** *"These are checkable disciplines, scored after every output by the agent and, since v0.14, from outside by the session auditor."* — rewrite: drop the version stamp. *"The kit can make drift visible. It cannot stop it. The human stops it."* — rewrite to INTENT's sentence.

**6 · The Form.** *"Until v0.13 the kit asked one thing … Rules diluted each other in context, ceremonies were skipped when work felt routine, drift mitigated by more prose recurred up to 13 times, and learnings were approved almost without exception."* — drop: the "13 times" and "almost without exception" figures trace to no record in the repository (the same class of claim contract-006 withdrew from `meta-ledger/SKILL.md`). *"A prior-art survey — agent context engineering, clinical decision support, aviation checklists, standards bodies, expert-judgement training, organisational learning — pointed the same way each time: split by job."* — rewrite: kept as one sentence without the list; the research notes are not in the repo. *"4 · Casebook | binding precedents with their facts, scenario cards"* — rewrite: "precedents with their facts, and the checks they became". *"Learnings are held and scored before anyone asks for a decision."* — rewrite: "held, and read against the skill they would change, before anyone asks for a decision" — scoring per candidate was retired by contract-006.

**7 · How It Works.** Step 2: *"frozen with the contract, run by the verifier"* — keep; adds disappointment, pre-mortem, red test. Step 3: *"with its grade"* — rewrite: the grade stays, the three questions and the clerk's check are what a newcomer needs to know. Step 5: *"each with a frozen stated confidence"* — drop: recorded, not scored (contract-006). Step 6: *"counted by independence"* — rewrite: "kept apart by whether a different reading produced them". Step 7: *"from the fourth batch on it may include up to two items the pioneer already decided, shown again as if new"* — keep, explained. Step 8: *"adopted learnings are written into skills"* — rewrite: "each learning is adopted as an update to a skill, a retirement of a rule, or a new rule".

**9 · Mechanisms.** *"stop-gate.sh | hands over one due kit task per turn; never after a question"* — keep, and the guard now also reads the text after the drift block (contract-007 G-6). Rows added: `checks/P-NNN.sh` and `checks/G1-size.sh`.

**10 · Kit Structure.** *"FOUNDING.md (instance — this repo's statement, not yet given)"* — rewrite: given 2026-09-13.

**15 · Upgrading.** *"it compares versions, classifies every skill … ports changes node by node, replaces the kit's hook groups rather than duplicating them, seeds missing instance files, and migrates older schemas additively. Contracts from before v0.14 are marked legacy."* — rewrite to the contract-007 procedure.

**17 · Measuring Maturity.** *"candidates created per contract — read next to the share of sessions audited and contracts verified"* — keep. *"corrections from tests versus from reading"* — keep, explained. *"re-presented decisions"* — keep. *"cost per contract"* — keep. *"the fading curve"* — keep, explained. *"reconstruction tests"* — keep. *"The non-developer milestone …"* — keep.

**19 · Status.** Every sentence rewritten; see the new section. The bullet list of known limits is reduced to the gaps still open in `meta-manifest/MANIFEST.yaml` (gap-020 to gap-028, gap-030, gap-031) named in words, not by id.

## What the new README does not say

- No figure that is not measured by a check or recorded in a log. Sizes come from `G1-size.sh`; counts from the files.
- No description of a retired instrument, even to say it was retired — that history lives in the contract log (contract-006) and `docs/rebuild-design.md`.
- No claim about the kit in use elsewhere. The first upgrade on a real fork is rehearsed under contract-007 and the results live in `meta-mechanisms/tests/results/`; the evaluation in other repositories is stage 1 and is not yet reported.
