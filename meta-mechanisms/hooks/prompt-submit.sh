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

printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"%s"}}\n' "$(json_escape "$msg")"
