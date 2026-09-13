#!/usr/bin/env bash
# P-001 — from C-1 (M-04).
# Holding: no retries. A failed network call surfaces its first failure to the caller at once;
#          the caller decides.
# Shape checked: no source file in the project tree carries a retry construct
#          (retry / retries / retrying / max_attempts / attempt loop).
# Exit 0 when the standard holds; non-zero with one line naming the first file that breaks it.
# Skips .claude/, .git/, node_modules/, vendor/, dist/, build/ — skills are prose, not code,
# and their wording is the ledger's business, not this check's.

set -u

root="$(cd "$(dirname "$0")/../../../.." && pwd)"

hit="$(grep -rIliE \
  --exclude-dir=.claude --exclude-dir=.git --exclude-dir=node_modules \
  --exclude-dir=vendor --exclude-dir=dist --exclude-dir=build \
  --include='*.py' --include='*.js' --include='*.ts' --include='*.tsx' --include='*.jsx' \
  --include='*.cs' --include='*.go' --include='*.rs' --include='*.java' --include='*.kt' \
  --include='*.rb' --include='*.php' --include='*.sh' --include='*.ps1' --include='*.c' \
  --include='*.cpp' --include='*.h' --include='*.swift' \
  '\bretr(y|ies|ying)\b|\bmax_?attempts\b|\battempts?\s*(<|<=|-=|\+=|\+\+)' \
  "$root" 2>/dev/null | head -n 1)"

if [ -n "$hit" ]; then
  echo "P-001 broken: retry construct in ${hit#$root/} — surface the first failure to the caller, no retries"
  exit 1
fi

exit 0
