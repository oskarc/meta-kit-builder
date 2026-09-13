#!/usr/bin/env bash
# P-006 — from C-006 (M-05, contract-003).
# Holding: "shrink the map, we cant start with moving our allowance." — the map fits contract-001 G-1
#          (MAP ≤ ~8 KB and ~40 entries); the allowance is not raised to fit the map.
# Shape checked: meta-map/MAP.md — and templates/MAP.template.md where it ships — is at most 8192 bytes and
#          carries at most 40 entry lines (lines beginning `M-NN `).
# Exit 0 when the standard holds; non-zero with one line naming the file and the figure that broke it.

set -u

here="$(cd "$(dirname "$0")" && pwd)"
kit="$(cd "$here/../.." && pwd)"                 # .claude/skills in a project; the repo root in the base kit

max_bytes=8192
max_entries=40

for f in "$kit/meta-map/MAP.md" "$kit/templates/MAP.template.md"; do
  [ -f "$f" ] || continue
  bytes="$(wc -c < "$f" | tr -d ' ')"
  entries="$(grep -c '^M-[0-9][0-9]* ' "$f")"
  if [ "$bytes" -gt "$max_bytes" ]; then
    echo "P-006 broken: ${f#$kit/} is ${bytes} bytes, over the ${max_bytes}-byte allowance — shrink the map, the allowance does not move"
    exit 1
  fi
  if [ "$entries" -gt "$max_entries" ]; then
    echo "P-006 broken: ${f#$kit/} has ${entries} entries, over the ${max_entries}-entry allowance — shrink the map, the allowance does not move"
    exit 1
  fi
done

[ -f "$kit/meta-map/MAP.md" ] || { echo "P-006 broken: meta-map/MAP.md is missing — nothing to hold to the allowance"; exit 1; }

exit 0
