#!/usr/bin/env bash
# SessionStart — put the kit's backlog in front of the agent. Governed by meta-mechanisms/SKILL.md.
# Output: hookSpecificOutput.additionalContext. Never blocks.
# Counts of pioneer-owned items (due candidates, map proposals, unranked cards) are deliberately NOT
# printed: with the batch size known, a count of the real items would give away how many canaries a batch
# carries. They are reported as present, not as a number.
. "$(dirname "$0")/lib.sh"
read_input
kit_installed || exit 0
telemetry session-start "$(json_str source)"

ct=$(contracts_table)
bt=$(batches_table)
lines=""
add() { # COUNT TEXT ROUTE
  if [ "${1:-0}" -gt 0 ] 2>/dev/null; then
    lines="${lines}- $2: $1 -> $3
"
  fi
}
add_flag() { # COUNT TEXT ROUTE — presence only, never the number
  if [ "${1:-0}" -gt 0 ] 2>/dev/null; then
    lines="${lines}- $2 -> $3
"
  fi
}

add "$(nrows "$bt" '$2=="true" && $3=="false"')" "Review batches decided, canaries unrevealed" "M-17 run reveal-canaries.sh"
add "$(nrows "$bt" '$2=="false"')" "Review batches open, awaiting the pioneer" "M-16 resume the batch; ledger and casebook stay closed until the reveal"
add "$(nrows "$ct" '$2=="implemented" && $4=="false"')" "Contracts implemented, session not audited" "M-11 kit-session-auditor"
add "$(late_test_revisions | grep -c .)" "Contracts whose acceptance tests were revised after the verification report" "M-18 record the drift, then withdraw the revision or draw a follow-up contract"
add "$(nrows "$ct" '$2=="implemented" && $3=="reported"')" "Contracts verified-but-not-closed (corrected or open clauses)" "M-12 put them to the pioneer, then set status or re-verify"
add "$(nrows "$ct" '$2=="implemented" && $3=="none"')" "Contracts implemented, no verification evidence recorded" "M-12 kit-verifier, or set awaiting-evidence"
add "$(nrows "$ct" '$3=="awaiting-evidence"')" "Contracts awaiting verification evidence" "M-12 when the evidence exists, set verification_state: none to re-verify"
add "$(nrows "$ct" '$2=="verified"')" "Contracts verified, awaiting a learning diff" "M-13 meta-learning sweep"
add "$(count_matches '^[[:space:]]+consolidated:[[:space:]]*false' "$LEDGER")" "Ledger observations unconsolidated" "M-14 kit-consolidator"
add "$(count_matches '^[[:space:]]+clerked:[[:space:]]*false' "$CORRECTIONS")" "Corrections not yet clerked into the casebook" "M-15 kit-case-clerk"
add "$(count_matches '^[[:space:]]+status:[[:space:]]*(watching|mitigated)' "$DRIFT")" "Drift entries watching or mitigated" "M-18 stay alert to those aspects"
add "$(count_matches '^[[:space:]]+stewarded:[[:space:]]*false' "$LEDGER")" "Map misses not yet stewarded" "M-21 kit-map-steward at 3"

pending=$(( $(count_matches '^[[:space:]]+review_due:[[:space:]]*true' "$LEDGER") \
          + $(count_matches '^[[:space:]]+state:[[:space:]]*pending' "$LEDGER") \
          + $(count_matches '^[[:space:]]+pioneer_ranking:[[:space:]]*pending' "$KIT/meta-casebook/CASEBOOK.yaml") \
          + $(count_matches '\|[[:space:]]*proposed[[:space:]]*$' "$MAPFILE") ))
add_flag "$pending" "Pioneer-owned items are waiting (candidates, map proposals, unratified entries or unranked cards)" "M-16 kit-canary-author assembles the batch"

add "$(nrows "$ct" '$5=="no" && ($3=="none" || $3=="awaiting-evidence" || $3=="reported")')" "Contracts with no bearing" "M-24 surface to the pioneer"

if [ -f "$FOUNDING" ]; then
  if grep -qE 'Not yet given|Deferred by the Pioneer' "$FOUNDING"; then
    lines="${lines}- Founding statement not given or deferred -> M-24 surface it before drawing contracts
"
  fi
  n_amend=$(count_matches '^### Amendment' "$FOUNDING")
  n_cause=$(count_matches '\*\*Caused by:\*\*' "$FOUNDING")
  n_binds=$(count_matches '\*\*Now binds:\*\*' "$FOUNDING")
  if [ "$n_amend" -gt "$n_cause" ] || [ "$n_amend" -gt "$n_binds" ]; then
    lines="${lines}- Founding amendments missing a cause or a binding clause -> M-24 surface to the pioneer
"
  fi
fi

if [ -z "$lines" ]; then
  body="Kit backlog (session-start hook): clear."
else
  body="Kit backlog (session-start hook):
${lines}Act on each line through its map entry, one kit task at a time. The pioneer does not need to invoke any of this."
fi

printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$(json_escape "$body")"
