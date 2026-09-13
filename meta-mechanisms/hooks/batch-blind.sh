#!/usr/bin/env bash
# PreToolUse (Read|Grep|Glob) — two blinds on the main session. Governed by meta-ledger/SKILL.md → Review
# batches and meta-mechanisms/SKILL.md → The blind and the seal.
#
# 1. TELEMETRY, ALWAYS (contract-005 G-1). meta-ledger/telemetry.log holds the ownership count — one line per
#    record edited without its governing skill loaded. A count the acting session can read becomes a ceremony:
#    the agent loads skills to keep the count down instead of because the moment called for them. The file is
#    read by kit-map-steward and kit-consolidator, never by the session being measured.
# 2. THE LEDGER, WHILE A BATCH IS OPEN. Real batch items are copied from the ledger. A presenter that can
#    read it can tell which items were re-presented by comparing, and the re-presentation stops measuring anything.
#
# Scope, and why it is exactly this wide:
#   * telemetry.log by any path spelling; any Grep or Glob whose search path covers meta-ledger/; and any
#     Grep whose pattern names the count (`bypass`) — always;
#   * LEDGER.yaml by any path spelling, and any Grep or Glob whose search path or glob covers a directory
#     holding it (the leak a file-only check leaves open) — while a batch is open;
#   * NOT the casebook: scenario cards and precedents are never re-presented, so closing it would only break
#     the precedent check (M-04, M-05) for contracts drawn while a batch waits;
#   * NOT kit agents (agent_id present) — they are not the presenter, and the steward is telemetry's reader;
#   * NOT the batch file or the ledger's SKILL.md.
# Limits, stated plainly: Bash reads are not seen here; a Grep over a directory above meta-ledger/ with a
# pattern that does not name the count still reaches telemetry when no batch is open; and the pioneer can
# open either file themselves.
. "$(dirname "$0")/lib.sh"
read_input
kit_installed || exit 0
in_subagent && exit 0

tool=$(json_str tool_name)
fp=$(norm_path "$(json_str file_path)")
searchpath=$(norm_path "$(json_str path) $(json_str glob)")
pattern=$(json_str pattern)

deny() { # EVENT-DETAIL REASON
  telemetry batch-blind "$1"
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' \
    "$(json_escape "$2")"
  exit 0
}

# --- telemetry: closed to the acting session at all times -------------------------------------------------
TELE_REASON="Telemetry is evidence, not context: meta-ledger/telemetry.log is read by the map steward and the consolidator, never by the session it measures (meta-mechanisms → Telemetry). Nothing in it is needed for the work."
contains "$fp" "meta-ledger/telemetry.log" && deny "telemetry:file" "$TELE_REASON"
case "$tool" in
  Grep|Glob)
    if contains "$searchpath" "meta-ledger" && ! contains "$searchpath" "meta-ledger/batches"; then
      deny "telemetry:search" "$TELE_REASON Search the batch file under meta-ledger/batches/, or the nodes themselves."
    fi
    ;;
esac
[ "$tool" = "Grep" ] && contains "$pattern" "bypass" && deny "telemetry:pattern" "$TELE_REASON"

# --- the ledger: closed while a batch is open ---------------------------------------------------------------
has_open_batch || exit 0
LEDGER_REASON="A review batch is open, so the ledger is closed to this session until the reveal — that is what keeps re-presented items indistinguishable (meta-ledger, Review batches)."
CLOSE="When every item carries a decision, run: bash \".claude/skills/meta-mechanisms/hooks/close-batch.sh\" B-NNN"

contains "$fp" "meta-ledger/LEDGER.yaml" && deny "file" "$LEDGER_REASON The batch file, meta-ledger/SKILL.md and the casebook stay readable. $CLOSE"

case "$tool" in
  Grep|Glob)
    wide=$(norm_path "$searchpath $pattern")
    for frag in "meta-ledger/LEDGER.yaml" "meta-ledger" ".claude/skills" ".claude"; do
      if contains "$wide" "$frag"; then
        case "$wide" in
          *meta-ledger/batches*) : ;;
          *) deny "search:$frag" "$LEDGER_REASON Narrow the search: the batch file under meta-ledger/batches/ and the nodes themselves are readable. $CLOSE" ;;
        esac
      fi
    done
    ;;
esac
exit 0
