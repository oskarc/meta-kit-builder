#!/usr/bin/env bash
# reveal-key.sh B-NNN — print a review batch's sealed key, but only once every item carries a decision.
# Run by the main agent with Bash when the stop-gate names M-17. Governed by meta-ledger/SKILL.md.
# The key maps each item to its source and marks the items that were re-presented, with the decision the
# pioneer gave them before (contract-006). It lives in .claude/kit-sealed/, which a Read deny rule hides
# from file tools. This script is the one sanctioned way to open it; reading it any other way before
# decisions exist is drift the auditor flags.
# A decision is any non-empty value — a word, or a ranking such as [B, A, C] for a scenario card.
. "$(dirname "$0")/lib.sh"
b="${1:-}"
if [ -z "$b" ]; then
  echo "usage: reveal-key.sh B-NNN" >&2
  exit 2
fi
batch="$KIT/meta-ledger/batches/$b.md"
key="$SEALED/$b.key"
[ -f "$batch" ] || { echo "No batch file at $batch" >&2; exit 1; }
[ -f "$key" ] || { echo "No sealed key for $b at $key" >&2; exit 1; }

items=$(count_matches '^#+[[:space:]]*I-[0-9]+' "$batch")
decided=$(count_matches '^\**Decision:\**[[:space:]]*[^[:space:]]' "$batch")
if [ "$items" -eq 0 ] || [ "$decided" -lt "$items" ]; then
  echo "Not revealing $b: $decided of $items items carry a decision." >&2
  exit 1
fi

telemetry reveal "$b"
echo "Sealed key for $b — item: source"
cat "$key"
echo
echo "Now: apply decisions to items that were not re-presented, clear their review_due, write the represented record (prior, now, consistent) on the batch, show the pioneer each earlier decision beside the new one without comment, and set revealed: true on the batch."
