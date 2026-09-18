#!/usr/bin/env bash
# residue.sh <project copy> <yardstick> — the upgrade's step 3, made mechanical (contract-013 G-1).
# Prints the lines of the project's copy of a kit file that the yardstick never had: the project's own lines, the
# residue. The yardstick is the installed copy (.claude/skills/installed/<skill>/SKILL.md) or, for a project that
# predates installed copies, the staged kit's line history (meta-bootstrap/history/<skill>.lines).
#
# A line is the kit's, and not residue, when — carriage returns and runs of whitespace aside, blank lines ignored —
#   1. the yardstick has the same line; or
#   2. it is RE-WRAPPED kit text (five words or more): its words stand, in order, inside one yardstick line, or they
#      are the end of one yardstick line, then whole yardstick lines, then the start of another, each piece two
#      words or more. A history file has lost the document's order, so the pieces are matched against any lines;
#      a project line that tiles that way by chance would have to repeat the kit's own word sequences exactly.
# Everything else is printed, as it stands in the project's copy, in file order. The count goes to stderr.
# A re-wrap this rule misses is printed — the error falls on the side of asking the pioneer, never of dropping a line.
# bash and awk only (contract-001 G-3). Exit 0 always; 2 on bad usage.
set -u
[ $# -eq 2 ] || { echo "usage: residue.sh <project copy> <installed copy | history .lines file>" >&2; exit 2; }
[ -f "$1" ] || { echo "residue: no such file: $1" >&2; exit 2; }
[ -f "$2" ] || { echo "residue: no such file: $2" >&2; exit 2; }
awk '
  function norm(s) { gsub(/\r/, "", s); gsub(/[ \t]+/, " ", s); sub(/^ /, "", s); sub(/ $/, "", s); return s }
  function join(a, b,   i, s) { s = ""; for (i = a; i <= b; i++) s = (s == "" ? w[i] : s " " w[i]); return s }
  function wrapped(l, n,   i, j, k) {
    for (k = 1; k <= ny; k++) if (index(" " lines[k] " ", " " l " ") > 0) return 1          # inside one line
    split("", reach)
    for (i = 2; i <= n - 2; i++) if (join(1, i) in suf) reach[i] = 1                          # the end of a line
    for (i = 2; i <= n - 2; i++) if (i in reach)
      for (j = i + 2; j <= n - 2; j++) if (join(i + 1, j) in whole) reach[j] = 1              # whole lines between
    for (i = 2; i <= n - 2; i++) if ((i in reach) && (join(i + 1, n) in pre)) return 1       # the start of a line
    return 0
  }
  FNR == NR {
    l = norm($0); if (l == "") next
    whole[l] = 1; lines[++ny] = l; n = split(l, w, " ")
    s = ""; for (i = n; i >= 1; i--) { s = (s == "" ? w[i] : w[i] " " s); suf[s] = 1 }
    s = ""; for (i = 1; i <= n; i++) { s = (s == "" ? w[i] : s " " w[i]); pre[s] = 1 }
    next
  }
  {
    l = norm($0); if (l == "" || (l in whole)) next
    n = split(l, w, " ")
    if (n >= 5 && wrapped(l, n)) next
    print $0; c++
  }
  END { printf "residue: %d line(s)\n", c + 0 > "/dev/stderr" }
' "$2" "$1"
exit 0
