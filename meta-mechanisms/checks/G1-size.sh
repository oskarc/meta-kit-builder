#!/usr/bin/env bash
# G1-size — from contract-001 G-1 ("INTENT <= ~5 KB; MAP <= ~8 KB and ~40 entries"), made a mechanism by
# contract-007 G-9 after drift-003 recurred a third time: a size was stated without being measured.
# Holding it enforces: the always-loaded files fit their allowance; the allowance does not move (P-006).
# Shape checked: meta-foundation/INTENT.md at most 5120 bytes; meta-map/MAP.md (and templates/MAP.template.md
#          where it ships) at most 8192 bytes and at most 40 entry lines (lines beginning `M-NN `).
# Exit 0 when the standard holds; non-zero with one line naming the file and the figure that broke it.
set -u
here="$(cd "$(dirname "$0")" && pwd)"
kit="$(cd "$here/../.." && pwd)"                 # .claude/skills in a project; the repo root in the base kit

f="$kit/meta-foundation/INTENT.md"
[ -f "$f" ] || { echo "G1-size broken: meta-foundation/INTENT.md is missing — restore it from the kit's own copy or from git history; if this project never had one, run this check from the kit root instead"; exit 1; }
b="$(wc -c < "$f" | tr -d ' ')"
[ "$b" -le 5120 ] || { echo "G1-size broken: meta-foundation/INTENT.md is ${b} bytes, over the 5120-byte allowance — shorten it or point to a node; the allowance does not move"; exit 1; }

for f in "$kit/meta-map/MAP.md" "$kit/templates/MAP.template.md"; do
  [ -f "$f" ] || continue
  b="$(wc -c < "$f" | tr -d ' ')"; n="$(grep -c '^M-[0-9][0-9]* ' "$f")"
  [ "$b" -le 8192 ] || { echo "G1-size broken: ${f#$kit/} is ${b} bytes, over the 8192-byte allowance — prune the map; the allowance does not move"; exit 1; }
  [ "$n" -le 40 ]   || { echo "G1-size broken: ${f#$kit/} has ${n} entries, over the 40-entry allowance — prune the map; the allowance does not move"; exit 1; }
done
[ -f "$kit/meta-map/MAP.md" ] || { echo "G1-size broken: meta-map/MAP.md is missing — seed it from templates/MAP.template.md (meta-bootstrap step 5), or run this check from the kit root"; exit 1; }
exit 0
