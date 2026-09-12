#!/usr/bin/env bash
# SubagentStop — record that an agent ran, so evaluation can see which agents actually fired.
# Governed by meta-mechanisms/SKILL.md. Never blocks.
. "$(dirname "$0")/lib.sh"
read_input
kit_installed || exit 0
telemetry subagent "$(json_str agent_type)"
exit 0
