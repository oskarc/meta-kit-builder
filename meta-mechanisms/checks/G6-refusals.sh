#!/usr/bin/env bash
# G6-refusals — contract-019 G-3. Fails when a refusal the kit can print is not registered with a way forward.
#
# The pioneer's ruling of 2026-09-20: "No check must block the work being initiated, if something is not possible
# to resolve; ask the pioneer for guidance." A refusal that says only what is wrong leaves whoever met it with
# nowhere to go — the same failure as a gate task nobody can clear, one scale down. Ten of the kit's own refusals
# were that way when this check was written.
#
# Usage: G6-refusals.sh [<kit root>]        hold every refusal to the registry
#        G6-refusals.sh --list [<kit root>] print the refusals as the check reads them (how the registry is built)
# Default root: the folder this checks/ sits under — .claude/skills in a project.
# Scanned: every .sh under checks/, hooks/ and meta-bootstrap/ — not tests/, whose scripts quote these messages
# on purpose. A refusal is any string literal holding `refused:` or ` broken:`. Variables are normalised to <>,
# so one registry line covers a message however its values come out.
# Exit 1 names each unregistered message and the file it is printed from. Registering it means adding it to
# refusal-nextsteps.txt with the `-> ` line that says what the reader does next — which is the point: a new
# refusal cannot enter the kit without one.
here="$(cd "$(dirname "$0")" && pwd)"
list_only=0
[ "${1:-}" = "--list" ] && { list_only=1; shift; }
kit="${1:-$(cd "$here/../.." && pwd)}"
reg="$here/refusal-nextsteps.txt"

files=()
for f in "$kit"/meta-mechanisms/checks/*.sh "$kit"/meta-mechanisms/hooks/*.sh "$kit"/meta-bootstrap/*.sh; do
  [ -f "$f" ] && files+=("$f")
done
[ "${#files[@]}" -gt 0 ] || { echo "G6-refusals broken: no kit scripts found under $kit — pass the kit root as the first argument, which in a project is .claude/skills"; exit 1; }

# scan FILE — every refusal literal in FILE, normalised, one per line, prefixed by the file it is printed from.
# The scan walks each line character by character so an escaped quote inside a message stays inside it.
scan() {
  awk -v label="${1#$kit/}" '
    {
      line = $0; n = length(line); i = 1
      while (i <= n) {
        if (substr(line, i, 1) != "\"") { i++; continue }
        i++; msg = ""
        while (i <= n) {
          c = substr(line, i, 1)
          if (c == "\\") { msg = msg substr(line, i, 2); i += 2; continue }
          if (c == "\"") { i++; break }
          msg = msg c; i++
        }
        if (msg ~ /refused:/ || msg ~ / broken:/) {
          gsub(/\$\{[^}]*\}/, "<>", msg)
          gsub(/\$\([^)]*\)/, "<>", msg)
          gsub(/\$[A-Za-z_][A-Za-z0-9_]*/, "<>", msg)
          print label "\t" msg
        }
      }
    }
  ' "$1"
}

found="$(for f in "${files[@]}"; do scan "$f"; done | sort -u)"

if [ "$list_only" = 1 ]; then
  printf '%s\n' "$found" | cut -f2- | sort -u
  exit 0
fi

[ -f "$reg" ] || { echo "G6-refusals broken: $reg is missing — it ships beside this script; restore it from the staged kit or from git history"; exit 1; }

# a registered message must carry its next step
unstepped="$(awk '
  /^[[:space:]]*(#|$)/ { next }
  /^-> / { last = ""; next }
  { if (last != "") print last; last = $0 }
  END { if (last != "") print last }
' "$reg" | tr -d '\r')"
if [ -n "$unstepped" ]; then
  echo "G6-refusals broken: a registered refusal carries no next step — every message in refusal-nextsteps.txt is followed by a line beginning \"-> \" saying what the reader does next:"
  printf '%s\n' "$unstepped" | sed 's/^/    /'
  exit 1
fi

regmsgs="$(grep -v -E '^[[:space:]]*(#|->|$)' "$reg" | tr -d '\r')"
bad=0
while IFS=$'\t' read -r file msg; do
  [ -n "$msg" ] || continue
  if ! printf '%s\n' "$regmsgs" | grep -q -x -F -- "$msg"; then
    [ "$bad" = 0 ] && echo "G6-refusals broken: a refusal the kit can print is not registered with a way forward:"
    echo "    $file: $msg"
    bad=1
  fi
done <<EOF
$found
EOF
if [ "$bad" = 1 ]; then
  echo "  next: add each message above to meta-mechanisms/checks/refusal-nextsteps.txt, each followed by a \"-> \" line saying what the reader does next. Where the reader can do nothing themselves, the next step is to ask the pioneer for guidance (contract-019)."
  exit 1
fi
exit 0
