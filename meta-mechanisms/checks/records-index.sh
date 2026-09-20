#!/usr/bin/env bash
# records-index.sh [<kit root>] [observations|corrections|all] — contract-021 UC-2.
#
# Four kit agents ran out of turns eight times in two days downstream, every one of them with the work done and
# nothing written. The cost was not the work: one consolidation merged sixteen observations inside its budget and
# a later one merged two and exhausted. What changed between them was the record each had to read first, which
# had grown. Telling an agent to write early did not help, which rules out thoroughness and leaves size.
#
# So the same move the transcript digest made for the audit: an index of the items an agent must act on, small
# enough to read whole, each line keeping the LINE NUMBER in the record so the agent opens the record only at the
# item it is working on.
#
# A line is:  <line> | <id> | <date> | <what it is> | <the first words>
# Usage from an agent: read this, act on an item, open the record at that line for the item in full.
# Portable: bash, sed, awk, grep, tr, date. No jq.
here="$(cd "$(dirname "$0")" && pwd)"
kit="${1:-$(cd "$here/../.." && pwd)}"
what="${2:-all}"
L="$kit/meta-ledger/LEDGER.yaml"
C="$kit/meta-correction-log/CORRECTIONS.yaml"

index_of() {   # FILE ID_KEY MARKER_KEY FIELD_A FIELD_B TEXT_KEY LABEL
  local f="$1" idkey="$2" marker="$3" fa="$4" fb="$5" textkey="$6" label="$7"
  [ -f "$f" ] || { echo "$label: (no record at ${f#$kit/})"; return; }
  awk -v idkey="$idkey" -v marker="$marker" -v fa="$fa" -v fb="$fb" -v textkey="$textkey" -v label="$label" '
    function flush() {
      if (id != "" && due == 1) { rows[++n] = ln " | " id " | " a " | " b " | " substr(txt, 1, 90) }
      id=""; due=0; a="-"; b="-"; txt=""; intext=0
    }
    /^[[:space:]]*#/ { next }
    $0 ~ ("^[[:space:]]*-[[:space:]]+" idkey ":[[:space:]]*[^[:space:]]") {
      flush(); id=$3; sub(/[[:space:]]*#.*$/, "", id); ln=NR; keyind=index($0, "-") + 2; next
    }
    /^[[:space:]]*-[[:space:]]+[a-z_]+_id:/ { flush(); next }
    /^[a-z_]+:/ { flush(); next }
    {
      if (id == "") next
      line = $0; sub(/[[:space:]]*#.*$/, "", line)
      if (match(line, /[^ ]/) == keyind) {
        intext = 0
        if (line ~ ("^[[:space:]]+" marker ":[[:space:]]*false[[:space:]]*$")) due = 1
        if (line ~ ("^[[:space:]]+" fa ":[[:space:]]*[^[:space:]]")) { a=line; sub("^[[:space:]]+" fa ":[[:space:]]*", "", a) }
        if (line ~ ("^[[:space:]]+" fb ":[[:space:]]*[^[:space:]]")) { b=line; sub("^[[:space:]]+" fb ":[[:space:]]*", "", b) }
        if (line ~ ("^[[:space:]]+" textkey ":")) { intext=1; t=line; sub("^[[:space:]]+" textkey ":[[:space:]]*\\|?[[:space:]]*", "", t); if (t != "") txt = t }
        next
      }
      if (intext && txt == "") { t=line; sub(/^[[:space:]]+/, "", t); gsub(/\|/, "/", t); txt=t }
    }
    END {
      flush()
      print label ": " n
      for (i = 1; i <= n; i++) print rows[i]
    }
  ' "$f"
}

case "$what" in
  observations) index_of "$L" obs_id consolidated date source statement "observations to consolidate" ;;
  corrections)  index_of "$C" corr_id clerked date grade pioneer_said "corrections to clerk" ;;
  all)
    index_of "$L" obs_id consolidated date source statement "observations to consolidate"
    echo
    index_of "$C" corr_id clerked date grade pioneer_said "corrections to clerk"
    ;;
  *) echo "records-index refused: unknown selection \"$what\" — pass observations, corrections, or all"; exit 1 ;;
esac
