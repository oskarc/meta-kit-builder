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
# It decides nothing of its own (contract-023 UC-9). Whether a review is due, which batches are open and what is
# recorded blocked are read through the same functions the stop-gate and the session-start hook use, in
# hooks/lib.sh. Its first version carried its own copies of those rules: four of its searches used a `+` that
# plain grep reads as a literal plus sign, so it never saw an unranked card, a precedent conflict, a pending map
# proposal or a drift entry awaiting resolution; and it called a review due at one candidate where the gate
# opens a batch at three. A rule that is written twice is a rule that will be told two ways.
#
# Portable: bash, sed, awk, grep, tr, date. No jq.
here="$(cd "$(dirname "$0")" && pwd)"
kit="${1:-$(cd "$here/../.." && pwd)}"
. "$here/../hooks/lib.sh"
# The library points its record paths at an installed project; this script is also run over the base kit's own
# records, which sit at the kit root — so the paths are set from the root it was given.
CONTRACTS="$kit/meta-contract-before-execution/CONTRACT-LOG.yaml"
LEDGER="$kit/meta-ledger/LEDGER.yaml"
CORRECTIONS="$kit/meta-correction-log/CORRECTIONS.yaml"
CASEBOOK="$kit/meta-casebook/CASEBOOK.yaml"
DRIFT="$kit/meta-drift-eventlog/DRIFTLOG.yaml"
MAPFILE="$kit/meta-map/MAP.md"
out=$(mktemp)

# 1. Clauses a verification left open: the pioneer chooses one of three ways to close each contract.
[ -f "$CONTRACTS" ] && awk '
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
' "$CONTRACTS" >> "$out"

# 2. Anything recorded blocked, in any record: it is waiting on guidance (contract-019; six states since
#    contract-023). The list is the library's, so this script and the gate name the same tasks.
blocked_all | while IFS='|' read -r kind id key since reason waiting; do
  [ -n "$id" ] || continue
  [ -n "$since" ] || since="9999-99-99"
  case "$key" in
    assembly) printf '%s\t%s\ta review batch cannot be assembled, and it is waiting on you to say how to proceed\n' "$since" "$id" ;;
    *)        printf '%s\t%s\ta kit task cannot be done and is waiting on you to say how to proceed (%s)\n' "$since" "$id" "$id" ;;
  esac
done >> "$out"

# 3. A review, if one is open or due — ONE line, no count, no kinds. See the header. A batch step the ledger
#    records as blocked is not a review on its way: the line above already says what it waits for.
if has_open_batch || { ! assembly_is_blocked && pioneer_items_due "$LEDGER" "$CASEBOOK" "$DRIFT" "$MAPFILE"; }; then
  printf '9999-99-98\t-\ta review of what would change the standard is waiting for you\n' >> "$out"
fi

# 4. The map's proposed entries, where the ratification pass was put off.
if [ -f "$MAPFILE" ] && grep -q 'ratification: deferred' "$MAPFILE" 2>/dev/null; then
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
