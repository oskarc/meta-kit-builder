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

# Whether pioneer-owned items are due is ONE rule, in lib.sh: the stop-gate's step 10 and the waiting list call it
# too, so the three readers cannot disagree (contract-023 UC-9). Two of them used to repeat the rule to each other
# (contract-007); the third, written later, did not.
pending=0
# ...and like the gate, it does not send the agent to assemble a batch the ledger records as blocked: that one
# waits on the pioneer, and the waiting list below says so.
if ! assembly_is_blocked && pioneer_items_due "$LEDGER" "$CASEBOOK" "$DRIFT" "$MAPFILE"; then pending=1; fi
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

# What is queued on the PIONEER's decision, at the start of a sitting and never because they asked for it
# (contract-022 UC-4, P-004). The script says what waits; the agent says it in their words.
woy="$KIT/meta-mechanisms/checks/waiting-on-you.sh"
if [ -f "$woy" ]; then
  wn=$(bash "$woy" "$KIT" 2>/dev/null | head -n1)
  case "$wn" in
    "waiting on the pioneer: nothing"|"") : ;;
    *) lines="${lines}- Things are waiting on the pioneer -> run bash \".claude/skills/meta-mechanisms/checks/waiting-on-you.sh\" and put the list to them in your own words, oldest first, before other work. Say nothing about how many items are due for review or which they are: a batch shows its own size when it is presented, and a count of what is due would give away which of its items are shown a second time.
" ;;
  esac
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
