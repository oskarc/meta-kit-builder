#!/usr/bin/env bash
# Stop — the kit's lifecycle runner. Governed by meta-mechanisms/SKILL.md.
# At the end of a turn, if the kit has due work, hand the agent exactly ONE task, highest priority first.
# Uses additionalContext (non-error continuation). Guards: stop_hook_active (one forced continuation per
# turn), and a turn whose visible text ends by asking the pioneer a question is never extended.
. "$(dirname "$0")/lib.sh"
read_input
kit_installed || exit 0
[ "$(json_bool stop_hook_active)" = "true" ] && exit 0

# A question to the pioneer is never buried. The message arrives with its JSON escapes intact, so rather
# than decoding them: cut everything from the LAST "drift score" marker (the block that closes every
# output — the phrase also occurs in ordinary prose, so the last one is the block), then look for a
# question mark anywhere in the closing stretch of what remains. A late "?" that was not a question costs
# one turn of delay; a missed question gets buried under a kit task, which is the worse failure.
last=$(json_str last_assistant_message)
# `.*` is greedy, so the capture runs to the LAST "drift score" in the message; a message without the
# phrase is passed through unchanged.
visible=$(printf '%s' "$last" | sed -e 's/\(.*\)drift score.*/\1/')
# A question can sit before the block or after it (contract-007 G-6): check the closing stretch of both the text
# before the block and the whole message. The deferral is logged; the map steward reads how often it happens.
case "$(printf '%s' "$visible" | tail -c 400)$(printf '%s' "$last" | tail -c 400)" in
  *"?"*)
    telemetry stop-deferred question
    exit 0
    ;;
esac

ct=$(contracts_table)
bt=$(batches_table)
reason=""
gate() { if [ -z "$reason" ] && [ -n "$id" ]; then reason="$1"; fi; }
count_gate() { if [ "${1:-0}" -ge "$2" ] 2>/dev/null; then id="$1"; else id=""; fi; }
HOOKS='bash ".claude/skills/meta-mechanisms/hooks'

# 1. An open batch whose every item is decided: close it, or the blind never lifts.
id=""
for b in $(rows "$bt" '$2=="false"' | awk '{print $1}'); do
  if batch_fully_decided "$b"; then id="$b"; break; fi
done
gate "Every item in review batch $id carries a decision. Run $HOOKS/close-batch.sh\" $id with Bash to mark it decided — the ledger stays closed to you until you do (M-17, meta-skill-builder)."

# 2. A decided batch must be revealed before anything else touches the ledger.
id=$(first_id "$bt" '$2=="true" && $3=="false"')
gate "Review batch $id is decided but its key is unopened. Run $HOOKS/reveal-key.sh\" $id with Bash, then apply the decisions to items that were not re-presented, write the represented record, and set revealed: true on the batch (M-17, meta-skill-builder)."

# 3. A test changed after the verifier reported is drift, not a revision (contract-004 G-3, M-18).
id=$(late_test_revisions | head -n1)
gate "Contract $id carries a revision that changes Tier 4 tests, dated after its verification report. That is drift, not a revision (M-18): record it in DRIFTLOG.yaml, then withdraw the revision or draw the change as a follow-up contract with a follows: link. The verifier will not apply it."

# 4. Audit the session while its transcript is available.
id=$(first_id "$ct" '$2=="implemented" && $4=="false"')
if [ -n "$id" ]; then
  t=$(contract_field "$id" transcript)
  [ -n "$t" ] || t="(none recorded on the entry — say in the audit which session you read)"
  # A value with no slash in it is a session id (contract-015 G-2): say what it is and how the file is found.
  case "$t" in
    */*|"("*) gate "Contract $id is implemented and its session is unaudited. Launch the kit-session-auditor subagent with the contract id $id and transcript path: $t. Give it no account of how the work went (M-11)." ;;
    *) gate "Contract $id is implemented and its session is unaudited. Launch the kit-session-auditor subagent with the contract id $id and the session id $t - the transcript is the file named $t.jsonl under the Claude projects folder in the user's home, which the auditor finds by that name. Give it no account of how the work went (M-11)." ;;
  esac
fi

# 5. A verification that reported corrected or open clauses, with the contract still implemented.
id=$(first_id "$ct" '$2=="implemented" && $3=="reported"')
gate "Contract $id has a verification report but is still implemented. Read its verification block and put every corrected and open clause to the pioneer. Then close it one of three ways: set status: verified (all clauses verified, or the pioneer confirms per clause); draw the follow-up work as its own contract and set verification_state: closed-by-follow-up with a follows: link; or set verification_state: none once new evidence exists to re-verify (M-12)."

# 6. Verification evidence, from outside the builder.
id=$(first_id "$ct" '$2=="implemented" && $3=="none"')
gate "Contract $id is implemented with verification_state: none. If tests, observations or a pioneer confirmation exist, launch the kit-verifier subagent with only the contract id and where the evidence lives, not your account of the work. If none exists yet, set verification_state: awaiting-evidence on the entry and name the evidence needed (M-12)."

# 7. Observations waiting for consolidation.
count_gate "$(count_matches '^[[:space:]]+consolidated:[[:space:]]*false' "$LEDGER")" 1
gate "$id ledger observation(s) are unconsolidated. Launch the kit-consolidator subagent (M-14)."

# 8. Verified contracts waiting for a learning diff.
count_gate "$(nrows "$ct" '$2=="verified"')" 1
gate "$id contract(s) are verified and awaiting a learning diff. Run the meta-learning sweep now (M-13)."

# 9. Corrections waiting for the case clerk.
count_gate "$(count_matches '^[[:space:]]+clerked:[[:space:]]*false' "$CORRECTIONS")" 1
gate "$id pioneer correction(s) are not yet clerked. Launch the kit-case-clerk subagent (M-15)."

# 10. Pioneer-owned items are due and no batch is open — and no install or upgrade ended in this session (in_grace,
#     contract-011): the first batch after one waits for the next session start. The count is deliberately not named: knowing how
#    many real items are due would let the re-presented items be counted out.
if ! has_open_batch && ! in_grace; then
  due=$(count_matches '^[[:space:]]+review_due:[[:space:]]*true' "$LEDGER")
  pend=$(count_matches '^[[:space:]]+state:[[:space:]]*pending' "$LEDGER")
  cards=$(count_matches '^[[:space:]]+pioneer_ranking:[[:space:]]*pending' "$CASEBOOK")
  conflicts=$(count_matches '^[[:space:]]+conflict:[[:space:]]*P-' "$CASEBOOK")
  resolutions=$(count_matches '^[[:space:]]+status:[[:space:]]*mitigated' "$DRIFT")
  props=0
  # Unratified base entries wait for the install-time ratification pass; until it has run or been
  # declined, they do not open batches of their own (meta-bootstrap Step 7).
  if ! grep -q 'ratification: deferred' "$MAPFILE" 2>/dev/null; then
    props=$(count_matches '\|[[:space:]]*proposed[[:space:]]*$' "$MAPFILE")
  fi
  if [ "${due:-0}" -ge 3 ] || [ "${pend:-0}" -ge 1 ] || [ "${cards:-0}" -ge 1 ] \
     || [ "${conflicts:-0}" -ge 1 ] || [ "${resolutions:-0}" -ge 1 ] || [ "${props:-0}" -ge 1 ]; then
    id="due"
  else
    id=""
  fi
  gate "Pioneer-owned items are waiting: candidates, map proposals, unratified entries, unranked cards, precedent conflicts or drift resolutions. Launch the kit-batch-assembler subagent to assemble a batch, then present it per meta-skill-builder's review batch (M-16). Never read .claude/kit-sealed/, and while the batch is open your reads of the ledger are blocked so re-presented items stay indistinguishable."
fi

# 11. Map misses waiting for the steward.
count_gate "$(count_matches '^[[:space:]]+stewarded:[[:space:]]*false' "$LEDGER")" 3
gate "$id map misses are unstewarded. Launch the kit-map-steward subagent (M-21)."

# 12. Form check: a live contract with no bearing (gap-009).
id=$(first_id "$ct" '$5=="no" && ($3=="none" || $3=="awaiting-evidence" || $3=="reported")')
gate "Contract $id has no bearing. Tell the pioneer it was approved without one; do not draft one after the fact. Record bearing: 'none recorded at approval' on the entry so the gap stays visible (M-24)."

[ -z "$reason" ] && exit 0
telemetry stop-gate "$(printf '%s' "$reason" | cut -c1-72)"
printf '{"hookSpecificOutput":{"hookEventName":"Stop","additionalContext":"%s"}}\n' \
  "$(json_escape "Kit mechanism (stop-gate): $reason One kit task per turn. The pioneer does not need to invoke this.")"
