#!/usr/bin/env bash
# Regenerates the line history the upgrade uses as its stand-in for a missing installed copy (contract-008 G-1).
# One file per meta skill and INTENT.md: every distinct line (trailing whitespace stripped, blank lines dropped)
# that any committed version of that file, or the working tree, has ever carried. A fork installed before the
# kit kept installed copies is compared against these; the lines of its copy found here are the kit's, the rest
# are the project's own. Run from anywhere inside the kit repository before a release; the kit ships the output.
set -u
SRC="$(cd "$(dirname "$0")/../.." && pwd)"; OUT="$SRC/meta-bootstrap/history"
cd "$SRC" || exit 1
for f in meta-*/SKILL.md meta-foundation/INTENT.md; do
  [ -f "$f" ] || continue
  name="${f%/*}"; [ "$f" = meta-foundation/INTENT.md ] && name="meta-foundation.INTENT"
  { for c in $(git log --format=%h --all -- "$f"); do git show "$c:$f" 2>/dev/null; done; cat "$f"; } \
    | tr -d '\r' | sed 's/[[:space:]]*$//' | grep -v '^$' | LC_ALL=C sort -u > "$OUT/$name.lines"
done
ls "$OUT"/*.lines | wc -l
