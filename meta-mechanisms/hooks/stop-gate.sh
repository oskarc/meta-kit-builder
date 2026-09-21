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
# than decoding them: cut everything from the LAST occurrence of the first of the closing four, which is the
# line the block opens with (contract-020) — an agent may quote that question in its prose, so the last one is
# the block — then look for a question mark in the closing stretch of what remains. A late "?" that was not a
# question costs one turn of delay; a missed question gets buried under a kit task, which is worse.
last=$(json_str last_assistant_message)
# `.*` is greedy, so the capture runs to the LAST occurrence; a message without the block passes through whole.
visible=$(printf '%s' "$last" | sed -e 's/\(.*\)What should you have based the framing.*/\1/')
# A question can sit before the block or after it (contract-007 G-6), so the whole message is scanned too — but
# the block now carries four question marks of its own, and without removing them every turn would read as a
# question and the lifecycle would never run again. The four are removed by their exact words, decoration and
# all, before the scan. The deferral is logged; the map steward reads how often it happens.
rest=$(printf '%s' "$last" | sed \
  -e 's/What should you have based the framing of the output on?//g' \
  -e 's/What did you base the framing of the output on?//g' \
  -e 's/Why did you choose to base the framing of the output on that?//g' \
  -e 's/How are you presenting this to the pioneer to make sure they can align on the basis of the output?//g')
case "$(printf '%s' "$visible" | tail -c 400)$(printf '%s' "$rest" | tail -c 400)" in
  *"?"*)
    telemetry stop-deferred question
    exit 0
    ;;
esac

ct=$(contracts_table)
bt=$(batches_table)
reason=""; owner=""; where=""; queued=0
# gate MESSAGE [OWNER] [COUNTED] [WHERE] — a task is handed over once; the rest are counted, so the pioneer sees
# the depth of the queue behind it without having to ask (contract-021 UC-5).
#   OWNER    whose move the task's NEXT step is: `agent` (default) or `pioneer`. Only a task waiting on the pioneer
#            is "waiting, not failing" when it repeats.
#   COUNTED  `no` for a task that must never appear in the count behind another: anything made of pioneer-owned
#            items, because knowing how many are really due would let the re-presented ones be counted out
#            (contract-011). These were one flag until contract-023, and the batch step — the agent's move, made of
#            pioneer-owned items — was tagged the pioneer's to keep it uncounted; a jammed assembler was then
#            reported as "waiting on you rather than stuck - nothing is wrong with it".
#   WHERE    where this task is written down as blocked, in words; empty when it has no blocked state. The fault
#            message tells the agent to write exactly that and never a key the task does not have (contract-023 G-2).
gate() {
  if [ -n "$id" ]; then
    if [ -z "$reason" ]; then reason="$1"; owner="${2:-agent}"; where="${4:-}"
    elif [ "${3:-yes}" != no ] && [ "${2:-agent}" != pioneer ]; then queued=$((queued+1)); fi
  fi
}
count_gate() { if [ "${1:-0}" -ge "$2" ] 2>/dev/null; then id="$1"; else id=""; fi; }
HOOKS='bash ".claude/skills/meta-mechanisms/hooks'

# 0. A task nobody can clear is not a backlog. Where a record says a gate task is blocked, the pioneer is asked
#    for guidance before anything else is routed — and the gate then routes past it, so one stuck task cannot take
#    the lifecycle offline (contract-019 UC-2, UC-3; the pioneer's ruling of 2026-09-20: "No check must block the
#    work being initiated, if something is not possible to resolve; ask the pioneer for guidance"). Once per
#    sitting, not once ever: an announcement the agent never made has to come back.
id=""
blk=$(blocked_all | head -n1)
if [ -n "$blk" ]; then
  bkind=${blk%%|*}; brest=${blk#*|}
  bid=${brest%%|*}; brest=${brest#*|}
  bkey=${brest%%|*}; brest=${brest#*|}
  bsince=${brest%%|*}; brest=${brest#*|}
  breason=${brest%%|*}; bwait=${brest#*|}
  [ -n "$bsince" ] || bsince="an unrecorded date"
  [ -n "$breason" ] || breason="none recorded on the entry"
  [ -n "$bwait" ] || bwait="not recorded on the entry"
  if ! announced_this_sitting "$bid:$bkey"; then
    id="$bid"
    telemetry blocked-announced "$bid:$bkey"
    # the batch step has no entry of its own, so it is named as what it is rather than by an id
    case "$bkey" in
      assembly) bwhat="A review batch cannot be assembled: the ledger has recorded that blocked" ;;
      *)        bwhat="$bkind $bid cannot be worked: its $bkey has been blocked" ;;
    esac
    gate "$bwhat since $bsince, and the pioneer has not been told in this sitting. Put it to them now, in their words, before other kit work: what is stuck — $breason — and what it is waiting for — $bwait. Then give them the choices and say which you suggest: clear it (you write $bkey back to false once what it waits for exists, and the task returns to the queue), leave it blocked while the rest of the lifecycle runs on, or something they name instead. The rest of the queue is routed as usual from here (M-32)."
  fi
fi

# 0a. An agent is running. Nothing else is dispatched until it finishes: four times downstream the gate handed
#     over a second agent while the first still held the ledger, and only a person watching stopped the
#     collision (contract-021 UC-3). The hold expires like a lease - an agent that dies without reporting
#     cannot keep the queue forever - and when it does, the gate says so rather than pretending it finished.
flight=$(agent_flight)
if [ -z "$reason" ]; then
  case "$flight" in
    running) exit 0 ;;
    lapsed)
      telemetry agent-lease-lapsed "$(agent_last_type)"
      printf '{"hookSpecificOutput":{"hookEventName":"Stop","additionalContext":"%s"}}\n' \
        "$(json_escape "Kit mechanism (stop-gate): the $(agent_last_type) agent was launched and never reported finishing, and the queue has been held for it long enough. It is released now. If it produced anything, record that before the next task; if it did not, say so to the pioneer. The queue continues from the next turn.")"
      exit 0
      ;;
  esac
fi

# 0b. The last agent stopped and wrote nothing, which is what exhausting its turns looks like: no report, no
#     partial result, silence with the work done and lost. Downstream that happened eight times in two days to
#     four different agents, and a person restarted every one by hand (contract-021 UC-1). It is resumed once;
#     a second silence is recorded blocked and the queue moves on (P-004: the recovery is never the pioneer's).
if [ -z "$reason" ] && [ "$flight" = nothing ]; then
  at=$(agent_last_type)
  if agent_resumed; then
    id="$at"
    aw=$(agent_block_where "$at")
    if [ -n "$aw" ]; then
      gate "the $at agent has now run twice and written nothing both times, which is what it looks like when an agent runs out of turns with the work done and unsaved. Stop relaunching it. Record the task it was doing as blocked - $aw - with blocked_reason, blocked_waiting_for and blocked_since beside it (M-32), and put it to the pioneer with what you suggest. The rest of the queue runs on from the next turn."
    else
      gate "the $at agent has now run twice and written nothing both times, which is what it looks like when an agent runs out of turns with the work done and unsaved. Stop relaunching it. Its task has no blocked state of its own, so there is nothing to write: tell the pioneer what it was asked to do, that it came back empty twice, and what you suggest, and ask how to proceed (M-32). The rest of the queue runs on from the next turn."
    fi
  else
    telemetry agent-resume "$at"
    id="$at"
    gate "the $at agent stopped without writing anything to the records it is allowed to write. That is what running out of turns looks like from outside: the work is done and unsaved, not undone. Resume that same agent - do not start it over - and tell it to write what it already has before doing anything else. If it comes back empty a second time the task is recorded blocked instead."
  fi
fi

# 1. An open batch whose every item is decided: close it, or the blind never lifts.
id=""
for b in $(rows "$bt" '$2=="false"' | awk '{print $1}'); do
  if batch_fully_decided "$b"; then id="$b"; break; fi
done
gate "Every item in review batch $id carries a decision. Run $HOOKS/close-batch.sh\" $id with Bash to mark it decided — the ledger stays closed to you until you do (M-17, meta-skill-builder)."

# 2. A decided batch must be revealed before anything else touches the ledger.
id=$(first_id "$bt" '$2=="true" && $3=="false"')
gate "Review batch $id is decided but its key is unopened. Run $HOOKS/reveal-key.sh\" $id with Bash, then apply the decisions to items that were not re-presented, write the represented record, and set revealed: true on the batch (M-17, meta-skill-builder)." agent yes "revealed: blocked on that batch in LEDGER.yaml"

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
    */*|"("*) gate "Contract $id is implemented and its session is unaudited. First build the digest the auditor reads: run bash \".claude/skills/meta-mechanisms/checks/transcript-digest.sh\" $t with Bash — it prints the path it wrote. Then launch the kit-session-auditor subagent with the contract id $id, transcript path: $t, and that digest path. Give it no account of how the work went (M-11)." agent yes "audited: blocked on that contract entry in CONTRACT-LOG.yaml" ;;
    *) gate "Contract $id is implemented and its session is unaudited. First build the digest the auditor reads: run bash \".claude/skills/meta-mechanisms/checks/transcript-digest.sh\" $t with Bash — it finds the transcript by that session id and prints the path it wrote. Then launch the kit-session-auditor subagent with the contract id $id, the session id $t and that digest path. Give it no account of how the work went (M-11)." agent yes "audited: blocked on that contract entry in CONTRACT-LOG.yaml" ;;
  esac
fi

# 5. A verification that reported corrected or open clauses, with the contract still implemented.
id=$(first_id "$ct" '$2=="implemented" && $3=="reported"')
gate "Contract $id has a verification report but is still implemented. Read its verification block and put every corrected and open clause to the pioneer. Then close it one of three ways: set status: verified (all clauses verified, or the pioneer confirms per clause); draw the follow-up work as its own contract and set verification_state: closed-by-follow-up with a follows: link; or set verification_state: none once new evidence exists to re-verify (M-12)." pioneer

# 6. Verification evidence, from outside the builder.
id=$(first_id "$ct" '$2=="implemented" && $3=="none"')
gate "Contract $id is implemented with verification_state: none. If tests, observations or a pioneer confirmation exist, launch the kit-verifier subagent with only the contract id and where the evidence lives, not your account of the work. If none exists yet, set verification_state: awaiting-evidence on the entry and name the evidence needed (M-12)."

# 7. Observations waiting for consolidation.
count_gate "$(count_matches '^[[:space:]]+consolidated:[[:space:]]*false' "$LEDGER")" 1
gate "$id ledger observation(s) are unconsolidated. Launch the kit-consolidator subagent (M-14)." agent yes "consolidated: blocked on each observation that cannot be taken, in LEDGER.yaml"

# 8. Verified contracts waiting for a learning diff.
count_gate "$(nrows "$ct" '$2=="verified"')" 1
gate "$id contract(s) are verified and awaiting a learning diff. Run the meta-learning sweep now (M-13)."

# 9. Corrections waiting for the case clerk.
count_gate "$(count_matches '^[[:space:]]+clerked:[[:space:]]*false' "$CORRECTIONS")" 1
gate "$id pioneer correction(s) are not yet clerked. Launch the kit-case-clerk subagent (M-15)." agent yes "clerked: blocked on each correction that cannot be taken, in CORRECTIONS.yaml"

# 10. Pioneer-owned items are due and no batch is open — and no install or upgrade ended in this session (in_grace,
#     contract-011): the first batch after one waits for the next session start. The count is deliberately not named: knowing how
#    many real items are due would let the re-presented items be counted out.
#     Whether items are due is one rule, in lib.sh, which session-start and the waiting list call too (contract-023 UC-9).
#     The NEXT MOVE here is the agent's — launch the assembler — so a jam is a fault like any other, and it has a
#     place to be written down: `assembly: blocked` in the ledger, which also holds this step until it is cleared.
#     It stays out of the count behind another task, because what it is made of is the pioneer's (contract-023 UC-2).
if ! has_open_batch && ! in_grace && ! assembly_is_blocked; then
  if pioneer_items_due "$LEDGER" "$CASEBOOK" "$DRIFT" "$MAPFILE"; then id="due"; else id=""; fi
  gate "Pioneer-owned items are waiting: candidates, map proposals, unratified entries, unranked cards, precedent conflicts or drift resolutions. Launch the kit-batch-assembler subagent to assemble a batch, then present it per meta-skill-builder's review batch (M-16). Never read .claude/kit-sealed/, and while the batch is open your reads of the ledger are blocked so re-presented items stay indistinguishable." agent no "assembly: blocked at the top level of LEDGER.yaml, beside observations: and candidates:"
fi

# 11. Map misses waiting for the steward.
count_gate "$(count_matches '^[[:space:]]+stewarded:[[:space:]]*false' "$LEDGER")" 3
gate "$id map misses are unstewarded. Launch the kit-map-steward subagent (M-21)." agent yes "stewarded: blocked on each map miss that cannot be taken, in LEDGER.yaml"

# 12. Form check: a live contract with no bearing (gap-009).
id=$(first_id "$ct" '$5=="no" && ($3=="none" || $3=="awaiting-evidence" || $3=="reported")')
gate "Contract $id has no bearing. Tell the pioneer it was approved without one; do not draft one after the fact. Record bearing: 'none recorded at approval' on the entry so the gap stays visible (M-24)."

[ -z "$reason" ] && exit 0

# The same task handed over three turns running with nothing changing in between is a fault, not a backlog: the gate
# stops repeating itself and says so (contract-019 UC-5, in the pioneer's words at the gate — "3 times means surface
# it to the pioneer for steering and suggest an action at this point"). The count is the trailing run of identical
# hand-overs in telemetry, which the gate already writes; any other gate event breaks the run.
det=$(printf '%s' "$reason" | cut -c1-72)
# Waiting is not failing. A task whose next move is the pioneer's repeats because they have not answered yet,
# and calling that a fault told an agent downstream to record a working mechanism as broken (contract-021 UC-4).
if [ "$owner" = pioneer ] && [ "$(repeated_handovers "$det")" -ge 2 ]; then
  reason="$reason This is the third turn with this same task, and it is waiting on you rather than stuck - nothing is wrong with it. Nothing else is dispatched until it is answered."
elif [ "$(repeated_handovers "$det")" -ge 2 ]; then
  telemetry stop-gate-fault "$det"
  # The action suggested is one the agent can take: where this task's block is written, or — for a task with no
  # blocked state — that there is nothing to write and the pioneer is asked (contract-023 G-2).
  if [ -n "$where" ]; then
    suggest="Suggest an action — usually to record it blocked: $where, with blocked_reason, blocked_waiting_for and blocked_since beside it, so the rest of the lifecycle runs on and what is stuck stays visible (M-32) — and ask whether to do that or something they name instead."
  else
    suggest="This task has no blocked state of its own, so there is nothing to write down: say plainly what stops it, suggest what you would do, and ask the pioneer how to proceed (M-32)."
  fi
  reason="this is the third turn running with the same kit task and nothing has changed - $det - which is a fault, not a backlog — the task cannot be cleared the way it is being tried. Stop trying it. Surface it to the pioneer for steering: name the task, what you have tried, and why it does not complete. $suggest"
  telemetry stop-gate "$(printf '%s' "$reason" | cut -c1-72)"
else
  telemetry stop-gate "$det"
fi
behind=""
[ "$queued" -gt 0 ] && behind=" $queued other kit task(s) are due behind this one."
printf '{"hookSpecificOutput":{"hookEventName":"Stop","additionalContext":"%s"}}\n' \
  "$(json_escape "Kit mechanism (stop-gate): $reason One kit task per turn.$behind The pioneer does not need to invoke this.")"
