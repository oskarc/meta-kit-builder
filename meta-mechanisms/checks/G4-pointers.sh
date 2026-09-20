#!/usr/bin/env bash
# G4-pointers — contract-013 G-5. Fails when a pointer of the form `node → Heading` names a heading its target does
# not have. The kit routes by such pointers — every map entry's load column, and cross-references between skills —
# and a heading renamed in one place left three pointers leading nowhere for six contracts without anything failing.
#
# Usage: G4-pointers.sh [<kit root>]   (default: the folder this checks/ sits under — .claude/skills in a project)
# A pointer is `meta-x → …`, `meta-x/SKILL.md → …` or `INTENT.md → …`, with or without backticks around the node.
# It resolves when the text after the arrow begins with one of the target's anchors, or the text up to its first
# delimiter ( ; | ) . or " — " ) begins an anchor. An anchor is a heading line's text, or the bold lead of a
# paragraph (**Like this.**). Pointers into records (… .yaml → …) are not checked: a record has keys, not headings.
# Exit 1 names file, line, target and the unresolved text.
set -u
here="$(cd "$(dirname "$0")" && pwd)"
kit="${1:-$(cd "$here/../.." && pwd)}"
files=()
for f in "$kit"/meta-*/SKILL.md "$kit/meta-foundation/INTENT.md" "$kit/meta-map/MAP.md" "$kit"/agents/*.md "$kit/templates/MAP.template.md"; do
  [ -f "$f" ] && files+=("$f")
done
[ "${#files[@]}" -gt 0 ] || { echo "G4-pointers broken: no kit texts found under $kit — pass the kit root as the first argument, which in a project is .claude/skills"; exit 1; }
anchors() { # anchors <file>: one anchor per line
  tr -d '\r' < "$1" | awk '
    /^#+ /          { a = $0; sub(/^#+ +/, "", a); print a; next }
    /^\*\*[^*]+\*\*/ { a = $0; sub(/^\*\*/, "", a); sub(/\*\*.*/, "", a); sub(/[.:]$/, "", a); print a }'
}
bad=0
for f in "${files[@]}"; do
  while IFS= read -r hit; do
    n="${hit%%:*}"; body="${hit#*:}"
    # every pointer on the line
    while IFS= read -r ptr; do
      [ -n "$ptr" ] || continue
      node="${ptr%% →*}"; node="${node//\`/}"; rest="${ptr#*→ }"
      case "$rest" in '"'*) continue ;; esac                       # a quoted passage, not a heading (Contradicts: lines)
      rest="${rest#\*}"; rest="${rest#\*}"                          # *Italic* and **bold** heading names
      case "$node" in
        INTENT.md)      target="$kit/meta-foundation/INTENT.md" ;;
        */SKILL.md)     target="$kit/$node" ;;
        *)              target="$kit/$node/SKILL.md" ;;
      esac
      [ -f "$target" ] || { echo "G4-pointers broken: ${f#$kit/}:$n points at $node, which has no file"; bad=1; continue; }
      cut="$(printf '%s' "$rest" | sed -E 's/ — .*//; s/[;|).*].*//; s/[[:space:]]+$//')"
      cut2="${cut%%,*}"                                             # "Template A, M-25": the heading ends at the comma
      ok=0
      while IFS= read -r a; do
        [ -n "$a" ] || continue
        case "$rest" in "$a"*) ok=1; break ;; esac
        [ -n "$cut" ] && case "$a" in "$cut"*) ok=1; break ;; esac
        [ -n "$cut2" ] && case "$a" in "$cut2"*) ok=1; break ;; esac
      done < <(anchors "$target")
      [ "$ok" = 1 ] || { echo "G4-pointers broken: ${f#$kit/}:$n → \"$cut\" is no heading of ${target#$kit/}"; bad=1; }
    done < <(printf '%s\n' "$body" | grep -o -E '`?(meta-[a-z-]+(/SKILL\.md)?|INTENT\.md)`? → [^`]{2,80}')
  done < <(tr -d '\r' < "$f" | grep -n -E '(meta-[a-z-]+(/SKILL\.md)?|INTENT\.md)`? → ')
done
exit $bad
