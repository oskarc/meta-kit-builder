#!/usr/bin/env bash
# G5-steps — contract-016 G-2. Fails when any paragraph of the bootstrap skill is longer than its allowance.
# The bootstrap skill is the text an agent follows while a project's records are at risk. From contract-007 to
# contract-015 every change appended clauses to the same sentences, until the rehearsal step was one paragraph of
# 4,078 bytes. A paragraph here is one line of the file. The allowance is one number, below; like the size check's
# (G1), it does not move — a paragraph that outgrows it is split into steps.
#
# Usage: G5-steps.sh [<kit root>]   (default: the folder this checks/ sits under — .claude/skills in a project)
# Exit 1 names every offending line and its length in bytes.
LIMIT=1200
here="$(cd "$(dirname "$0")" && pwd)"
kit="${1:-$(cd "$here/../.." && pwd)}"
f="$kit/meta-bootstrap/SKILL.md"
[ -f "$f" ] || { echo "G5-steps broken: $f is missing — this check reads the bootstrap skill; restore it from the staged kit, or run the check from the kit root"; exit 1; }
LC_ALL=C awk -v max="$LIMIT" '
  { n = length($0); if (n > max) { printf "G5-steps broken: meta-bootstrap/SKILL.md line %d is %d bytes, over the %d-byte allowance for one paragraph — split it into steps; the allowance does not move\n", NR, n, max; bad = 1 } }
  END { exit bad }' "$f"
