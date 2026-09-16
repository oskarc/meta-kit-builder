#!/usr/bin/env bash
# roots — contract-008 G-3. Step 8 of the upgrade drafts one map entry per project node that no other node
# names as a dependency. `dependencies` lists name manifest ids, never folders, so the join runs through
# skill_file: a folder registered under two ids counts once. The first real fork matched folder names against
# ids and reported 93 roots where there were 16; this script is now the only source of that list and count.
#
# Usage: roots.sh <MANIFEST.yaml>
#   prints the root ids, one per line, to stdout; the count to stderr; exit 1 if the file has no nodes.
# A project node is a node with a skill_file that does not start with `meta-` (agent nodes have agent_file and
# are never roots). bash, sed and awk only (contract-001 G-3).
set -u
m="${1:?usage: roots.sh <MANIFEST.yaml>}"
[ -f "$m" ] || { echo "roots: $m not found" >&2; exit 1; }
tr -d '\r' < "$m" | awk '
  /^nodes:/ { f=1; next } /^[a-z_]+:/ { f=0 } !f { next }
  function ind(s){ match(s, /^ */); return RLENGTH }
  function flush(){ if (id=="") return; n++; ids[n]=id; sfs[n]=sf; deps[n]=dp; id="" }
  /^ *- \{/ { flush(); id=$0; sub(/.*\{ *id: */,"",id); sub(/[,}].*/,"",id)
             sf=""; if (match($0, /skill_file: [^,}]+/)) { sf=substr($0,RSTART+12,RLENGTH-12) }
             dp=""; if (match($0, /dependencies: \[[^]]*\]/)) { dp=substr($0,RSTART+15,RLENGTH-16) }
             flush(); next }
  /^ *- id: / { flush(); id=$0; sub(/^ *- id: */,"",id); fi=ind($0)+2; sf=""; dp=""; next }
  id!="" && ind($0)==fi && /^ *skill_file: / { sf=$0; sub(/^ *skill_file: */,"",sf) }
  id!="" && ind($0)==fi && /^ *dependencies: *\[/ { dp=$0; sub(/^ *dependencies: *\[/,"",dp); sub(/\].*/,"",dp) }
  END { flush()
    if (n==0) { print "roots: no nodes found" > "/dev/stderr"; exit 1 }
    for (i=1;i<=n;i++) { k=split(deps[i], a, ","); for (j=1;j<=k;j++) { d=a[j]; gsub(/^ +| +$/,"",d); if (d!="") named[d]=1 } }
    c=0
    for (i=1;i<=n;i++) {
      if (sfs[i]=="" || sfs[i] ~ /^meta-/) continue
      folder=sfs[i]; sub(/\/.*/,"",folder)
      if (folder in seen) continue
      seen[folder]=1
      if (!(ids[i] in named)) { print ids[i]; c++ }
    }
    print c " root(s)" > "/dev/stderr"
  }'
