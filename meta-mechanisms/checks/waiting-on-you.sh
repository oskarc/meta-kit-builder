#!/usr/bin/env bash
# waiting-on-you.sh [<kit root>] — contract-022 UC-4. What is queued on the PIONEER's decision, oldest first,
# one line each. Read by the agent at the start of a sitting and put to the pioneer in words; never a thing the
# pioneer asks for (P-004), and never a thing the pioneer reads raw (the translation rule — a script cannot say
# what a record means).
#
# The practice promises the pioneer never has to prompt the kit, and then a backlog of fifty-one proposed
# standards reached them only because they asked where things stood. This is the smallest answer to that: the
# short list of open shots, so nothing is waiting on them without their knowing.
#
# What it will not say: anything about a review batch beyond the fact that one is waiting. Contract-011 keeps
# the count of pioneer-owned items deliberately unnamed, because knowing how many are really due would let the
# re-presented items — the ones that test whether a decision holds twice — be counted out. One line, no number,
# no kinds.
#
# Portable: bash, sed, awk, grep, tr, date. No jq.
here="$(cd "$(dirname "$0")" && pwd)"
kit="${1:-$(cd "$here/../.." && pwd)}"
C="$kit/meta-contract-before-execution/CONTRACT-LOG.yaml"
L="$kit/meta-ledger/LEDGER.yaml"
R="$kit/meta-correction-log/CORRECTIONS.yaml"
K="$kit/meta-casebook/CASEBOOK.yaml"
D="$kit/meta-drift-eventlog/DRIFTLOG.yaml"
M="$kit/meta-map/MAP.md"
out=$(mktemp)

# 1. Clauses a verification left open: the pioneer chooses one of three ways to close each contract.
[ -f "$C" ] && awk '
  function flush() {
    if (id != "" && vs == "reported" && st == "implemented") print (d == "" ? "9999-99-99" : d) "\t" id "\tthe checks on " id " came back with something unresolved, and closing it is your call"
    id=""; vs=""; st=""; d=""
  }
  /^[[:space:]]*#/ { next }
  /^[[:space:]]*-[[:space:]]+[A-Za-z_]+_id:[[:space:]]*[^[:space:]]/ {
    flush(); key=$2; sub(/:$/, "", key); keyind=index($0, "-") + 2
    if (key == "contract_id") { id=$3; sub(/[[:space:]]*#.*$/, "", id) }
    next
  }
  /^[a-z_]+:/ { flush(); next }
  {
    if (id == "") next
    if (match($0, /[^ ]/) != keyind) next
    line=$0; sub(/[[:space:]]*#.*$/, "", line)
    if (line ~ /^[[:space:]]+status:[[:space:]]*implemented[[:space:]]*$/) st="implemented"
    if (line ~ /^[[:space:]]+verification_state:[[:space:]]*reported[[:space:]]*$/) vs="reported"
    if (line ~ /^[[:space:]]+date_approved:[[:space:]]*[0-9]/) { d=$2 }
  }
  END { flush() }
' "$C" >> "$out"

# 2. Anything recorded blocked, in any record: it is waiting on guidance (contract-019).
blocked_lines() {   # FILE ID_KEY STATE_KEY WORDS
  [ -f "$1" ] || return 0
  awk -v idkey="$2" -v statekey="$3" -v words="$4" '
    function flush() { if (id != "" && st == "blocked") print (since == "" ? "9999-99-99" : since) "\t" id "\t" words " (" id ")" ; id=""; st=""; since="" }
    /^[[:space:]]*#/ { next }
    /^[[:space:]]*-[[:space:]]+[A-Za-z_]+_id:[[:space:]]*[^[:space:]]/ {
      flush(); key=$2; sub(/:$/, "", key); keyind=index($0, "-") + 2
      if (key == idkey) { id=$3; sub(/[[:space:]]*#.*$/, "", id) }
      next
    }
    /^[a-z_]+:/ { flush(); next }
    {
      if (id == "") next
      if (match($0, /[^ ]/) != keyind) next
      line=$0; sub(/[[:space:]]*#.*$/, "", line)
      if (line ~ ("^[[:space:]]+" statekey ":[[:space:]]*blocked[[:space:]]*$")) st="blocked"
      if (line ~ /^[[:space:]]+blocked_since:[[:space:]]*[0-9]/) { since=$2 }
    }
    END { flush() }
  ' "$1" >> "$out"
}
blocked_lines "$C" contract_id audited      "a kit task cannot be done and is waiting on you to say how to proceed"
blocked_lines "$R" corr_id     clerked      "a kit task cannot be done and is waiting on you to say how to proceed"
blocked_lines "$L" obs_id      consolidated "a kit task cannot be done and is waiting on you to say how to proceed"
blocked_lines "$L" batch_id    revealed     "a kit task cannot be done and is waiting on you to say how to proceed"

# 3. A review batch, if one is due — ONE line, no count, no kinds. See the header.
batch_due=no
if [ -f "$L" ] && grep -q '^[[:space:]]*-[[:space:]]*batch_id:' "$L" && \
   awk '/^[[:space:]]*-[[:space:]]*batch_id:/{b=1} b && /^[[:space:]]+decided:[[:space:]]*false/{f=1} END{exit !f}' "$L"; then
  batch_due=yes
elif [ -f "$L" ] && { grep -q '^[[:space:]]*review_due:[[:space:]]*true' "$L" || grep -q '^[[:space:]]+state:[[:space:]]*pending' "$L"; }; then
  batch_due=yes
elif [ -f "$K" ] && { grep -q '^[[:space:]]+pioneer_ranking:[[:space:]]*pending' "$K" || grep -q '^[[:space:]]+conflict:[[:space:]]*P-' "$K"; }; then
  batch_due=yes
elif [ -f "$D" ] && grep -q '^[[:space:]]+status:[[:space:]]*mitigated' "$D"; then
  batch_due=yes
fi
[ "$batch_due" = yes ] && printf '9999-99-98\t-\ta review of what would change the standard is waiting for you\n' >> "$out"

# 4. The map's proposed entries, where the ratification pass was put off.
if [ -f "$M" ] && grep -q 'ratification: deferred' "$M" 2>/dev/null; then
  printf '9999-99-98\t-\tthe map still carries entries you have not ratified, put off at install\n' >> "$out"
fi

n=$(grep -c . "$out" 2>/dev/null); n=${n:-0}
if [ "$n" = 0 ]; then
  echo "waiting on the pioneer: nothing"
else
  echo "waiting on the pioneer: $n"
  sort "$out" | cut -f3-
fi
rm -f "$out"
