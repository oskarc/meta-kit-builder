#!/usr/bin/env bash
# close-batch.sh B-NNN — mark a review batch decided, once every item in its file carries a decision.
# Run by the main agent with Bash when the last item has been decided (M-16). Governed by meta-ledger/SKILL.md.
# Exists because the ledger is unreadable to the presenting session while the batch is open (batch-blind.sh):
# this sets the one flag without the session reading the file.
# A decision is any non-empty value — a word, or a ranking such as [B, A, C] for a scenario card.
. "$(dirname "$0")/lib.sh"
b="${1:-}"
if [ -z "$b" ]; then
  echo "usage: close-batch.sh B-NNN" >&2
  exit 2
fi
batch="$KIT/meta-ledger/batches/$b.md"
[ -f "$batch" ] || { echo "No batch file at $batch" >&2; exit 1; }
[ -f "$LEDGER" ] || { echo "No ledger at $LEDGER" >&2; exit 1; }

items=$(count_matches '^#+[[:space:]]*I-[0-9]+' "$batch")
decided=$(count_matches '^\**Decision:\**[[:space:]]*[^[:space:]]' "$batch")
if [ "$items" -eq 0 ] || [ "$decided" -lt "$items" ]; then
  echo "Not closing $b: $decided of $items items carry a decision." >&2
  exit 1
fi

tmp="$LEDGER.tmp.$$"
awk -v want="$b" '
  /^[[:space:]]*-[[:space:]]+batch_id:[[:space:]]*[^[:space:]]/ { cur=$3; sub(/[[:space:]]*#.*$/, "", cur) }
  cur == want && /^[[:space:]]+decided:[[:space:]]*false/ { sub(/false/, "true"); done=1 }
  { print }
  END { if (!done) exit 3 }
' "$LEDGER" > "$tmp" || { rm -f "$tmp"; echo "Batch $b not found in the ledger, or already decided." >&2; exit 1; }
mv "$tmp" "$LEDGER"
telemetry batch-decided "$b"
echo "Batch $b marked decided ($items items). The stop-gate will hand over the reveal next."
