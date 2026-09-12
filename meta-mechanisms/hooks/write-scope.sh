#!/usr/bin/env bash
# PreToolUse (Write|Edit), declared in an AGENT's frontmatter — the agent may write only to paths containing
# one of the fragments passed as arguments. Governed by meta-mechanisms/SKILL.md.
. "$(dirname "$0")/lib.sh"
read_input
p=$(norm_path "$(json_str file_path)")
[ -z "$p" ] && exit 0
for frag in "$@"; do
  if contains "$p" "$frag"; then
    exit 0
  fi
done
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' \
  "$(json_escape "Write scope: this agent may only write to paths containing: $*. Report the change you wanted instead of making it.")"
exit 0
