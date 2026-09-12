#!/usr/bin/env bash
# PreToolUse, declared in an AGENT's frontmatter — the agent is blind to every path fragment passed as an
# argument. Checks file_path, path, pattern, glob and command. Governed by meta-mechanisms/SKILL.md.
# Limits, stated plainly: a Grep over a parent directory can still reach a denied file, a Bash command can
# reach it by a spelling this check does not see, and an agent's own transcript records what it read.
# Blindness is enforced for the ordinary path and audited (kit-session-auditor) for the rest; it is not a
# security boundary.
. "$(dirname "$0")/lib.sh"
read_input
fields=$(norm_path "$(json_str file_path) $(json_str path) $(json_str pattern) $(json_str glob) $(json_str command)")
for frag in "$@"; do
  if contains "$fields" "$frag"; then
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' \
      "$(json_escape "Blind by design: this agent may not read '$frag' (meta-mechanisms, agent scope). Work from what you were given, and say what you could not check.")"
    exit 0
  fi
done
exit 0
