#!/usr/bin/env bash
# Run from anywhere: bash meta-mechanisms/tests/walk.sh — drives the hooks through 78 states in a temp fixture built as a real project — settings, a seal and agents: the stop-gate's lifecycle (01-36), which kit a hook acts on, the hold on the first batch and the session id (37-47), a task that cannot be done (48-56), the closing four against the question guard (57), and a workflow healing itself — the queue's depth, the hold while an agent runs, the resume, the lease that lapses and waiting told from failing (58-65), and the repairs of contract-023 — only the kit's own agents watched, a merge in place not read as silence, the batch step's jam called a fault with a place to write it down, a blocked map miss, a task with no blocked state never told to write one, and a key sealed by one script and opened by the other (66-78).
# Lifecycle walk: drive stop-gate.sh through every state of the kit's state machine.
SRC="$(cd "$(dirname "$0")/../.." && pwd)"

# The walk can fail (contract-007 G-7): the outer run captures every state line and diffs it against walk.expected,
# exiting non-zero on any difference. Regenerate the expected file only when a gate message changed by design:
#   WALK_INNER=1 bash walk.sh | grep -E '^[0-9]{2} ' | sed 's/  */ /g' > walk.expected
if [ -z "${WALK_INNER:-}" ]; then
  log="$(mktemp)"; WALK_INNER=1 bash "$0" | tee "$log"
  if d=$(grep -E '^[0-9]{2} ' "$log" | sed 's/  */ /g' | diff - "$SRC/meta-mechanisms/tests/walk.expected"); then
    echo "walk: all $(grep -cE '^[0-9]{2} ' "$log") states match walk.expected"; rm -f "$log"; exit 0
  else
    echo "walk: MISMATCH against walk.expected"; echo "$d"; rm -f "$log"; exit 1
  fi
fi

FX="$(mktemp -d)"
K="$FX/.claude/skills"
H="$K/meta-mechanisms/hooks"

mk() {
  rm -rf "$FX"
  mkdir -p "$H" "$K/meta-manifest" "$K/meta-contract-before-execution" \
           "$K/meta-ledger/batches" "$K/meta-correction-log" "$K/meta-casebook" \
           "$K/meta-drift-eventlog" "$K/meta-map" "$K/meta-founding-contract"
  cp "$SRC"/meta-mechanisms/hooks/*.sh "$H/"
  printf 'kit_type: project\nnodes: []\n'   > "$K/meta-manifest/MANIFEST.yaml"
  printf 'contracts: []\n'                  > "$K/meta-contract-before-execution/CONTRACT-LOG.yaml"
  printf 'observations: []\n'               > "$K/meta-ledger/LEDGER.yaml"
  printf 'corrections: []\n'                > "$K/meta-correction-log/CORRECTIONS.yaml"
  printf 'precedents: []\n'                 > "$K/meta-casebook/CASEBOOK.yaml"
  printf 'entries: []\n'                    > "$K/meta-drift-eventlog/DRIFTLOG.yaml"
  printf 'M-01 | x | must | INTENT.md | ratified\n' > "$K/meta-map/MAP.md"
  printf 'founding\n'                       > "$K/meta-founding-contract/FOUNDING.md"
  # a project, not a bare skills folder: the settings that wire the hooks, the seal the batch writes into, and
  # the agents the gate dispatches to (contract-021 UC-7)
  mkdir -p "$FX/.claude/kit-sealed" "$FX/.claude/agents"
  cp "$SRC/templates/settings.template.json" "$FX/.claude/settings.json"
  cp "$SRC"/agents/*.md "$FX/.claude/agents/"
}
# launch TYPE / stopped TYPE — the REAL launch and stop hooks, fed what the program sends them. Until contract-023
# this walk wrote their telemetry lines by hand, so the one walk that travels to projects never ran the hook that
# records an agent starting.
launch()  { ( cd "$FX" && printf '{"cwd":"%s","tool_name":"Agent","tool_input":{"subagent_type":"%s"}}' "$FX" "$1" | CLAUDE_PROJECT_DIR="$FX" bash "$H/agent-launch.sh" ); }
stopped() { ( cd "$FX" && printf '{"cwd":"%s","agent_type":"%s"}' "$FX" "$1" | CLAUDE_PROJECT_DIR="$FX" bash "$H/subagent-stop.sh" ); }
tel() { printf '%s|%s|%s|\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$1" "$2" >> "$K/meta-ledger/telemetry.log"; }

DEFMSG="Work done. drift score 0.1"

# show LABEL [MESSAGE] [STOP_HOOK_ACTIVE]
show() {
  local label="$1" msg="${2:-$DEFMSG}" sha="${3:-false}" r
  # every real event carries the session's working directory; sending it here is what lets the walk give the same
  # answer when it is run from inside an installed project, and keeps it out of that project's records (contract-017)
  r=$(cd "$FX" && printf '{"cwd":"%s","stop_hook_active":%s,"last_assistant_message":"%s"}' "$FX" "$sha" "$msg" \
      | CLAUDE_PROJECT_DIR="$FX" bash "$H/stop-gate.sh" 2>&1)
  if [ -z "$r" ]; then
    printf '%-62s -> (silent)\n' "$label"
  else
    printf '%-62s -> %s\n' "$label" \
      "$(printf '%s' "$r" | sed -e 's/.*additionalContext":"//' -e 's/\\n.*//' | cut -c1-300)"
  fi
}

w_ledger()      { cat > "$K/meta-ledger/LEDGER.yaml"; }
w_contracts()   { cat > "$K/meta-contract-before-execution/CONTRACT-LOG.yaml"; }
w_corr()        { cat > "$K/meta-correction-log/CORRECTIONS.yaml"; }
w_case()        { cat > "$K/meta-casebook/CASEBOOK.yaml"; }
w_drift()       { cat > "$K/meta-drift-eventlog/DRIFTLOG.yaml"; }
w_map()         { cat > "$K/meta-map/MAP.md"; }
w_batch()       { cat > "$K/meta-ledger/batches/$1.md"; }

echo "=== guards ==="
mk; show "01 clean kit"
mk; printf 'kit_type: base\nnodes: []\n' > "$K/meta-manifest/MANIFEST.yaml"
w_ledger <<'EOF'
observations:
  - obs_id: O-1
    consolidated: false
EOF
show "02 kit_type base (uninstalled) must stay silent"
mk; w_ledger <<'EOF'
observations:
  - obs_id: O-1
    consolidated: false
EOF
show "03 stop_hook_active" "$DEFMSG" true
mk; w_ledger <<'EOF'
observations:
  - obs_id: O-1
    consolidated: false
EOF
CLOSE='What should you have based the framing of the output on? The plan. What did you base the framing of the output on? The plan. Why did you choose to base the framing of the output on that? It governs. How are you presenting this to the pioneer to make sure they can align on the basis of the output? I showed the source.'
show "04 question before the closing four must defer" "Should I keep the agent? $CLOSE"
show "05 question, no closing four at all" 'Should I keep it?'
show "06 no question, the closing four present" "All set. $CLOSE"

echo "=== batch lifecycle ==="
mk; w_ledger <<'EOF'
observations:
  - obs_id: O-1
    review_due: true
batches:
  - batch_id: B-1
    decided: false
    revealed: false
EOF
w_batch B-1 <<'EOF'
## I-1
**Decision:** keep
## I-2
EOF
show "07 open batch, 1 of 2 decided"
mk; w_ledger <<'EOF'
observations: []
batches:
  - batch_id: B-1
    decided: false
    revealed: false
EOF
w_batch B-1 <<'EOF'
## I-1
**Decision:** keep
## I-2
Decision: drop
EOF
show "08 open batch, all decided -> close"
mk; w_ledger <<'EOF'
observations: []
batches:
  - batch_id: B-1   # first batch
    decided: true
    revealed: false
EOF
show "09 decided, unrevealed -> reveal (comment on id)"
mk; w_ledger <<'EOF'
observations: []
batches:
  - batch_id: B-1
    decided: true
    revealed: true
EOF
show "10 decided + revealed -> silent (no deadlock)"

echo "=== contract lifecycle ==="
mk; w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented
    verification_state: none
    audited: false
    transcript: /path/t.jsonl
    bearing: b
EOF
show "11 implemented, unaudited, transcript present -> audit"
mk; w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented
    verification_state: none
    audited: false
    transcript: null
    bearing: b
EOF
show "12 implemented, unaudited, transcript null -> fallback text"
mk; w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented
    verification_state: reported
    audited: true
    bearing: b
EOF
show "13 implemented + reported -> close three ways"
mk; w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented
    verification_state: none
    audited: true
    bearing: b
EOF
show "14 implemented + none -> verifier"
mk; w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented
    verification_state: awaiting-evidence
    audited: true
    bearing: b
EOF
show "15 awaiting-evidence -> silent (no deadlock)"
mk; w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented
    verification_state: closed-by-follow-up
    audited: true
    bearing: b
EOF
show "16 closed-by-follow-up -> silent"
mk; w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: verified
    verification_state: reported
    audited: true
    bearing: b
EOF
show "17 verified -> learning diff"
mk; w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: approved
    verification_state: none
    audited: false
EOF
show "18 no bearing -> form check"

echo "=== queues ==="
mk; w_ledger <<'EOF'
observations:
  - obs_id: O-1
    consolidated: false
EOF
show "19 unconsolidated observation -> consolidator"
mk; w_corr <<'EOF'
corrections:
  - corr_id: C-1
    clerked: false
EOF
show "20 unclerked correction -> case clerk"
mk; w_ledger <<'EOF'
observations:
  - obs_id: O-1
    stewarded: false
  - obs_id: O-2
    stewarded: false
  - obs_id: O-3
    stewarded: false
EOF
show "21 3 map misses -> steward"
mk; w_ledger <<'EOF'
observations:
  - obs_id: O-1
    stewarded: false
  - obs_id: O-2
    stewarded: false
EOF
show "22 2 map misses -> below threshold, silent"

echo "=== pioneer-owned items (step 9, must never print a count) ==="
mk; w_ledger <<'EOF'
observations:
  - obs_id: O-1
    review_due: true
  - obs_id: O-2
    review_due: true
  - obs_id: O-3
    review_due: true
EOF
show "23 review_due x3 -> assemble batch"
mk; w_ledger <<'EOF'
observations:
  - obs_id: O-1
    review_due: true
  - obs_id: O-2
    review_due: true
EOF
show "24 review_due x2 -> silent"
mk; w_ledger <<'EOF'
candidates:
  - cand_id: K-1
    state: pending
EOF
show "25 one pending candidate -> assemble batch"
mk; w_case <<'EOF'
precedents:
  - prec_id: P-1
    pioneer_ranking: pending
EOF
show "26 unranked card -> assemble batch"
mk; w_case <<'EOF'
precedents:
  - prec_id: P-1
    conflict: P-003
EOF
show "27 precedent conflict -> assemble batch"
mk; w_drift <<'EOF'
entries:
  - drift_id: d-1
    status: mitigated
EOF
show "28 mitigated drift -> assemble batch"
mk; w_map <<'EOF'
<!-- ratification: deferred -->
M-01 | x | must | INTENT.md | proposed
EOF
show "29 proposed entries, ratification deferred -> silent"
mk; w_map <<'EOF'
M-01 | x | must | INTENT.md | proposed
EOF
show "30 proposed entries, ratification run -> assemble batch"
mk; w_ledger <<'EOF'
candidates:
  - cand_id: K-1
    state: pending
batches:
  - batch_id: B-1
    decided: false
    revealed: false
EOF
w_batch B-1 <<'EOF'
## I-1
EOF
show "31 pending candidate WITH open batch -> silent (no double batch)"

echo "=== parsing traps ==="
mk; w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: verified
    verification_state: legacy
    audited: true
    bearing: b
    tier_3: |
      G-1 set status: implemented and verification_state: none on the entry
      audited: false is written by the auditor
EOF
show "32 enum words quoted in tier prose must not become state"
mk; w_contracts <<'EOF'
contracts:
  - report_id: report-1
    type: analysis-report
    status: implemented
    verification_state: none
    audited: false
EOF
show "33 analysis report entry must be skipped"
mk; w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented   # ready for audit
    verification_state: none   # nothing yet
    audited: false   # not yet
    bearing: b
EOF
show "34 trailing comments on state values"

echo "=== priority order ==="
mk; w_ledger <<'EOF'
observations:
  - obs_id: O-1
    consolidated: false
batches:
  - batch_id: B-1
    decided: false
    revealed: false
EOF
w_batch B-1 <<'EOF'
## I-1
**Decision:** keep
EOF
w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented
    verification_state: none
    audited: false
    bearing: b
EOF
show "35 close-batch outranks audit and consolidate"
mk; w_ledger <<'EOF'
observations:
  - obs_id: O-1
    consolidated: false
EOF
w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented
    verification_state: none
    audited: false
    bearing: b
EOF
show "36 audit outranks verify and consolidate"

echo "=== which kit a hook acts on, the hold on the first batch, the session id (contracts 010, 011, 015) ==="
# These states print a derived word, never a path, so walk.expected reads the same on every platform.
say() { printf '%-62s -> %s\n' "$1" "$2"; }
UNCONS='observations:
  - obs_id: O-1
    consolidated: false
'
mk; printf '%s' "$UNCONS" | w_ledger; mkdir -p "$FX/src/deep"; PLAIN="$(mktemp -d)"
r=$(cd "$FX/src/deep" && printf '{"stop_hook_active":false,"last_assistant_message":"%s"}' "$DEFMSG" | CLAUDE_PROJECT_DIR="$PLAIN" bash "$H/stop-gate.sh" 2>&1)
case "$r" in *kit-consolidator*) say "37 run from a subfolder, launched elsewhere: the kit is found" "found" ;; *) say "37 run from a subfolder, launched elsewhere: the kit is found" "NOT FOUND" ;; esac
# a second installed kit beside the first
B2="$PLAIN/kitB"; mkdir -p "$B2/.claude/skills/meta-manifest" "$B2/.claude/skills/meta-map" "$B2/.claude/skills/meta-ledger"
printf 'kit_type: project\nnodes: []\n' > "$B2/.claude/skills/meta-manifest/MANIFEST.yaml"; printf 'x\n' > "$B2/.claude/skills/meta-map/SKILL.md"; printf 'x\n' > "$K/meta-map/SKILL.md"
rm -f "$K/meta-ledger/telemetry.log"
( cd "$FX" && printf '{"tool_name":"Read","tool_input":{"file_path":"%s/.claude/skills/meta-map/SKILL.md"}}' "$B2" | CLAUDE_PROJECT_DIR="$FX" bash "$H/post-read.sh" )
grep -q '|loaded|' "$K/meta-ledger/telemetry.log" 2>/dev/null && say "38 a read of another kit's file is not this kit's evidence" "LOGGED" || say "38 a read of another kit's file is not this kit's evidence" "ignored"
# the kit's own file, reported in the platform's other spelling where there is one (Windows: C:\x for /c/x)
OWN="$FX/.claude/skills/meta-map/SKILL.md"
if command -v cygpath >/dev/null 2>&1; then
  M=$(cygpath -m "$FX"); DFX="/$(printf '%s' "${M%%:*}" | tr '[:upper:]' '[:lower:]')${M#*:}"; W=$(cygpath -w "$DFX/.claude/skills/meta-map/SKILL.md"); OWN=${W//\\/\\\\}
else DFX="$FX"; fi
rm -f "$K/meta-ledger/telemetry.log"
( cd "$DFX" && printf '{"tool_name":"Read","tool_input":{"file_path":"%s"}}' "$OWN" | CLAUDE_PROJECT_DIR="$DFX" bash "$DFX/.claude/skills/meta-mechanisms/hooks/post-read.sh" )
grep -q '|loaded|meta-map/SKILL.md' "$K/meta-ledger/telemetry.log" 2>/dev/null && say "39 the kit's own file, in the platform's other spelling, is logged" "logged" || say "39 the kit's own file, in the platform's other spelling, is logged" "NOT LOGGED"

# the hold: an install has just ended (the baseline exists), mark-done.sh was never run, no session has started since
PEND='M-01 | x | must | INTENT.md | proposed
'
mk; printf '%s' "$PEND" | w_map; printf 'x  y\n' > "$K/meta-manifest/INSTALLED.sha1"
show "40 install just ended, done script never run: batch held"
w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented
    verification_state: none
    audited: false
    bearing: b
    transcript: 8f2c1e9a-3b7d-4c55-9a10-6e2f0d4b7c31
EOF
r=$(cd "$FX" && printf '{"cwd":"%s","stop_hook_active":false,"last_assistant_message":"%s"}' "$FX" "$DEFMSG" | CLAUDE_PROJECT_DIR="$FX" bash "$H/stop-gate.sh" 2>&1)
case "$r" in *"session id 8f2c1e9a-3b7d-4c55-9a10-6e2f0d4b7c31"*) say "41 during the hold an audit is still handed over, by session id" "audit, by session id" ;; *kit-session-auditor*) say "41 during the hold an audit is still handed over, by session id" "audit, NO ID" ;; *) say "41 during the hold an audit is still handed over, by session id" "NOT HANDED OVER" ;; esac
printf 'contracts: []\n' | w_contracts
r=$(cd "$FX" && printf '{"cwd":"%s","source":"startup","session_id":"8f2c1e9a-3b7d-4c55-9a10-6e2f0d4b7c31"}' "$FX" | CLAUDE_PROJECT_DIR="$FX" bash "$H/session-start.sh" 2>&1)
case "$r" in *"8f2c1e9a-3b7d-4c55-9a10-6e2f0d4b7c31"*) say "42 session start names the session's id" "named" ;; *) say "42 session start names the session's id" "NOT NAMED" ;; esac
r=$(cd "$FX" && printf '{"cwd":"%s","stop_hook_active":false,"last_assistant_message":"%s"}' "$FX" "$DEFMSG" | CLAUDE_PROJECT_DIR="$FX" bash "$H/stop-gate.sh" 2>&1)
case "$r" in *kit-batch-assembler*) say "43 after the next session start the batch is handed over" "handed over" ;; *) say "43 after the next session start the batch is handed over" "STILL HELD" ;; esac
sleep 1; printf 'x  z\n' > "$K/meta-manifest/INSTALLED.sha1"
show "44 an upgrade ends mid-session (baseline rewritten): held again"

# the governing kit changes under a session: said aloud only when both folders hold an installed kit and they differ
ps() { ( cd "$2" && printf '{"prompt":"add a feature"}' | CLAUDE_PROJECT_DIR="$1" bash "$2/.claude/skills/meta-mechanisms/hooks/prompt-submit.sh" 2>&1 ); }
mk; mkdir -p "$B2/.claude/skills/meta-mechanisms/hooks"; cp "$SRC"/meta-mechanisms/hooks/*.sh "$B2/.claude/skills/meta-mechanisms/hooks/"
r=$(ps "$FX" "$FX");    case "$r" in *"has a different one"*) say "45 launched in kit A, working in kit A" "SAYS SO" ;; *) say "45 launched in kit A, working in kit A" "(says nothing of it)" ;; esac
r=$(ps "$PLAIN" "$FX"); case "$r" in *"has a different one"*) say "46 launched in a plain folder, working in kit A" "SAYS SO" ;; *) say "46 launched in a plain folder, working in kit A" "(says nothing of it)" ;; esac
r=$(ps "$FX" "$B2");    case "$r" in *"has a different one"*"kitB"*) say "47 launched in kit A, working in kit B" "tells the pioneer, naming both" ;; *) say "47 launched in kit A, working in kit B" "SILENT" ;; esac
rm -rf "$PLAIN"


echo "=== a task that cannot be done: the third state, the skip, the ask and the repetition fault (contract-019) ==="
BLOCKED_LOG='contracts:
  - contract_id: c-1
    status: implemented
    verification_state: none
    audited: blocked
    blocked_since: 2026-09-20
    blocked_reason: the transcript is 70 MB and the search returns whole turns, so the auditor fills before it reads
    blocked_waiting_for: a digest built by checks/transcript-digest.sh
    bearing: |
      audited: false in here is prose, not state
'
mk; printf '%s' "$BLOCKED_LOG" | w_contracts
show "48 a blocked task is put to the pioneer before anything else is routed"
show "49 ...and not again in the same sitting: the queue below it runs"
printf '2026-09-20T00:00:00Z|session-start|startup|\n' >> "$K/meta-ledger/telemetry.log"
show "50 a new sitting puts it to the pioneer again"
mk; printf '%s' "$BLOCKED_LOG" | sed 's/audited: blocked/audited: false/' | w_contracts
show "51 cleared, the same task is handed over as before"
show "52 ...twice is still a backlog"
show "53 ...three turns running with nothing changed is a fault, with an action suggested"
show "54 ...and the turn after the fault routes normally again"
mk; printf 'corrections:\n  - corr_id: C-1\n    clerked: blocked\n    blocked_since: 2026-09-20\n    blocked_reason: the correction names a record the project does not have\n    blocked_waiting_for: the pioneer to say which record was meant\n' | w_corr
show "55 a blocked correction is put to the pioneer, and the clerk is not asked for it"
show "56 ...and with it announced, nothing else is due"
echo "=== the closing four and the question guard (contract-020) ==="
mk; printf 'observations:
  - obs_id: O-1
    consolidated: false
' > "$K/meta-ledger/LEDGER.yaml"
show "57 a question AFTER the closing four still defers, though the block carries four of its own" "$CLOSE Shall I proceed with the retirement?"

echo "=== a workflow that heals itself (contract-021) ==="
mk; printf 'observations:\n  - obs_id: O-1\n    consolidated: false\n' > "$K/meta-ledger/LEDGER.yaml"
printf 'corrections:\n  - corr_id: C-1\n    clerked: false\n' > "$K/meta-correction-log/CORRECTIONS.yaml"
show "58 a hand-over names how many kit tasks stand behind it"
launch kit-consolidator
show "59 while an agent runs, nothing else is dispatched"
stopped kit-consolidator
show "60 it stopped having written nothing: resume it, do not start it over"
show "61 ...and a second silence records the task blocked and moves the queue on"
mk; printf 'observations:\n  - obs_id: O-1\n    consolidated: false\n' > "$K/meta-ledger/LEDGER.yaml"
launch kit-case-clerk
tel stop-gate "x"; tel stop-gate "x"; tel stop-gate "x"
show "62 an agent that never reported finishing releases the queue, and the gate says so"
mk; printf 'contracts:\n  - contract_id: c-1\n    status: implemented\n    verification_state: reported\n    audited: true\n    bearing: |\n      b\n' | w_contracts
show "63 a task whose next move is the pioneer's, once"
show "64 ...twice"
show "65 ...three turns running is waiting on them, not a fault"

echo "=== the obvious repairs (contract-023) ==="
# says LABEL NEEDLE [ABSENT] — fires the gate once, like show, and answers whether its WHOLE message carries NEEDLE
# and not ABSENT: show prints only a message's first 300 characters, and what a fault suggests comes after them.
says() {
  local r
  r=$(cd "$FX" && printf '{"cwd":"%s","stop_hook_active":false,"last_assistant_message":"%s"}' "$FX" "$DEFMSG" \
      | CLAUDE_PROJECT_DIR="$FX" bash "$H/stop-gate.sh" 2>&1)
  case "$r" in
    *"$2"*) if [ -n "${3:-}" ] && case "$r" in *"$3"*) true ;; *) false ;; esac; then printf '%-62s -> NO: it also says: %s\n' "$1" "$3"
            else printf '%-62s -> yes\n' "$1"; fi ;;
    *) printf '%-62s -> NO: %s\n' "$1" "$(printf '%s' "$r" | sed -e 's/.*additionalContext":"//' | cut -c1-160)" ;;
  esac
}
UNCLERKED='corrections:
  - corr_id: C-1
    clerked: false
'
mk; printf '%s' "$UNCLERKED" | w_corr
launch Explore
show "66 a project's own helper agent is running: the kit's queue is not held for it, nor is it read as a kit agent"
stopped Explore
mk; printf '%s' "$UNCLERKED" | w_corr
printf 'observations:\n  - obs_id: O-1\n    consolidated: false\n    merged_into: null\ncandidates:\n  - cand_id: K-1\n    evidence_refs: [O-0]\n    restatements: 1\n' | w_ledger
launch kit-consolidator
sed -i -e 's/consolidated: false/consolidated: true/' -e 's/merged_into: null/merged_into: K-1/' -e 's/\[O-0\]/[O-0, O-1]/' -e 's/restatements: 1/restatements: 2/' "$K/meta-ledger/LEDGER.yaml"
stopped kit-consolidator
show "67 a consolidator that merged in place, adding no line, wrote something: the queue moves on"
mk; printf '%s' "$UNCLERKED" | w_corr; mkdir -p "$K/meta-casebook/reconstruction"
launch kit-reconstructor
printf '# predictions\n' > "$K/meta-casebook/reconstruction/RT-001.predictions.md"
stopped kit-reconstructor
show "68 the reconstructor's predictions file is a write: nobody is told to resume it"
CARD='precedents: []
scenarios:
  - card_id: S-1
    pioneer_ranking: pending
'
MISSES='observations:
  - obs_id: O-1
    source: map-miss
    consolidated: true
    stewarded: false
  - obs_id: O-2
    source: map-miss
    consolidated: true
    stewarded: false
  - obs_id: O-3
    source: map-miss
    consolidated: true
    stewarded: false
'
mk; printf '%s' "$CARD" | w_case; printf '%s' "$MISSES" | w_ledger
show "69 items only the pioneer can decide are due: a batch is to be assembled"
show "70 ...twice is still a backlog"
says "71 ...three turns is a fault with a place to write it down, never waiting on the pioneer" "assembly: blocked at the top level of LEDGER.yaml" "waiting on you rather than stuck"
{ printf 'assembly: blocked\nblocked_since: 2026-09-21\nblocked_reason: the key cannot be sealed in this project\nblocked_waiting_for: the pioneer to say how to proceed\n'; printf '%s' "$MISSES"; } | w_ledger
show "72 the batch step, recorded blocked, is put to the pioneer once"
show "73 ...and the queue behind it runs"
mk; printf 'observations:\n  - obs_id: O-1\n    source: map-miss\n    consolidated: true\n    stewarded: blocked\n    blocked_since: 2026-09-21\n    blocked_reason: the telemetry is more than the steward can read in its turns\n    blocked_waiting_for: the pioneer to say whether it is trimmed\n' | w_ledger
show "74 a map miss the steward could not take is put to the pioneer"
mk; printf 'contracts:\n  - contract_id: c-1\n    status: implemented\n    verification_state: awaiting-evidence\n    audited: true\n' | w_contracts
show "75 a task with no blocked state of its own, once"
show "76 ...twice"
says "77 ...and its fault never tells the agent to write a state the task does not have" "has no blocked state of its own" "blocked_reason"
mk; printf '# Review batch B-001\n\n## I-1\nDecision: adopt\n\n## I-2\nDecision: decline\n' | w_batch B-001
sealed=$(printf 'I-1: K-001\nI-2: REPRESENTED K-004 | prior: adopt | batch: B-000\n' | (cd "$FX" && bash "$H/seal-key.sh" B-001) 2>&1 | head -n1 | cut -c1-24)
again=$(printf 'I-1: K-001\nI-2: K-002\n' | (cd "$FX" && bash "$H/seal-key.sh" B-001) 2>&1 | grep -c 'never overwritten')
opened=$(cd "$FX" && bash "$H/reveal-key.sh" B-001 2>&1 | grep -c '^I-[0-9]')
printf '%-62s -> %s; a second sealing refused: %s; lines opened after the decisions: %s\n' "78 the key is sealed by one script and opened by the other" "$sealed" "$again" "$opened"

echo "=== telemetry ==="
ls -1 "$K/meta-ledger/" 2>/dev/null
tail -n 4 "$K/meta-ledger/telemetry.log" 2>/dev/null || echo "(no telemetry written)"

# The comparison with walk.expected happens in the outer run at the top of this file.
