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
set -u
here="$(cd "$(dirname "$0")" && pwd)"
kit="${1:-$(cd "$here/../.." && pwd)}"
list="$here/retired-phrases.txt"
[ -f "$list" ] || { echo "G3-retired broken: $list is missing"; exit 1; }
files=()
for f in "$kit"/meta-*/SKILL.md "$kit/meta-foundation/INTENT.md" "$kit/meta-map/MAP.md" "$kit"/agents/*.md "$kit"/templates/* "$kit/README.md"; do
  [ -f "$f" ] && files+=("$f")
done
[ "${#files[@]}" -gt 0 ] || { echo "G3-retired broken: no kit texts found under $kit"; exit 1; }
bad=0
while IFS= read -r phrase || [ -n "$phrase" ]; do
  phrase="${phrase%$'\r'}"
  case "$phrase" in ''|'#'*) continue ;; esac
  hit="$(grep -n -F -- "$phrase" "${files[@]}" 2>/dev/null | head -n1)"
  if [ -n "$hit" ]; then
    f="${hit%%:*}"; rest="${hit#*:}"; n="${rest%%:*}"
    echo "G3-retired broken: ${f#$kit/}:$n still says \"$phrase\""
    bad=1
  fi
done < "$list"
exit $bad
