#!/usr/bin/env bash
# G7-batch — contract-024 G-6. Holds a review batch file to what one sitting may put to the pioneer.
#
# The pioneer's words on the first review batch a project ever held, twenty items long (2026-09-23): "The kit
# should present to a pioneer in a way that assumes no prior knowledge of the practice, it should tell the
# pioneer why it is seeing something, and it should tell it concise, it cannot be 2000 words and ask 12-15
# things. that is information overload."
#
# So a batch file is held to four things, none of them judgement:
#   - at most 6 items (## I-n headings) and at most 1,200 words in the whole file
#   - a preamble before the first item, headed "How to read these items", of at most 5 sentences
#   - every item carries the three lines the reader needs: **Kind:**, **Why you are seeing this:**, **What is asked:**
#   - "Verdict before evidence:" and "Against:" appear only under items whose kind is a candidate
#
# Usage: G7-batch.sh <batch file>     exit 0 when the file holds; exit 1 with one line per breach, each saying
#                                     what to do — the assembler runs it before sealing, and the walk runs it on
#                                     fixtures. Portable: bash, sed, awk, grep, tr. No jq.
f="${1:-}"
[ -n "$f" ] && [ -f "$f" ] || { echo "G7-batch refused: no batch file at \"$f\" — pass the path of the batch file to hold"; exit 1; }

MAX_ITEMS=6; MAX_WORDS=1200; MAX_PREAMBLE=5
bad=0
say() { bad=$((bad+1)); echo "$1"; }

items=$(grep -c '^## I-[0-9]' "$f")
[ "$items" -le "$MAX_ITEMS" ] || say "G7-batch refused: $items items in ${f##*/} — one sitting carries at most $MAX_ITEMS; leave the rest for the next batch, oldest first"
[ "$items" -ge 1 ] || say "G7-batch refused: no items in ${f##*/} — a batch file holds at least one ## I-n item"

words=$(tr -d '\r' < "$f" | wc -w | tr -d ' ')
[ "$words" -le "$MAX_WORDS" ] || say "G7-batch refused: $words words in ${f##*/} — a batch stays under $MAX_WORDS; shorten the items or carry fewer"

# the preamble: from the header line to the first item
pre="$(awk '/^## I-[0-9]/{exit} {print}' "$f" | tr -d '\r')"
printf '%s\n' "$pre" | grep -q -i 'How to read these items' \
  || say "G7-batch refused: ${f##*/} has no \"How to read these items\" preamble — write one before the first item, for a reader who has never seen a batch"
sentences=$(printf '%s\n' "$pre" | grep -v '^# ' | sed 's/[Hh]ow to read these items\.\{0,1\}//' | tr '\n' ' ' | grep -o -E '[.!?]([[:space:]]|$)' | wc -l | tr -d ' ')
[ "$sentences" -le "$MAX_PREAMBLE" ] || say "G7-batch refused: the preamble of ${f##*/} runs to $sentences sentences — at most $MAX_PREAMBLE: what a batch is, what a card and a candidate are, that each item says why it is here and what is asked"

# per item: the three lines, and the two opening questions only on candidates
awk -v file="${f##*/}" '
  function check() {
    if (id == "") return
    if (!kind) printf "G7-batch refused: item %s in %s has no **Kind:** line — open every item with its kind and a one-clause gloss\n", id, file
    if (!why)  printf "G7-batch refused: item %s in %s has no **Why you are seeing this:** line — say what became true that put it in front of the reader\n", id, file
    if (!ask)  printf "G7-batch refused: item %s in %s has no **What is asked:** line — list every decision the kind allows, each with what it does\n", id, file
    if (!cand && (verdict || against)) printf "G7-batch refused: item %s in %s asks for a read or a reason against, and it is not a candidate — those two lines belong to candidates only\n", id, file
    if (cand && !(verdict && against)) printf "G7-batch refused: item %s in %s is a candidate without Verdict before evidence: and Against: — a candidate carries both\n", id, file
  }
  /^## I-[0-9]/ { check(); id=$2; kind=0; why=0; ask=0; cand=0; verdict=0; against=0; next }
  /^\*\*Kind:\*\*/ { kind=1; if (tolower($0) ~ /candidate/) cand=1 }
  /^\*\*Why you are seeing this:\*\*/ { why=1 }
  /^\*\*What is asked:\*\*/ { ask=1 }
  /^Verdict before evidence:/ { verdict=1 }
  /^Against:/ { against=1 }
  END { check() }
' "$f" | while IFS= read -r line; do echo "$line"; done > "${TMPDIR:-${TMP:-${TEMP:-/tmp}}}/g7-items.$$"
if [ -s "${TMPDIR:-${TMP:-${TEMP:-/tmp}}}/g7-items.$$" ]; then
  cat "${TMPDIR:-${TMP:-${TEMP:-/tmp}}}/g7-items.$$"; bad=$((bad+1))
fi
rm -f "${TMPDIR:-${TMP:-${TEMP:-/tmp}}}/g7-items.$$"

if [ "$bad" = 0 ]; then
  echo "G7-batch: ${f##*/} holds — $items item(s), $words words, a $sentences-sentence preamble"
  exit 0
fi
exit 1
