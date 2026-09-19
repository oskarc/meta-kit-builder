#!/usr/bin/env bash
# rollback.sh — the way back from an install or upgrade that did not finish (contract-017 UC-3). Run from the project's
# root. Reads .claude/kit-upgrade.lock, which preflight.sh wrote, and restores what the run may have touched — .claude/,
# CLAUDE.md, .gitignore, .gitattributes — to the recorded starting point:
#   snapshot: commit <id>   git restores those paths from that commit and removes what the run added under .claude/
#   snapshot: copy …        the kept copy is put back
# The staged kit (.claude/kit-incoming/) and the reports a run wrote under docs/ are left alone: the first so the run
# can be started again, the second because they say what happened. A half-finished run is never continued.
ROOT="$PWD"; LOCK="$ROOT/.claude/kit-upgrade.lock"; KEEP="$ROOT/.claude.before-upgrade"
[ -f "$LOCK" ] || { echo "nothing to restore: there is no .claude/kit-upgrade.lock here, so no install or upgrade is under way."; exit 1; }
snap=$(tr -d '\r' < "$LOCK" | awk '/^snapshot:/{sub(/^snapshot:[[:space:]]*/,""); print; exit}')
case "$snap" in
  "commit "*)
    id="${snap#commit }"
    command -v git >/dev/null 2>&1 || { echo "cannot restore: the snapshot is commit $id and git is not available."; exit 1; }
    for p in .claude CLAUDE.md .gitignore .gitattributes; do
      if git -C "$ROOT" cat-file -e "$id:$p" 2>/dev/null; then git -C "$ROOT" checkout -q "$id" -- "$p" || { echo "cannot restore $p from $id"; exit 1; }
      elif [ "$p" != .claude ] && [ -e "$ROOT/$p" ]; then rm -f "$ROOT/$p"; fi   # the run created it
    done
    # what the run added under .claude/ and the commit never had; ignored files (the seal, the session mark) are kept
    git -C "$ROOT" clean -q -fd -e kit-incoming -e kit-upgrade.lock -- .claude
    ;;
  "copy "*)
    [ -d "$KEEP" ] || { echo "cannot restore: the kept copy .claude.before-upgrade/ is gone."; exit 1; }
    ( cd "$ROOT/.claude" && for e in * .[!.]*; do [ -e "$e" ] || continue; case "$e" in kit-incoming|kit-upgrade.lock) continue ;; esac; rm -rf "$e"; done )
    ( cd "$KEEP" && for e in * .[!.]*; do [ -e "$e" ] || continue; [ "$e" = _root ] && continue; cp -R "$e" "$ROOT/.claude/"; done )
    for f in CLAUDE.md .gitignore .gitattributes; do
      if [ -f "$KEEP/_root/$f" ]; then cp "$KEEP/_root/$f" "$ROOT/$f"; else rm -f "$ROOT/$f"; fi
    done
    ;;
  *) echo "cannot restore: the lock names no snapshot I know ('$snap')."; exit 1 ;;
esac
rm -f "$LOCK"
echo "restored to the starting point ($snap). The staged kit is still in place; start the run again from its first step."
