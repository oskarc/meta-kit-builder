#!/usr/bin/env bash
# P-004 — from C-004 (M-05, contract-001).
# Holding: "I want the workflow to be handled by the agent, so no commands that needs triggers from the human."
# Shape checked: the kit ships no slash-command directory, and no node, agent, hook or template tells the
#          pioneer to run a command to move the lifecycle (no `.claude/commands` reference, no `commands/` path).
# Exit 0 when the standard holds; non-zero with one line naming what broke.
# Instance records (CORRECTIONS.yaml, LEDGER.yaml, …) are not scanned: they quote what was offered and declined.

set -u

here="$(cd "$(dirname "$0")" && pwd)"
kit="$(cd "$here/../.." && pwd)"                 # .claude/skills in a project; the repo root in the base kit
if [ -d "$kit/agents" ]; then agents="$kit/agents"; else agents="$kit/../agents"; fi

for d in "$kit" "$agents"; do
  [ -d "$d" ] || continue
  found="$(find "$d" -type d -name commands -not -path '*/research/*' -not -path '*/.git/*' 2>/dev/null | head -n 1)"
  if [ -n "$found" ]; then
    echo "P-004 broken: a commands/ directory ships with the kit at ${found} — the workflow is handled by the agent, no human-triggered commands"
    exit 1
  fi
done

files=""
for f in "$kit"/meta-*/SKILL.md "$agents"/kit-*.md "$kit"/templates/* "$kit"/meta-mechanisms/hooks/*.sh; do
  [ -f "$f" ] && files="$files
$f"
done

hit="$(printf '%s\n' "$files" | sed '/^$/d' | while IFS= read -r f; do
  if grep -nE '\.claude/commands|(^|[^A-Za-z_-])commands/' "$f" >/dev/null 2>&1; then
    printf '%s:%s\n' "$f" "$(grep -nE '\.claude/commands|(^|[^A-Za-z_-])commands/' "$f" | head -n 1 | cut -d: -f1)"
    break
  fi
done)"

if [ -n "$hit" ]; then
  echo "P-004 broken: a kit file points at a slash-command path (${hit#$kit/}) — the workflow is handled by the agent, no human-triggered commands"
  exit 1
fi

exit 0
