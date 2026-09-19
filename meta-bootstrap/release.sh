#!/usr/bin/env bash
# release.sh <outdir> — build a release of the kit (contract-017 UC-1). Run from anywhere inside the kit repository.
# A release is built from a COMMIT, never from the working tree: `git archive` exports the shipping folders
# (meta-*, agents, templates) as committed, not-shipped.txt says what is then left out, and two files are written
# beside the result:
#   RELEASE        what this is: kit, version, the commit it was built from, the date, the number of files
#   RELEASE.sha1   every shipped file with its hash (carriage returns removed first, as the install baseline does),
#                  which is how preflight.sh tells a whole staged kit from a raw clone or a partial copy
# <outdir> is what a pioneer places in a project's .claude/kit-incoming/ (upgrade) or .claude/skills/ (install).
# --from-last-commit builds from HEAD although the tree has uncommitted changes, and says so; it is for tests.
# Does not travel: it only works where the kit's history is.
set -e
SRC="$(cd "$(dirname "$0")/.." && pwd)"
ALLOW=0; [ "${1:-}" = "--from-last-commit" ] && { ALLOW=1; shift; }
OUT="${1:?usage: release.sh [--from-last-commit] <outdir>}"
command -v git >/dev/null 2>&1 || { echo "release refused: git is not available"; exit 1; }
# <outdir> is read where the command was typed, not where the kit is, so it is resolved BEFORE moving to the kit,
# and refused when it points inside the kit repository: a release built there sits in the source it ships from
# (contract-018, from the upgrade rehearsal, where a relative path silently wrote the release into the kit clone).
case "$OUT" in /*|[A-Za-z]:*) ;; *) OUT="$PWD/$OUT" ;; esac
od=$(dirname "$OUT"); ob=$(basename "$OUT"); if [ -d "$od" ]; then OUT="$(cd "$od" && pwd)/$ob"; fi
case "$OUT/" in "$SRC"/*) echo "release refused: <outdir> is inside the kit repository ($OUT). Build the release outside it, in a folder of your own — one built in the source it ships from would be swept into the next build."; exit 1;; esac
cd "$SRC"
dirs=$(git ls-tree -d --name-only HEAD | grep -E '^(meta-.*|agents|templates)$')
if [ "$ALLOW" = 1 ] && [ -n "$(git status --porcelain -- $dirs)" ]; then
  echo "note: built from the last commit; the uncommitted changes in the shipping folders are NOT in this release"
elif [ -n "$(git status --porcelain -- $dirs)" ]; then
  echo "release refused: the shipping folders have uncommitted changes. A release is built from a commit, so what ships is what is recorded — commit first."
  exit 1
fi
if [ -e "$OUT" ] && [ -n "$(ls -A "$OUT" 2>/dev/null)" ]; then echo "release refused: $OUT exists and is not empty"; exit 1; fi
mkdir -p "$OUT"; OUT="$(cd "$OUT" && pwd)"
git archive HEAD $dirs | tar -x -C "$OUT"
grep -v -E '^[[:space:]]*(#|$)' "$SRC/meta-bootstrap/not-shipped.txt" | tr -d '\r' | while IFS= read -r pat; do
  # the pattern is expanded inside the output folder; an unmatched pattern removes nothing
  ( cd "$OUT" && for p in $pat; do [ -e "$p" ] && rm -rf "$p"; done; true )
done
version=$(git show HEAD:meta-manifest/MANIFEST.yaml | tr -d '\r' | awk '/^kit_identity:/{f=1;next} f&&/^[^ ]/{f=0} f&&/^  version:/{print $2; exit}')
[ -n "$version" ] || { echo "release refused: no kit_identity.version in the committed manifest"; exit 1; }
( cd "$OUT" && find . -type f ! -name RELEASE ! -name RELEASE.sha1 -print0 | sort -z \
  | while IFS= read -r -d '' f; do printf '%s  %s\n' "$(tr -d '\r' < "$f" | sha1sum | cut -c1-40)" "${f#./}"; done > RELEASE.sha1 )
n=$(grep -c . "$OUT/RELEASE.sha1")
printf 'kit: base-building-kit\nversion: %s\ncommit: %s\nbuilt: %s\nfiles: %s\n' "$version" "$(git rev-parse --short HEAD)" "$(date -u +%Y-%m-%d)" "$n" > "$OUT/RELEASE"
echo "release $version built from $(git rev-parse --short HEAD): $n files in $OUT"
