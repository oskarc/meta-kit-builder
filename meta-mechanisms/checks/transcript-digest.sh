#!/usr/bin/env bash
# transcript-digest.sh <session id | transcript path> [outfile] — contract-019 UC-7.
#
# A session transcript is JSONL: one line per turn, with every tool result inside that line. So a search of it
# does not return a line, it returns a whole turn — 219 KB for the largest turn measured here — and the four
# searches kit-session-auditor is told to make returned 15.2 MB of a 70 MB file. The agent fills and stops with
# no error and no partial result; it is not a slow audit, it is an audit that cannot be initiated. The kit's
# answer is not a bigger budget but an input the budget fits: one row per turn, which the auditor greps instead
# of the raw file, going back to the file only to quote something exactly.
#
# A row is:  <line> | <time> | <who> | <flags> | <tools> | <files touched> | <the first words>
#   flags    closing-four  this turn ends with the closing four (contract-020)
#            err         a tool on this turn returned an error
#   who      human       the pioneer's own words (a user turn whose origin is human)
#            agent       the assistant
#            result      a user-role turn carrying tool results, not the pioneer
#            system      anything else the transcript records
# Every row keeps its LINE NUMBER in the raw transcript, so a quote is found with one targeted read.
#
# Run by the agent before it launches the auditor — never by the pioneer (P-004). The auditor has no Bash;
# this is why the digest is made for it rather than by it. Prints the path it wrote.
# Portable: bash, sed, awk, grep, tr, date. No jq.
set -e
src="${1:?usage: transcript-digest.sh <session id | transcript path> [outfile]}"
if [ ! -f "$src" ]; then
  # a bare session id: the transcript is <id>.jsonl under the Claude projects folder in the user's home
  found=""
  for c in "$HOME/.claude/projects"/*/"$src.jsonl" "$HOME/.claude/projects"/*/*"$src"*.jsonl; do
    [ -f "$c" ] && { found="$c"; break; }
  done
  [ -n "$found" ] || { echo "digest refused: no transcript found for \"$src\" — pass the path to the .jsonl file, or check the session id on the contract entry. If the transcript is genuinely gone, record the audit blocked on the contract entry with that reason and put it to the pioneer (meta-mechanisms → Blocked tasks)"; exit 1; }
  src="$found"
fi
# native_path PATH — the spelling the file tools use. The digest is made for an agent with no shell
# (kit-session-auditor), and on a Windows shell a path like /tmp/x or /c/x is the shell's own: the file tools
# cannot open it. The first version of this script printed exactly that, so the auditor was handed a file it
# could not read (contract-023 UC-6).
native_path() {
  case "${OSTYPE:-}" in
    msys*|cygwin*|win32*) if command -v cygpath >/dev/null 2>&1; then cygpath -m "$1"; return; fi ;;
  esac
  printf '%s' "$1"
}
out="${2:-}"
if [ -z "$out" ]; then
  base=$(basename "$src"); base="${base%.jsonl}"
  # the platform's temp folder where the environment names one, brought to one spelling; /tmp otherwise
  tmpdir="${TMPDIR:-${TMP:-${TEMP:-/tmp}}}"
  tmpdir="$(printf '%s' "$tmpdir" | sed -e 's#\\#/#g' -e 's#/*$##')"
  [ -d "$tmpdir" ] || tmpdir=/tmp
  out="$tmpdir/kit-digest-$base.txt"
fi
awk -v OFS=' | ' '
  function first(field,   m, s) {            # the FIRST occurrence of "field":"..." on the line (top level)
    if (match($0, "\"" field "\":\"[^\"]*\"") == 0) return ""
    s = substr($0, RSTART, RLENGTH); sub("^\"" field "\":\"", "", s); sub("\"$", "", s)
    return s
  }
  function snippet(keep,   s) {               # the first text block, unescaped enough to read
    if (match($0, /"type":"text","text":"/) == 0) return ""
    s = substr($0, RSTART + RLENGTH, keep * 3)
    # cut at the quote that closes the value: the first one not escaped by a backslash
    if (substr(s, 1, 1) == "\"") return ""
    if (match(s, /[^\\]"/)) s = substr(s, 1, RSTART)
    gsub(/\\n/, " ", s); gsub(/\\"/, "\x27", s); gsub(/\\\\/, "/", s); gsub(/\|/, "/", s)
    gsub(/[[:space:]]+/, " ", s)
    return substr(s, 1, keep)
  }
  # What a row is flagged for. The digest replaces a search of the raw file, so it has to answer the searches
  # that search was making: the record ids named on the turn, the tier headings of a contract draw, the moment
  # of approval, and the turns that end with the closing four. Without these a grep of the digest for a
  # contract id finds only the turns that happened to open with it.
  function flags(   f, t, s, seen) {
    f = ""
    if (index($0, "What should you have based the framing")) f = "closing-four"
    if (index($0, "\"is_error\":true")) f = (f == "" ? "err" : f ",err")
    if (index($0, "Tier 1") || index($0, "Tier 4") || index($0, "tier_1")) f = (f == "" ? "tier" : f ",tier")
    if (index($0, "contract is approved") || index($0, "Approve to proceed") || index($0, "approved-at-gate")) \
      f = (f == "" ? "approval" : f ",approval")
    t = $0
    while (match(t, /(contract|report)-[0-9]+|[COPKIS]-[0-9]{3}|M-[0-9]{2}/)) {
      s = substr(t, RSTART, RLENGTH)
      if (!(s in seen)) { seen[s] = 1; f = (f == "" ? s : f "," s) }
      t = substr(t, RSTART + RLENGTH)
    }
    return f
  }
  function tools(   t, s, seen, out) {        # every tool_use name on the line, once each, in order
    t = $0; out = ""
    while (match(t, /"type":"tool_use"/)) {
      t = substr(t, RSTART + RLENGTH, 400)    # the name follows within the block\x27s own head
      if (match(t, /"name":"[A-Za-z_]+"/)) {
        s = substr(t, RSTART, RLENGTH); sub(/^"name":"/, "", s); sub(/"$/, "", s)
        if (!(s in seen)) { seen[s] = 1; out = (out == "" ? s : out "," s) }
      }
    }
    return out
  }
  function files(   t, s, seen, out, n) {     # the paths written or read, basenames only, at most four
    t = $0; out = ""; n = 0
    while (match(t, /"file_path":"[^"]*"/)) {
      s = substr(t, RSTART, RLENGTH); sub(/^"file_path":"/, "", s); sub(/"$/, "", s)
      gsub(/\\\\/, "/", s); sub(/.*\//, "", s)
      if (!(s in seen) && n < 4) { seen[s] = 1; n++; out = (out == "" ? s : out "," s) }
      t = substr(t, RSTART + RLENGTH)
    }
    return out
  }
  {
    # The role is read from the message, not from the line: most assistant turns carry `"message":{...
    # "role":"assistant"` BEFORE any top-level "type" key, so a first-key reading loses them. Bookkeeping
    # lines (queue operations, the bridge record) carry no role at all and are not turns.
    if (index($0, "\"role\":\"assistant\"")) who = "agent"
    else if (index($0, "\"role\":\"user\"")) who = index($0, "\"origin\":{\"kind\":\"human\"}") ? "human" : "result"
    else next
    # a kit agent keeps its own transcript inside this one; the session auditor reads the main session only
    if (index($0, "\"isSidechain\":true")) who = who "-sub"
    ts = first("timestamp"); sub(/T/, " ", ts); sub(/\.[0-9]*Z$/, "", ts)
    # a turn of the pioneers own keeps more of its words: a redirect cut at 120 characters is not a redirect,
    # and there are two orders of magnitude fewer of those turns than of the agents
    print NR, ts, who, flags(), tools(), files(), snippet(who == "human" ? 400 : 120)
  }
' "$src" > "$out"
rows=$(grep -c . "$out" || true)
turns=$(grep -c '| human |' "$out" || true)
printf 'digest written: %s\n%s rows (%s of them the pioneer'"'"'s own turns) from %s\n' "$(native_path "$out")" "$rows" "$turns" "$(native_path "$src")"
printf 'Each row keeps its line number in the transcript: read that line for an exact quote.\n'
