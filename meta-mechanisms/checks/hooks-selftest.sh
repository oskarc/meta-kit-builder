#!/usr/bin/env bash
# hooks-selftest.sh — run every installed hook once, against a throwaway copy of this project's .claude/, so that
# the test writes nothing into the project's own records (contract-017 UC-6). Run from the project's root at the end
# of an install (Step 7) or an upgrade (step 9). Before this script the same commands were run against the live
# project: they appended to its telemetry and left a session mark newer than the baseline, which switched off the
# hold on the first review batch.
# Prints one line per hook — its exit code and whether it printed JSON, text or nothing — then the tail of the
# copy's telemetry, then a verdict. Exit 0 when every hook behaved: exit code 0 and JSON-or-nothing, except
# close-batch.sh, reveal-key.sh and seal-key.sh, whose right answer with no batch is a refusal and exit 1, and
# mark-done.sh, whose right answer with no argument is its usage line and exit 2.
# EVERY script under hooks/ but the library is run here. The one that records an agent starting was added to the
# kit without being added to this list, and nothing noticed; walk-007 now holds the list to the folder
# (contract-023 UC-14).
ROOT="$PWD"; [ -d "$ROOT/.claude/skills/meta-mechanisms/hooks" ] || { echo "hooks-selftest: run from the project's root (no .claude/skills/meta-mechanisms/hooks here)"; exit 2; }
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
mkdir -p "$T/.claude"; cp -R "$ROOT/.claude/skills" "$T/.claude/skills"; rm -f "$T/.claude/skills/meta-ledger/telemetry.log" "$T/.claude/skills/meta-ledger/.session-started"
H="$T/.claude/skills/meta-mechanisms/hooks"; bad=0
run() { # NAME EXPECTED_EXIT INPUT ARGS...
  local name="$1" want="$2" input="$3"; shift 3; local out rc kind
  out=$(cd "$T" && printf '%s' "$input" | CLAUDE_PROJECT_DIR="$T" bash "$H/$name" "$@" 2>&1); rc=$?
  case "$out" in "") kind="nothing" ;; "{"*) kind="JSON" ;; *) kind="text: $(printf '%s' "$out" | head -n1 | cut -c1-60)" ;; esac
  ok=yes; [ "$rc" = "$want" ] || ok=NO
  if [ "$want" = 0 ]; then case "$kind" in nothing|JSON) ;; *) ok=NO ;; esac; fi
  [ "$ok" = yes ] || bad=1
  printf '%-18s exit %s (expected %s)  printed %s  %s\n' "$name" "$rc" "$want" "$kind" "$([ "$ok" = yes ] && echo ok || echo WRONG)"
  # what the two hooks that speak to the agent actually said, so the run can read the backlog and the gate's task
  case "$name" in session-start.sh|stop-gate.sh)
    [ "$kind" = JSON ] && printf '%s' "$out" | sed -e 's/.*additionalContext":"//' -e 's/"}}[[:space:]]*$//' | awk '{ n = split($0, a, /\\n/); for (i = 1; i <= n; i++) if (a[i] != "") print "    says: " substr(a[i], 1, 300) }' ;;
  esac
}
c="\"cwd\":\"$T\""
run session-start.sh 0 "{$c,\"source\":\"selftest\"}"
run prompt-submit.sh 0 "{$c,\"prompt\":\"add a feature\"}"
run stop-gate.sh     0 "{$c,\"stop_hook_active\":false,\"last_assistant_message\":\"Done.\"}"
run agent-launch.sh  0 "{$c,\"tool_name\":\"Agent\",\"tool_input\":{\"subagent_type\":\"kit-verifier\"}}"
run subagent-stop.sh 0 "{$c,\"agent_type\":\"kit-verifier\"}"
run post-read.sh     0 "{$c,\"tool_name\":\"Read\",\"tool_input\":{\"file_path\":\"$T/.claude/skills/meta-map/MAP.md\"}}"
run owner-check.sh   0 "{$c,\"tool_name\":\"Edit\",\"tool_input\":{\"file_path\":\"$T/.claude/skills/meta-casebook/CASEBOOK.yaml\"}}"
run batch-blind.sh   0 "{$c,\"tool_name\":\"Read\",\"tool_input\":{\"file_path\":\"$T/.claude/skills/meta-ledger/LEDGER.yaml\"}}"
run deny-paths.sh    0 "{$c,\"tool_input\":{\"file_path\":\"src/x.cs\"}}" "kit-sealed/"
run write-scope.sh   0 "{$c,\"tool_input\":{\"file_path\":\"src/x.cs\"}}" "meta-ledger/LEDGER.yaml"
run close-batch.sh   1 "" B-000
run reveal-key.sh    1 "" B-000
run seal-key.sh      1 "" B-000
run mark-done.sh     2 ""
echo "telemetry written in the copy (the project's own is untouched):"
tail -n 4 "$T/.claude/skills/meta-ledger/telemetry.log" 2>/dev/null | sed 's/^/  /' || echo "  (none)"
grep -q '|loaded|meta-map/MAP.md' "$T/.claude/skills/meta-ledger/telemetry.log" 2>/dev/null || { echo "WRONG: no loaded line — telemetry is not recording reads"; bad=1; }
[ "$bad" = 0 ] && echo "hooks-selftest: every hook behaved." || echo "hooks-selftest: at least one hook did not behave — see WRONG above."
exit "$bad"
