#!/usr/bin/env bash
# lib.sh — shared helpers for the kit's mechanisms. Governed by meta-mechanisms/SKILL.md.
# Portable by design: bash, sed, awk, grep, tr, date. No jq, no python.
#
# State is read through FLAT MARKER KEYS in the instance files (verification_state:, audited:, transcript:,
# consolidated:, stewarded:, review_due:, clerked:, decided:, revealed:). Two rules keep that parsing honest:
#   * a marker is only read at the entry's own indentation, so an enumerated value quoted inside a tier
#     block or a revision note is prose, not state;
#   * values may carry a trailing `# comment`.
# Renaming a key, or adding a value outside the enumerations below, silently switches a mechanism off.

ROOT=$(printf '%s' "${CLAUDE_PROJECT_DIR:-$PWD}" | sed -e 's#\\\\#/#g' -e 's#\\#/#g')
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

INPUT=""
SCAN=""
read_input() {
  INPUT=$(cat)
  # Fields are read from the request only: a tool_response echoing file_path must not override tool_input.
  SCAN=${INPUT%%\"tool_response\"*}
  SCAN=${SCAN%%\"tool_result\"*}
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

# norm_path TEXT — JSON-escaped or native Windows separators to forward slashes
norm_path() { printf '%s' "$1" | sed -e 's#\\\\#/#g' -e 's#\\#/#g'; }

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
      if (line ~ /^[[:space:]]+audited:[[:space:]]*(true|false|legacy)[[:space:]]*$/) { au=$2 }
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
