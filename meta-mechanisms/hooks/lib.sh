#!/usr/bin/env bash
# lib.sh — shared helpers for the kit's mechanisms. Governed by meta-mechanisms/SKILL.md.
# Portable by design: bash, sed, awk, grep, tr, date. No jq, no python.
#
# Since contract-021 the gate also reads its own telemetry: agent-launch, subagent, agent-resume and its own
# stop-gate lines tell it whether an agent is running, whether the last one wrote anything, and how long a
# hand-over has been repeating. That is evidence the hooks already wrote and nobody read.
#
# State is read through FLAT MARKER KEYS in the instance files (verification_state:, audited:, transcript:,
# consolidated:, stewarded:, review_due:, clerked:, decided:, revealed:, the ledger's top-level assembly:, and the
# blocked_* keys beside them).
# Two rules keep that parsing honest:
#   * a marker is only read at the entry's own indentation, so an enumerated value quoted inside a tier
#     block or a revision note is prose, not state;
#   * values may carry a trailing `# comment`.
# Renaming a key, or adding a value outside the enumerations below, silently switches a mechanism off.

# norm_path TEXT — JSON-escaped or native Windows separators to forward slashes, and ONE spelling per path.
# On a Windows shell a path has two spellings: /c/dir (Git Bash) and C:\dir or C:/dir (native, which is what a tool
# call carries). Both are brought to the drive-letter form, so a root taken from $PWD and a file path taken from a
# tool call compare as the same place (contract-013 G-1 — before it, under_root dropped this kit's own events when
# the two spellings met). Elsewhere a leading /c/ is an ordinary directory and is left alone.
# Not covered: a project under one of the shell's own mount points (/tmp, /usr), whose native spelling no sed can
# derive — a project lives on a drive, and a test fixture must be given its drive spelling (walk-007 state 152).
case "${OSTYPE:-}" in msys*|cygwin*|win32*) KIT_WINSHELL=1 ;; *) KIT_WINSHELL=0 ;; esac
norm_path() {
  if [ "$KIT_WINSHELL" = 1 ]; then
    printf '%s' "$1" | sed -e 's#\\\\#/#g' -e 's#\\#/#g' -e 's#^/\([A-Za-z]\)/#\1:/#' -e 's#^/\([A-Za-z]\)$#\1:/#'
  else
    printf '%s' "$1" | sed -e 's#\\\\#/#g' -e 's#\\#/#g'
  fi
}

# kit_root PATH — the nearest ancestor of PATH (PATH itself first) holding an installed kit: a manifest whose
# kit_type is not base. Prints it; empty and false when there is none. A hook acts on the kit its event belongs
# to, never on the launch directory by default (contract-010 G-5).
kit_root() {
  local d; d=$(norm_path "$1"); d="${d%/}"
  while [ -n "$d" ]; do
    if [ -f "$d/.claude/skills/meta-manifest/MANIFEST.yaml" ] \
       && ! grep -qE '^[[:space:]]*kit_type:[[:space:]]*base[[:space:]]*(#.*)?$' "$d/.claude/skills/meta-manifest/MANIFEST.yaml"; then
      printf '%s' "$d"; return 0
    fi
    case "$d" in */*) d="${d%/*}" ;; *) d="" ;; esac
  done
  return 1
}

# set_root DIR — every record path derives from ROOT; called once with the launch directory, and again from
# read_input with the kit the event's working directory belongs to.
set_root() {
  ROOT=$(norm_path "$1")
  KIT="$ROOT/.claude/skills"
  SEALED="$ROOT/.claude/kit-sealed"
  CONTRACTS="$KIT/meta-contract-before-execution/CONTRACT-LOG.yaml"
  DRIFT="$KIT/meta-drift-eventlog/DRIFTLOG.yaml"
  LEDGER="$KIT/meta-ledger/LEDGER.yaml"
  CORRECTIONS="$KIT/meta-correction-log/CORRECTIONS.yaml"
  CASEBOOK="$KIT/meta-casebook/CASEBOOK.yaml"
  MAPFILE="$KIT/meta-map/MAP.md"
  FOUNDING="$KIT/meta-founding-contract/FOUNDING.md"
  MANIFEST="$KIT/meta-manifest/MANIFEST.yaml"
  TELEMETRY="$KIT/meta-ledger/telemetry.log"
}
# The kit the shell sits in comes first (the locator in settings.template.json found the script the same way), then the
# launch directory. A hook run with no cwd in its input still acts on the kit it was started under.
set_root "$(kit_root "$PWD" || printf '%s' "${CLAUDE_PROJECT_DIR:-$PWD}")"

# under_root PATH — true when PATH lies under this root's .claude/skills/ (drive letters compare case-blind)
under_root() {
  local p r
  p=$(norm_path "$1" | tr '[:upper:]' '[:lower:]'); r=$(printf '%s' "$ROOT" | tr '[:upper:]' '[:lower:]')
  case "$p" in "$r/.claude/skills/"*) return 0 ;; esac
  return 1
}

INPUT=""
SCAN=""
read_input() {
  INPUT=$(cat)
  # Fields are read from the request only: a tool_response echoing file_path must not override tool_input.
  SCAN=${INPUT%%\"tool_response\"*}
  SCAN=${SCAN%%\"tool_result\"*}
  # The kit this event belongs to: the one the working directory sits in, when it sits in one (contract-010 G-5).
  local c r; c=$(json_str cwd)
  if [ -n "$c" ] && r=$(kit_root "$c"); then set_root "$r"; fi
}

# kit_installed — true only for a BOOTSTRAPPED project. The kit ships its own MANIFEST.yaml
# (kit_type: base), so a copied-but-not-installed kit must not look installed to the mechanisms.
kit_installed() {
  [ -f "$MANIFEST" ] || return 1
  grep -qE '^[[:space:]]*kit_type:[[:space:]]*base[[:space:]]*(#.*)?$' "$MANIFEST" && return 1
  return 0
}

# json_str FIELD — string value of FIELD in the hook request
json_str() {
  printf '%s' "$SCAN" | tr -d '\n\r' \
    | sed -nE "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"(([^\"\\\\]|\\\\.)*)\".*/\1/p" | head -n1
}

# json_bool FIELD — true | false | empty
json_bool() {
  printf '%s' "$SCAN" | tr -d '\n\r' \
    | sed -nE "s/.*\"$1\"[[:space:]]*:[[:space:]]*(true|false).*/\1/p" | head -n1
}

# in_subagent — true when the hook fired inside a kit agent rather than the main session
in_subagent() { [ -n "$(json_str agent_id)" ] || [ -n "$(json_str agent_type)" ]; }

# contains HAYSTACK NEEDLE — case-insensitive fixed-string match in pure bash
# (grep -iF aborts in some Git for Windows builds, so no grep here)
contains() {
  local h n
  h=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')
  n=$(printf '%s' "$2" | tr '[:upper:]' '[:lower:]')
  [ -n "$n" ] || return 1
  case "$h" in *"$n"*) return 0 ;; esac
  return 1
}

# json_escape TEXT — safe to embed inside a JSON string
json_escape() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/\r//g' -e 's/	/ /g' \
    | awk 'NR>1{printf "%s", "\\n"} {printf "%s", $0}'
}

# count_matches ERE FILE — integer, 0 when the file is missing
count_matches() {
  local n
  [ -f "$2" ] || { echo 0; return; }
  n=$(grep -cE "$1" "$2" 2>/dev/null)
  echo "${n:-0}"
}

# telemetry EVENT [DETAIL] — append-only evidence for the map steward and for evaluation
telemetry() {
  [ -d "$KIT/meta-ledger" ] || return 0
  printf '%s|%s|%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$1" "${2:-}" >> "$TELEMETRY" 2>/dev/null || true
}

# contracts_table — one line per CONTRACT (analysis reports skipped): id status verification_state audited bearing
contracts_table() {
  [ -f "$CONTRACTS" ] || return 0
  awk '
    function emit() { if (id != "" && skip == 0) print id, (st==""?"-":st), (vs==""?"-":vs), (au==""?"-":au), (br?"yes":"no"); id=""; skip=0 }
    /^[[:space:]]*#/ { next }
    /^[[:space:]]*-[[:space:]]+[A-Za-z_]+_id:[[:space:]]*[^[:space:]]/ {
      emit()
      key=$2; val=$3; sub(/:$/, "", key)
      keyind = index($0, "-") + 2
      if (key == "contract_id" && val !~ /^report-/) { id=val; st=""; vs=""; au=""; br=0; skip=0 }
      else { id=""; skip=1 }
      next
    }
    {
      if (id == "" && skip == 0) next
      if (match($0, /[^ ]/) != keyind) next            # entry-level keys only; block prose is deeper
      line = $0; sub(/[[:space:]]*#.*$/, "", line)
      if (line ~ /^[[:space:]]+type:[[:space:]]*analysis-report[[:space:]]*$/) { skip=1 }
      if (line ~ /^[[:space:]]+status:[[:space:]]*(approved|implemented|verified|learned|legacy)[[:space:]]*$/) { st=$2 }
      if (line ~ /^[[:space:]]+verification_state:[[:space:]]*(none|awaiting-evidence|reported|closed-by-follow-up|legacy)[[:space:]]*$/) { vs=$2 }
      if (line ~ /^[[:space:]]+audited:[[:space:]]*(true|false|legacy|blocked)[[:space:]]*$/) { au=$2 }
      if (line ~ /^[[:space:]]+bearing:/) { br=1 }
    }
    END { emit() }
  ' "$CONTRACTS"
}

# contract_field ID KEY — a scalar field from one contract entry; null/~/none read as empty
contract_field() {
  [ -f "$CONTRACTS" ] || return 0
  awk -v want="$1" -v key="$2" '
    /^[[:space:]]*#/ { next }
    /^[[:space:]]*-[[:space:]]+[A-Za-z_]+_id:[[:space:]]*[^[:space:]]/ { cur=$3; keyind=index($0,"-")+2; next }
    cur == want && match($0, /[^ ]/) == keyind && $0 ~ ("^[[:space:]]+" key ":[[:space:]]*[^[:space:]]") {
      line=$0
      sub(/^[[:space:]]+[A-Za-z_]+:[[:space:]]*/, "", line)
      sub(/[[:space:]]*#.*$/, "", line)
      if (line == "null" || line == "~" || line == "none") exit
      print line
      exit
    }
  ' "$CONTRACTS"
}

# blocked_list FILE ID_KEY STATE_KEY — every entry in FILE whose STATE_KEY reads `blocked`, one per line:
#   id|since|reason|waiting_for
# A task nobody can clear is the failure mode meta-mechanisms names; contract-019 gives it a value to be written
# down in, beside the field it belongs to and in the same record, so one read finds both the state and its reason
# (the pioneer's ruling of 2026-09-20: the drift log is written by other agents and would take two files).
# The blocked_* keys are read at the entry's own indentation, like every other marker.
blocked_list() {
  [ -f "$1" ] || return 0
  awk -v idkey="$2" -v statekey="$3" '
    function emit() { if (id != "" && st == "blocked") print id "|" since "|" reason "|" waiting; id="" }
    /^[[:space:]]*#/ { next }
    /^[[:space:]]*-[[:space:]]+[A-Za-z_]+_id:[[:space:]]*[^[:space:]]/ {
      emit()
      key=$2; sub(/:$/, "", key)
      keyind = index($0, "-") + 2
      if (key == idkey) { id=$3; sub(/[[:space:]]*#.*$/, "", id); st=""; since=""; reason=""; waiting="" }
      else { id="" }
      next
    }
    /^[a-z_]+:/ { emit(); next }
    {
      if (id == "") next
      if (match($0, /[^ ]/) != keyind) next
      line = $0; sub(/[[:space:]]*#.*$/, "", line); sub(/[[:space:]]+$/, "", line)
      if (line ~ ("^[[:space:]]+" statekey ":[[:space:]]*blocked$")) { st="blocked" }
      # a bar in a value would shift every field the gate reads, so it never survives the reader
      if (line ~ /^[[:space:]]+blocked_since:[[:space:]]*[^[:space:]]/)       { since=line;   sub(/^[[:space:]]+blocked_since:[[:space:]]*/, "", since);    gsub(/\|/, "/", since) }
      if (line ~ /^[[:space:]]+blocked_reason:[[:space:]]*[^[:space:]]/)      { reason=line;  sub(/^[[:space:]]+blocked_reason:[[:space:]]*/, "", reason);  gsub(/\|/, "/", reason) }
      if (line ~ /^[[:space:]]+blocked_waiting_for:[[:space:]]*[^[:space:]]/) { waiting=line; sub(/^[[:space:]]+blocked_waiting_for:[[:space:]]*/, "", waiting); gsub(/\|/, "/", waiting) }
    }
    END { emit() }
  ' "$1"
}

# assembly_blocked — since|reason|waiting_for when the ledger says a review batch cannot be assembled; nothing
# otherwise. Assembling a batch is the one gate task with no entry of its own until it has succeeded, so its state
# is the ledger's: `assembly: blocked` at the top level, with the three blocked_* lines beside it at the same
# column (contract-023 UC-3). Entry-level blocked_* keys are deeper and are never read here.
assembly_blocked() {
  [ -f "$LEDGER" ] || return 0
  awk '
    function val(s, k) { sub("^" k ":[[:space:]]*", "", s); sub(/[[:space:]]*#.*$/, "", s); sub(/[[:space:]]+$/, "", s); gsub(/\|/, "/", s); return s }
    /^assembly:[[:space:]]*blocked[[:space:]]*(#.*)?$/ { b=1 }
    /^blocked_since:[[:space:]]*[^[:space:]]/       { since=val($0, "blocked_since") }
    /^blocked_reason:[[:space:]]*[^[:space:]]/      { reason=val($0, "blocked_reason") }
    /^blocked_waiting_for:[[:space:]]*[^[:space:]]/ { waiting=val($0, "blocked_waiting_for") }
    END { if (b) print since "|" reason "|" waiting }
  ' "$LEDGER"
}
assembly_is_blocked() { [ -n "$(assembly_blocked)" ]; }

# blocked_all — every blocked task in the project, one per line: file_label|id|state_key|since|reason|waiting_for
# Six states since contract-023: the four contract-019 gave, a map miss the steward could not take, and the
# assembling of a batch. A gate task with no line here has no blocked state, and the gate never says it has.
blocked_all() {
  local a
  blocked_list "$CONTRACTS"   contract_id audited      | sed 's/^/contract|/;s/|/|audited|/2'
  blocked_list "$CORRECTIONS" corr_id     clerked      | sed 's/^/correction|/;s/|/|clerked|/2'
  blocked_list "$LEDGER"      obs_id      consolidated | sed 's/^/observation|/;s/|/|consolidated|/2'
  blocked_list "$LEDGER"      batch_id    revealed     | sed 's/^/batch|/;s/|/|revealed|/2'
  blocked_list "$LEDGER"      obs_id      stewarded    | sed 's/^/map miss|/;s/|/|stewarded|/2'
  a=$(assembly_blocked)
  if [ -n "$a" ]; then printf 'review batch|assembly|assembly|%s\n' "$a"; fi
  return 0
}

# announced_this_sitting KEY — true when KEY was already put to the pioneer since the last session start.
# Once per sitting, not once ever: an announcement the agent never made must come back, or a blocked task can
# disappear silently — which is the pre-mortem of contract-019 in one line.
announced_this_sitting() {
  [ -f "$TELEMETRY" ] || return 1
  awk -F'|' -v k="$1" '
    $2=="session-start" && ($3=="startup" || $3=="resume") { seen=0 }
    $2=="blocked-announced" && $3==k { seen=1 }
    END { exit !seen }
  ' "$TELEMETRY"
}

# repeated_handovers DETAIL — how many times in a row the gate has just handed over this same task with nothing
# changing in between. Counts the trailing run of identical stop-gate lines in telemetry; any other gate event
# breaks the run. Three in a row is a fault, not a backlog (contract-019 UC-5).
repeated_handovers() {
  [ -f "$TELEMETRY" ] || { echo 0; return; }
  awk -F'|' -v d="$1" '
    $2=="stop-gate"       { if ($3==d) run++; else run=0; next }
    $2=="stop-gate-fault" { run=0; next }
  END { print run+0 }' "$TELEMETRY"
}

# fingerprint_paths — every place a kit agent may write, one path or folder per line. The list is the union of
# the write scopes the agents declare in their own files, plus the sealed folder the assembler reaches through
# seal-key.sh; walk-007 holds it to the agent files, so a new scope cannot be added without it (contract-023 G-3).
fingerprint_paths() {
  printf '%s\n' "$LEDGER" "$CORRECTIONS" "$CONTRACTS" "$CASEBOOK" "$DRIFT" \
    "$KIT/meta-ledger/batches/" "$SEALED/" "$KIT/meta-casebook/reconstruction/" "$KIT/meta-mechanisms/checks/"
}

# record_fingerprint — one number standing for the CONTENT of everything a kit agent may write.
# Taken when an agent is launched and again when it stops: unchanged means it wrote nothing, which is what
# happens when an agent exhausts its turns — no report, no partial result, silence with the work done and lost
# (contract-021 UC-1). It was line counts until contract-023: an agent that edits in place — a consolidator merging
# into a candidate that exists — adds no line, and the reconstructor writes a file that was never counted, so both
# read as silence and were told to start again. The names are hashed with the text, so a new empty file shows too.
# awk alone, byte by byte, because the portability list holds no checksum tool; it runs when an agent starts and
# stops, never per turn.
record_fingerprint() {
  local p f files=()
  while IFS= read -r p; do
    case "$p" in
      */) for f in "$p"*; do [ -f "$f" ] && files+=("$f"); done ;;
      *)  [ -f "$p" ] && files+=("$p") ;;
    esac
  done <<EOF
$(fingerprint_paths)
EOF
  [ "${#files[@]}" -gt 0 ] || { printf '0'; return; }
  { printf '%s\n' "${files[@]##*/}"; cat "${files[@]}"; } | LC_ALL=C awk '
    BEGIN { for (i = 1; i < 256; i++) ord[sprintf("%c", i)] = i }
    { n = length($0); for (i = 1; i <= n; i++) h = (h * 31 + ord[substr($0, i, 1)]) % 2147483647; h = (h * 31 + 10) % 2147483647 }
    END { printf "%d", h }'
}

# agent_flight — what the telemetry says about the last agent launch, as one word:
#   running   launched, no stop recorded yet, and fewer than LEASE gate firings have passed
#   lapsed    launched, no stop recorded, and the lease has run out — it never reported finishing
#   nothing   it stopped and every record is exactly as long as it was: it wrote nothing
#   done      it stopped and something was written
#   none      no agent has been launched in this sitting
# The lease is what a durable workflow engine calls a visibility timeout: a hold that expires, so a worker that
# dies silently cannot keep a task forever.
# ONLY THE KIT'S OWN AGENTS are read here — a type beginning `kit-` (contract-023 UC-4). The launch hook fires for
# every agent a project has, and a helper that searches code or writes a test never touches a kit record, so by
# this measure it always "wrote nothing": before the filter the gate told the session to resume it, and then to
# record it blocked. The lines are still written for every agent; they are evidence of what ran.
AGENT_LEASE=3
agent_flight() {
  [ -f "$TELEMETRY" ] || { echo none; return; }
  awk -F'|' -v lease="$AGENT_LEASE" '
    $2=="session-start" && ($3=="startup" || $3=="resume") { type=""; launched=""; stopped=""; gates=0; next }
    ($2=="agent-launch" || $2=="subagent") && $3 !~ /^kit-/ { next }
    $2=="agent-launch" { split($3, a, ":"); type=a[1]; launched=a[2]; stopped=""; gates=0; next }
    $2=="subagent"     { if (type != "") { split($3, b, ":"); stopped=(b[2]=="" ? "?" : b[2]) } next }
    $2=="stop-gate" || $2=="stop-gate-fault" { if (type != "" && stopped == "") gates++ ; next }
    END {
      if (type == "") { print "none"; exit }
      if (stopped == "") { print (gates >= lease ? "lapsed" : "running"); exit }
      if (stopped == "?" || launched == "") { print "done"; exit }
      print (stopped == launched ? "nothing" : "done")
    }
  ' "$TELEMETRY"
}

# agent_last_type — the kit agent the last launch names
agent_last_type() {
  [ -f "$TELEMETRY" ] || return 0
  awk -F'|' '$2=="agent-launch" && $3 ~ /^kit-/ { split($3, a, ":"); t=a[1] } END { print t }' "$TELEMETRY"
}

# agent_resumed — true when that agent has already been given one resume since it was launched
agent_resumed() {
  [ -f "$TELEMETRY" ] || return 1
  awk -F'|' '
    $2=="agent-launch" && $3 ~ /^kit-/ { seen=0; next }
    $2=="agent-resume" { seen=1 }
    END { exit !seen }
  ' "$TELEMETRY"
}

# agent_block_where TYPE — where a kit agent's task is written down as blocked, in words the gate can hand over;
# empty when its task has no blocked state. The gate never tells a session to make a write that does not exist
# for the task in hand (contract-023 G-2).
agent_block_where() {
  case "$1" in
    kit-session-auditor) printf '%s' "audited: blocked on that contract's entry in CONTRACT-LOG.yaml" ;;
    kit-consolidator)    printf '%s' "consolidated: blocked on each observation it could not take, in LEDGER.yaml" ;;
    kit-case-clerk)      printf '%s' "clerked: blocked on each correction it could not take, in CORRECTIONS.yaml" ;;
    kit-map-steward)     printf '%s' "stewarded: blocked on each map miss it could not take, in LEDGER.yaml" ;;
    kit-batch-assembler) printf '%s' "assembly: blocked at the top level of LEDGER.yaml, beside observations: and candidates:" ;;
    *) : ;;
  esac
}

# pioneer_items_due LEDGER CASEBOOK DRIFT MAPFILE — true when items only the pioneer can decide are waiting for a
# review batch. THE ONE RULE (contract-023 UC-9): three or more due candidates, or one of anything else — a pending
# map proposal, an unranked card, a precedent conflict, a drift entry awaiting resolution, an unratified map entry
# unless the map carries `ratification: deferred`. The gate, the session-start list and the waiting list all call
# this. Contract-007 made two readers agree by repeating the rule in both; a third was then written that did not
# (contract-022), which is what repeating a rule buys. It prints nothing: how many items are due is never named,
# because with a batch's size visible that count would give away how many of its items are shown a second time.
pioneer_items_due() {
  local due pend cards conflicts resolutions props=0
  due=$(count_matches '^[[:space:]]+review_due:[[:space:]]*true' "$1")
  pend=$(count_matches '^[[:space:]]+state:[[:space:]]*pending' "$1")
  cards=$(count_matches '^[[:space:]]+pioneer_ranking:[[:space:]]*pending' "$2")
  conflicts=$(count_matches '^[[:space:]]+conflict:[[:space:]]*P-' "$2")
  resolutions=$(count_matches '^[[:space:]]+status:[[:space:]]*mitigated' "$3")
  # Unratified base entries wait for the install-time ratification pass; until it has run or been declined, they
  # do not open batches of their own (meta-bootstrap Step 7).
  if ! grep -q 'ratification: deferred' "$4" 2>/dev/null; then
    props=$(count_matches '\|[[:space:]]*proposed[[:space:]]*$' "$4")
  fi
  [ "${due:-0}" -ge 3 ] || [ "${pend:-0}" -ge 1 ] || [ "${cards:-0}" -ge 1 ] \
    || [ "${conflicts:-0}" -ge 1 ] || [ "${resolutions:-0}" -ge 1 ] || [ "${props:-0}" -ge 1 ]
}

# late_test_revisions — ids of reported contracts with a revision that changes Tier 4 tests dated AFTER the
# verification report. Such a revision is drift, not a revision (contract-004 G-3). Reads verification.date
# at the entry's key indentation + 2 and each revision's date / tests_changed; ISO dates compare as strings.
late_test_revisions() {
  [ -f "$CONTRACTS" ] || return 0
  awk '
    function check() { if (rdate != "" && rtests != "" && vdate != "" && rdate > vdate) late = 1; rdate = ""; rtests = "" }
    function emit() { check(); if (id != "" && vs == "reported" && late) print id; id = ""; late = 0; sect = "" }
    /^[[:space:]]*#/ { next }
    /^[[:space:]]*-[[:space:]]+contract_id:[[:space:]]*[^[:space:]]/ {
      emit(); id = $3; sub(/[[:space:]]*#.*$/, "", id); keyind = index($0, "-") + 2; vs = ""; vdate = ""; next
    }
    /^[[:space:]]*-[[:space:]]+[A-Za-z_]+_id:/ { emit(); next }
    /^[a-z_]+:/ { emit(); next }
    id == "" { next }
    {
      ind = match($0, /[^ ]/)
      line = $0; sub(/[[:space:]]*#.*$/, "", line)
      if (ind == keyind) {
        check(); sect = ""
        if (line ~ /^[[:space:]]+verification_state:[[:space:]]*reported[[:space:]]*$/) vs = "reported"
        if (line ~ /^[[:space:]]+verification:[[:space:]]*$/) sect = "ver"
        if (line ~ /^[[:space:]]+revisions:[[:space:]]*$/) sect = "rev"
        next
      }
      if (sect == "ver" && ind == keyind + 2 && line ~ /^[[:space:]]+date:[[:space:]]*[0-9]/) { vdate = $2 }
      if (sect == "rev") {
        if (line ~ /^[[:space:]]+-[[:space:]]/) check()
        if (line ~ /^[[:space:]]+(-[[:space:]]+)?date:[[:space:]]*[0-9]/) { t = line; sub(/.*date:[[:space:]]*/, "", t); rdate = t }
        if (line ~ /^[[:space:]]+(-[[:space:]]+)?tests_changed:[[:space:]]*[^[:space:]]/) {
          t = line; sub(/.*tests_changed:[[:space:]]*/, "", t); gsub(/[[:space:]]/, "", t)
          if (t != "[]" && t != "null" && t != "~" && t != "none") rtests = t
        }
      }
    }
    END { emit() }
  ' "$CONTRACTS"
}

# batches_table — one line per review batch in the ledger: id decided revealed
batches_table() {
  [ -f "$LEDGER" ] || return 0
  awk '
    function emit() { if (id != "") print id, (dc==""?"-":dc), (rv==""?"-":rv); id="" }
    /^[[:space:]]*#/ { next }
    /^[[:space:]]*-[[:space:]]+batch_id:[[:space:]]*[^[:space:]]/ {
      emit(); id=$3; sub(/[[:space:]]*#.*$/, "", id); dc=""; rv=""; keyind=index($0,"-")+2; next
    }
    /^[[:space:]]*-[[:space:]]+(obs_id|cand_id|prop_id|audit_id):/ { emit() }
    /^[a-z_]+:/ { emit() }
    {
      if (id == "") next
      if (match($0, /[^ ]/) != keyind) next
      line = $0; sub(/[[:space:]]*#.*$/, "", line)
      if (line ~ /^[[:space:]]+decided:[[:space:]]*(true|false)[[:space:]]*$/) dc=$2
      if (line ~ /^[[:space:]]+revealed:[[:space:]]*(true|false)[[:space:]]*$/) rv=$2
    }
    END { emit() }
  ' "$LEDGER"
}

# in_grace — an install or upgrade ended in this session, so the review batch waits for the next one (contract-011
# G-5). Audits and verification are not held. Two signs, either is enough (contract-015 G-1):
#   * the baseline both flows end by writing (INSTALLED.sha1, 6j) is newer than the mark session-start.sh leaves at the
#     start of each sitting — or no mark exists yet, because the hooks were not running when the install began. This
#     sign needs nothing from the agent: a promise made in the done block must not rest on a script being remembered.
#   * a `done` line (mark-done.sh) stands after the last session start in telemetry.
# A sitting starts on `startup` or `resume`; `clear` and `compact` happen inside one.
SESSION_MARK_NAME=".session-started"
in_grace() {
  local base="$KIT/meta-manifest/INSTALLED.sha1" mark="$KIT/meta-ledger/$SESSION_MARK_NAME"
  if [ -f "$base" ]; then
    [ -f "$mark" ] || return 0
    [ "$base" -nt "$mark" ] && return 0
  fi
  [ -f "$TELEMETRY" ] || return 1
  awk -F'|' '$2=="session-start" && ($3=="startup" || $3=="resume") {s=NR} $2=="done" {d=NR} END { exit !(d>s) }' "$TELEMETRY"
}
# mark_session — called by session-start.sh when a sitting starts; an empty file whose age is all that is read
mark_session() { [ -d "$KIT/meta-ledger" ] && : > "$KIT/meta-ledger/$SESSION_MARK_NAME" 2>/dev/null || true; }

# has_open_batch — a batch exists that the pioneer has not finished deciding
has_open_batch() { batches_table | awk '$2=="false"' | grep -q .; }

# batch_fully_decided ID — every item in the batch file carries a decision
batch_fully_decided() {
  local f items decided
  f="$KIT/meta-ledger/batches/$1.md"
  [ -f "$f" ] || return 1
  items=$(count_matches '^#+[[:space:]]*I-[0-9]+' "$f")
  decided=$(count_matches '^\**Decision:\**[[:space:]]*[^[:space:]]' "$f")
  [ "$items" -gt 0 ] && [ "$decided" -ge "$items" ]
}

# rows / nrows / first_id — table helpers
rows() { printf '%s\n' "$1" | awk "$2"; }
nrows() { printf '%s\n' "$1" | awk "$2" | grep -c .; }
first_id() { printf '%s\n' "$1" | awk "$2" | head -n1 | awk '{print $1}'; }
