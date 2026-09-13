#!/usr/bin/env bash
# P-005 — from C-005 (M-05, contract-003).
# Holding: "why not pass it to an agent that is allowed to write there?" — a session blind to LEDGER.yaml records
#          observations through an agent that may write there (kit-recorder), not through a helper script that
#          appends without reading.
# Shape checked: agents/kit-recorder.md exists and its write scope names meta-ledger/LEDGER.yaml; no
#          append-observation helper ships under meta-mechanisms/hooks/.
# Exit 0 when the standard holds; non-zero with one line naming what broke.

set -u

here="$(cd "$(dirname "$0")" && pwd)"
kit="$(cd "$here/../.." && pwd)"                 # .claude/skills in a project; the repo root in the base kit
if [ -d "$kit/agents" ]; then agents="$kit/agents"; else agents="$kit/../agents"; fi

recorder="$agents/kit-recorder.md"
if [ ! -f "$recorder" ]; then
  echo "P-005 broken: ${recorder} is missing — observations recorded while a batch is open go through an agent allowed to write to the ledger"
  exit 1
fi

if ! grep -q 'meta-ledger/LEDGER.yaml' "$recorder"; then
  echo "P-005 broken: kit-recorder.md does not name meta-ledger/LEDGER.yaml in its write scope — the recorder is the agent allowed to write there"
  exit 1
fi

helper="$(find "$kit/meta-mechanisms/hooks" -maxdepth 1 -type f -name 'append-observation*' 2>/dev/null | head -n 1)"
if [ -n "$helper" ]; then
  echo "P-005 broken: ${helper#$kit/} ships — the write goes to an agent allowed to write there, not to an append helper"
  exit 1
fi

exit 0
