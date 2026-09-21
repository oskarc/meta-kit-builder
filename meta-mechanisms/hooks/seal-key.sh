#!/usr/bin/env bash
# seal-key.sh B-NNN  (the key's lines on standard input, one per item) — write a review batch's sealed key.
# Run by kit-batch-assembler with Bash, after it has written the batch file. Governed by meta-ledger/SKILL.md.
# The mirror of reveal-key.sh: that script is the one sanctioned opening, this is the one sanctioned sealing.
#
# Why the key is written by a script and not with the file tools (contract-023 UC-1). The assembler was told to
# write `.claude/kit-sealed/B-NNN.key`, and its own write scope allowed it — and for four releases no project
# ever got a review batch, because the program the kit runs inside refuses the file tools in that folder. Seen
# first-hand on two versions, for two different reasons: on one, the project's read rule on the sealed folder
# also stops a write there; on the other, the folder counts as a sensitive location and the write waits on a
# human's grant that an agent has nobody to ask for. Neither rule governs a shell. So the same agent seals the
# key here, as the session already opens it through reveal-key.sh — never a command the pioneer runs (P-004).
#
# What it holds to, so a bad key is caught at sealing rather than at the reveal:
#   * the batch file exists, and the key names exactly its items — every `I-n` heading once, and no other;
#   * a key is never overwritten, and this script never prints one — not the one it writes, not one that is there;
#   * each line is `I-n: <source>` as kit-batch-assembler's step 6 gives it.
# Every refusal says what to do next and is registered in checks/refusal-nextsteps.txt (G6-refusals).
. "$(dirname "$0")/lib.sh"
b="${1:-}"
if [ -z "$b" ]; then
  echo "usage: seal-key.sh B-NNN   (the key's lines on standard input)" >&2
  exit 2
fi
if ! printf '%s' "$b" | grep -qE '^B-[0-9]+$'; then
  echo "seal-key refused: $b is not a batch id of the form B-NNN — pass the id of the batch file just written" >&2
  exit 2
fi
batch="$KIT/meta-ledger/batches/$b.md"
key="$SEALED/$b.key"
[ -f "$batch" ] || { echo "seal-key refused: there is no batch file at $batch — write the batch file first, then seal its key" >&2; exit 1; }
[ -e "$key" ] && { echo "seal-key refused: $b already has a sealed key, and a key is never overwritten or opened — if this batch id was taken by an earlier run, assemble under the next id and say so in the final message" >&2; exit 1; }

tmp="$(mktemp)"; trap 'rm -f "$tmp"' EXIT
tr -d '\r' > "$tmp"
# every non-empty line is `I-n: source`
n=0
while IFS= read -r line || [ -n "$line" ]; do
  n=$((n+1))
  case "$line" in '') continue ;; esac
  if ! printf '%s' "$line" | grep -qE '^I-[0-9]+:[[:space:]]+[^[:space:]]'; then
    echo "seal-key refused: line $n of the key is not an item id, a colon and a source (I-n: source) — send one line per item, exactly as the assembling procedure gives them" >&2
    exit 1
  fi
done < "$tmp"

want="$(tr -d '\r' < "$batch" | grep -oE '^#+[[:space:]]*I-[0-9]+' | grep -oE 'I-[0-9]+' | sort -u)"
have="$(grep -oE '^I-[0-9]+' "$tmp" | sort)"
kn=$(printf '%s\n' "$have" | grep -c .); bn=$(printf '%s\n' "$want" | grep -c .)
if [ -z "$have" ] || [ "$want" != "$have" ]; then
  echo "seal-key refused: the key names $kn item line(s) and the batch file carries $bn item(s) — every item in the batch needs exactly one line, and no line may name an item the batch does not have" >&2
  exit 1
fi

mkdir -p "$SEALED" 2>/dev/null
if ! grep -v '^$' "$tmp" > "$key.part" 2>/dev/null || ! mv "$key.part" "$key" 2>/dev/null; then
  rm -f "$key.part" 2>/dev/null
  echo "seal-key refused: the sealed folder could not be written at $SEALED — stop and say so in the final message; the session records the batch step blocked and puts it to the pioneer (meta-mechanisms → Blocked tasks)" >&2
  exit 1
fi
echo "Sealed $b: $kn item(s). The key is not shown, and is opened only by reveal-key.sh once every item carries a decision."
