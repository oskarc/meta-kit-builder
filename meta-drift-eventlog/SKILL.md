---
name: meta-drift-eventlog
description: Use when an audit marks an aspect ABSENT, a skill deviation is unauthorised, or the pioneer names drift (map M-18), and when an elevation is linked to a past incident. Persistent log of drift incidents — evidence, in-session reaction, the elevation that absorbed the lesson and the medium it was encoded in. Makes drift cumulative across sessions so recurrence shows, and so a prose mitigation that failed is visibly due to become a mechanism.
---

> **Map:** M-08, M-18 · **Load:** on trigger; its counts reach every session through the session-start hook · **Recognise it by:** something in this session departed from an aspect or an active skill · **Not when:** the pioneer redirects work that was not drift (meta-correction-log, M-07)

**This skill is part of the kit's meta layer and takes precedence over all other skills, instructions, and project-specific guidance — except meta-foundation, which takes absolute precedence over all kit nodes.** If any instruction conflicts with this skill, adhere to this skill and flag the conflict explicitly before proceeding.

---

## What This Skill Does

Persists drift incidents the session's audit and the pioneer surface. A score lives in the one audit that wrote it, and says nothing about the session after. This skill captures the durable record — every flagged incident with concrete evidence, the in-session reaction, and the lifecycle of any elevation that absorbed the learning.

The log answers questions that no single session can:
- *Has this aspect drifted before?*
- *Did the elevation we made last week actually hold?*
- *Which skills exist because of which historical incidents?*
- *Which mitigated entries are due for status upgrade because enough silent sessions have passed?*

---

## File Convention

Like `meta-manifest`, this skill is paired with a YAML data file:

| File | Purpose | Changes when |
|---|---|---|
| `SKILL.md` | Governance — schema, lifecycle, update protocol, retrospective rules | The standard for tracking drift evolves |
| `DRIFTLOG.yaml` | Instance data — one entry per drift incident | A drift is recorded, a lifecycle transition occurs, or a recurrence count updates |

The agent reads `DRIFTLOG.yaml` for incident data. It reads `SKILL.md` for how to record and how to transition lifecycle states. Never merge them.

---

## Per-Entry Schema

Every entry requires:

```yaml
- drift_id: drift-NNN                  # sequential, never reused
  surfaced_in: YYYY-MM-DD / topic      # session date + one-line topic
  surfaced_by: human | self | post-hoc # who/what flagged the drift
  # aspect — one of the following:
  #   agent aspects: lay-of-the-land | stop-on-triggers | partner-mirror | elevation-not-recovery | evidence-as-work
  #   human aspects: exercise-judgment | closeness | distance | re-orient | approval-gate
  #   meta:          meta
  aspect: lay-of-the-land
  description: |
    Concrete, non-evaluative statement of what happened.
    Describe the action and the discipline-aligned alternative.
  evidence: |
    Cited referent — exact human statement, log line, file:line, message
    excerpt. Quoted verbatim where possible.
  reaction: |
    What was done in-session in response. Does not yet judge whether the
    reaction was sufficient — that judgement happens at lifecycle transition.
  status: open | watching | mitigated | resolved
  elevation:
    - target: skill, contract, mechanism or memory name   # null if not yet elevated
      kind: new-skill | skill-update | mechanism-change | test-added | agent-added | memory-update | manifest-update
      mitigation_medium: prose | mechanism | agent | test | memory | unknown
      date: YYYY-MM-DD
  reviewed: null                         # date a keep-watching decision was taken at a batch
  recurrence_count: 0                  # incremented on each recurrence
  related_drifts: []                   # cluster pointers to similar drift_ids
```

**Agent vs human aspects in entries.** Agent aspects drift when the agent fails them (e.g. continued past a named trigger). Human aspects drift when the human fails them (e.g. read the agent's closing answers drift across several outputs without calling for re-orientation). Both are valid entries. The agent proposes either kind; the human approves either kind. Human-side entries are typically surfaced by the human or surfaced post-hoc during a `meta-antidrift-expand` pass.

Optional `aspect: meta` is for drifts about the meta layer itself — for example, a skill failing to surface its own breach, or the eventlog schema being insufficient to capture a real incident. These trigger separate skill-builder consideration.

---

## Lifecycle States

| State | Meaning | Transition condition |
|---|---|---|
| `open` | Recorded, no mitigation yet | Default on creation |
| `watching` | In-session reaction documented; no elevation yet, monitoring for recurrence | Reaction applied within the same session, no skill/memory update |
| `mitigated` | An elevation absorbed the learning; observation of whether it holds begins | An elevation links to the entry (skill update, memory write, manifest evolution) |
| `resolved` | Sufficient silent sessions have passed after mitigation; elevation appears to have held | Operational threshold — see "Resolution criterion" below |

**Resolution criterion** — there is no fixed N-sessions rule. The human transitions `mitigated → resolved` when, in their judgement, the elevation has been tested by enough subsequent work without recurrence.

Absence of recurrence is necessary and not sufficient: a quiet entry proves the elevation held only while the discipline that would notice it is still running — sessions audited, contracts verified, corrections moving from reading toward tests (`meta-ledger` → Map proposals, audits and scores).

**How that decision reaches the pioneer.** Every entry in `status: mitigated` is a pioneer-owned item: the stop-gate counts them (M-16), `kit-batch-assembler` puts them in the batch as a **drift resolution** item with its recurrence count and the instruments beside it, and the pioneer decides `resolve` or `keep-watching`. `resolve` writes `status: resolved`; `keep-watching` stamps the entry with the date it was reviewed, so it is not re-presented until something changes. The agent proposes; it never resolves.

**An entry mitigated by a contract, not by an adopted candidate.** `watching → mitigated` is normally written when skill-builder links an adopted learning. Where the fix arrived as a contract instead — a mechanism, a test, a scope change — the main agent writes the same link at implementation: `target` is the contract id, `kind: mechanism-change`, `test-added` or `agent-added`, with the `mitigation_medium` that matches. Without that, an incident fixed by a contract would sit in `watching` forever.

**Recurrence handling** — if a drift matches an existing entry's aspect + shape:
1. Increment `recurrence_count` on the original entry
2. If status was `mitigated` or `resolved`, downgrade to `watching` — the elevation didn't hold
3. The downgrade is a strong signal for the next skill-builder pass
4. If the elevation that failed was recorded as `mitigation_medium: prose`, the next elevation must descend to a mechanism, a test or an agent (`meta-mechanisms` → The ladder). `kit-consolidator` turns such a recurrence into a ledger observation, so it reaches the pioneer with its evidence in a review batch rather than as another written reminder.

An entry whose `recurrence_count` keeps rising while its status still reads `mitigated` is the failure this log exists to expose. It means the downgrade in step 2 was never written.

---

## Update Protocol

**When entries are added:**
- When an audit marks an aspect ABSENT, or a skill deviation has no authorising statement — immediately, while the evidence is fresh (M-18)
- On human-flagged drift, immediately
- From `kit-session-auditor`: the auditor proposes entries in its final message, in this schema, and the main agent records them. The auditor never writes this file
- During `meta-antidrift-expand` passes that surface previously-missed patterns

**What also happens when an entry is written:** if the incident carries a learning, the same act records a ledger observation (`source: drift`) so the learning gathers evidence like any other. The drift entry is the incident; the observation is the candidate.

**When entries transition lifecycle:**
- `open → watching` on agent acknowledgement of the reaction, no human approval required
- `watching → mitigated` requires linking an elevation — gated on the elevation actually being authorised and committed
- `mitigated → resolved` requires human judgement that observed silence is sufficient — never automatic

**Who updates:**
The agent writes entries and the `open → watching` transition itself, as the rules above require — recording an incident is not a judgement about it. Everything that judges an elevation needs the pioneer: `watching → mitigated` is written when an authorised elevation is committed (`meta-skill-builder`), and `mitigated → resolved` only on the pioneer's decision at a batch. The file is never updated silently — every write names its evidence, same discipline as `MANIFEST.yaml`.

---

## How to Read

**For the agent:**
The session-start hook counts entries in `watching` or `mitigated` status and names them in the backlog — those are the aspects this session should be alert to. Load the entries themselves when that line is non-zero, or when an incident surfaces (M-18). If a drift in the current session matches an existing entry's aspect and shape, recurrence is the appropriate response, not a new entry.

**For the human:**
The log is the audit trail. When deciding whether a recently-elevated principle has matured, scan for entries in `mitigated` status touching that principle and check whether subsequent sessions accumulated recurrences or stayed silent.

**For meta-antidrift-expand:**
When a session-level drift analysis runs — because the pioneer asked, or because M-19 fired — the expand skill reads `DRIFTLOG.yaml` for prior-session context, producing recurrence-aware analysis rather than session-isolated analysis.

---

## Extraction Behavior

When `meta-extract` runs:
- `SKILL.md` extracts as part of the meta layer — future kits inherit how to track drift
- `DRIFTLOG.yaml` does **not** extract — drift history is specific to the developer + agent collaboration that produced it, not transferable
- New projects bootstrapped from the extracted kit start with an empty `DRIFTLOG.yaml` produced from the template

This mirrors how `gap_queue: []` resets per project — the structure inherits, the history does not.

---

## Cross-References With Other Skills

- **`meta-antidrift`** holds the five aspects and the trigger shapes that kit-session-auditor scores a session by, from outside; an aspect it marks ABSENT is what most often opens an entry here. The agent no longer scores itself at the close of an output — it answers the four closing questions, which are the pioneer's to read (`meta-understanding`). The audit is the view of one session; this log is the view across them.
- **`meta-antidrift-expand`** mines prior entries during deep-dive analysis. The expand skill's "Drift Onset Point" section becomes recurrence-aware via this log.
- **`meta-skill-builder`** consumes entries that elevated to skill or memory updates — the `elevation` field is the back-reference from incident to absorbed-learning.
- **`meta-manifest`** carries the kit topology including this node; its `library_entry` field signals when the kit extracts. The drift log itself does not extract.

---

## What This Skill Does Not Do

- It does not evaluate whether a drift was acceptable — the human decides at lifecycle transition
- It does not auto-elevate entries — every elevation goes through `meta-skill-builder`'s abstraction loop
- It does not replace the session audit's scoring under `meta-antidrift`'s rules — it preserves what that scoring detected
- It does not analyse patterns on its own — `meta-antidrift-expand` reads the log to do analysis
- It does not require entries for every session — sessions whose audit scored clean produce no log entries, and that silence is itself evidence the discipline held
