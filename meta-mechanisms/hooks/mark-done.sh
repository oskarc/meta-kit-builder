#!/usr/bin/env bash
# mark-done.sh install|upgrade — the done block's last act (contract-011 G-5). Writes one `done` line to telemetry;
# from then until the next session start the stop-gate's review-batch step hands over nothing, so "nothing is
# required now" holds for the rest of the session. Audits and verification are not held. Run by the agent with
# Bash at the end of the install's Step 7 or the upgrade's step 9. Governed by meta-mechanisms/SKILL.md.
. "$(dirname "$0")/lib.sh"
case "${1:-}" in
  install|upgrade) ;;
  *) echo "usage: mark-done.sh install|upgrade" >&2; exit 2 ;;
esac
[ -d "$KIT/meta-ledger" ] || { echo "No ledger folder at $KIT/meta-ledger" >&2; exit 1; }
telemetry done "$1"
echo "Done marked ($1). The review batch waits for the next session; audits and verification do not."
