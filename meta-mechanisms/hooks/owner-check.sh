#!/usr/bin/env bash
# PostToolUse (matcher: Write|Edit) — the ownership check. Governed by meta-mechanisms/SKILL.md (contract-004 G-5).
# A record edited in a session that never loaded the skill that governs it is one `bypass` line in telemetry.
# Read by kit-map-steward alone (G-6): no hook or skill prints the count to the acting session.
# Main session only; never blocks; never prints.
#
# Ownership comes from MANIFEST.yaml: each node's `owns:` lists paths, relative to .claude/skills/, that the
# node's skill governs; a folder owns everything under it. Both manifest forms are read — the one-line flow
# form the template seeds (`- {id: x, ..., owns: [a, b], ...}`) and the block form.
# "Loaded" means a `loaded|<skill_file>` or `loaded|skill:<folder>` line since the last session-start whose
# source was startup or clear: a resume or compaction keeps what was loaded in context, a clear does not.
. "$(dirname "$0")/lib.sh"
read_input
kit_installed || exit 0
in_subagent && exit 0

p=$(norm_path "$(json_str file_path)")
case "$p" in
  */.claude/skills/*) rel="${p##*/.claude/skills/}" ;;
  *) exit 0 ;;
esac
[ -n "$rel" ] || exit 0
[ -f "$MANIFEST" ] || exit 0

# owners — one "node|skill_file" per node whose owns: covers the edited path
owners=$(awk -v rel="$rel" '
  function trim(s) { gsub(/^[[:space:]"]+|[[:space:]"]+$/, "", s); return s }
  function owns_list(s,   n, a, i, o) {
    n = split(s, a, ",")
    for (i = 1; i <= n; i++) { o = trim(a[i]); if (o != "" && index(rel, o) == 1) hit = 1 }
  }
  function flush() { if (id != "" && hit) print id "|" sf; id = ""; sf = ""; hit = 0; inowns = 0 }
  /^[[:space:]]*#/ { next }
  /^[[:space:]]*-[[:space:]]*\{/ {                                   # flow node, one line
    flush(); line = $0
    if (match(line, /(\{|,)[[:space:]]*id:[[:space:]]*[^,}]+/)) {
      id = substr(line, RSTART, RLENGTH); sub(/.*id:[[:space:]]*/, "", id); id = trim(id)
    } else next
    if (match(line, /skill_file:[[:space:]]*[^,}]+/)) {
      sf = substr(line, RSTART, RLENGTH); sub(/skill_file:[[:space:]]*/, "", sf); sf = trim(sf)
    }
    if (match(line, /owns:[[:space:]]*\[[^]]*\]/)) {
      o = substr(line, RSTART, RLENGTH); sub(/owns:[[:space:]]*\[/, "", o); sub(/\]$/, "", o); owns_list(o)
    }
    flush(); next
  }
  /^[[:space:]]*-[[:space:]]+id:[[:space:]]*[^[:space:]]/ { flush(); id = trim($3); next }   # block node
  /^[[:space:]]*-[[:space:]]+[a-z_]+_id:/ { flush(); next }                                    # gaps, coverage
  /^[a-z_]+:/ { flush(); next }
  id == "" { next }
  /^[[:space:]]+skill_file:[[:space:]]*[^[:space:]]/ { sf = trim($2); inowns = 0; next }
  /^[[:space:]]+owns:[[:space:]]*\[/ { o = $0; sub(/.*owns:[[:space:]]*\[/, "", o); sub(/\].*/, "", o); owns_list(o); inowns = 0; next }
  /^[[:space:]]+owns:[[:space:]]*$/ { inowns = 1; next }
  inowns && /^[[:space:]]+-[[:space:]]+/ { o = $0; sub(/^[[:space:]]+-[[:space:]]+/, "", o); sub(/[[:space:]]*#.*$/, "", o); owns_list(o); next }
  /^[[:space:]]+[a-z_]+:/ { inowns = 0 }
  END { flush() }
' "$MANIFEST")
[ -n "$owners" ] || exit 0

# what this session has loaded: telemetry after the last session-start|startup or session-start|clear
recent=""
if [ -f "$TELEMETRY" ]; then
  recent=$(awk '/\|session-start\|(startup|clear)$/ { buf = ""; next } { buf = buf $0 "\n" } END { printf "%s", buf }' "$TELEMETRY")
fi

printf '%s\n' "$owners" | while IFS='|' read -r node sf; do
  [ -n "$node" ] || continue
  # Files that arrive by CLAUDE.md import are in context every session without a Read, so no `loaded` line can
  # ever exist for them; an owner whose skill file is one of them counts as loaded (contract-007 G-10).
  case "$sf" in *INTENT.md|*MAP.md|*FOUNDING.md) continue ;; esac
  folder="${sf%%/*}"
  if [ -n "$sf" ] && printf '%s' "$recent" | grep -qE "\|loaded\|(${sf}|skill:${folder})\$"; then
    continue
  fi
  telemetry bypass "${node}|${rel}"
done
exit 0
