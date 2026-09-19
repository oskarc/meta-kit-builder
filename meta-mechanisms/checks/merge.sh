#!/usr/bin/env bash
# merge.sh — put the pioneer's own lines onto the new kit's text (contract-017 UC-5). Two jobs, one rule each.
#
#   merge.sh <yours> <shipped-last-time> <new> <out>
#       A kit skill or a template the project edited. git's three-way merge: what changed between the base and
#       <yours> is the pioneer's, what changed between the base and <new> is the kit's; each edit stays where it was
#       made. <shipped-last-time> is the installed copy of the skill, or the template the last install shipped.
#       Exit 0 merged cleanly · n (1-127) n conflicts: <out> holds both versions between <<<<<<< yours and
#       >>>>>>> new-kit markers, and each is printed here so the sheet can show it. Nothing is resolved unasked.
#   merge.sh --take yours|kit|both <yours> <shipped-last-time> <new> <out>
#       The same merge with every conflict in the file settled one way - the pioneer's answer from the sheet, or
#       "kit" in a rehearsal copy, which has to go on through the remaining steps without markers in it. "both" is
#       the kit's lines, then the pioneer's. Exit 0; says how many conflicts were settled. Different answers for
#       different conflicts in one file are applied by hand, at the markers, and no marker may be left.
#
#   merge.sh --header[-port|-overwrite] <record> <old template> <new template> <out>
#       The comment block at the head of a record — instruction, which an upgrade refreshes; the record's body is
#       carried over untouched. The rule is the template rule's, not a merge: the new template's block, and beneath it
#       every line of the record's block that the OLD template never had — the pioneer's notes, in their order.
#       Exit 0, and prints how many notes were kept. Exit 3, writing nothing: the record's block shares no line with
#       the old template's, so the pioneer replaced it wholesale — that is the instance-file question, theirs to
#       answer: --header-port writes the new block with all of theirs beneath it, --header-overwrite the new block
#       alone, and "keep" is not running this at all.
#
# Works on plain files; the project need not be a repository. Carriage returns are set aside; <out> has LF endings.
# Exit 200: usage, a missing file, or git missing. An install from before the kit kept installed copies has no base
# for the first job: residue.sh measures the pioneer's lines there, against the line history.
job=merge; take=""
case "${1:-}" in --header) job=header; shift ;; --header-port) job=port; shift ;; --header-overwrite) job=overwrite; shift ;;
  --take) take="${2:-}"; shift 2 2>/dev/null; case "$take" in yours|kit|both) ;; *) echo "merge.sh: --take yours|kit|both" >&2; exit 200 ;; esac ;; esac
[ $# -eq 4 ] && [ -f "$1" ] && [ -f "$2" ] && [ -f "$3" ] || { echo "usage: merge.sh [--header|--header-port|--header-overwrite] <yours> <old> <new> <out>" >&2; exit 200; }
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
for i in 1 2 3; do eval "f=\${$i}"; tr -d '\r' < "$f" > "$T/$i"; done

if [ "$job" = merge ]; then
  command -v git >/dev/null 2>&1 || { echo "merge.sh: git is not available" >&2; exit 200; }
  if [ -n "$take" ]; then
    cp "$T/1" "$T/1.probe"; git merge-file "$T/1.probe" "$T/2" "$T/3" >/dev/null 2>&1; n=$?
    case "$take" in yours) flag=--ours ;; kit) flag=--theirs ;; both) flag=--union ;; esac
    # --union keeps the current side's lines first; "both" is the kit's lines, then the pioneer's, so the sides are swapped
    if [ "$take" = both ]; then cp "$T/3" "$T/out"; git merge-file --union "$T/out" "$T/2" "$T/1" >/dev/null 2>&1
    else cp "$T/1" "$T/out"; git merge-file $flag "$T/out" "$T/2" "$T/3" >/dev/null 2>&1; fi
    grep -q -E '^(<<<<<<<|>>>>>>>) ' "$T/out" && { echo "merge.sh: markers left after --take $take" >&2; exit 200; }
    cp "$T/out" "$4"; echo "merge.sh: $n conflict(s) settled as: $take."; exit 0
  fi
  git merge-file -L yours -L shipped-last-time -L new-kit "$T/1" "$T/2" "$T/3" >/dev/null 2>&1; rc=$?
  [ "$rc" -ge 0 ] && [ "$rc" -le 127 ] || { echo "merge.sh: git merge-file failed ($rc)" >&2; exit 200; }
  cp "$T/1" "$4"
  if [ "$rc" -gt 0 ]; then
    echo "merge.sh: $rc conflict(s) — the pioneer's edit and the kit's change meet in the same lines:"
    awk '/^<<<<<<< /{f=1} f{print "  " $0} /^>>>>>>> /{f=0; print ""}' "$T/1"
  fi
  exit "$rc"
fi

# the block: in YAML the run of # lines (and blank lines) that opens the file; in Markdown the first <!-- … --> comment
# a Markdown record opens with its title, a YAML record with its block: tell them by the first line of the NEW template
if head -n1 "$T/3" | grep -q '^#[^!]' && grep -q '^<!--' "$T/3"; then kind=md; else kind=yaml; fi
if [ "$kind" = md ]; then
  for i in 1 2 3; do awk -v pre="$T/$i.pre" -v blk="$T/$i.blk" -v post="$T/$i.post" '
    BEGIN { printf "" > pre; printf "" > blk; printf "" > post; s = 0 }
    s == 0 && /^<!--/ { s = 1 }
    s == 0 { print > pre; next }
    s == 1 { print > blk; if (/-->/) s = 2; next }
    { print > post }' "$T/$i"; done
else
  for i in 1 2 3; do awk -v pre="$T/$i.pre" -v blk="$T/$i.blk" -v post="$T/$i.post" '
    BEGIN { printf "" > pre; printf "" > blk; printf "" > post; s = 1 }
    s == 1 && /^[^#]/ { s = 2 }
    s == 1 { print > blk; next }
    { print > post }' "$T/$i"; done
fi
shared=$(grep -x -F -f "$T/2.blk" "$T/1.blk" | grep -c '[^[:space:]]')
grep -v -x -F -f "$T/2.blk" "$T/1.blk" | grep '[^[:space:]]' > "$T/notes" || true
[ "$kind" = md ] && { grep -v -e '^<!--[[:space:]]*$' -e '^-->[[:space:]]*$' "$T/notes" > "$T/notes2" || true; mv "$T/notes2" "$T/notes"; }
n=$(grep -c '' "$T/notes")
if [ "$job" = header ] && [ "$shared" = 0 ] && [ -s "$T/2.blk" ] && [ -s "$T/1.blk" ]; then
  echo "merge.sh: the record's header shares no line with the old template's — the pioneer replaced it wholesale ($n line(s) of theirs). Nothing written: this is the instance-file question — keep, overwrite (--header-overwrite) or port (--header-port)."
  exit 3
fi
[ "$job" = overwrite ] && { : > "$T/notes"; n=0; }
{
  cat "$T/1.pre"
  if [ "$kind" = md ]; then
    # notes go inside the comment, before the line that closes it
    awk -v notes="$T/notes" '/-->/ && !done { while ((getline l < notes) > 0) print l; done = 1 } { print }' "$T/3.blk"
  else
    # beneath the refreshed block: after its last comment line, before the blank line that ends it
    awk -v notes="$T/notes" '{ a[NR] = $0 } END { last = NR; while (last > 0 && a[last] ~ /^[[:space:]]*$/) last--; for (i = 1; i <= last; i++) print a[i]; while ((getline l < notes) > 0) print l; for (i = last + 1; i <= NR; i++) print a[i] }' "$T/3.blk"
  fi
  cat "$T/1.post"
} > "$4"
echo "merge.sh: header refreshed; $n line(s) that the old template never had are kept beneath it:"; sed 's/^/  /' "$T/notes"
# the lines are shown because a count is not evidence of whose they are: a note of the pioneer's and a line of a still
# older template both read as "not in the old template", and both are kept - nothing is lost, and the reader can see which
exit 0
