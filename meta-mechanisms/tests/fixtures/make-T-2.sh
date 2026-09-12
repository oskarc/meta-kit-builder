#!/usr/bin/env bash
# Builds the contract-005 T-2 fixture in $1 (an empty folder): a project whose corrections log holds one
# unclerked correction contradicting a planted sentence in proj-network/SKILL.md. Run kit-case-clerk on it,
# then kit-consolidator; the candidate's contradicts: must quote the planted sentence exactly.
# Recorded run: tests/results/T-2-2026-09-12.md.
set -e
SRC="$(cd "$(dirname "$0")/../../.." && pwd)"
FX="${1:?target folder}"; S="$FX/.claude/skills"
mkdir -p "$S/meta-ledger" "$S/meta-contract-before-execution" "$S/meta-drift-eventlog" "$S/proj-network" "$S/meta-manifest" "$S/meta-casebook" "$S/meta-correction-log"
cp "$SRC/meta-ledger/SKILL.md" "$S/meta-ledger/"; cp "$SRC/meta-casebook/SKILL.md" "$S/meta-casebook/"; cp "$SRC/meta-correction-log/SKILL.md" "$S/meta-correction-log/"
cp "$SRC/templates/CASEBOOK.template.yaml" "$S/meta-casebook/CASEBOOK.yaml"
printf 'kit_type: project\nnodes:\n  - id: proj-network\n    kind: skill\n    skill_file: proj-network/SKILL.md\n    owns: [proj-network/SKILL.md]\n    status: thin\n' > "$S/meta-manifest/MANIFEST.yaml"
printf 'contracts: []\n' > "$S/meta-contract-before-execution/CONTRACT-LOG.yaml"
printf 'entries: []\n' > "$S/meta-drift-eventlog/DRIFTLOG.yaml"
printf '2026-09-12T10:00:00Z|session-start|startup\n' > "$S/meta-ledger/telemetry.log"
printf 'observations: []\n\ncandidates: []\nbatches: []\nmap_proposals: []\naudits: []\nscores:\n  updated: null\n' > "$S/meta-ledger/LEDGER.yaml"
cat > "$S/proj-network/SKILL.md" <<'SK'
---
name: proj-network
description: Network calls in this project.
---

# Network calls

## Principles

Fail loudly and early: a caller must learn about a failed call in the same turn it happened.

## Patterns

Always retry a failed network call twice before surfacing the error, with a one-second pause between attempts.

Log every retry at warning level with the endpoint and attempt number.

## Anti-patterns

- Swallowing a timeout and returning an empty result.
SK
cat > "$S/meta-correction-log/CORRECTIONS.yaml" <<'CR'
corrections:

  - corr_id: C-1
    date: 2026-09-12
    contract_id: null
    moment: M-04
    grade: detail
    intervention: redirected
    agent_offered: |
      Tier 3, G-2: "retry a failed network call twice before surfacing the error, per proj-network."
    pioneer_said: |
      "no retries. surface the first failure to the caller at once and let the caller decide."
    reason_given: |
      "retries hide the failure."
    supersedes: []
    recorded_by: main-agent
    clerked: false
    precedent: null
    clerk_note: null

trajectory:
  updated: null
  by_contract: []
  moments: {}
CR
echo "T-2 fixture built at $FX"
