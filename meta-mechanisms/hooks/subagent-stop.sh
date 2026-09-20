#!/usr/bin/env bash
# SubagentStop — record that an agent ran and whether it wrote anything, so evaluation can see which agents
# fired and the gate can see an agent that exhausted its turns in silence (contract-021 UC-1).
# Governed by meta-mechanisms/SKILL.md. Never blocks.
. "$(dirname "$0")/lib.sh"
read_input
kit_installed || exit 0
t=$(json_str agent_type)
[ -n "$t" ] || t=$(json_str subagent_type)
[ -n "$t" ] || t=unnamed
# the same fingerprint agent-launch.sh took, so the gate can see whether anything was written (contract-021)
telemetry subagent "$t:$(record_fingerprint)"
exit 0
