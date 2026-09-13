#!/usr/bin/env bash
# Run from anywhere: bash meta-mechanisms/tests/walk-004.sh — contract-004 acceptance fixtures (T-3, T-5, T-8, T-9, T-4, T-6)
# and contract-005's (T-1 telemetry blind; T-3 the batch states and the 6h seed); exits non-zero on any failure.
# Lifecycle walk for contract-004: T-3 (late test revisions), T-5 (ownership check, three fixtures plus the
# template's one-line manifest form), T-8 (retirement leaves the gate silent), T-9 (rebuild plan seed, M-31,
# map under 8,192 bytes). Self-contained; the original walk.sh covers the 36 earlier states unchanged.
SRC="$(cd "$(dirname "$0")/../.." && pwd)"
FX="$(mktemp -d)"
K="$FX/.claude/skills"
H="$K/meta-mechanisms/hooks"
pass=0; fail=0
ok()   { pass=$((pass+1)); printf 'PASS  %s\n' "$1"; }
bad()  { fail=$((fail+1)); printf 'FAIL  %s\n      got: %s\n' "$1" "$2"; }

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
}
gate() { # -> the stop-gate's additionalContext, or "(silent)"
  local r
  r=$(printf '{"stop_hook_active":false,"last_assistant_message":"Work done. drift score 0.1"}' \
      | CLAUDE_PROJECT_DIR="$FX" bash "$H/stop-gate.sh" 2>&1)
  [ -z "$r" ] && { echo "(silent)"; return; }
  printf '%s' "$r" | sed -e 's/.*additionalContext":"//' -e 's/\\n.*//' | cut -c1-200
}
oc() { # FILE_PATH [AGENT_JSON] -> bypass lines now in telemetry
  printf '{"tool_name":"Edit","tool_input":{"file_path":"%s"}%s}' "$1" "${2:-}" \
    | CLAUDE_PROJECT_DIR="$FX" bash "$H/owner-check.sh" 2>&1
  grep '|bypass|' "$K/meta-ledger/telemetry.log" 2>/dev/null | sed 's/^[^|]*|//' | tr '\n' ' '
}
w_contracts() { cat > "$K/meta-contract-before-execution/CONTRACT-LOG.yaml"; }
w_manifest()  { cat > "$K/meta-manifest/MANIFEST.yaml"; }
w_tele()      { cat > "$K/meta-ledger/telemetry.log"; }

echo "=== T-3: a test revised after the verification report ==="
mk; w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented
    verification_state: reported
    audited: true
    bearing: b
    verification:
      date: 2026-09-10
      by: kit-verifier
      tests: {T-1: pass, T-2: pass}
    revisions:
      - what: "T-2 loosened"
        authorised_by: "pioneer"
        date: 2026-09-11
        tests_changed: [T-2]
EOF
r=$(gate); case "$r" in *"drift, not a revision"*) ok "37 tier_4 revision dated after the report -> drift (M-18)";; *) bad "37 late revision" "$r";; esac
w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented
    verification_state: reported
    audited: true
    bearing: b
    verification:
      date: 2026-09-10
    revisions:
      - what: "T-2 loosened"
        date: 2026-09-09
        tests_changed: [T-2]
EOF
r=$(gate); case "$r" in *"has a verification report but is still implemented"*) ok "38 revision dated before the report -> ordinary (close three ways)";; *) bad "38 early revision" "$r";; esac
w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented
    verification_state: reported
    audited: true
    bearing: b
    verification:
      date: 2026-09-10
    revisions:
      - what: "wording only"
        date: 2026-09-11
        tests_changed: []
EOF
r=$(gate); case "$r" in *"has a verification report but is still implemented"*) ok "39 late revision that changes no test -> not drift";; *) bad "39 no tests changed" "$r";; esac
w_contracts <<'EOF'
contracts:
  - contract_id: c-1
    status: implemented
    verification_state: none
    audited: true
    bearing: b
    tier_3: |
      G-3 a revision dated after verification_state: reported with tests_changed: [T-9] is drift
    revisions:
      - what: "x"
        date: 2026-09-11
        tests_changed: [T-1]
EOF
r=$(gate); case "$r" in *"verification_state: none"*) ok "40 no report yet -> a test revision is an ordinary revision; prose mention of the keys is prose";; *) bad "40 unreported" "$r";; esac

echo "=== T-5: ownership check ==="
mk; w_manifest <<'EOF'
kit_type: project
nodes:
  - id: base-casebook
    kind: record
    skill_file: meta-casebook/SKILL.md
    data_file: meta-casebook/CASEBOOK.yaml
    owns: [meta-casebook/CASEBOOK.yaml, meta-casebook/reconstruction/, meta-casebook/SKILL.md]
    status: thin
  - id: base-ledger
    kind: record
    skill_file: meta-ledger/SKILL.md
    owns:
      - meta-ledger/LEDGER.yaml
      - meta-ledger/telemetry.log   # a comment
    status: thin
gap_queue:
  - gap_id: gap-001
    status: open
EOF
w_tele <<'EOF'
2026-09-12T10:00:00Z|session-start|startup
2026-09-12T10:00:05Z|loaded|meta-map/MAP.md
EOF
r=$(oc "$FX/.claude/skills/meta-casebook/CASEBOOK.yaml")
case "$r" in *"bypass|base-casebook|meta-casebook/CASEBOOK.yaml"*) ok "41 record edited, owner never loaded -> one bypass line";; *) bad "41 bypass" "$r";; esac
n=$(grep -c '|bypass|' "$K/meta-ledger/telemetry.log"); [ "$n" = 1 ] && ok "41b exactly one line" || bad "41b line count" "$n"
w_tele <<'EOF'
2026-09-12T10:00:00Z|session-start|startup
2026-09-12T10:00:05Z|loaded|meta-casebook/SKILL.md
EOF
r=$(oc "$FX/.claude/skills/meta-casebook/CASEBOOK.yaml"); [ -z "$r" ] && ok "42 owner loaded this session -> no line" || bad "42 loaded" "$r"
w_tele <<'EOF'
2026-09-12T09:00:00Z|loaded|meta-casebook/SKILL.md
2026-09-12T10:00:00Z|session-start|startup
EOF
r=$(oc "$FX/.claude/skills/meta-casebook/CASEBOOK.yaml"); case "$r" in *bypass*) ok "43 loaded only in an EARLIER session -> bypass";; *) bad "43 earlier session" "$r";; esac
w_tele <<'EOF'
2026-09-12T10:00:00Z|session-start|startup
2026-09-12T10:00:05Z|loaded|meta-casebook/SKILL.md
2026-09-12T10:30:00Z|session-start|resume
EOF
r=$(oc "$FX/.claude/skills/meta-casebook/CASEBOOK.yaml"); [ -z "$r" ] && ok "44 loaded before a resume -> still loaded, no line" || bad "44 resume" "$r"
w_tele <<'EOF'
2026-09-12T10:00:00Z|session-start|startup
2026-09-12T10:00:05Z|loaded|meta-casebook/SKILL.md
2026-09-12T10:30:00Z|session-start|clear
EOF
r=$(oc "$FX/.claude/skills/meta-casebook/CASEBOOK.yaml"); case "$r" in *bypass*) ok "45 loaded before a clear -> context gone, bypass";; *) bad "45 clear" "$r";; esac
w_tele <<'EOF'
2026-09-12T10:00:00Z|session-start|startup
2026-09-12T10:00:05Z|loaded-agent|meta-casebook/SKILL.md
EOF
r=$(oc "$FX/.claude/skills/meta-casebook/CASEBOOK.yaml"); case "$r" in *bypass*) ok "46 an AGENT loaded it, the main session did not -> bypass";; *) bad "46 loaded-agent" "$r";; esac
w_tele <<'EOF'
2026-09-12T10:00:00Z|session-start|startup
EOF
r=$(oc "$FX/.claude/skills/meta-casebook/CASEBOOK.yaml" ',"agent_type":"kit-case-clerk"'); [ -z "$r" ] && ok "47 same edit inside a subagent -> no line" || bad "47 subagent" "$r"
w_tele <<'EOF'
2026-09-12T10:00:00Z|session-start|startup
2026-09-12T10:00:05Z|loaded|skill:meta-casebook
EOF
r=$(oc "$FX/.claude/skills/meta-casebook/CASEBOOK.yaml"); [ -z "$r" ] && ok "48 loaded through the Skill tool -> counts as loaded" || bad "48 skill tool" "$r"
w_tele <<'EOF'
2026-09-12T10:00:00Z|session-start|startup
EOF
r=$(oc "$FX/.claude/skills/meta-casebook/reconstruction/RT-001.input.md"); case "$r" in *"bypass|base-casebook|meta-casebook/reconstruction/RT-001.input.md"*) ok "49 a folder owns what is under it";; *) bad "49 folder" "$r";; esac
w_tele <<'EOF'
2026-09-12T10:00:00Z|session-start|startup
EOF
r=$(oc "$FX/.claude/skills/meta-ledger/telemetry.log"); case "$r" in *"bypass|base-ledger|meta-ledger/telemetry.log"*) ok "50 block-form owns list with a trailing comment";; *) bad "50 block list" "$r";; esac
w_tele <<'EOF'
2026-09-12T10:00:00Z|session-start|startup
EOF
r=$(oc "$FX/.claude/skills/meta-nobody/X.yaml"); [ -z "$r" ] && ok "51 a path nobody owns -> no line" || bad "51 unowned" "$r"
r=$(oc "$FX/src/app.cs"); [ -z "$r" ] && ok "52 a file outside .claude/skills -> no line" || bad "52 outside" "$r"
# the template's one-line node form, as a fresh project manifest actually reads
mk; cp "$SRC/templates/MANIFEST.template.yaml" "$K/meta-manifest/MANIFEST.yaml"
sed -i -e 's/__PROJECT_NAME__/fx/' -e 's/__CATEGORY__/test/' -e 's/__LIBRARY_KIT__/null/' "$K/meta-manifest/MANIFEST.yaml"
w_tele <<'EOF'
2026-09-12T10:00:00Z|session-start|startup
EOF
r=$(oc "$FX/.claude/skills/meta-casebook/CASEBOOK.yaml"); case "$r" in *"bypass|base-casebook|meta-casebook/CASEBOOK.yaml"*) ok "53 the TEMPLATE's one-line node form is read";; *) bad "53 flow form" "$r";; esac
w_tele <<'EOF'
2026-09-12T10:00:00Z|session-start|startup
2026-09-12T10:00:05Z|loaded|meta-casebook/SKILL.md
EOF
r=$(oc "$FX/.claude/skills/meta-casebook/CASEBOOK.yaml"); [ -z "$r" ] && ok "54 flow form, owner loaded -> no line" || bad "54 flow loaded" "$r"
w_tele <<'EOF'
2026-09-12T10:00:00Z|session-start|startup
EOF
r=$(oc "$FX/.claude/skills/templates/CONTRACT-LOG.template.yaml"); case "$r" in *"base-bootstrap|"*) ok "55 flow form, folder owner (templates/ -> base-bootstrap)";; *) bad "55 flow folder" "$r";; esac
mk; printf 'kit_type: base\nnodes:\n  - id: base-casebook\n    skill_file: meta-casebook/SKILL.md\n    owns: [meta-casebook/]\n' > "$K/meta-manifest/MANIFEST.yaml"
r=$(oc "$FX/.claude/skills/meta-casebook/CASEBOOK.yaml"); [ -z "$r" ] && ok "56 kit_type base (the kit's own repo) -> silent" || bad "56 base" "$r"

echo "=== T-8, through the batch (contract-005 G-3): a contradiction candidate from due to retired ==="
mk; w_manifest <<'EOF'
kit_type: project
nodes:
  - id: proj-old-rule
    kind: skill
    skill_file: proj-old-rule/SKILL.md
    owns: [proj-old-rule/SKILL.md]
    status: thin
EOF
mkdir -p "$K/proj-old-rule"; printf 'Always retry twice.\n' > "$K/proj-old-rule/SKILL.md"
printf 'M-01 | x | must | INTENT.md | ratified\nM-40 | old-rule | situation | must | retrying | — | proj-old-rule | ratified\n' > "$K/meta-map/MAP.md"
cat > "$K/meta-ledger/LEDGER.yaml" <<'EOF'
observations: []
candidates:
  - cand_id: K-1
    stage: assess
    source: pioneer
    contradicts:
      - {file: proj-old-rule/SKILL.md, passage: "Always retry twice."}
    review_due: true
    disposition_proposed: retire
  - cand_id: K-2
    stage: assess
    contradicts: []
    review_due: true
  - cand_id: K-3
    stage: assess
    contradicts: []
    review_due: true
batches:
EOF
r=$(gate); case "$r" in *"Launch the kit-batch-assembler"*) ok "57 contradicting candidate due (with two others) -> assemble a batch";; *) bad "57 assemble" "$r";; esac
# the batch assembler's work, as a fixture: the batch file with no ledger ids, the sealed key, the batch registered
cat > "$K/meta-ledger/batches/B-1.md" <<'EOF'
# Review batch B-1 — 2026-09-12
## I-1
**Kind:** candidate
**Statement:** Retrying hides the failure from the caller.
Verdict before evidence:
**Proposed:** retire — pattern · project · target: proj-old-rule
**Contradicts:** proj-old-rule/SKILL.md → "Always retry twice."
Decision:
## I-2
**Kind:** candidate
Decision:
## I-3
**Kind:** candidate
Decision:
EOF
mkdir -p "$FX/.claude/kit-sealed"; printf 'I-1: K-1\nI-2: K-2\nI-3: K-3\n' > "$FX/.claude/kit-sealed/B-1.key"
printf '  - batch_id: B-1\n    decided: false\n    revealed: false\n' >> "$K/meta-ledger/LEDGER.yaml"
r=$(gate); [ "$r" = "(silent)" ] && ok "58 batch open, undecided -> silent (the pioneer is deciding)" || bad "58 open batch" "$r"
r=$(printf '{"tool_name":"Read","tool_input":{"file_path":"%s"}}' "$K/meta-ledger/LEDGER.yaml" | CLAUDE_PROJECT_DIR="$FX" bash "$H/batch-blind.sh" 2>&1)
case "$r" in *deny*) ok "59 the ledger is closed to the presenter while the batch is open";; *) bad "59 blind" "$r";; esac
# the pioneer decides: retire the passage; the other two declined
awk 'BEGIN{split("retire decline decline",v," ")} /^Decision:$/ {n++; print "Decision: " v[n]; next} {print}' "$K/meta-ledger/batches/B-1.md" > "$K/meta-ledger/batches/B-1.tmp" && mv "$K/meta-ledger/batches/B-1.tmp" "$K/meta-ledger/batches/B-1.md"
r=$(gate); case "$r" in *"close-batch.sh"*) ok "60 every item decided -> close the batch";; *) bad "60 close due" "$r";; esac
r=$(CLAUDE_PROJECT_DIR="$FX" bash "$H/close-batch.sh" B-1 2>&1); case "$r" in *"marked decided"*) ok "61 close-batch.sh sets decided without the session reading the ledger";; *) bad "61 close-batch" "$r";; esac
r=$(gate); case "$r" in *"reveal-key.sh"*) ok "62 decided -> reveal";; *) bad "62 reveal due" "$r";; esac
r=$(CLAUDE_PROJECT_DIR="$FX" bash "$H/reveal-key.sh" B-1 2>&1); case "$r" in *"I-1: K-1"*) ok "63 reveal-key.sh opens the key once every item is decided";; *) bad "63 reveal" "$r";; esac
# the main agent applies the terminal values (meta-skill-builder -> Reveal): retire at the quoted passage,
# remove the map entry, mark the node retired, clear review_due, set revealed
sed -i -e '/^Always retry twice\.$/d' "$K/proj-old-rule/SKILL.md"
sed -i -e '/^M-40 /d' "$K/meta-map/MAP.md"
sed -i -e 's/^    status: thin$/    status: retired\n    retired_by: B-1/' "$K/meta-manifest/MANIFEST.yaml"
awk '
  /cand_id: K-1/ {k="K-1"} /cand_id: K-2/ {k="K-2"} /cand_id: K-3/ {k="K-3"}
  k=="K-1" && /stage: assess/ {print "    stage: adopt"; print "    decision: {batch: B-1, item: I-1, decision: retire, applied_as: retire, date: 2026-09-12}"; next}
  (k=="K-2" || k=="K-3") && /stage: assess/ {print "    stage: declined"; print "    decision: {batch: B-1, decision: decline, date: 2026-09-12}"; next}
  /review_due: true/ {print "    review_due: false"; next}
  /revealed: false/ {print "    revealed: true"; next}
  {print}' "$K/meta-ledger/LEDGER.yaml" > "$K/meta-ledger/LEDGER.tmp" && mv "$K/meta-ledger/LEDGER.tmp" "$K/meta-ledger/LEDGER.yaml"
r=$(gate); [ "$r" = "(silent)" ] && ok "64 terminal values written -> gate silent, nothing re-presented" || bad "64 terminal" "$r"
# every decided item carries its terminal value — not merely a cleared flag (contract-007 G-7)
n=$(awk '/cand_id: K-2|cand_id: K-3/ {c=1} c && /stage: declined/ {s++} c && /decision: \{batch: B-1, decision: decline/ {d++} END{print s+0 "/" d+0}' "$K/meta-ledger/LEDGER.yaml")
[ "$n" = "2/2" ] && ok "64b the two declined candidates carry stage: declined and a decision block" || bad "64b terminal values" "$n"
[ -f "$K/proj-old-rule/SKILL.md" ] && ok "65 the skill file is still on disk (the passage went, the file stayed)" || bad "65 file kept" "missing"
grep -q 'Always retry twice' "$K/proj-old-rule/SKILL.md" && bad "66 passage removed" "still present" || ok "66 the quoted passage is gone from the skill"
grep -q 'proj-old-rule' "$K/meta-map/MAP.md" && bad "67 map entry removed" "still present" || ok "67 no map entry points at the retired node"
grep -q 'status: retired' "$K/meta-manifest/MANIFEST.yaml" && ok "68 the manifest shows the node retired" || bad "68 manifest" "-"

echo "=== contract-006 T-7 (replaces contract-004 T-9): the rebuild is out of the map; the design note exists ==="
# contract-004's T-9 seeded REBUILD.yaml and required M-31. contract-006 G-7 withdrew both; the expectation moved
# here under the follow-up, as a Tier 4 line may only move.
for m in "$SRC/meta-map/MAP.md" "$SRC/templates/MAP.template.md"; do
  grep -q 'M-31' "$m" && bad "75 no M-31 in $(basename "$m")" "still present" || ok "75 no M-31 in $(basename "$m")"
  b=$(wc -c < "$m"); [ "$b" -lt 7133 ] && ok "76 $(basename "$m") is $b bytes (< 7,133, smaller than before)" || bad "76 map smaller" "$b"
done
[ -f "$SRC/docs/rebuild-design.md" ] && ok "77 docs/rebuild-design.md exists" || bad "77 design note" "missing"
[ -f "$SRC/templates/REBUILD.template.yaml" ] && bad "78 REBUILD template removed" "still present" || ok "78 REBUILD template removed"
grep -q 'REBUILD' "$SRC/meta-bootstrap/SKILL.md" && bad "79 bootstrap 6h seeds nothing" "REBUILD still named" || ok "79 bootstrap 6h seeds no rebuild plan"

echo "=== contract-005 T-1: telemetry closed to the acting session at all times ==="
mk
bb() { printf '{"tool_name":"%s","tool_input":{%s}%s}' "$1" "$2" "${3:-}" | CLAUDE_PROJECT_DIR="$FX" bash "$H/batch-blind.sh" 2>&1; }
r=$(bb Read "\"file_path\":\"$K/meta-ledger/telemetry.log\""); case "$r" in *deny*) ok "80 Read telemetry.log, no batch open -> denied";; *) bad "80 read telemetry" "$r";; esac
r=$(bb Grep "\"pattern\":\"loaded\",\"path\":\"$K/meta-ledger\""); case "$r" in *deny*) ok "81 Grep over meta-ledger/ -> denied";; *) bad "81 grep folder" "$r";; esac
r=$(bb Grep "\"pattern\":\"bypass\",\"path\":\"$FX\""); case "$r" in *deny*) ok "82 Grep anywhere for the count's name -> denied";; *) bad "82 grep pattern" "$r";; esac
r=$(bb Read "\"file_path\":\"$K/meta-ledger/telemetry.log\"" ',"agent_type":"kit-map-steward"'); [ -z "$r" ] && ok "83 the same Read by a kit agent -> allowed" || bad "83 agent" "$r"
r=$(bb Read "\"file_path\":\"$K/meta-ledger/LEDGER.yaml\""); [ -z "$r" ] && ok "84 Read LEDGER.yaml with no batch open -> allowed, as before" || bad "84 ledger" "$r"
r=$(bb Grep "\"pattern\":\"loaded\",\"path\":\"$K/meta-ledger/batches\""); [ -z "$r" ] && ok "85 Grep over the batches folder -> allowed" || bad "85 batches" "$r"

echo "=== T-4 / T-6 ==="
n=$(awk '/^  - id: / {id=$3; kind=""; owns=0} /^    kind: / {kind=$2} /^    owns: \[.+\]/ {owns=1} /^    status: / { if (kind=="skill" && !owns) print id }' "$SRC/meta-manifest/MANIFEST.yaml" | wc -l)
[ "$n" = 0 ] && ok "86 every kind: skill node in MANIFEST.yaml has a non-empty owns:" || bad "86 owns" "$n missing"
n=$(grep -c '^  - {id: .*kind: skill' "$SRC/templates/MANIFEST.template.yaml"); m=$(grep -c '^  - {id: .*kind: skill.*owns: \[[^]]' "$SRC/templates/MANIFEST.template.yaml")
[ "$n" = "$m" ] && ok "87 template: $m of $n skill nodes carry owns:" || bad "87 template owns" "$m of $n"
files=$(grep -l 'bypass' "$SRC"/meta-mechanisms/hooks/*.sh "$SRC"/agents/*.md | xargs -n1 basename | sort | tr '\n' ' ')
# contract-004 T-6 expected only owner-check.sh and kit-map-steward.md here. contract-005 G-1 added batch-blind.sh,
# which must name the count's word to refuse Greps for it. It denies; it never prints a count — 004 G-6 still holds.
[ "$files" = "batch-blind.sh kit-map-steward.md owner-check.sh " ] && ok "88 only owner-check.sh, kit-map-steward.md and batch-blind.sh (contract-005) mention bypass" || bad "88 who mentions bypass" "$files"
mk; w_tele <<'EOF'
2026-09-12T10:00:00Z|session-start|startup
2026-09-12T10:00:05Z|bypass|base-casebook|meta-casebook/CASEBOOK.yaml
2026-09-12T10:00:06Z|bypass|base-ledger|meta-ledger/LEDGER.yaml
EOF
r=$(printf '{"source":"startup"}' | CLAUDE_PROJECT_DIR="$FX" bash "$H/session-start.sh" 2>&1)
case "$r" in *bypass*|*ypass*) bad "89 session-start must not surface the count" "$r";; *) ok "89 session-start prints nothing about ownership counts";; esac

echo; echo "contract-004 walk: $pass passed, $fail failed"
[ "$fail" = 0 ]
