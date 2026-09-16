#!/usr/bin/env bash
# Run from anywhere: bash meta-mechanisms/tests/walk-007.sh — contract-007's mechanical fixtures: T-5 (session-start
# tells the truth), T-6 (the question guard), T-7 (walks that fail), T-9 (the size check), T-10 (import-loaded
# owners), T-8 (text consistency greps), T-1 (version). Exits non-zero on any failure. T-2/T-3/T-4/T-12 are
# upgrade runs by the agent on fixtures and are recorded under tests/results/.
SRC="$(cd "$(dirname "$0")/../.." && pwd)"
FX="$(mktemp -d)"
K="$FX/.claude/skills"; H="$K/meta-mechanisms/hooks"
pass=0; fail=0
ok(){ pass=$((pass+1)); printf 'PASS  %s\n' "$1"; }
bad(){ fail=$((fail+1)); printf 'FAIL  %s\n      got: %s\n' "$1" "$2"; }
mk(){
  rm -rf "$FX"; mkdir -p "$H" "$K/meta-manifest" "$K/meta-contract-before-execution" "$K/meta-ledger/batches" \
    "$K/meta-correction-log" "$K/meta-casebook" "$K/meta-drift-eventlog" "$K/meta-map" "$K/meta-founding-contract" "$K/meta-foundation"
  cp "$SRC"/meta-mechanisms/hooks/*.sh "$H/"
  printf 'kit_type: project\nnodes: []\n' > "$K/meta-manifest/MANIFEST.yaml"
  printf 'contracts: []\n' > "$K/meta-contract-before-execution/CONTRACT-LOG.yaml"
  printf 'observations: []\n' > "$K/meta-ledger/LEDGER.yaml"
  printf 'corrections: []\n' > "$K/meta-correction-log/CORRECTIONS.yaml"
  printf 'precedents: []\n' > "$K/meta-casebook/CASEBOOK.yaml"
  printf 'entries: []\n' > "$K/meta-drift-eventlog/DRIFTLOG.yaml"
  printf 'M-01 | x | must | INTENT.md | ratified\n' > "$K/meta-map/MAP.md"
  printf 'founding\n' > "$K/meta-founding-contract/FOUNDING.md"
}
ss(){ printf '{"source":"startup"}' | CLAUDE_PROJECT_DIR="$FX" bash "$H/session-start.sh" | sed 's/.*additionalContext":"//' ; }
gate(){ printf '{"stop_hook_active":false,"last_assistant_message":"%s"}' "$1" | CLAUDE_PROJECT_DIR="$FX" bash "$H/stop-gate.sh" | grep -c additionalContext; }

echo "=== T-5: session-start tells the truth ==="
mk; printf 'observations: []\nbatches:\n  - batch_id: B-1\n    decided: false\n    revealed: false\n' > "$K/meta-ledger/LEDGER.yaml"
r=$(ss); case "$r" in *"casebook stays open"*) ok "90 open batch: the casebook is said to stay open";; *) bad "90 casebook line" "$r";; esac
case "$r" in *"casebook stay closed"*|*"and casebook"*) bad "90b no 'casebook closed' text" "$r";; *) ok "90b no 'casebook closed' text";; esac
mk; printf '<!-- ratification: deferred -->\nM-01 | x | must | INTENT.md | proposed\n' > "$K/meta-map/MAP.md"
r=$(ss); case "$r" in *"Pioneer-owned"*) bad "91 deferred ratification must not raise the backlog" "$r";; *) ok "91 deferred ratification -> no pioneer-owned line";; esac
mk; printf 'M-01 | x | must | INTENT.md | proposed\n' > "$K/meta-map/MAP.md"
r=$(ss); case "$r" in *"Pioneer-owned"*) ok "92 undeferred proposed entry -> pioneer-owned line";; *) bad "92 proposed entry" "$r";; esac
mk; printf 'precedents:\n  - prec_id: P-1\n    conflict: P-2\n' > "$K/meta-casebook/CASEBOOK.yaml"
r=$(ss); case "$r" in *"Pioneer-owned"*) ok "93 precedent conflict -> pioneer-owned line (agrees with the gate)";; *) bad "93 conflict" "$r";; esac
mk; printf 'entries:\n  - drift_id: d-1\n    status: mitigated\n' > "$K/meta-drift-eventlog/DRIFTLOG.yaml"
r=$(ss); case "$r" in *"Pioneer-owned"*) ok "94 mitigated drift -> pioneer-owned line (agrees with the gate)";; *) bad "94 mitigated" "$r";; esac

mk; { printf '# Founding\n\n<!-- AGENT INSTRUCTIONS: if deferred, replace the block with "*Deferred by the Pioneer on [date].*" -->\n\n*Given by the Pioneer, 2026-09-12. Recorded verbatim.*\n\n> We build a small test API.\n'; } > "$K/meta-founding-contract/FOUNDING.md"
r=$(ss); case "$r" in *"not given or deferred"*) bad "94b a recorded statement beside the template's own comment must not read as deferred (rehearsal 4f)" "$r";; *) ok "94b the template's instruction comment does not trigger the deferral line";; esac
mk; printf '# Founding\n\n*Deferred by the Pioneer on 2026-09-12.*\n' > "$K/meta-founding-contract/FOUNDING.md"
r=$(ss); case "$r" in *"not given or deferred"*) ok "94c a real deferral still raises the line";; *) bad "94c deferral" "$r";; esac

mk; printf 'observations:
  - obs_id: O-1
    review_due: true
  - obs_id: O-2
    review_due: true
' > "$K/meta-ledger/LEDGER.yaml"
r=$(ss); case "$r" in *"Pioneer-owned"*) bad "94d two due candidates alone must NOT raise the backlog: the gate waits for three (UC-5)" "$r";; *) ok "94d two due candidates alone -> silent, as the gate is";; esac
mk; printf 'observations:
  - obs_id: O-1
    review_due: true
  - obs_id: O-2
    review_due: true
  - obs_id: O-3
    review_due: true
' > "$K/meta-ledger/LEDGER.yaml"
r=$(ss); case "$r" in *"Pioneer-owned"*) ok "94e three due candidates -> the line, matching the gate's threshold";; *) bad "94e three due candidates" "$r";; esac

echo "=== T-6: the question guard ==="
mk; printf 'observations:\n  - obs_id: O-1\n    consolidated: false\n' > "$K/meta-ledger/LEDGER.yaml"
n=$(gate 'Done. drift score 0.1 lay 0.2 Shall I proceed with the retirement?'); [ "$n" = 0 ] && ok "95 a question AFTER the drift block defers the gate" || bad "95 question after block" "fired"
n=$(gate 'Implemented the change. Want me to run the tests? drift score 0.1'); [ "$n" = 0 ] && ok "96 a question before the block defers" || bad "96" "fired"
grep -q '|stop-deferred|question' "$K/meta-ledger/telemetry.log" && ok "96b …and writes a stop-deferred line the steward can read" || bad "96b telemetry" "$(cat "$K/meta-ledger/telemetry.log" 2>/dev/null)"
n=$(gate 'All done, tests green. drift score 0.1'); [ "$n" = 1 ] && ok "97 no question -> the gate fires" || bad "97 no question" "silent"
grep -q 'stop-deferred' "$SRC/agents/kit-map-steward.md" && ok "98 the steward's definition names the deferral event" || bad "98 steward" "-"

echo "=== T-7: walks that fail ==="
bash "$SRC/meta-mechanisms/tests/walk.sh" >/dev/null 2>&1 && ok "99a walk.sh exits 0 when every state matches walk.expected" || bad "99a walk.sh fails on an unchanged tree" "exit $?"
t=$(mktemp -d); cp "$SRC/meta-mechanisms/tests/walk.expected" "$t/walk.expected.bak"
sed -i '1s/^01/0X/' "$SRC/meta-mechanisms/tests/walk.expected"
bash "$SRC/meta-mechanisms/tests/walk.sh" >/dev/null 2>&1; rc=$?
cp "$t/walk.expected.bak" "$SRC/meta-mechanisms/tests/walk.expected"; rm -rf "$t"
[ "$rc" != 0 ] && ok "99b walk.sh exits non-zero when walk.expected differs by one character" || bad "99b walk.sh cannot fail" "exit 0"
bash "$SRC/meta-mechanisms/tests/walk-004.sh" 2>/dev/null | grep -q 'PASS  64b' && ok "100 walk-004 state 64b asserts the declined candidates' terminal values" || bad "100 64b" "-"

echo "=== T-9: the size check ==="
bash "$SRC/meta-mechanisms/checks/G1-size.sh" >/dev/null && ok "101 G1-size passes on the tree ($(wc -c < "$SRC/meta-foundation/INTENT.md") B intent, $(wc -c < "$SRC/meta-map/MAP.md") B map)" || bad "101 G1-size" "$(bash "$SRC/meta-mechanisms/checks/G1-size.sh")"
t=$(mktemp -d); mkdir -p "$t/meta-mechanisms/checks" "$t/meta-foundation" "$t/meta-map"; cp "$SRC/meta-mechanisms/checks/G1-size.sh" "$t/meta-mechanisms/checks/"; cp "$SRC/meta-foundation/INTENT.md" "$t/meta-foundation/"; cp "$SRC/meta-map/MAP.md" "$t/meta-map/"
head -c 600 /dev/zero | tr '\0' 'x' >> "$t/meta-foundation/INTENT.md"
r=$(bash "$t/meta-mechanisms/checks/G1-size.sh"); rc=$?; rm -rf "$t"
[ "$rc" != 0 ] && case "$r" in *INTENT.md*bytes*) ok "102 G1-size fails on an oversized INTENT.md, naming file and figure";; *) bad "102 message" "$r";; esac || bad "102 G1-size did not fail" "$r"
grep -q 'mitigation_medium: mechanism' "$SRC/meta-drift-eventlog/DRIFTLOG.yaml" && ok "103 drift-003 elevated to a mechanism" || bad "103 drift-003" "-"

echo "=== T-10: import-loaded owners ==="
mk; printf 'kit_type: project\nnodes:\n  - id: base-intent\n    kind: intent\n    skill_file: meta-foundation/INTENT.md\n    owns: [meta-foundation/INTENT.md]\n' > "$K/meta-manifest/MANIFEST.yaml"
printf '2026-09-13T10:00:00Z|session-start|startup\n' > "$K/meta-ledger/telemetry.log"
printf '{"tool_name":"Edit","tool_input":{"file_path":"%s"}}' "$K/meta-foundation/INTENT.md" | CLAUDE_PROJECT_DIR="$FX" bash "$H/owner-check.sh"
grep -q '|bypass|' "$K/meta-ledger/telemetry.log" && bad "104 INTENT.md edit must not produce a bypass" "$(grep bypass "$K/meta-ledger/telemetry.log")" || ok "104 editing an import-loaded file writes no bypass"

echo "=== T-1 / T-8: version and text consistency ==="
grep -q "^  version: 0.16" "$SRC/meta-manifest/MANIFEST.yaml" && grep -q "^  base_kit_version: 0.16" "$SRC/templates/MANIFEST.template.yaml" && ok "105 both manifests read 0.16" || bad "105 version" "-"
grep -q 'closed-by-follow-up' "$SRC/templates/CONTRACT-LOG.template.yaml" && grep -q 'approved-at-gate' "$SRC/templates/CONTRACT-LOG.template.yaml" && grep -q 'closed-by-follow-up' "$SRC/meta-contract-before-execution/SKILL.md" && grep -q 'approved-at-gate' "$SRC/meta-contract-before-execution/SKILL.md" && ok "106 enumerations in template and node" || bad "106 enumerations" "-"
n=0; for id in M-03 M-08 M-09 M-10 M-23 M-28 M-29; do l=$(grep "^$id " "$SRC/meta-map/MAP.md" | awk -F' \\| ' '{print $7}'); case "$l" in *": "*|*" then "*|*"; unauthorised"*|*"cite the id"*|*"flag it"*) n=$((n+1)); echo "      $id load: $l";; esac; done
[ "$n" = 0 ] && ok "107 the seven map entries carry file + heading only" || bad "107 map pointers" "$n entries still carry guidance"
for id in M-23 M-28; do s=$(grep "^$id " "$SRC/meta-map/MAP.md" | awk -F' \\| ' '{print $6}'); [ "$s" != "—" ] && ok "108 $id names a sibling: $s" || bad "108 $id sibling" "—"; done
grep -q 'watching' "$SRC/meta-mechanisms/SKILL.md" && ok "109 marker-key table names watching" || bad "109 watching" "-"
grep -c 'THE ONE WRITER LIST' "$SRC/templates/LEDGER.template.yaml" | grep -q '^1$' && grep -q "the one writer list" "$SRC/meta-ledger/SKILL.md" && ok "110 one writer list, the node points to it" || bad "110 writer list" "-"
diff <(sed '1d' "$SRC/meta-map/MAP.md" | sed '/^ALWAYS LOADED/,/^-->/d') <(sed '1d' "$SRC/templates/MAP.template.md" | sed '/^ALWAYS LOADED/,/^-->/d') >/dev/null && ok "111 template map and live map agree entry for entry" || bad "111 maps differ" "$(diff <(sed '1d' "$SRC/meta-map/MAP.md") <(sed '1d' "$SRC/templates/MAP.template.md") | head -3)"

echo "=== T-11: the README ==="
n=$(grep -c -i -E 'canary|brier|wilson|catch rate|lower.bound|binding precedent|binding|v0\.14|dominant force' "$SRC/README.md"); [ "$n" = 0 ] && ok "112a census over README clean" || bad "112a README census" "$(grep -n -i -E 'canary|brier|wilson|catch rate|lower.bound|binding|v0\.14|dominant force' "$SRC/README.md" | head -3)"
miss=""; for p in $(grep -o '`[a-zA-Z0-9_./-]*/[a-zA-Z0-9_./-]*`' "$SRC/README.md" | tr -d '`' | grep -E '^(meta-|agents/|templates/|docs/)' | grep -v 'NNN\|meta-manifest/INSTALLED\|meta-ledger/batches\|meta-mechanisms/checks/$' | sort -u); do [ -e "$SRC/$p" ] || miss="$miss $p"; done
[ -z "$miss" ] && ok "112b every path the README names exists on disk" || bad "112b README names missing paths" "$miss"
h=$(grep -c '^## \|^### ' "$SRC/README.md"); r=$(grep -c '^| [0-9]* | ' "$SRC/docs/readme-review.md"); [ "$r" -ge 19 ] && ok "112c readme-review.md has a row per section of the old README ($r rows; new README has $h headings)" || bad "112c review rows" "$r"
grep -q "v0.16" "$SRC/README.md" && grep -q "Contract-003" "$SRC/README.md" && grep -q "Contract-006" "$SRC/README.md" && ok "112d README status reads v0.16 and narrates 003–006" || bad "112d status" "-"

echo "=== contract-008 T-2: the migration check ==="
G2="$SRC/meta-mechanisms/checks/G2-migration.sh"; RT="$SRC/meta-mechanisms/checks/roots.sh"
mkrec(){ # a minimal migrated project: one contract, one drift entry holding two block scalars and an elevation list,
         # one correction, a ledger batch, and a manifest registering every node of the staged template
  R="$FX/rec"; rm -rf "$R"; mkdir -p "$R/meta-contract-before-execution" "$R/meta-drift-eventlog" "$R/meta-correction-log" "$R/meta-ledger" "$R/meta-manifest" "$R/templates" "$R/pre/meta-drift-eventlog"
  cp "$SRC/templates/MANIFEST.template.yaml" "$R/templates/"
  printf 'contracts:\n  - contract_id: contract-001\n    feature: x\n    type: contract\n    status: implemented\n    verification_state: legacy\n    audited: legacy\n    disappointment: legacy\n    premortem: legacy\n    red_test: legacy\n    cost: legacy\n    work_id: null\n' > "$R/meta-contract-before-execution/CONTRACT-LOG.yaml"
  printf 'entries:\n  - drift_id: drift-001\n    status: mitigated\n    evidence: >-\n      the first line of evidence\n      and the second\n    elevation:\n      - target: >-\n          a long target name\n          continued\n        kind: memory-update\n        mitigation_medium: unknown\n' > "$R/meta-drift-eventlog/DRIFTLOG.yaml"
  cp "$R/meta-drift-eventlog/DRIFTLOG.yaml" "$R/pre/meta-drift-eventlog/"
  printf 'corrections:\n  - corr_id: C-001\n    noticed: |\n      not asked\n    would_have_been_right: |\n      not asked\n    seen_before: |\n      not asked\n' > "$R/meta-correction-log/CORRECTIONS.yaml"
  printf 'observations: []\nbatches:\n  - batch_id: B-1\n    represented: []\n' > "$R/meta-ledger/LEDGER.yaml"
  { printf 'kit_identity:\n  version: 0.15\nnodes:\n'; awk '/^nodes:/{f=1;next} /^[a-z_]+:/{f=0} f' "$SRC/templates/MANIFEST.template.yaml"; printf 'coverage_map: []\n'; } > "$R/meta-manifest/MANIFEST.yaml"
}
D0="meta-drift-eventlog/DRIFTLOG.yaml"
mkrec; r=$(bash "$G2" "$R" "$R/templates/MANIFEST.template.yaml" "$R/pre"); [ $? = 0 ] && ok "113 G2-migration exits 0 on a correctly migrated record set" || bad "113 G2 baseline" "$r"
mkrec; awk 'NR==10{print "        mitigation_medium: x"} {print}' "$R/$D0" > "$R/t" && mv "$R/t" "$R/$D0"
r=$(bash "$G2" "$R" "$R/templates/MANIFEST.template.yaml" "$R/pre"); rc=$?; [ $rc != 0 ] && case "$r" in *DRIFTLOG.yaml*contiguous*) ok "114 a key inserted inside a block scalar fails the check, naming the file";; *) bad "114 message" "$r";; esac || bad "114 severed scalar not caught" "$r"
mkrec; sed -i '3d' "$R/$D0"
r=$(bash "$G2" "$R" "$R/templates/MANIFEST.template.yaml"); rc=$?; [ $rc != 0 ] && case "$r" in *drift-001*status*0*) ok "115 an entry missing its migrated field fails the check, naming entry and field";; *) bad "115 message" "$r";; esac || bad "115 missing field not caught" "$r"
mkrec; sed -i '/{id: agent-verifier,/d' "$R/meta-manifest/MANIFEST.yaml"
r=$(bash "$G2" "$R" "$R/templates/MANIFEST.template.yaml"); rc=$?; [ $rc != 0 ] && case "$r" in *agent-verifier*) ok "116 a template node absent from the manifest fails the check, naming the node";; *) bad "116 message" "$r";; esac || bad "116 missing node not caught" "$r"
mkrec; awk 'NR==8{print "      mitigation_medium: unknown"} {print}' "$R/$D0" > "$R/t" && mv "$R/t" "$R/$D0"
r=$(bash "$G2" "$R" "$R/templates/MANIFEST.template.yaml"); rc=$?; [ $rc != 0 ] && case "$r" in *DRIFTLOG.yaml*mixes*) ok "116b a bare key at list level fails the check";; *) bad "116b message" "$r";; esac || bad "116b list-level key not caught" "$r"

echo "=== contract-008 T-3: roots by id ==="
# the report-010 defect reproduced: folders carry a layer prefix, dependencies name bare ids; matching folder names finds no root named
printf 'nodes:
  - {id: engagement-contract, kind: skill, skill_file: principle-engagement-contract/SKILL.md, load: trigger, triggers: [], owns: [principle-engagement-contract/], dependencies: []}
  - {id: render-vs-declared, kind: skill, skill_file: principle-render-vs-declared/SKILL.md, load: trigger, triggers: [], owns: [principle-render-vs-declared/], dependencies: [engagement-contract]}
  - {id: class-dashboard-ia, kind: skill, skill_file: pattern-class-dashboard-ia/SKILL.md, load: trigger, triggers: [], owns: [pattern-class-dashboard-ia/], dependencies: [engagement-contract, render-vs-declared]}
  - {id: base-map, kind: map, skill_file: meta-map/SKILL.md, load: trigger, triggers: [], owns: [meta-map/], dependencies: []}
coverage_map: []
' > "$FX/p.yaml"
r=$(bash "$RT" "$FX/p.yaml" 2>/dev/null | tr '
' ' '); [ "$r" = "class-dashboard-ia " ] && ok "117 roots are joined through skill_file: one root of three, where folder-name matching would report all three (report-010's 93 of 96)" || bad "117 roots by id" "$r"
printf 'nodes:\n  - {id: a, kind: skill, skill_file: pattern-a/SKILL.md, load: trigger, triggers: [], owns: [pattern-a/], dependencies: [b]}\n  - {id: b, kind: skill, skill_file: pattern-b/SKILL.md, load: trigger, triggers: [], owns: [pattern-b/], dependencies: []}\n  - id: c\n    kind: skill\n    skill_file: pattern-c/SKILL.md\n    load: trigger\n    triggers: []\n    owns: [pattern-c/]\n    dependencies: [b]\n  - {id: b2, kind: skill, skill_file: pattern-b/SKILL.md, load: trigger, triggers: [], owns: [pattern-b/], dependencies: []}\n  - {id: base-x, kind: skill, skill_file: meta-x/SKILL.md, load: trigger, triggers: [], owns: [meta-x/], dependencies: []}\ncoverage_map: []\n' > "$FX/m.yaml"
r=$(bash "$RT" "$FX/m.yaml" 2>/dev/null | tr '\n' ' '); [ "$r" = "a c " ] && ok "118 a node named by two others is no root; a folder under two ids counts once; meta skills never" || bad "118 roots synthetic" "$r"

echo "=== contract-008 T-4: a drift entry at legacy is left alone ==="
mk; printf 'entries:\n  - drift_id: d-1\n    status: legacy\n' > "$K/meta-drift-eventlog/DRIFTLOG.yaml"
r=$(ss); case "$r" in *"Pioneer-owned"*|*"Drift entries"*) bad "119 a legacy drift entry must raise no session-start line" "$r";; *) ok "119 session-start ignores status: legacy";; esac
[ "$(gate 'done')" = 0 ] && ok "120 the stop-gate hands over nothing for a legacy drift entry" || bad "120 gate on legacy" "task raised"
grep -q 'mitigated | resolved | legacy' "$SRC/templates/DRIFTLOG.template.yaml" && ok "121 legacy is in the drift template's enumeration" || bad "121 enumeration" "-"
grep -q '`legacy`' "$SRC/meta-mechanisms/SKILL.md" && grep -q 'never one at `legacy`' "$SRC/agents/kit-batch-assembler.md" && ok "122 the marker-key table and the batch assembler name legacy" || bad "122 legacy named" "-"

echo "=== contract-008 T-6 / G-1 / G-5: the procedure's text ==="
grep -q 'instance-file question' "$SRC/meta-bootstrap/SKILL.md" && grep -q 'asked as its own question' "$SRC/meta-bootstrap/SKILL.md" && ok "123 step 2 names the instance-file question and step 7 says it is asked" || bad "123 two questions" "-"
n=$(grep -c 'skills/installed/' "$SRC/meta-bootstrap/SKILL.md"); [ "$n" -ge 4 ] && grep -q '5g — Installed copies' "$SRC/meta-bootstrap/SKILL.md" && ok "124 the installed copies are written at install (5g) and read and refreshed on upgrade ($n mentions)" || bad "124 installed copies" "$n"
grep -q 'rehearsal-<date>.md' "$SRC/meta-bootstrap/SKILL.md" && grep -q 'did \*\*not\*\* check' "$SRC/meta-bootstrap/SKILL.md" && ok "125 the rehearsal log is kept and the report lists what was not checked" || bad "125 log and not-checked" "-"
grep -q 'G2-migration.sh' "$SRC/meta-bootstrap/SKILL.md" && grep -q 'checks/roots.sh' "$SRC/meta-bootstrap/SKILL.md" && ok "126 steps 8 and 9 name the two scripts" || bad "126 scripts named" "-"

echo; echo "contract-007 walk: $pass passed, $fail failed"; rm -rf "$FX"
[ "$fail" = 0 ]
