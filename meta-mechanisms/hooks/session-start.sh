#!/usr/bin/env bash
# SessionStart — put the kit's backlog in front of the agent. Governed by meta-mechanisms/SKILL.md.
# Output: hookSpecificOutput.additionalContext. Never blocks.
# Counts of pioneer-owned items (due candidates, map proposals, unranked cards) are deliberately NOT
# printed: with the batch size known, a count of the real items would give away how many re-presented
# items a batch carries. They are reported as present, not as a number.
. "$(dirname "$0")/lib.sh"
read_input
kit_installed || exit 0
src=$(json_str source)
telemetry session-start "$src"
# A sitting starts here: leave the mark the stop-gate's hold on the first batch is measured against (contract-015 G-1).
case "$src" in startup|resume) mark_session ;; esac

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

add "$(nrows "$bt" '$2=="true" && $3=="false"')" "Review batches decided, key unopened" "M-17 run reveal-key.sh"
add "$(nrows "$bt" '$2=="false"')" "Review batches open, awaiting the pioneer" "M-16 resume the batch; the ledger stays closed until the reveal, the casebook stays open"
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

# Same items as the stop-gate's step 10, so the two backlog readers never disagree (contract-007 G-5): unratified
# base entries wait for the install-time ratification pass while MAP.md carries `ratification: deferred`.
props=0
if ! grep -q 'ratification: deferred' "$MAPFILE" 2>/dev/null; then
  props=$(count_matches '\|[[:space:]]*proposed[[:space:]]*$' "$MAPFILE")
fi
# The gate opens a batch on three or more due candidates, or on ONE of anything else pioneer-owned.
# This repeats that rule rather than summing, so the two backlog readers never disagree (contract-007 UC-5).
due=$(count_matches '^[[:space:]]+review_due:[[:space:]]*true' "$LEDGER")
others=$(( $(count_matches '^[[:space:]]+state:[[:space:]]*pending' "$LEDGER") \
          + $(count_matches '^[[:space:]]+pioneer_ranking:[[:space:]]*pending' "$CASEBOOK") \
          + $(count_matches '^[[:space:]]+conflict:[[:space:]]*P-' "$CASEBOOK") \
          + $(count_matches '^[[:space:]]+status:[[:space:]]*mitigated' "$DRIFT") \
          + props ))
pending=0
if [ "${others:-0}" -ge 1 ] || [ "${due:-0}" -ge 3 ]; then pending=1; fi
add_flag "$pending" "Pioneer-owned items are waiting (candidates, map proposals, unratified entries, unranked cards, precedent conflicts or drift resolutions)" "M-16 kit-batch-assembler assembles the batch"

add "$(nrows "$ct" '$5=="no" && ($3=="none" || $3=="awaiting-evidence" || $3=="reported")')" "Contracts with no bearing" "M-24 surface to the pioneer"

if [ -f "$FOUNDING" ]; then
  # anchored at line start: the template's own instruction comment quotes the deferral phrase (contract-007 rehearsal, 4f)
  if grep -qE '^\*?(Not yet given|Deferred by the Pioneer on)' "$FOUNDING"; then
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

# A staged kit is an upgrade waiting (M-27). The staged copy of meta-bootstrap knows what it added; the installed
# copy cannot (contract-007).
if [ -d "$ROOT/.claude/kit-incoming" ]; then
  lines="${lines}- A newer kit is staged in .claude/kit-incoming/ -> M-27 follow the STAGED kit's meta-bootstrap/SKILL.md, Upgrading an Existing Install: rehearse on a copy first
"
fi

# A lock left behind means an install or upgrade began here and did not reach its end (contract-017 UC-2, UC-3).
if [ -f "$ROOT/.claude/kit-upgrade.lock" ]; then
  rb=".claude/skills/meta-mechanisms/checks/rollback.sh"
  [ -f "$ROOT/.claude/kit-incoming/meta-mechanisms/checks/rollback.sh" ] && rb=".claude/kit-incoming/meta-mechanisms/checks/rollback.sh"
  lines="${lines}- An install or upgrade was started here and did not finish -> M-27 tell the pioneer, then restore the project with: bash $rb - and start the run again from its first step. A half-finished run is never continued.
"
fi

if [ -z "$lines" ]; then
  body="Kit backlog (session-start hook): clear."
else
  body="Kit backlog (session-start hook):
${lines}Act on each line through its map entry, one kit task at a time. The pioneer does not need to invoke any of this."
fi

# The session's id, so a contract implemented here can record which session to audit without recording a machine
# path (contract-015 G-2). Claude Code sends it with every hook event; when it is absent, nothing is said.
sid=$(json_str session_id | tr -cd 'A-Za-z0-9._-')
if [ -n "$sid" ]; then
  body="${body}
This session's id is ${sid}. When a contract is implemented in this session, record that id as its transcript: value - the id alone, never a path."
fi

printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$(json_escape "$body")"
