#!/usr/bin/env bash
# P-007 — from C-007 (M-05; shaped contract-004's form).
# Holding: "Acceptance tests should be the tier 4 then, and comes after guardrails."
# Shape checked: in the contract log template and every contract entry, no acceptance-test line (`T-N …`)
#          sits inside a tier_3 block, and wherever tier_4 is present it comes after tier_3.
# Exit 0 when the standard holds; non-zero with one line naming the file and line that broke it.

set -u

here="$(cd "$(dirname "$0")" && pwd)"
kit="$(cd "$here/../.." && pwd)"                 # .claude/skills in a project; the repo root in the base kit

check_file() {
  f="$1"
  # Block keys sit at the entry's key indentation (4 spaces in the instance file, "#     " in the template's
  # schema comment). Track the current block; a T-N line inside tier_3 breaks the standard; tier_4 before
  # tier_3 within one entry breaks it.
  awk -v file="${f#$kit/}" '
    function reset() { t3 = 0; t4 = 0 }
    /^  - contract_id:/ || /^#   - contract_id:/ { reset() }
    /^(#?    |#     )[a-z_0-9]+:/ {
      key = $0; sub(/^(#?    |#     )/, "", key); sub(/:.*/, "", key)
      block = key
      if (key == "tier_3") t3 = NR
      if (key == "tier_4") { t4 = NR; if (t3 == 0) { printf "P-007 broken: %s:%d tier_4 comes before tier_3 — acceptance tests are Tier 4, after the guardrails\n", file, NR; exit 1 } }
      next
    }
    block == "tier_3" && /^(#?[ \t]+)T-[0-9]+[ \t]/ {
      printf "P-007 broken: %s:%d an acceptance test (T-N) sits inside tier_3 — acceptance tests are Tier 4, after the guardrails\n", file, NR; exit 1
    }
  ' "$f" || return 1
  return 0
}

found=0
for f in "$kit/templates/CONTRACT-LOG.template.yaml" "$kit/meta-contract-before-execution/CONTRACT-LOG.yaml"; do
  [ -f "$f" ] || continue
  found=1
  check_file "$f" || exit 1
done

if [ "$found" -eq 0 ]; then
  echo "P-007 broken: no contract log or template found under ${kit} — nothing carries the tier order"
  exit 1
fi

if [ -f "$kit/templates/CONTRACT-LOG.template.yaml" ] && ! grep -qE '^#     tier_4:' "$kit/templates/CONTRACT-LOG.template.yaml"; then
  echo "P-007 broken: templates/CONTRACT-LOG.template.yaml has no tier_4 block — acceptance tests are Tier 4, after the guardrails"
  exit 1
fi

exit 0
