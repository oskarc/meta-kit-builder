#!/usr/bin/env bash
# PreToolUse on the tool that launches a kit agent — records that one is STARTING, which nothing did before
# (contract-021 UC-1, UC-3). Governed by meta-mechanisms/SKILL.md. Never blocks.
#
# The kit recorded that an agent stopped and nothing at all about one starting, so three failures were invisible:
# an agent that exhausted its turns and wrote nothing looked identical to one that had never run; two agents
# could be dispatched at the same record with nothing to notice the first was still holding it; and a task being
# worked on right now looked exactly like a task nobody had touched in three turns.
#
# What it writes: agent-launch | <type>:<fingerprint>, where the fingerprint is the length of every record a kit
# agent may write. subagent-stop.sh writes the same shape when the run ends. Equal fingerprints mean nothing was
# written — the silence that took eight hand recoveries in two days downstream.
. "$(dirname "$0")/lib.sh"
read_input
kit_installed || exit 0
t=$(json_str subagent_type)
[ -n "$t" ] || t=$(json_str agent_type)
[ -n "$t" ] || t=unnamed
telemetry agent-launch "$t:$(record_fingerprint)"
exit 0
