#!/usr/bin/env bash
# G3-retired — contract-013 G-5. Fails when a wording the kit has retired still stands anywhere in the kit's texts.
# A contract that replaces a rule tests for the new sentence; nothing tested for the old one, and across contracts
# 008 to 012 every miss the verifier found was an old sentence left beside a new one. The list lives beside this
# script in retired-phrases.txt; a contract that retires a wording adds it there in the same act.
#
# Usage: G3-retired.sh [<kit root>]   (default: the folder this checks/ sits under — .claude/skills in a project)
# Scanned: every meta-*/SKILL.md, meta-foundation/INTENT.md, meta-map/MAP.md, agents/*.md, templates/*, and the
# README where one sits beside the kit. Not scanned: the records, the line history, tests and results — they keep
# what was once said on purpose. Exit 1 names the first survivor of each phrase: file, line, phrase.
#
# In a project, only the KIT's text is held to the list (contract-017). A line the pioneer wrote — put back onto a
# skill by the upgrade, or a map entry they reworded — is theirs, and may say what the kit no longer says. The test of
# whose a line is: the kit's shipped copy of that file (installed/<file> for a skill, templates/MAP.template.md for
# the map). A line that does not stand in the shipped copy is the pioneer's: it is reported as a note and does not
# fail the check. Where there is no shipped copy — this repository, or an install from before the kit kept them —
# every line counts, as before.
here="$(cd "$(dirname "$0")" && pwd)"
kit="${1:-$(cd "$here/../.." && pwd)}"
list="$here/retired-phrases.txt"
[ -f "$list" ] || { echo "G3-retired broken: $list is missing"; exit 1; }
files=()
for f in "$kit"/meta-*/SKILL.md "$kit/meta-foundation/INTENT.md" "$kit/meta-map/MAP.md" "$kit"/agents/*.md "$kit"/templates/* "$kit/README.md"; do
  [ -f "$f" ] && files+=("$f")
done
[ "${#files[@]}" -gt 0 ] || { echo "G3-retired broken: no kit texts found under $kit"; exit 1; }
# shipped FILE — the kit's shipped copy of FILE, or nothing
shipped() {
  local rel="${1#$kit/}"
  case "$rel" in
    meta-map/MAP.md) [ -f "$kit/templates/MAP.template.md" ] && [ -d "$kit/installed" ] && printf '%s' "$kit/templates/MAP.template.md" ;;
    *) [ -f "$kit/installed/$rel" ] && printf '%s' "$kit/installed/$rel" ;;
  esac
}
bad=0
while IFS= read -r phrase || [ -n "$phrase" ]; do
  phrase="${phrase%$'\r'}"
  case "$phrase" in ''|'#'*) continue ;; esac
  while IFS= read -r hit; do
    [ -n "$hit" ] || continue
    f="${hit%%:*}"; rest="${hit#*:}"; n="${rest%%:*}"; line="${rest#*:}"; line="${line%$'\r'}"
    s="$(shipped "$f")"
    if [ -n "$s" ] && ! tr -d '\r' < "$s" | grep -q -x -F -- "$line"; then
      echo "note: ${f#$kit/}:$n says \"$phrase\" in a line that is the project's own, not the kit's — left alone"
      continue
    fi
    echo "G3-retired broken: ${f#$kit/}:$n still says \"$phrase\""
    bad=1; break
  done < <(grep -n -F -- "$phrase" "${files[@]}" /dev/null 2>/dev/null)
done < "$list"
exit $bad
