#!/usr/bin/env bash
# UserPromptSubmit — force the situation assessment before the agent acts. Governed by meta-mechanisms/SKILL.md.
# The forced per-turn check is what lifted skill activation from ~50% to ~100% in measured runs.
# Output: hookSpecificOutput.additionalContext. Never blocks.
. "$(dirname "$0")/lib.sh"
read_input
kit_installed || exit 0
telemetry prompt

prompt=$(json_str prompt)
msg="Kit: before acting, name this moment by its map id (meta-map/MAP.md) and load what that entry points to. Close the turn with the drift score block from INTENT.md."

if printf '%s' "$prompt" | grep -qiE "instead|wrong|not what|rather than|redo|revert|scrap|undo|go back|don'?t want|do not want|that'?s not|isn'?t right|i said|stop|reconsider|rethink"; then
  msg="$msg This prompt may correct or redirect earlier work. If it does, record it verbatim before continuing (M-07, meta-correction-log)."
fi

# The session was launched inside one installed kit and now works inside another (a cd into a repository that has
# its own kit): the hooks follow the working directory, so they are acting on the other kit's records. Said on every
# prompt for as long as it is true, because it was silent before (contract-015 G-4). A launch folder with no kit of
# its own - a projects folder opened as the workspace - is the ordinary arrangement and says nothing.
launch=$(kit_root "${CLAUDE_PROJECT_DIR:-}" 2>/dev/null || true)
if [ -n "$launch" ] && [ "$(printf '%s' "$launch" | tr '[:upper:]' '[:lower:]')" != "$(printf '%s' "$ROOT" | tr '[:upper:]' '[:lower:]')" ]; then
  msg="$msg Tell the pioneer, in plain words, before anything else: this session was started in ${launch##*/}, which has its own kit, and the working directory is now inside ${ROOT##*/}, which has a different one. The kit's hooks follow the working directory, so they are now reading and writing ${ROOT##*/}'s records, not ${launch##*/}'s. If that is not intended, change back."
fi

printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"%s"}}\n' "$(json_escape "$msg")"
