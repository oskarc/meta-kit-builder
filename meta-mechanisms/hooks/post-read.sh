#!/usr/bin/env bash
# PostToolUse (matcher: Read|Skill) — record which kit knowledge was actually loaded. This is the map's
# firing telemetry: an entry whose target never appears here is either unneeded or silently broken.
# Governed by meta-mechanisms/SKILL.md and meta-map/SKILL.md. Never blocks.
#
# Reads made by kit agents are logged as `loaded-agent`, separately from the main session's `loaded`:
# an agent reading a node is not evidence that a map entry fired.
. "$(dirname "$0")/lib.sh"
read_input
kit_installed || exit 0

ev=loaded
in_subagent && ev=loaded-agent

p=$(norm_path "$(json_str file_path)")
[ -n "$p" ] && ! under_root "$p" && exit 0   # another kit's file is not this kit's evidence (contract-010 G-5)
case "$p" in
  */.claude/skills/*) telemetry "$ev" "${p##*/.claude/skills/}"; exit 0 ;;
  */.claude/agents/*) telemetry "$ev" "agents/${p##*/.claude/agents/}"; exit 0 ;;
esac

# Skill tool: a node reached by description rather than by path.
s=$(json_str skill)
[ -n "$s" ] || s=$(json_str name)
[ -n "$s" ] && telemetry "$ev" "skill:$s"
exit 0
