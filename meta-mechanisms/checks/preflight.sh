#!/usr/bin/env bash
# preflight.sh check|begin|end [install] — the ground is checked before an install or an upgrade touches anything
# (contract-017 UC-2, UC-3). Run from the project's root, from the NEW kit's copy of this script:
#   upgrade:  bash .claude/kit-incoming/meta-mechanisms/checks/preflight.sh check
#   install:  bash .claude/skills/meta-mechanisms/checks/preflight.sh check install
#   check   looks and changes nothing. Every refusal is printed, each with its reason, then exit 1.
#   begin   the same checks, then records the starting point in .claude/kit-upgrade.lock — the last commit in a
#           repository, a kept copy (.claude.before-upgrade/) outside one. rollback.sh restores from it.
#   end     removes the lock. The kept copy, if there is one, stays until the pioneer deletes it.
# Exit 0 passed · 1 refused · 2 usage · 3 nothing to do (the staged version is the installed one).
mode="${1:-}"; kind="${2:-upgrade}"
case "$mode" in check|begin|end) ;; *) echo "usage: preflight.sh check|begin|end [install]" >&2; exit 2 ;; esac
here="$(cd "$(dirname "$0")" && pwd)"; REL="$(cd "$here/../.." && pwd)"; ROOT="$PWD"
LOCK="$ROOT/.claude/kit-upgrade.lock"; KEEP="$ROOT/.claude.before-upgrade"
[ -d "$ROOT/.claude" ] || { echo "refused: run this from the project's root — there is no .claude folder in $ROOT"; exit 1; }

if [ "$mode" = end ]; then
  rm -f "$LOCK"; echo "preflight: the lock is removed."
  [ -d "$KEEP" ] && echo "The copy kept before the upgrade is still at .claude.before-upgrade/ — delete it when you no longer want the way back."
  exit 0
fi

bad=0; refuse() { bad=1; printf 'refused: %s\n' "$1"; }; note() { printf 'note: %s\n' "$1"; }

# 1. git — the upgrade's snapshot, its way back and its merge
if ! command -v git >/dev/null 2>&1; then
  refuse "git is not available. The upgrade uses git to take its snapshot, to find its way back, and to merge your own lines into the new kit. Install git and start again."
fi

# 2. the new kit is a whole release
if [ ! -f "$REL/RELEASE" ] || [ ! -f "$REL/RELEASE.sha1" ]; then
  refuse "the new kit in ${REL#$ROOT/} is not a release: it has no RELEASE file and no list of its files. Build it in the kit's repository with meta-bootstrap/release.sh and place that folder here. A raw copy of the repository carries the kit's own records and must not be used."
else
  miss=0; diff=0; first=""
  while IFS= read -r line; do
    h="${line%%  *}"; p="${line#*  }"; [ -n "$p" ] || continue
    if [ ! -f "$REL/$p" ]; then miss=$((miss+1)); [ -n "$first" ] || first="$p (missing)"
    elif [ "$(tr -d '\r' < "$REL/$p" | sha1sum | cut -c1-40)" != "$h" ]; then diff=$((diff+1)); [ -n "$first" ] || first="$p (changed)"; fi
  done < <(tr -d '\r' < "$REL/RELEASE.sha1")
  extra=0
  if [ "$kind" != install ]; then   # after an install the folder also holds the project's own records; a staged kit holds nothing else
    listed=$(tr -d '\r' < "$REL/RELEASE.sha1" | cut -c43-)
    while IFS= read -r -d '' f; do
      p="${f#$REL/}"; case "$p" in RELEASE|RELEASE.sha1) continue ;; esac
      printf '%s\n' "$listed" | grep -q -x -F -- "$p" || { extra=$((extra+1)); [ -n "$first" ] || first="$p (not on the list)"; }
    done < <(find "$REL" -type f -print0)
  fi
  if [ $((miss+diff+extra)) -gt 0 ]; then
    refuse "the new kit is not whole: $miss file(s) missing, $diff changed, $extra not on its own list — first: $first. Build it again with meta-bootstrap/release.sh and place that folder here unchanged."
  fi
fi

# 3. versions (upgrade only)
newv=$(tr -d '\r' < "$REL/RELEASE" 2>/dev/null | awk '/^version:/{print $2; exit}')
if [ "$kind" != install ]; then
  M="$ROOT/.claude/skills/meta-manifest/MANIFEST.yaml"
  if [ ! -f "$M" ]; then refuse "this project has no manifest at .claude/skills/meta-manifest/MANIFEST.yaml, so there is no installed kit to upgrade. Use the install instead."
  else
    oldv=$(tr -d '\r' < "$M" | awk '/^[[:space:]]+base_kit_version:/{print $2; exit}')
    if [ -n "$newv" ] && [ "$oldv" = "$newv" ] && [ "$bad" = 0 ]; then echo "nothing to do: this project is already on base kit $newv."; exit 3; fi
  fi
fi

# 4. no upgrade already under way
if [ -f "$LOCK" ]; then
  refuse "an install or upgrade was started here and did not finish ($(tr -d '\r' < "$LOCK" | awk '/^started:/{print $2}')). A half-finished run is never continued: restore the project with  bash ${here#$ROOT/}/rollback.sh  and start again."
fi

# 5. no review batch open — while one is, this session cannot read the ledger the upgrade has to migrate
LEDGER="$ROOT/.claude/skills/meta-ledger/LEDGER.yaml"
if [ "$kind" != install ] && [ -f "$LEDGER" ] && grep -v '^[[:space:]]*#' "$LEDGER" | grep -q -E '^[[:space:]]+decided:[[:space:]]*false'; then
  refuse "a review batch is open. While it is, this session cannot read the ledger, and the upgrade has to migrate it. Finish the batch, or close it, and start again."
fi

# 6. the pioneer's own work is committed first (C-023): warn, say why, ask
snapshot=""
if command -v git >/dev/null 2>&1 && git -C "$ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if [ "$kind" = install ]; then skip=':!.claude/skills'; else skip=':!.claude/kit-incoming'; fi
  # the rehearsal log is the upgrade's own file, written by the step before this one: it is committed with the
  # upgrade, not before it (found by the first rehearsal that followed this script: the log it was told to write
  # made the next step refuse)
  dirty=$(git -C "$ROOT" status --porcelain --untracked-files=all -- . "$skip" ':!.claude/kit-upgrade.lock' ':!docs/reports/rehearsal-*.md' 2>/dev/null)
  if [ -n "$dirty" ]; then
    n=$(printf '%s\n' "$dirty" | grep -c .)
    refuse "you have $n uncommitted change(s) — first: $(printf '%s\n' "$dirty" | head -n1 | cut -c4-). Please commit and push your ongoing work before this starts. The reason: it uses git. Your last commit is its snapshot and its way back, and git merges your own lines into the new kit. From a clean start, everything it changes stays apart from your work, the result is one clean commit, and undoing it is one command."
  fi
  ahead=$(git -C "$ROOT" rev-list --count '@{u}..HEAD' 2>/dev/null || true)
  [ -n "$ahead" ] && [ "$ahead" != 0 ] && note "$ahead commit(s) are not pushed yet. Push them too if you want the snapshot to exist off this machine."
  snapshot="commit $(git -C "$ROOT" rev-parse HEAD 2>/dev/null)"
else
  note "this project is not a git repository, so the snapshot will be a copy kept at .claude.before-upgrade/ (git still does the merging)."
  snapshot="copy .claude.before-upgrade"
fi

[ "$bad" = 0 ] || exit 1
if [ "$mode" = check ]; then echo "preflight passed: nothing was changed. The way back will be: $snapshot."; exit 0; fi

# begin: record the starting point
if [ "$snapshot" = "copy .claude.before-upgrade" ]; then
  rm -rf "$KEEP"; mkdir -p "$KEEP/_root"
  ( cd "$ROOT/.claude" && for e in * .[!.]*; do [ -e "$e" ] || continue; [ "$e" = kit-incoming ] && continue; cp -R "$e" "$KEEP/"; done )
  for f in CLAUDE.md .gitignore .gitattributes; do [ -f "$ROOT/$f" ] && cp "$ROOT/$f" "$KEEP/_root/"; done
fi
printf 'started: %s\nkind: %s\nto: %s\nsnapshot: %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$kind" "${newv:-unknown}" "$snapshot" > "$LOCK"
echo "preflight passed and the starting point is recorded ($snapshot). If this run stops before its end, restore with  bash ${here#$ROOT/}/rollback.sh  and start again."
