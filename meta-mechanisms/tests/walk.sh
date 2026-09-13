#!/usr/bin/env bash
# Run from anywhere: bash meta-mechanisms/tests/walk.sh — drives stop-gate.sh through 36 lifecycle states in a temp fixture.
# Lifecycle walk: drive stop-gate.sh through every state of the kit's state machine.
SRC="$(cd "$(dirname "$0")/../.." && pwd)"

# The walk can fail (contract-007 G-7): the outer run captures every state line and diffs it against walk.expected,
# exiting non-zero on any difference. Regenerate the expected file only when a gate message changed by design:
#   WALK_INNER=1 bash walk.sh | grep -E '^[0-9]{2} ' | sed 's/  */ /g' > walk.expected
if [ -z "${WALK_INNER:-}" ]; then
  log="$(mktemp)"; WALK_INNER=1 bash "$0" | tee "$log"
  if d=$(grep -E '^[0-9]{2} ' "$log" | sed 's/  */ /g' | diff - "$SRC/meta-mechanisms/tests/walk.expected"); then
    echo "walk: all $(grep -cE '^[0-9]{2} ' "$log") states match walk.expected"; rm -f "$log"; exit 0
  else
    echo "walk: MISMATCH against walk.expected"; echo "$d"; rm -f "$log"; exit 1
  fi
fi

FX="$(mktemp -d)"
K="$FX/.claude/skills"
H="$K/meta-mechanisms/hooks"

mk() {
  rm -rf "$FX"
  mkdir -p "$H" "$K/meta-manifest" "$K/meta-contract-before-execution" \
           "$K/meta-ledger/batches" "$K/meta-correction-log" "$K/meta-casebook" \
           "$K/meta-drift-eventlog" "$K/meta-map" "$K/meta-founding-contract"
  cp "$SRC"/meta-mechanisms/hooks/*.sh "$H/"
  printf 'kit_type: project\nnodes: []\n'   > "$K/meta-manifest/MANIFEST.yaml"
  printf 'contracts: []\n'                  > "$K/meta-contract-before-execution/CONTRACT-LOG.yaml"
  printf 'observations: []\n'               > "$K/meta-ledger/LEDGER.yaml"
  printf 'corrections: []\n'                > "$K/meta-correction-log/CORRECTIONS.yaml"
  printf 'precedents: []\n'                 > "$K/meta-casebook/CASEBOOK.yaml"
  printf 'entries: []\n'                    > "$K/meta-drift-eventlog/DRIFTLOG.yaml"
  printf 'M-01 | x | must | INTENT.md | ratified\n' > "$K/meta-map/MAP.md"
  printf 'founding\n'                       > "$K/meta-founding-contract/FOUNDING.md"
}

DEFMSG="Work done. drift score 0.1"

# show LABEL [MESSAGE] [STOP_HOOK_ACTIVE]
show() {
  local label="$1" msg="${2:-$DEFMSG}" sha="${3:-false}" r
  r=$(printf '{"stop_hook_active":%s,"last_assistant_message":"%s"}' "$sha" "$msg" \
      | CLAUDE_PROJECT_DIR="$FX" bash "$H/stop-gate.sh" 2>&1)
  if [ -z "$r" ]; then
    printf '%-62s -> (silent)\n' "$label"
  else
    printf '%-62s -> %s\n' "$label" \
      "$(printf '%s' "$r" | sed -e 's/.*additionalContext":"//' -e 's/\\n.*//' | cut -c1-300)"
  fi
}

w_ledger()      { cat > "$K/meta-ledger/LEDGER.yaml"; }
w_contracts()   { cat > "$K/meta-contract-before-execution/CONTRACT-LOG.yaml"; }
w_corr()        { cat > "$K/meta-correction-log/CORRECTIONS.yaml"; }
w_case()        { cat > "$K/meta-casebook/CASEBOOK.yaml"; }
w_drift()       { cat > "$K/meta-drift-eventlog/DRIFTLOG.yaml"; }
w_map()         { cat > "$K/meta-map/MAP.md"; }
w_batch()       { cat > "$K/meta-ledger/batches/$1.md"; }

echo "=== guards ==="
mk; show "01 clean kit"
mk; printf 'kit_type: base\nnodes: []\n' > "$K/meta-manifest/MANIFEST.yaml"
w_ledger <<'EOF'
observations:
  - obs_id: O-1
    consolidated: false
EOF
show "02 kit_type base (uninstalled) must stay silent"
mk; w_ledger <<'EOF'
observations:
  - obs_id: O-1
    consolidated: false
EOF
show "03 stop_hook_active" "$DEFMSG" true
mk; w_ledger <<'EOF'
observations:
  - obs_id: O-1
    consolidated: false
EOF
show "04 question before drift block must defer" 'Should I keep the agent? drift score 0.1 lay-of-the-land 0.0'
show "05 question, no drift block at all" 'Should I keep it?'
show "06 no question, drift block present" 'All set. drift score 0.1 closeness 0.2'

echo "=== batch lifecycle ==="
mk; w_ledger <<'EOF'
observations:
  - obs_id: O-1
    review_due: true
batches:
  - batch_id: B-1
    decided: false
    revealed: false
EOF
w_batch B-1 <<'EOF'
## I-1
**Decision:** keep
## I-2
EOF
show "07 open batch, 1 of 2 decided"
mk; w_ledger <<'EOF'
observations: []
batches:
  - batch_id: B-1
    decided: false
    revealed: false
EOF
w_batch B-1 <<'EOF'
## I-1
**Decision:** keep
## I-2
Decision: drop
EOF
show "08 open batch, all decided -> close"
mk; w_ledger <<'EOF'
observations: []
batches:
  - batch_id: B-1   # first batch
    decided: true
    revealed: false
EOF
show "09 decided, unrevealed -> reveal (comment on id)"
mk; w_ledger <<'EOF'
observations: []
batches:
  - batch_id: B-1
    decided: true
    revealed: true
EOF
show "10 decided + revealed -> silent (no deadlock)"

echo "=== contract lifecycle ==="
mk; w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented
    verification_state: none
    audited: false
    transcript: /path/t.jsonl
    bearing: b
EOF
show "11 implemented, unaudited, transcript present -> audit"
mk; w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented
    verification_state: none
    audited: false
    transcript: null
    bearing: b
EOF
show "12 implemented, unaudited, transcript null -> fallback text"
mk; w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented
    verification_state: reported
    audited: true
    bearing: b
EOF
show "13 implemented + reported -> close three ways"
mk; w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented
    verification_state: none
    audited: true
    bearing: b
EOF
show "14 implemented + none -> verifier"
mk; w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented
    verification_state: awaiting-evidence
    audited: true
    bearing: b
EOF
show "15 awaiting-evidence -> silent (no deadlock)"
mk; w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented
    verification_state: closed-by-follow-up
    audited: true
    bearing: b
EOF
show "16 closed-by-follow-up -> silent"
mk; w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: verified
    verification_state: reported
    audited: true
    bearing: b
EOF
show "17 verified -> learning diff"
mk; w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: approved
    verification_state: none
    audited: false
EOF
show "18 no bearing -> form check"

echo "=== queues ==="
mk; w_ledger <<'EOF'
observations:
  - obs_id: O-1
    consolidated: false
EOF
show "19 unconsolidated observation -> consolidator"
mk; w_corr <<'EOF'
corrections:
  - corr_id: C-1
    clerked: false
EOF
show "20 unclerked correction -> case clerk"
mk; w_ledger <<'EOF'
observations:
  - obs_id: O-1
    stewarded: false
  - obs_id: O-2
    stewarded: false
  - obs_id: O-3
    stewarded: false
EOF
show "21 3 map misses -> steward"
mk; w_ledger <<'EOF'
observations:
  - obs_id: O-1
    stewarded: false
  - obs_id: O-2
    stewarded: false
EOF
show "22 2 map misses -> below threshold, silent"

echo "=== pioneer-owned items (step 9, must never print a count) ==="
mk; w_ledger <<'EOF'
observations:
  - obs_id: O-1
    review_due: true
  - obs_id: O-2
    review_due: true
  - obs_id: O-3
    review_due: true
EOF
show "23 review_due x3 -> assemble batch"
mk; w_ledger <<'EOF'
observations:
  - obs_id: O-1
    review_due: true
  - obs_id: O-2
    review_due: true
EOF
show "24 review_due x2 -> silent"
mk; w_ledger <<'EOF'
candidates:
  - cand_id: K-1
    state: pending
EOF
show "25 one pending candidate -> assemble batch"
mk; w_case <<'EOF'
precedents:
  - prec_id: P-1
    pioneer_ranking: pending
EOF
show "26 unranked card -> assemble batch"
mk; w_case <<'EOF'
precedents:
  - prec_id: P-1
    conflict: P-003
EOF
show "27 precedent conflict -> assemble batch"
mk; w_drift <<'EOF'
entries:
  - drift_id: d-1
    status: mitigated
EOF
show "28 mitigated drift -> assemble batch"
mk; w_map <<'EOF'
<!-- ratification: deferred -->
M-01 | x | must | INTENT.md | proposed
EOF
show "29 proposed entries, ratification deferred -> silent"
mk; w_map <<'EOF'
M-01 | x | must | INTENT.md | proposed
EOF
show "30 proposed entries, ratification run -> assemble batch"
mk; w_ledger <<'EOF'
candidates:
  - cand_id: K-1
    state: pending
batches:
  - batch_id: B-1
    decided: false
    revealed: false
EOF
w_batch B-1 <<'EOF'
## I-1
EOF
show "31 pending candidate WITH open batch -> silent (no double batch)"

echo "=== parsing traps ==="
mk; w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: verified
    verification_state: legacy
    audited: true
    bearing: b
    tier_3: |
      G-1 set status: implemented and verification_state: none on the entry
      audited: false is written by the auditor
EOF
show "32 enum words quoted in tier prose must not become state"
mk; w_contracts <<'EOF'
contracts:
  - report_id: report-1
    type: analysis-report
    status: implemented
    verification_state: none
    audited: false
EOF
show "33 analysis report entry must be skipped"
mk; w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented   # ready for audit
    verification_state: none   # nothing yet
    audited: false   # not yet
    bearing: b
EOF
show "34 trailing comments on state values"

echo "=== priority order ==="
mk; w_ledger <<'EOF'
observations:
  - obs_id: O-1
    consolidated: false
batches:
  - batch_id: B-1
    decided: false
    revealed: false
EOF
w_batch B-1 <<'EOF'
## I-1
**Decision:** keep
EOF
w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented
    verification_state: none
    audited: false
    bearing: b
EOF
show "35 close-batch outranks audit and consolidate"
mk; w_ledger <<'EOF'
observations:
  - obs_id: O-1
    consolidated: false
EOF
w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented
    verification_state: none
    audited: false
    bearing: b
EOF
show "36 audit outranks verify and consolidate"

echo "=== telemetry ==="
ls -1 "$K/meta-ledger/" 2>/dev/null
tail -n 4 "$K/meta-ledger/telemetry.log" 2>/dev/null || echo "(no telemetry written)"

# The comparison with walk.expected happens in the outer run at the top of this file.
