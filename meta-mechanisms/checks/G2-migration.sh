#!/usr/bin/env bash
# G2-migration — contract-008 G-2. The upgrade's step 7 migrates records additively and was verified only for
# preservation (every old line survives). On the first real fork the rehearsal caught three defects by hand that
# preservation cannot see — a key inserted inside a block scalar, an insertion missed on some entries, and the
# real run registered eight fewer nodes than the template carries. This check makes those three failures
# mechanical. It is bash, sed and awk only (contract-001 G-3): no YAML parser is assumed, so "parses" here means
# exactly the structural walk below, and nothing more.
#
# Usage: G2-migration.sh [<skills dir> [<staged MANIFEST.template.yaml> [<pre-migration copies dir>]]]
#   <skills dir>  .claude/skills of the project (default: the folder this checks/ sits under, i.e. the kit root)
#   <template>    the staged kit's templates/MANIFEST.template.yaml (default: <skills dir>/templates/MANIFEST.template.yaml)
#   <pre dir>     the copies step 7 took before migrating, at their relative paths (meta-drift-eventlog/DRIFTLOG.yaml …);
#                 optional — the contiguity check (4) runs only when it is given
#
# Checked, in order, exit 1 on the first failure with one line naming the file and the figure:
#   1. Structure. In every record outside comments and block scalars: a block-scalar indicator (`key: |`, `key: >-`, `- >-`)
#      is followed by at least one deeper line; every line is a list item, a `key:` line, a comment, or a plain
#      scalar's continuation (any line deeper than the `key: value` or bare `key:` line it continues); siblings at one indent are all list
#      items or all keys, never mixed — a sequence written at its key's own indent is that key's, not a mix.
#   2. Migrated fields. Every contract entry carries exactly one verification_state, audited, disappointment,
#      premortem (and red_test and cost unless status: approved, since both are written later); every drift entry exactly one status; every
#      correction exactly one noticed, would_have_been_right and seen_before; every manifest node exactly one
#      kind, load and triggers, and owns unless it is an agent; every ledger batch exactly one represented; the
#      manifest's kit_identity exactly one workspace (contract-010 G-2).
#   3. Completeness. Every node id in the staged template's nodes: is registered in the manifest — a node the
#      project registered under another id counts when its skill_file or agent_file is the same. Every node_id in the
#      staged template's coverage_map is a node_id in the manifest's coverage_map (contract-009 G-2).
#   4. Contiguity (with <pre dir>). Every block scalar of a pre-migration record — its key line and every content
#      line, in order — still stands as consecutive lines in the migrated record. A key inserted inside one
#      splits it, which no line-preservation diff can see and no YAML parser reliably reports.
set -u
here="$(cd "$(dirname "$0")" && pwd)"
kit="${1:-$(cd "$here/../.." && pwd)}"
tpl="${2:-$kit/templates/MANIFEST.template.yaml}"
pre="${3:-}"
fail(){ echo "G2-migration broken: $*"; exit 1; }

C="$kit/meta-contract-before-execution/CONTRACT-LOG.yaml"
D="$kit/meta-drift-eventlog/DRIFTLOG.yaml"
R="$kit/meta-correction-log/CORRECTIONS.yaml"
L="$kit/meta-ledger/LEDGER.yaml"
M="$kit/meta-manifest/MANIFEST.yaml"
for f in "$C" "$D" "$R" "$L" "$M"; do [ -f "$f" ] || fail "${f#$kit/} is missing"; done

# --- 1. structure -------------------------------------------------------------------------------------------
structure(){
  tr -d '\r' < "$1" | awk -v F="${1##*/}" '
    function ind(s){ match(s, /^ */); return RLENGTH }
    function kind(s,  t){ t=s; sub(/^ */, "", t)
      if (t ~ /^- /) return "item"
      if (t ~ /^[A-Za-z0-9_.-]+:( .*)?$/) return "key"
      return "other" }
    { line=$0; n=NR
      if (inblock) { if (line ~ /^[ \t]*$/) next; if (ind(line) > blockind) next; inblock=0 }
      if (line ~ /^[ \t]*$/ || line ~ /^ *#/) next
      i=ind(line)
      if (pendblock) { if (i <= pendind) { print "empty block scalar at line " pendline " in " F; exit 1 }; inblock=1; blockind=pendind; pendblock=0; pendplain=0; next }
      k=kind(line)
      if (pendplain && (i > pendind || (i == pendind && k=="other"))) next
      if (k=="other") { if (i > lastkeyind) next; print "unstructured line " n " in " F ": " line; exit 1 }
      pendplain=0; pendblock=0
      body=line; sub(/^ */, "", body); sub(/^- /, "", body)
      ki=i; if (line ~ /^ *- /) ki=i+2
      # block content and plain continuations are measured from the key column; a plain continuation may sit at
      # the key column itself only when it is not a key or an item (the records carry such lines and parse)
      if (body ~ /^[A-Za-z0-9_.-]+: *[|>][-+]?$/) { pendblock=1; pendind=ki; pendline=n }
      else if (line ~ /^ *- [|>][-+]?$/) { pendblock=1; pendind=i; pendline=n }
      else if (body ~ /^[A-Za-z0-9_.-]+: .+$/ && body !~ /^[A-Za-z0-9_.-]+: *[\[{"]/) { pendplain=1; pendind=ki; pendline=n }
      barekey=(k=="key" && body ~ /^[A-Za-z0-9_.-]+: *$/)
      # sibling kinds at one indent, per parent; a sequence at the indent of its own bare key belongs to that key
      while (sp>0 && stk_i[sp] > i) sp--
      if (sp>0 && stk_i[sp]==i) {
        if (stk_k[sp]=="key" && k=="item" && lastbare==i) { sp++; stk_i[sp]=i; stk_k[sp]="item"; stk_s[sp]=1 }
        else if (stk_s[sp]==1 && k=="key") { sp--; if (sp>0 && stk_i[sp]==i && stk_k[sp]!=k) { print "line " n " in " F " mixes a " k " with " stk_k[sp] "s at the same indent"; exit 1 } if (!(sp>0 && stk_i[sp]==i)) { sp++; stk_i[sp]=i; stk_k[sp]=k; stk_s[sp]=0 } }
        else if (stk_k[sp]!=k) { print "line " n " in " F " mixes a " k " with " stk_k[sp] "s at the same indent (a key at list level, or an item under a mapping)"; exit 1 }
      } else { sp++; stk_i[sp]=i; stk_k[sp]=k; stk_s[sp]=0 }
      lastbare = barekey ? ki : -1
      if (k=="key" || body ~ /^[A-Za-z0-9_.-]+:/) lastkeyind = ki
    }'
}
for f in "$C" "$D" "$R" "$L" "$M"; do out="$(structure "$f")" || fail "$out"; done

# --- 2. migrated fields ---------------------------------------------------------------------------------------
count(){ # count <file> <entrykey> <fieldkey>: "<entry> <count>" per entry, the field counted at the entry's field indent
  tr -d '\r' < "$1" | awk -v EK="$2" -v FK="$3" '
    function ind(s){ match(s, /^ */); return RLENGTH }
    $0 ~ "^ *- "EK": " { if (e!="") print e, c; e=$0; sub(/^ *- [a-z_]*: */, "", e); c=0; fi=ind($0)+2; next }
    e!="" && ind($0)==fi && $0 ~ "^ *"FK":" { c++ }
    END { if (e!="") print e, c }'
}
need(){ # need <file> <entrykey> <field> [<status that exempts a missing field>]
  count "$1" "$2" "$3" | while read -r e c; do
    if [ "$c" != 1 ]; then
      if [ -n "${4:-}" ] && tr -d '\r' < "$1" | awk -v E="$e" -v EK="$2" -v S="$4" '$0 ~ "^ *- "EK": "E"$" {f=1; next} f && /^ *- [a-z_]*: / {exit} f && $0 ~ "^    status: "S"$" {found=1} END {exit !found}'; then continue; fi
      echo "${1##*/}: entry $e carries $3 $c times, expected exactly 1"; exit 1
    fi
  done
}
for k in verification_state audited disappointment premortem; do out="$(need "$C" contract_id "$k")" || fail "$out"; done
out="$(need "$C" contract_id cost approved)" || fail "$out"   # cost is written at implemented (contract-009 revision 1)
out="$(need "$C" contract_id red_test approved)" || fail "$out"
out="$(need "$D" drift_id status)" || fail "$out"
for k in noticed would_have_been_right seen_before; do out="$(need "$R" corr_id "$k")" || fail "$out"; done
grep -q '^ *- batch_id:' "$L" && { out="$(need "$L" batch_id represented)" || fail "$out"; }

n=$(tr -d '\r' < "$M" | grep -c '^  workspace:'); [ "$n" = 1 ] || fail "${M##*/}: kit_identity carries workspace $n times, expected exactly 1 (contract-010 G-2)"

nodes(){ tr -d '\r' < "$1" | awk '/^nodes:/{f=1;next} /^[a-z_]+:/{f=0} f' ; }
nodes "$M" | awk -v F="${M##*/}" '
  function ind(s){ match(s, /^ */); return RLENGTH }
  function flush(  miss){ if (id=="") return
    miss=""; if (kn!=1) miss=miss" kind"; if (ld!=1) miss=miss" load"; if (tr!=1) miss=miss" triggers"; if (ag==0 && ow!=1) miss=miss" owns"
    if (miss!="") { print F ": node " id " lacks or duplicates" miss; exit 1 } }
  /^ *- \{/ { flush(); id=$0; sub(/.*\{ *id: */,"",id); sub(/[,}].*/,"",id)
             kn=gsub(/[ ,{]kind: /,"&"); ld=gsub(/[ ,{]load: /,"&"); tr=gsub(/[ ,{]triggers: /,"&"); ow=gsub(/[ ,{]owns: /,"&"); ag=($0 ~ /kind: agent/); flush(); id=""; next }
  /^ *- id: / { flush(); id=$0; sub(/^ *- id: */,"",id); fi=ind($0)+2; kn=ld=tr=ow=ag=0; next }
  id!="" && ind($0)==fi { if ($0 ~ /^ *kind: /) { kn++; if ($0 ~ /kind: agent/) ag=1 } if ($0 ~ /^ *load: /) ld++; if ($0 ~ /^ *triggers: /) tr++; if ($0 ~ /^ *owns: /) ow++ }
  END { flush() }' || exit 1

# --- 3. completeness against the staged template --------------------------------------------------------------
[ -f "$tpl" ] || fail "staged template not found at $tpl"
tids="$(nodes "$tpl" | grep -o -E '(- id: |\{ *id: )[A-Za-z0-9_-]+' | sed -E 's/.*id: *//' | sort -u)"
mnodes="$(nodes "$M")"
missing=""
for t in $tids; do
  if ! printf '%s\n' "$mnodes" | grep -q -E "(- id: |\{ *id: )$t([,} ]|$)"; then
    sf="$(nodes "$tpl" | grep -E "(- id: |\{ *id: )$t([,} ]|$)" | grep -o -E '(skill_file|agent_file): [^,}]+' | head -1 | sed 's/^[a-z_]*: //')"
    if [ -z "$sf" ] || ! printf '%s\n' "$mnodes" | grep -q -F "$sf"; then missing="$missing $t"; fi
  fi
done
[ -z "$missing" ] || fail "${M##*/} lacks $(echo "$missing" | wc -w | tr -d ' ') node(s) the staged template registers:$missing"
# coverage lines (contract-009 G-2): every node_id the staged template's coverage_map carries is one in the manifest's
covids(){ tr -d '\r' < "$1" | awk '/^coverage_map:/{f=1;next} /^[a-z_]+:/{f=0} f' | grep -o 'node_id: [A-Za-z0-9_-]*' | sed 's/node_id: //' | sort -u; }
mcov="$(covids "$M")"; missing=""
for t in $(covids "$tpl"); do printf '%s\n' "$mcov" | grep -q -x "$t" || missing="$missing $t"; done
[ -z "$missing" ] || fail "${M##*/} lacks $(echo "$missing" | wc -w | tr -d ' ') base coverage line(s) the staged template carries:$missing"

# --- 4. contiguity of every pre-migration block scalar ---------------------------------------------------------
# A block is identified by its first content line, not its key line (`concern: >-` recurs). A block whose first
# content line is gone from the migrated record was removed by design (a base node line the template rule
# replaced) and is not checked; one whose content survives must survive as consecutive lines.
if [ -n "$pre" ]; then
  [ -d "$pre" ] || fail "pre-migration copies dir not found at $pre"
  for rel in meta-contract-before-execution/CONTRACT-LOG.yaml meta-drift-eventlog/DRIFTLOG.yaml meta-correction-log/CORRECTIONS.yaml meta-ledger/LEDGER.yaml meta-manifest/MANIFEST.yaml; do
    [ -f "$pre/$rel" ] || continue
    out="$(tr -d '\r' < "$pre/$rel" | awk -v NEW="$kit/$rel" -v F="${rel##*/}" '
      function ind(s){ match(s, /^ */); return RLENGTH }
      function trimblanks(b){ while (b ~ /\n[ \t]*$/) sub(/\n[ \t]*$/, "", b); return b }
      function trim(s){ sub(/^ */, "", s); return substr(s, 1, 70) }
      function check(  b){ b=trimblanks(blk); if (first=="") return
        if (index(txt, first "\n")==0) return
        if (index(txt, b "\n")==0) { print F ": the block scalar whose text begins `" trim(first) "` is no longer contiguous - a line was inserted inside it"; failed=1; exit 1 } }
      BEGIN { while ((getline l < NEW) > 0) txt = txt l "\n"; close(NEW) }
      { if (inblock) { if ($0 ~ /^[ \t]*$/ || ind($0) > blockind) { blk=blk "\n" $0; if (first=="" && $0 !~ /^[ \t]*$/) first=$0; next }
                       check(); inblock=0 }
        body=$0; sub(/^ *(- )?/, "", body)
        if (body ~ /^[A-Za-z0-9_.-]+: *[|>][-+]?$/ || body ~ /^[|>][-+]?$/) { inblock=1; blockind=ind($0); blk=$0; first="" } }
      END { if (inblock && !failed) check() }')" || fail "$out"
  done
fi
exit 0
