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
grep -q "^  version: 0.26" "$SRC/meta-manifest/MANIFEST.yaml" && grep -q "^  base_kit_version: 0.26" "$SRC/templates/MANIFEST.template.yaml" && ok "105 both manifests read 0.26" || bad "105 version" "-"
grep -q 'closed-by-follow-up' "$SRC/templates/CONTRACT-LOG.template.yaml" && grep -q 'approved-at-gate' "$SRC/templates/CONTRACT-LOG.template.yaml" && grep -q 'closed-by-follow-up' "$SRC/meta-contract-before-execution/SKILL.md" && grep -q 'approved-at-gate' "$SRC/meta-contract-before-execution/SKILL.md" && ok "106 enumerations in template and node" || bad "106 enumerations" "-"
n=0; for id in M-03 M-08 M-09 M-10 M-23 M-28 M-29; do l=$(grep "^$id " "$SRC/meta-map/MAP.md" | awk -F' \\| ' '{print $7}'); case "$l" in *": "*|*" then "*|*"; unauthorised"*|*"cite the id"*|*"flag it"*) n=$((n+1)); echo "      $id load: $l";; esac; done
[ "$n" = 0 ] && ok "107 the seven map entries carry file + heading only" || bad "107 map pointers" "$n entries still carry guidance"
for id in M-23 M-28; do s=$(grep "^$id " "$SRC/meta-map/MAP.md" | awk -F' \\| ' '{print $6}'); [ "$s" != "—" ] && ok "108 $id names a sibling: $s" || bad "108 $id sibling" "—"; done
grep -q 'watching' "$SRC/meta-mechanisms/SKILL.md" && ok "109 marker-key table names watching" || bad "109 watching" "-"
grep -c 'THE ONE WRITER LIST' "$SRC/templates/LEDGER.template.yaml" | grep -q '^1$' && grep -q "the one writer list" "$SRC/meta-ledger/SKILL.md" && ok "110 one writer list, the node points to it" || bad "110 writer list" "-"
diff <(sed '1d' "$SRC/meta-map/MAP.md" | sed '/^ALWAYS LOADED/,/^-->/d') <(sed '1d' "$SRC/templates/MAP.template.md" | sed '/^ALWAYS LOADED/,/^-->/d') >/dev/null && ok "111 template map and live map agree entry for entry" || bad "111 maps differ" "$(diff <(sed '1d' "$SRC/meta-map/MAP.md") <(sed '1d' "$SRC/templates/MAP.template.md") | head -3)"

echo "=== T-11: the README ==="
n=$(grep -c -i -E 'canary|brier|wilson|catch rate|lower.bound|v0\.14|dominant force' "$SRC/README.md"); [ "$n" = 0 ] && ok "112a census over README clean" || bad "112a README census" "$(grep -n -i -E 'canary|brier|wilson|catch rate|lower.bound|v0\.14|dominant force' "$SRC/README.md" | head -3)"
miss=""; for p in $(grep -o '`[a-zA-Z0-9_./-]*/[a-zA-Z0-9_./-]*`' "$SRC/README.md" | tr -d '`' | grep -E '^(meta-|agents/|templates/|docs/)' | grep -v 'NNN\|meta-manifest/INSTALLED\|meta-ledger/batches\|meta-mechanisms/checks/$' | sort -u); do [ -e "$SRC/$p" ] || miss="$miss $p"; done
[ -z "$miss" ] && ok "112b every path the README names exists on disk" || bad "112b README names missing paths" "$miss"
h=$(grep -c '^## \|^### ' "$SRC/README.md"); r=$(grep -c '^| [0-9]* | ' "$SRC/docs/readme-review.md"); [ "$r" -ge 19 ] && ok "112c readme-review.md has a row per section of the old README ($r rows; new README has $h headings)" || bad "112c review rows" "$r"
grep -q "v0.26" "$SRC/README.md" && grep -q "Contract-003" "$SRC/README.md" && grep -q "Contract-006" "$SRC/README.md" && ok "112d README status reads v0.26 and narrates 003–006" || bad "112d status" "-"

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
  { printf 'kit_identity:\n  version: 0.15\n  workspace: []\nnodes:\n'; awk '/^nodes:/{f=1;next} /^[a-z_]+:/{f=0} f' "$SRC/templates/MANIFEST.template.yaml"; awk '/^coverage_map:/{f=1} /^gap_queue:/{f=0} f' "$SRC/templates/MANIFEST.template.yaml"; printf 'gap_queue: []\n'; } > "$R/meta-manifest/MANIFEST.yaml"
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
grep -q 'instance-file question' "$SRC/meta-bootstrap/SKILL.md" && grep -q 'its own line on the sheet' "$SRC/meta-bootstrap/SKILL.md" && ok "123 step 2 names the instance-file question and step 7 gives it its own sheet line (since contract-011)" || bad "123 two questions" "-"
n=$(grep -c 'skills/installed/' "$SRC/meta-bootstrap/SKILL.md"); [ "$n" -ge 4 ] && grep -q '5g — Installed copies' "$SRC/meta-bootstrap/SKILL.md" && ok "124 the installed copies are written at install (5g) and read and refreshed on upgrade ($n mentions)" || bad "124 installed copies" "$n"
grep -q 'rehearsal-<date>.md' "$SRC/meta-bootstrap/SKILL.md" && grep -q 'did \*\*not\*\* check' "$SRC/meta-bootstrap/SKILL.md" && ok "125 the rehearsal log is kept and the report lists what was not checked" || bad "125 log and not-checked" "-"
grep -q 'G2-migration.sh' "$SRC/meta-bootstrap/SKILL.md" && grep -q 'checks/roots.sh' "$SRC/meta-bootstrap/SKILL.md" && ok "126 steps 8 and 9 name the two scripts" || bad "126 scripts named" "-"

echo "=== contract-009: the first real run's gaps ==="
grep -q 'not a raw clone' "$SRC/meta-bootstrap/SKILL.md" && grep -q 'short path first' "$SRC/meta-bootstrap/SKILL.md" && grep -q 'short-pathed folder' "$SRC/meta-bootstrap/SKILL.md" && ok "127 step 1 names the travel set and the short-path clone, step 2 the short-path copy (T-1)" || bad "127 long paths" "-"
mkrec; r=$(bash "$G2" "$R" "$R/templates/MANIFEST.template.yaml"); [ $? = 0 ] && ok "128a G2 exits 0 when every base coverage line is present" || bad "128a coverage baseline" "$r"
sed -i '/node_id: base-ledger,/d' "$R/meta-manifest/MANIFEST.yaml"
r=$(bash "$G2" "$R" "$R/templates/MANIFEST.template.yaml"); rc=$?; [ $rc != 0 ] && case "$r" in *MANIFEST.yaml*base-ledger*) ok "128b a base coverage line absent from the manifest fails the check, naming file and id (T-2)";; *) bad "128b message" "$r";; esac || bad "128b missing coverage line not caught" "$r"
grep -q 'nothing to ratify' "$SRC/meta-bootstrap/SKILL.md" && grep -q -i 'the kit ships 30 map entries' "$SRC/meta-bootstrap/SKILL.md" && ok "129 step 9 skips an empty pass; the offer's terms still stand (T-3; reworded by contract-011)" || bad "129 empty pass" "-"
n=$(grep -l -i 'this file is a template\|copies this file\|empty seed' "$SRC"/templates/*.template.yaml | wc -l); [ "$n" = 0 ] && ok "130 no template header calls itself a template (T-4)" || bad "130 template headers" "$(grep -l -i 'this file is a template\|copies this file\|empty seed' "$SRC"/templates/*.template.yaml | tr '\n' ' ')"
grep -q -F 'That replaces the tree-or-commit question of contract-009' "$SRC/meta-bootstrap/SKILL.md" && ! grep -q '\*the tree\* for the tree-or-commit question' "$SRC/meta-bootstrap/SKILL.md" && grep -q -F 'commit and push' "$SRC/meta-mechanisms/checks/preflight.sh" && ok "131 which copy is the project's is settled before the run: a clean commit, asked for by preflight - the question left the sheet (T-5; changed by contract-017, C-023)" || bad "131 tree-or-commit" "-"
r=$(bash "$G2" "$SRC"); [ $? = 0 ] && ok "132 G2-migration exits 0 on the base kit's own tree (T-6)" || bad "132 G2 on base tree" "$r"

mkrec; printf 'contracts:\n  - contract_id: contract-001\n    feature: x\n    type: contract\n    status: approved\n    verification_state: none\n    audited: false\n    disappointment: legacy\n    premortem: legacy\n    work_id: null\n' > "$R/meta-contract-before-execution/CONTRACT-LOG.yaml"
r=$(bash "$G2" "$R" "$R/templates/MANIFEST.template.yaml"); [ $? = 0 ] && ok "133 an entry at status: approved passes without cost or red_test, which the lifecycle writes later (revision 1)" || bad "133 approved without cost" "$r"

echo "=== contract-010: a kit across repositories ==="
grep -q 'Applications in the system flow' "$SRC/meta-bootstrap/SKILL.md" && grep -q '`workspace: \[\]` is added to `kit_identity`' "$SRC/meta-bootstrap/SKILL.md" && grep -q 'seven standing questions' "$SRC/meta-bootstrap/SKILL.md" && grep -q '\*none named\* for the workspace question' "$SRC/meta-bootstrap/SKILL.md" && ok "134 step 2 asks for the applications; step 7 adds the record; the standing list and the stub name the question (T-1)" || bad "134 the question" "-"
grep -q '^  workspace: \[\]' "$SRC/templates/MANIFEST.template.yaml" && grep -q '^  workspace: \[\]' "$SRC/meta-manifest/MANIFEST.yaml" && ok "135a the template and the kit's own manifest carry workspace (T-2)" || bad "135a workspace key" "-"
mkrec; sed -i '/^  workspace: \[\]$/d' "$R/meta-manifest/MANIFEST.yaml"
r=$(bash "$G2" "$R" "$R/templates/MANIFEST.template.yaml"); rc=$?; [ $rc != 0 ] && case "$r" in *MANIFEST.yaml*workspace*) ok "135b a manifest without workspace fails the check, naming the key (T-2)";; *) bad "135b message" "$r";; esac || bad "135b missing workspace not caught" "$r"
grep -q 'The workspace grant' "$SRC/meta-bootstrap/SKILL.md" && grep -q '"additionalDirectories": \[\]' "$SRC/templates/settings.template.json" && grep -q 'is rewritten from the manifest at every upgrade' "$SRC/meta-bootstrap/SKILL.md" && grep -q -F 'permissions.additionalDirectories' "$SRC/meta-mechanisms/checks/install.sh" && ok "136 step 5c writes the grant, the template carries the key, the upgrade keeps the pioneer's entries - since contract-018 install.sh does the writing (T-3)" || bad "136 the grant" "-"
grep -q '^> Applications in the system flow, beyond this repository: __WORKSPACE__' "$SRC/meta-bootstrap/SKILL.md" && grep -q -F 'rendering the applications line from the manifest' "$SRC/meta-bootstrap/SKILL.md" && grep -q -F '__WORKSPACE__' "$SRC/meta-mechanisms/checks/install.sh" && ok "137 the kit block carries the placeholder and step 5 renders it - since contract-018 install.sh does the rendering (T-4)" || bad "137 the block" "-"
# T-5: two installed kits, hooks anchored on A
FX2=$(mktemp -d); A2="$FX2/kitA"; B2="$FX2/kitB"
for rr in "$A2" "$B2"; do mkdir -p "$rr/.claude/skills/meta-mechanisms/hooks" "$rr/.claude/skills/meta-ledger" "$rr/.claude/skills/meta-manifest" "$rr/.claude/skills/meta-map" "$rr/.claude/skills/meta-contract-before-execution" "$rr/.claude/skills/meta-drift-eventlog" "$rr/sub"; cp "$SRC"/meta-mechanisms/hooks/*.sh "$rr/.claude/skills/meta-mechanisms/hooks/"; printf 'kit_type: project\nnodes:\n  - {id: base-map, kind: map, skill_file: meta-map/SKILL.md, load: always, triggers: [], owns: [meta-map/]}\n' > "$rr/.claude/skills/meta-manifest/MANIFEST.yaml"; printf 'x\n' > "$rr/.claude/skills/meta-map/SKILL.md"; printf 'contracts: []\n' > "$rr/.claude/skills/meta-contract-before-execution/CONTRACT-LOG.yaml"; done
printf 'entries:\n  - drift_id: d-1\n    status: watching\n' > "$A2/.claude/skills/meta-drift-eventlog/DRIFTLOG.yaml"
printf 'contracts:\n  - contract_id: c-9\n    status: implemented\n    verification_state: none\n    audited: false\n    bearing: x\n' > "$B2/.claude/skills/meta-contract-before-execution/CONTRACT-LOG.yaml"
HA="$A2/.claude/skills/meta-mechanisms/hooks"
printf '{"source":"startup"}' | CLAUDE_PROJECT_DIR="$A2" bash "$HA/session-start.sh" >/dev/null
printf '{"tool_name":"Read","tool_input":{"file_path":"%s/.claude/skills/meta-map/SKILL.md"}}' "$B2" | CLAUDE_PROJECT_DIR="$A2" bash "$HA/post-read.sh"
grep -q '|loaded|' "$A2/.claude/skills/meta-ledger/telemetry.log" && bad "138a a Read in kit B must not be logged as kit A's evidence" "$(grep loaded "$A2/.claude/skills/meta-ledger/telemetry.log")" || ok "138a a Read in kit B writes nothing into kit A's telemetry (T-5)"
printf '{"tool_name":"Read","tool_input":{"file_path":"%s/.claude/skills/meta-map/SKILL.md"}}' "$A2" | CLAUDE_PROJECT_DIR="$A2" bash "$HA/post-read.sh"
grep -q '|loaded|meta-map/SKILL.md' "$A2/.claude/skills/meta-ledger/telemetry.log" && ok "138b a Read in kit A is still logged (T-5)" || bad "138b kit A's own read" "$(cat "$A2/.claude/skills/meta-ledger/telemetry.log")"
r=$(printf '{"source":"startup","cwd":"%s"}' "$B2/sub" | CLAUDE_PROJECT_DIR="$A2" bash "$HA/session-start.sh" | sed 's/.*additionalContext":"//')
case "$r" in *"not audited"*) ok "138c a hook told cwd is kit B reports kit B's backlog (T-5)";; *) bad "138c cwd resolution" "$r";; esac
grep -q '|session-start|' "$B2/.claude/skills/meta-ledger/telemetry.log" 2>/dev/null && ok "138d ...and writes its telemetry into kit B" || bad "138d telemetry root" "$(ls "$B2/.claude/skills/meta-ledger/")"
# T-6: the template's locator, run from a subfolder of kit A with CLAUDE_PROJECT_DIR elsewhere
cmd=$(sed -n '/"SessionStart"/,/\]/p' "$SRC/templates/settings.template.json" | grep -o '"command": ".*"' | head -1 | sed 's/^"command": "//; s/"$//; s/\\"/"/g')
r=$(cd "$A2/sub" && printf '{"source":"startup"}' | CLAUDE_PROJECT_DIR=/nonexistent bash -c "$cmd" | sed 's/.*additionalContext":"//')
case "$r" in *"Drift entries watching"*) ok "139a the template's SessionStart command finds kit A by walking up from its subfolder (T-6)";; *) bad "139a locator" "$r";; esac
n=$(grep -c 'hooks/lib.sh' "$SRC"/agents/kit-*.md | awk -F: '{s+=$2} END{print s}'); [ "$n" = 16 ] && ok "139b all sixteen agent hook lines use the locator (T-6)" || bad "139b agent locators" "$n"
n=$(grep -c 'hooks/lib.sh' "$SRC/templates/settings.template.json"); [ "$n" = 7 ] && ok "139c all seven template hook commands use the locator (T-6)" || bad "139c template locators" "$n"
grep -q 'Which kit a hook acts on' "$SRC/meta-mechanisms/SKILL.md" && ok "140 the mechanisms node states which kit a hook acts on" || bad "140 mechanisms node" "-"
rm -rf "$FX2"

echo "=== contract-011: one sheet, a silent run, a done block ==="
grep -q 'present the introduction and the sheet together' "$SRC/meta-bootstrap/SKILL.md" && grep -q 'The rehearsal produces \*\*the sheet\*\*' "$SRC/meta-bootstrap/SKILL.md" && ok "141 the install presents once after the reading; the rehearsal produces the sheet (T-1)" || bad "141 read first" "-"
n=$(grep -c '^## The sheet and the done block' "$SRC/meta-bootstrap/SKILL.md"); [ "$n" = 1 ] && grep -q 'what changes in the records, what will be asked later because of it, what cannot be undone' "$SRC/meta-bootstrap/SKILL.md" && ok "142 one sheet section, and its line form carries the impact of each choice (T-2)" || bad "142 the sheet's form" "$n"
grep -q 'every question the run meets was on the sheet' "$SRC/meta-bootstrap/SKILL.md" && ok "143a the pass rule holds the real run to the sheet (T-3)" || bad "143a pass rule" "-"
n=0; for q in 'one line per differing skill' 'the stale list' 'contracts to verify' 'drift entries at `mitigated`' 'the instance-file question' 'the workspace question' 'the map question' 'the ratification pass' 'the acceptance'; do grep -q "^> [0-9]*\. .*$q" "$SRC/meta-bootstrap/SKILL.md" && n=$((n+1)); done; [ "$n" = 9 ] && ok "143b the upgrade sheet names every standing question and the two ends ($n of 9; ten until contract-017 took tree-or-commit off the sheet) (T-3)" || bad "143b upgrade sheet lines" "$n of 9"
n=0; for p in '\*\*Verified:\*\*' 'Waiting on you, when you want it' '\*\*Not checked:\*\*' '\*\*Next session\*\*' 'Start working\.'; do grep -q "$p" "$SRC/meta-bootstrap/SKILL.md" && n=$((n+1)); done; [ "$n" = 5 ] && ok "144a the done block has its five parts (T-4)" || bad "144a done block parts" "$n of 5"
n=$(grep -c 'mark-done.sh' "$SRC/meta-bootstrap/SKILL.md"); [ "$n" -ge 3 ] && ! grep -q 'What would you like to build first' "$SRC/meta-bootstrap/SKILL.md" && ! grep -q 'accepts the report' "$SRC/meta-bootstrap/SKILL.md" && ok "144b Step 7 and step 9 end on the done block; the old endings are gone (T-4)" || bad "144b endings" "mark-done mentions: $n"
# T-5: the grace
mk; printf 'observations:\n  - obs_id: O-1\n    review_due: true\n  - obs_id: O-2\n    review_due: true\n  - obs_id: O-3\n    review_due: true\n' > "$K/meta-ledger/LEDGER.yaml"
printf 'contracts:\n  - contract_id: c-9\n    status: implemented\n    verification_state: none\n    audited: false\n    bearing: x\n' > "$K/meta-contract-before-execution/CONTRACT-LOG.yaml"
printf '2026-09-18T10:00:00Z|session-start|startup\n' > "$K/meta-ledger/telemetry.log"
CLAUDE_PROJECT_DIR="$FX" bash "$H/mark-done.sh" upgrade >/dev/null
r=$(printf '{"stop_hook_active":false,"last_assistant_message":"done."}' | CLAUDE_PROJECT_DIR="$FX" bash "$H/stop-gate.sh")
case "$r" in *unaudited*) ok "145a in grace the gate still hands over the audit (T-5)";; *) bad "145a audit in grace" "$r";; esac
printf 'contracts: []\n' > "$K/meta-contract-before-execution/CONTRACT-LOG.yaml"
r=$(printf '{"stop_hook_active":false,"last_assistant_message":"done."}' | CLAUDE_PROJECT_DIR="$FX" bash "$H/stop-gate.sh" | grep -c additionalContext); [ "$r" = 0 ] && ok "145b in grace the gate hands over no batch though three candidates are due (T-5)" || bad "145b batch in grace" "fired"
printf '2026-09-18T11:00:00Z|session-start|startup\n' >> "$K/meta-ledger/telemetry.log"
r=$(printf '{"stop_hook_active":false,"last_assistant_message":"done."}' | CLAUDE_PROJECT_DIR="$FX" bash "$H/stop-gate.sh"); case "$r" in *"Pioneer-owned"*) ok "145c the next session start ends the grace: the batch is back (T-5)";; *) bad "145c after grace" "$r";; esac
grep -q 'hooks/mark-done.sh' "$SRC/meta-mechanisms/SKILL.md" && grep -q '`done`' "$SRC/meta-mechanisms/SKILL.md" && ok "146 the mechanisms node lists mark-done.sh and the done event" || bad "146 inventory" "-"

echo "=== contract-012: Tier 4 drafted with the tiers ==="
grep -q 'Tier 4 is drafted and presented with Tiers 1–3, in the same message' "$SRC/meta-contract-before-execution/SKILL.md" && grep -q 'stop once: ask for the disappointment lines per guarantee, the pre-mortem below, and the approval, in one reply' "$SRC/meta-contract-before-execution/SKILL.md" && ! grep -q 'After presenting Tier 4, stop again' "$SRC/meta-contract-before-execution/SKILL.md" && ok "147 Tier 4 is drafted with the tiers and the gate is one stop (T-1)" || bad "147 the order" "-"
grep -q 'a `realigned:` line naming the tests' "$SRC/meta-contract-before-execution/SKILL.md" && grep -q 'asked at the gate against the drafted tier_4' "$SRC/templates/CONTRACT-LOG.template.yaml" && ! grep -q 'BEFORE tier_4 is written' "$SRC/templates/CONTRACT-LOG.template.yaml" && ok "148 the realigned line is named and the template no longer places the lines before Tier 4 (T-2)" || bad "148 the record" "-"
grep -q 'a drafted test is drawn from the lay of the land after implementation' "$SRC/meta-contract-before-execution/SKILL.md" && grep -q 'the record of tests written by the builder alone is that they pass while the work is wrong' "$SRC/meta-contract-before-execution/SKILL.md" && ok "149 a drafted test is drawn from the land after implementation, and the builder-written-tests sentence stands (T-3)" || bad "149 what a draft is made from" "-"

echo "=== contract-013: one thing everywhere, and tests that see an old sentence ==="
G3="$SRC/meta-mechanisms/checks/G3-retired.sh"; G4="$SRC/meta-mechanisms/checks/G4-pointers.sh"; RS="$SRC/meta-mechanisms/checks/residue.sh"
T13=$(mktemp -d)
printf '# Title\n\nThe kit compares each skill line by line, with carriage returns removed, and the lines left over\nare the residue the pioneer is asked about once per file.\n\n- a bullet the kit wrote\n' > "$T13/yard.md"
printf '# Title\n\nThe kit compares each skill line by line, with carriage returns\nremoved, and the lines left over are the residue the pioneer\nis asked about once per file.\n\n- a bullet the kit wrote\n' > "$T13/wrapped.md"
r=$(bash "$RS" "$T13/wrapped.md" "$T13/yard.md" 2>/dev/null); [ -z "$r" ] && ok "150a a skill whose only change is a re-wrapped paragraph yields no lines of the project's (T-1)" || bad "150a re-wrap" "$r"
{ cat "$T13/wrapped.md"; printf 'A project rule kept here: every map entry names the file it loads.\n'; } > "$T13/proj.md"
r=$(bash "$RS" "$T13/proj.md" "$T13/yard.md" 2>/dev/null); [ "$r" = "A project rule kept here: every map entry names the file it loads." ] && ok "150b with one added sentence it yields exactly that sentence (T-1)" || bad "150b residue" "$r"
sort -u "$T13/yard.md" | grep -v '^$' > "$T13/yard.lines"; r=$(bash "$RS" "$T13/proj.md" "$T13/yard.lines" 2>/dev/null); [ "$r" = "A project rule kept here: every map entry names the file it loads." ] && ok "150c the same answer against a line-history file, which has lost the document's order (T-1)" || bad "150c residue vs history" "$r"
n=$(ls "$SRC"/templates/*.template.yaml "$SRC"/templates/*.template.md 2>/dev/null | wc -l | tr -d ' '); s=$(grep -c -E '^\*\*6[a-i] — ' "$SRC/meta-bootstrap/SKILL.md"); m=$(grep -l -i 'this file is a template\|copies this file\|empty seed' "$SRC"/templates/*.template.yaml "$SRC"/templates/*.template.md | wc -l | tr -d ' ')
[ "$n" = 9 ] && [ "$s" = 9 ] && [ "$m" = 0 ] && ok "151 the install seeds nine record templates, nine are checked, none calls itself a template (T-1)" || bad "151 templates" "templates=$n seed-steps=$s offenders=$m"
if command -v cygpath >/dev/null 2>&1; then
  # the shell's drive-letter spelling (/c/...), which is how a real project's path reads; mktemp's /tmp is a mount no sed can translate
  M13=$(cygpath -m "$T13"); D13="/$(printf '%s' "${M13%%:*}" | tr '[:upper:]' '[:lower:]')${M13#*:}"; A13="$D13/kitA"; mkdir -p "$A13/.claude/skills/meta-mechanisms/hooks" "$A13/.claude/skills/meta-ledger" "$A13/.claude/skills/meta-manifest" "$A13/.claude/skills/meta-map"
  cp "$SRC"/meta-mechanisms/hooks/*.sh "$A13/.claude/skills/meta-mechanisms/hooks/"
  printf 'kit_type: project\nnodes:\n  - {id: base-ledger, kind: record, skill_file: meta-ledger/SKILL.md, load: trigger, triggers: [], owns: [meta-ledger/]}\n' > "$A13/.claude/skills/meta-manifest/MANIFEST.yaml"
  printf 'x\n' > "$A13/.claude/skills/meta-map/SKILL.md"
  W13=$(cygpath -w "$A13"); J13=${W13//\\/\\\\}; H13="$A13/.claude/skills/meta-mechanisms/hooks"; L13="$A13/.claude/skills/meta-ledger/telemetry.log"
  ( cd "$A13" && printf '{"tool_name":"Read","tool_input":{"file_path":"%s\\\\.claude\\\\skills\\\\meta-map\\\\SKILL.md"}}' "$J13" | CLAUDE_PROJECT_DIR="$A13" bash "$H13/post-read.sh" )
  grep -q '|loaded|meta-map/SKILL.md' "$L13" 2>/dev/null && ok "152a root in the shell's spelling, file in the drive-letter spelling: the kit's own read is logged (T-1)" || bad "152a spellings, read" "$(cat "$L13" 2>/dev/null)"
  ( cd "$A13" && printf '{"tool_name":"Edit","tool_input":{"file_path":"%s\\\\.claude\\\\skills\\\\meta-ledger\\\\LEDGER.yaml"}}' "$J13" | CLAUDE_PROJECT_DIR="$A13" bash "$H13/owner-check.sh" )
  grep -q '|bypass|base-ledger|' "$L13" 2>/dev/null && ok "152b ...and an ungoverned edit reported in the other spelling is caught (T-1)" || bad "152b spellings, edit" "$(cat "$L13" 2>/dev/null)"
  rm -f "$L13"; printf '{"cwd":"%s","tool_name":"Read","tool_input":{"file_path":"%s/.claude/skills/meta-map/SKILL.md"}}' "$J13" "$A13" | CLAUDE_PROJECT_DIR="$A13" bash "$H13/post-read.sh"
  grep -q '|loaded|meta-map/SKILL.md' "$L13" 2>/dev/null && ok "152c the other way round: root from a drive-letter cwd, file in the shell's spelling (T-1)" || bad "152c spellings, reversed" "$(cat "$L13" 2>/dev/null)"
  B13="$D13/kitB"; mkdir -p "$B13/.claude/skills/meta-map"; printf 'x\n' > "$B13/.claude/skills/meta-map/SKILL.md"; WB13=$(cygpath -w "$B13"); JB13=${WB13//\\/\\\\}
  rm -f "$L13"; ( cd "$A13" && printf '{"tool_name":"Read","tool_input":{"file_path":"%s\\\\.claude\\\\skills\\\\meta-map\\\\SKILL.md"}}' "$JB13" | CLAUDE_PROJECT_DIR="$A13" bash "$H13/post-read.sh" )
  [ ! -s "$L13" ] && ok "152d ...and another kit's file, in either spelling, is still ignored (T-1)" || bad "152d another kit's file logged" "$(cat "$L13" 2>/dev/null)"
else
  ok "152 path spellings: not applicable on this platform (no cygpath; one spelling only)"
fi
bash "$G3" >/dev/null && grep -q 'nothing stops here' "$SRC/meta-bootstrap/SKILL.md" && grep -q 'never asked mid-run — the line is left out' "$SRC/meta-bootstrap/SKILL.md" && ok "153 no retired wording survives, and the two mid-run asks now take the sheet's answer or the default (T-2)" || bad "153 silent run" "$(bash "$G3" | head -2)"
o=$(grep -l -F -e 'seen to fail before the work starts' -e 'one test seen to fail (M-04)' -e 'derived from the disappointment lines' -e 'Final approval comes after the red test' -e 'The three tiers as identified clauses' "$SRC/meta-foundation/INTENT.md" "$SRC/meta-contract-before-execution/SKILL.md" "$SRC/README.md" "$SRC/templates/CONTRACT-LOG.template.yaml" "$SRC/meta-contract-artifact/SKILL.md" | tr '\n' ' ')
[ -z "$o" ] && grep -q 'one test is seen to fail after the build' "$SRC/meta-foundation/INTENT.md" && grep -q 'The red test comes after the build' "$SRC/meta-contract-before-execution/SKILL.md" && grep -q 'one is seen to fail after the build' "$SRC/README.md" && grep -q 'drafted with the tiers, realigned to the disappointment lines' "$SRC/templates/CONTRACT-LOG.template.yaml" && grep -q 'The four tiers as identified clauses' "$SRC/meta-contract-artifact/SKILL.md" && ok "154 five files state one contract order, and none still states the old one (T-3)" || bad "154 one order" "old order in: ${o:-none}"
grep -q '^- \*\*Precedents bind\.\*\*' "$SRC/meta-foundation/INTENT.md" && grep -q '^\*\*Binding\.\*\*' "$SRC/meta-casebook/SKILL.md" && ok "155 the intent and the casebook state the doctrine the pioneer chose: a matching precedent decides (T-4)" || bad "155 doctrine" "-"
n=0; for p in 'one sheet' 'done block' 'reapply them on top' 'seven standing questions' 'mark-done.sh' 'G2-migration.sh' 'roots.sh' 'residue.sh'; do grep -q "$p" "$SRC/README.md" && n=$((n+1)); done
e=$(grep -h '^    source:' "$SRC/meta-ledger/LEDGER.yaml" | sed 's/ *#.*//' | grep -c -v -E 'source: (ser|learning|verification|drift|auditor|map-miss|pioneer)$')
awk '/prec_id: P-001/{f=1} /prec_id: P-002/{f=0} f' "$SRC/meta-casebook/CASEBOOK.yaml" | grep -q 'contract_id: contract-009' && p=1 || p=0
[ "$n" = 8 ] && [ "$e" = 0 ] && [ "$p" = 1 ] && bash "$G4" >/dev/null && ok "156 the README names the current flows; no ledger source outside its list; P-001 lists contract-009; every pointer resolves (T-5)" || bad "156 README and records" "readme=$n/8 bad-sources=$e p001=$p g4=$(bash "$G4" | head -1)"
mkdir -p "$T13/k/meta-x" "$T13/k/meta-y"; printf '## Somewhere\n' > "$T13/k/meta-y/SKILL.md"; printf 'See `meta-y` → Somewhere for it.\n' > "$T13/k/meta-x/SKILL.md"
bash "$G3" "$T13/k" >/dev/null && bash "$G4" "$T13/k" >/dev/null && ok "157a both new checks pass on a clean fixture kit (T-6)" || bad "157a clean fixture" "$(bash "$G3" "$T13/k"; bash "$G4" "$T13/k")"
printf 'This file is a template.\n' >> "$T13/k/meta-x/SKILL.md"; r=$(bash "$G3" "$T13/k"); rc=$?; [ $rc != 0 ] && case "$r" in *meta-x/SKILL.md*"This file is a template"*) ok "157b a planted retired wording fails G3, naming file and phrase (T-6)";; *) bad "157b message" "$r";; esac || bad "157b planted phrase not caught" "$r"
printf 'See `meta-y` → Nowhere for it.\n' > "$T13/k/meta-x/SKILL.md"; r=$(bash "$G4" "$T13/k"); rc=$?; [ $rc != 0 ] && case "$r" in *Nowhere*) ok "157c a planted pointer to a missing heading fails G4, naming it (T-6)";; *) bad "157c message" "$r";; esac || bad "157c planted pointer not caught" "$r"
grep -q 'Commit each contract alone' "$SRC/meta-contract-before-execution/SKILL.md" && ok "158 the contract skill carries the one-commit rule (T-6)" || bad "158 commit rule" "-"
rm -rf "$T13"

echo "=== contract-014: what reaches the pioneer says what it is, why now, and what is asked ==="
F14="$SRC/meta-foundation/SKILL.md"; C14="$SRC/meta-contract-before-execution/SKILL.md"; L14="$SRC/meta-ledger/SKILL.md"
grep -q -F -- '- **Translate for the pioneer.**' "$SRC/meta-foundation/INTENT.md" && bash "$SRC/meta-mechanisms/checks/G1-size.sh" >/dev/null && grep -q -F '5120' "$SRC/meta-mechanisms/checks/G1-size.sh" && ok "159 the always-loaded intent carries the rule and still fits its 5,120 bytes, the limit unmoved (T-5)" || bad "159 intent" "$(wc -c < "$SRC/meta-foundation/INTENT.md") B; $(bash "$SRC/meta-mechanisms/checks/G1-size.sh" | head -1)"
grep -q -F '**Why you are seeing this:**' "$L14" && grep -q -F '**What is asked:**' "$L14" && grep -q -F 'no more and no fewer' "$L14" && grep -q -F 'nothing in these lines can mark it' "$L14" && grep -q -F '**Why you are seeing this:**' "$SRC/agents/kit-batch-assembler.md" && grep -q -F 'never replace or shorten them' "$SRC/agents/kit-batch-assembler.md" && grep -q -F 'A figure is copied as the record gives it' "$SRC/agents/kit-batch-assembler.md" && grep -q -F 'never by its `O-` or `C-` id' "$SRC/agents/kit-batch-assembler.md" && grep -q -F 'the choices offered are exactly the file' "$SRC/meta-skill-builder/SKILL.md" && ok "160 the batch item, its builder and its presenter carry the two lines, the record's words kept, the ask exactly the kind's, a re-shown item unmarked (T-1)" || bad "160 batch item" "-"
grep -q -F 'not its id, and not its confidence figure' "$C14" && grep -q -F 'nothing is asked of them now' "$C14" && ok "161 after a build: each note a plain sentence, no bare id, no bare number, nothing asked (T-2)" || bad "161 closing block" "-"
grep -q -F 'a precedent or a candidate is named by what it says' "$C14" && ok "162 a contract draw names a past ruling by what it held (T-3)" || bad "162 draw" "-"
n=$(cat "$SRC"/meta-*/SKILL.md | grep -c -F "**Passing on an agent's result.**"); [ "$n" = 1 ] && grep -q -F 'none merged and none left out' "$C14" && grep -q -F 'each with what it writes and what follows from it' "$C14" && grep -q -F 'they can confirm it or withdraw it' "$SRC/meta-antidrift/SKILL.md" && ok "163 the pass-on rule is stated once; the verification hand-over puts every clause and the three closures in words (T-4)" || bad "163 pass-on" "stated $n time(s)"
grep -q -F 'The agent regards how it presents its output to the pioneer and adapts it to make it accessible, clear and actionable' "$F14" && grep -q -F 'Translation adds; it never replaces' "$F14" && grep -q -F '`presented_for_pioneer`' "$SRC/agents/kit-session-auditor.md" && grep -q -F 'whose record you may read' "$SRC/agents/kit-session-auditor.md" && grep -q -F 'presented_for_pioneer: ' "$SRC/templates/LEDGER.template.yaml" && [ -f "$SRC/meta-mechanisms/tests/results/contract-014-T-1-T-7.md" ] && ok "164 the pioneer's test stands in their words, the auditor checks it from outside, and both agent runs are on record (T-7)" || bad "164 conduct" "-"

echo "=== contract-015: promises that hold without the agent remembering ==="
X15="$SRC/meta-mechanisms/tests/walk.expected"
n=$(grep -c . "$X15"); p=$(sed -n '37,$p' "$X15" | grep -c -E '/|\\'); [ "$n" = 47 ] && [ "$p" = 0 ] && ok "165 the travelling walk has 47 states, and the eleven new lines carry no path, drive letter or slash (T-3)" || bad "165 travelling walk" "lines=$n platform-marks=$p"
e=$(awk '/^  - contract_id: contract-015$/{f=1} f&&/^    transcript:/{print $2; exit}' "$SRC/meta-contract-before-execution/CONTRACT-LOG.yaml")
case "$e" in */*|"") t=0 ;; *) t=1 ;; esac
[ "$t" = 1 ] && grep -q -F 'find it with Glob on `~/.claude/projects/*/<id>.jsonl`' "$SRC/agents/kit-session-auditor.md" && grep -q -F 'the id alone, which the session-start hook names, never a path' "$SRC/meta-contract-before-execution/SKILL.md" && grep -q -F 'session-start hook names, never a path' "$SRC/templates/CONTRACT-LOG.template.yaml" && ok "166 the session id's road is written end to end: hook, entry, gate, auditor - and this contract's own entry records an id, no path (T-2)" || bad "166 session id" "entry transcript=$e"
grep -q -F "the pre-mortem's words stand as that guarantee's line" "$SRC/meta-contract-before-execution/SKILL.md" && grep -q -F 'does not rest on that script' "$SRC/meta-bootstrap/SKILL.md" && grep -q -F '.session-started' "$SRC/meta-bootstrap/SKILL.md" && ok "167 the gate states the pioneer's default, and the bootstrap no longer rests the hold on a script (T-5, T-1)" || bad "167 gate sentence" "-"

echo "=== contract-016: the upgrade procedure in steps, not a word changed ==="
G5="$SRC/meta-mechanisms/checks/G5-steps.sh"; SW="$SRC/meta-mechanisms/tests/same-words.sh"; T16=$(mktemp -d)
bash "$G5" >/dev/null && ok "168a no paragraph of the bootstrap skill is over its 1,200 bytes (T-1)" || bad "168a G5-steps on the tree" "$(bash "$G5" | head -2)"
mkdir -p "$T16/meta-bootstrap"; { printf 'short line\n'; head -c 1300 /dev/zero | tr '\0' 'x'; printf '\nshort again\n'; } > "$T16/meta-bootstrap/SKILL.md"
r=$(bash "$G5" "$T16"); rc=$?; [ $rc != 0 ] && case "$r" in *"line 2 is 1300 bytes"*) ok "168b a planted long paragraph fails the check, naming the line and its length (T-1)";; *) bad "168b message" "$r";; esac || bad "168b planted paragraph not caught" "$r"
printf 'One. Two, and three; four.\n- five\n' > "$T16/a.md"; printf 'One.\n\n   Two, and three;\n   - four.\n- five\n' > "$T16/b.md"; printf 'One.\n\n   Two, or three;\n   - four.\n- five\n' > "$T16/c.md"
bash "$SW" "$T16/a.md" "$T16/b.md" >/dev/null && ! bash "$SW" "$T16/a.md" "$T16/c.md" >/dev/null && ok "169 the same-words proof passes a text split at line breaks and fails one with a single word changed (T-2)" || bad "169 same-words" "$(bash "$SW" "$T16/a.md" "$T16/b.md"; bash "$SW" "$T16/a.md" "$T16/c.md")"
[ -f "$SRC/meta-mechanisms/tests/results/contract-016-T-2-T-4.md" ] && grep -q -F 'every `G*.sh`' "$SRC/meta-bootstrap/SKILL.md" && ok "170 the one-off proofs are on record, and the new check travels with the kit's other checks (T-2, T-4)" || bad "170 record" "-"
rm -rf "$T16"

echo "=== contract-017: installed and upgraded the way software is upgraded ==="
C17="$SRC/meta-mechanisms/checks"; T17=$(mktemp -d); G17="git -c user.name=walk -c user.email=walk@example.invalid"
# a release from the last commit; the scripts this tree has and that commit may not are added to its list, as a release of this tree would carry them
bash "$SRC/meta-bootstrap/release.sh" --from-last-commit "$T17/rel" >/dev/null 2>&1
for f in preflight.sh rollback.sh merge.sh hooks-selftest.sh; do cp "$C17/$f" "$T17/rel/meta-mechanisms/checks/$f"; done
( cd "$T17/rel" && find . -type f ! -name RELEASE ! -name RELEASE.sha1 -print0 | sort -z | while IFS= read -r -d '' f; do printf '%s  %s\n' "$(tr -d '\r' < "$f" | sha1sum | cut -c1-40)" "${f#./}"; done > RELEASE.sha1 )
n=$(grep -c . "$T17/rel/RELEASE.sha1"); m=$(cd "$T17/rel" && find . -type f ! -name RELEASE ! -name RELEASE.sha1 | wc -l | tr -d ' ')
own=$(cd "$T17/rel" && ls meta-contract-before-execution/CONTRACT-LOG.yaml meta-ledger/LEDGER.yaml meta-correction-log/CORRECTIONS.yaml meta-casebook/CASEBOOK.yaml meta-manifest/MANIFEST.yaml meta-map/MAP.md meta-mechanisms/tests/results meta-mechanisms/tests/walk-007.sh meta-mechanisms/checks/P-004.sh 2>/dev/null | wc -l | tr -d ' ')
grep -q '^version: ' "$T17/rel/RELEASE" && [ "$n" = "$m" ] && [ "$own" = 0 ] && ! grep -q -i 'users\|appdata' "$T17/rel/RELEASE" && ok "171a a release lists exactly the files it holds, names its version, and holds none of this repository's records or evidence (T-1)" || bad "171a release" "listed=$n held=$m own=$own"
# a project: an installed kit one version behind, in a repository
P17="$T17/proj"; mkdir -p "$P17/.claude/skills/meta-manifest" "$P17/.claude/skills/meta-ledger" "$P17/.claude/skills/templates" "$P17/.claude/agents"
printf 'kit_identity:\n  kit_type: project\n  base_kit_version: 0.01\nnodes: []\n' > "$P17/.claude/skills/meta-manifest/MANIFEST.yaml"
printf 'observations: []\nbatches: []\n' > "$P17/.claude/skills/meta-ledger/LEDGER.yaml"; printf '# old template\n' > "$P17/.claude/skills/templates/X.template.yaml"; printf 'agent\n' > "$P17/.claude/agents/a.md"; printf '# project\n' > "$P17/CLAUDE.md"
( cd "$P17" && git init -q && git add -A >/dev/null 2>&1 && $G17 commit -q -m start )
cp -R "$T17/rel" "$P17/.claude/kit-incoming"; PF17=".claude/kit-incoming/meta-mechanisms/checks/preflight.sh"
r=$(cd "$P17" && bash $PF17 check); rc=$?; [ $rc = 0 ] && [ ! -f "$P17/.claude/kit-upgrade.lock" ] && ok "172a a clean project with a whole staged release passes the check, and the check changes nothing (T-2)" || bad "172a preflight check" "$rc $r"
mv "$P17/.claude/kit-incoming/agents/kit-verifier.md" "$T17/"; r=$(cd "$P17" && bash $PF17 check); rc=$?; mv "$T17/kit-verifier.md" "$P17/.claude/kit-incoming/agents/"
[ $rc = 1 ] && case "$r" in *"not whole"*"kit-verifier.md (missing)"*) ok "171b a staged kit with one file removed is refused, naming the file (T-1)";; *) bad "171b message" "$r";; esac || bad "171b partial release not refused" "$rc"
printf 'contracts: []\n' > "$P17/.claude/kit-incoming/meta-contract-before-execution/CONTRACT-LOG.yaml"; r=$(cd "$P17" && bash $PF17 check); rc=$?; rm "$P17/.claude/kit-incoming/meta-contract-before-execution/CONTRACT-LOG.yaml"
[ $rc = 1 ] && case "$r" in *"not on its own list"*) ok "171c a staged folder carrying a record the release never listed - a raw copy - is refused (T-1)";; *) bad "171c message" "$r";; esac || bad "171c raw copy not refused" "$rc"
echo wip > "$P17/work.txt"; r=$(cd "$P17" && bash $PF17 check); rc=$?; rm "$P17/work.txt"
[ $rc = 1 ] && case "$r" in *"commit and push"*"it uses git"*"snapshot"*"way back"*) ok "172b uncommitted work: refused with a warning that asks the pioneer to commit and push, and says why - the upgrade uses git (T-2, C-023)";; *) bad "172b message" "$r";; esac || bad "172b dirty tree not refused" "$rc"
cp "$P17/.claude/skills/meta-ledger/LEDGER.yaml" "$T17/l.keep"; printf 'observations: []\nbatches:\n  - batch_id: B-001\n    decided: false\n' > "$P17/.claude/skills/meta-ledger/LEDGER.yaml"; ( cd "$P17" && $G17 commit -q -am batch )
r=$(cd "$P17" && bash $PF17 check); rc=$?; cp "$T17/l.keep" "$P17/.claude/skills/meta-ledger/LEDGER.yaml"; ( cd "$P17" && $G17 commit -q -am nobatch )
[ $rc = 1 ] && case "$r" in *"review batch is open"*"cannot read the ledger"*) ok "172c an open review batch is refused, with the reason (T-2)";; *) bad "172c message" "$r";; esac || bad "172c open batch not refused" "$rc"
gitdir=$(dirname "$(command -v git)"); r=$(cd "$P17" && env PATH="$(printf '%s' "$PATH" | tr ':' '\n' | grep -v -x -F "$gitdir" | grep -v -i '/git/\|/mingw64/bin\|/cmd$' | tr '\n' ':')" bash $PF17 check 2>&1); rc=$?
case "$r" in *"git is not available"*"snapshot"*) ok "172d with git out of reach the check refuses and says what the upgrade needs it for (T-2)";; *) if command -v git >/dev/null 2>&1 && printf '%s' "$r" | grep -q 'passed'; then ok "172d git could not be hidden on this machine; the refusal's text is checked instead: $(grep -c 'git is not available' "$C17/preflight.sh") sentence in the script (T-2)"; else bad "172d no-git" "$rc $r"; fi;; esac
h17() { ( cd "$P17" && find .claude CLAUDE.md -type f ! -path '.claude/kit-incoming/*' ! -name kit-upgrade.lock -print0 | sort -z | xargs -0 sha1sum | sha1sum | cut -c1-16 ); }
( cd "$P17" && rm -rf .claude/skills .claude/agents CLAUDE.md && git checkout -q -- . ); b=$(h17)
r=$(cd "$P17" && bash $PF17 begin); grep -q '^snapshot: commit ' "$P17/.claude/kit-upgrade.lock" 2>/dev/null && ok "172e begin records the starting point: the lock names the commit (T-2)" || bad "172e lock" "$r"
r=$(cd "$P17" && bash $PF17 check); rc=$?; [ $rc = 1 ] && case "$r" in *"did not finish"*"never continued"*"rollback.sh"*) ok "172f a second start while the lock stands is refused and names the way back (T-2)";; *) bad "172f message" "$r";; esac || bad "172f lock not honoured" "$rc"
r=$(printf '{"cwd":"%s","source":"startup"}' "$P17" | ( cd "$P17" && mkdir -p .claude/skills/meta-mechanisms/hooks && cp "$SRC"/meta-mechanisms/hooks/*.sh .claude/skills/meta-mechanisms/hooks/ && CLAUDE_PROJECT_DIR="$P17" bash .claude/skills/meta-mechanisms/hooks/session-start.sh ))
case "$r" in *"did not finish"*"rollback.sh"*) ok "172g the session-start hook reports a lock left behind and names the restore command (T-2)";; *) bad "172g session-start" "$r";; esac
( cd "$P17" && rm -rf .claude/skills/templates .claude/skills/meta-mechanisms && echo junk >> CLAUDE.md && echo new > .claude/skills/NEW.md && rm .claude/agents/a.md )
r=$(cd "$P17" && bash .claude/kit-incoming/meta-mechanisms/checks/rollback.sh); a=$(h17)
[ "$a" = "$b" ] && [ ! -f "$P17/.claude/kit-upgrade.lock" ] && [ -d "$P17/.claude/kit-incoming" ] && ok "173a a run stopped after files were replaced, removed and added is restored byte for byte; the staged kit stays, the lock goes (T-3)" || bad "173a rollback" "before=$b after=$a $r"
Q17="$T17/norepo"; mkdir -p "$Q17"; cp -R "$P17/.claude" "$Q17/"; cp "$P17/CLAUDE.md" "$Q17/"; rm -rf "$Q17/.git"
hq() { ( cd "$Q17" && find .claude CLAUDE.md -type f ! -path '.claude/kit-incoming/*' ! -name kit-upgrade.lock -print0 | sort -z | xargs -0 sha1sum | sha1sum | cut -c1-16 ); }
b=$(hq); ( cd "$Q17" && GIT_CEILING_DIRECTORIES="$T17" bash $PF17 begin >/dev/null; rm -rf .claude/skills/templates; echo junk >> CLAUDE.md; GIT_CEILING_DIRECTORIES="$T17" bash .claude/kit-incoming/meta-mechanisms/checks/rollback.sh >/dev/null ); a=$(hq)
[ "$a" = "$b" ] && [ -d "$Q17/.claude.before-upgrade" ] && ok "173b the same in a project that is not a repository, from its kept copy (T-3)" || bad "173b rollback without a repository" "before=$b after=$a"
# the merge
M17="$T17/m"; mkdir -p "$M17"; body17() { printf 'line one\n'; for i in a b c d e f; do printf 'filler %s\n' "$i"; done; printf '%s\n' "$1"; for i in g h i j k l; do printf 'filler %s\n' "$i"; done; printf 'last line of the kit\n'; }
body17 'line two of the kit' > "$M17/base"; { printf 'a new opening line in the kit\n'; body17 'line two of the kit, reworded by the kit'; } > "$M17/new"
{ body17 'line two of the kit'; printf '\nOur own passage.\n'; } > "$M17/y1"; bash "$C17/merge.sh" "$M17/y1" "$M17/base" "$M17/new" "$M17/o1" >/dev/null; rc=$?
[ $rc = 0 ] && grep -q 'Our own passage' "$M17/o1" && grep -q 'reworded by the kit' "$M17/o1" && grep -q 'a new opening line in the kit' "$M17/o1" && ok "174a an added passage is carried onto the new text, which keeps all of the kit's changes (T-4)" || bad "174a merge, added passage" "$rc $(cat "$M17/o1")"
body17 'line two of the kit' | sed 's/^filler k$/filler k (ours)/' > "$M17/y2"; bash "$C17/merge.sh" "$M17/y2" "$M17/base" "$M17/new" "$M17/o2" >/dev/null; rc=$?
[ $rc = 0 ] && grep -q '^filler k (ours)$' "$M17/o2" && grep -q 'reworded by the kit' "$M17/o2" && ok "174b an edit inside a kit line the new kit left alone keeps its place (T-4)" || bad "174b merge, in-line edit" "$rc $(cat "$M17/o2")"
body17 'line two of the kit, and ours' > "$M17/y3"; r=$(bash "$C17/merge.sh" "$M17/y3" "$M17/base" "$M17/new" "$M17/o3"); rc=$?
[ $rc = 1 ] && case "$r" in *"1 conflict"*"and ours"*"reworded by the kit"*) ok "174c an edit the new kit also rewrote comes back as one counted conflict, both versions printed (T-4)";; *) bad "174c message" "$r";; esac || bad "174c conflict not counted" "$rc"
printf '# kit one\n# kit two\n\nentries: []\n' > "$M17/ot"; printf '# kit one, reworded\n# kit two\n# kit three\n\nentries: []\n' > "$M17/nt"; printf '# kit one\n# kit two\n# NOTE: ours\n\nentries:\n  - id: 1\n' > "$M17/rec"
r=$(bash "$C17/merge.sh" --header "$M17/rec" "$M17/ot" "$M17/nt" "$M17/rec.out"); rc=$?
[ $rc = 0 ] && [ "$(grep -c '^# ' "$M17/rec.out")" = 4 ] && grep -q '^# NOTE: ours$' "$M17/rec.out" && grep -q '^  - id: 1$' "$M17/rec.out" && ! grep -q '^# kit one$' "$M17/rec.out" && ok "174d a record's header comes out as the new template's block with exactly the pioneer's own note beneath it, the body untouched (T-4)" || bad "174d header" "$rc $(cat "$M17/rec.out")"
printf '# all mine\n# every line\n\nentries: []\n' > "$M17/rec2"; r=$(bash "$C17/merge.sh" --header "$M17/rec2" "$M17/ot" "$M17/nt" "$M17/rec2.out"); rc=$?
[ $rc = 3 ] && [ ! -f "$M17/rec2.out" ] && ok "174e a header the pioneer replaced wholesale is not touched: exit 3, the instance-file question (T-4)" || bad "174e wholesale" "$rc"
# tests that write nothing
grep -q 'hooks-selftest.sh' "$SRC/meta-bootstrap/SKILL.md" && grep -q 'tests/walk.sh' "$SRC/meta-bootstrap/SKILL.md" && ! grep -q "echo '{\"source\":\"startup\"}'" "$SRC/meta-bootstrap/SKILL.md" && grep -q 'cd "$FX" && printf' "$SRC/meta-mechanisms/tests/walk.sh" && ok "175 the procedure tests the hooks on a throwaway copy and runs the walk, the walk runs inside its own fixture, and no step runs a hook against the live project (T-5, G-4)" || bad "175 tests without side effects" "-"
B17="$SRC/meta-bootstrap/SKILL.md"
grep -q -F 'replaced last, in step 9' "$B17" && grep -q -F 'they are what steps 7 and 8 compare against, and they are replaced last, in step 9' "$B17" && grep -q -F 'A half-finished upgrade is never continued' "$B17" && grep -q -F 'preflight.sh begin install' "$B17" && grep -q -F 'seven standing questions' "$B17" && ! grep -q -F 'tree-or-commit question (step 1)' "$B17" && grep -q -F 'and git, by the pioneer' "$SRC/meta-mechanisms/SKILL.md" && ok "176 the text: bases replaced last, a run never continued, the install uses the same preflight, seven standing questions, git in the portability rule (T-7, UC-3, UC-4, UC-8)" || bad "176 text" "-"
# found by the first independent rehearsal of this contract's own build (T-5, first run), each now a state
n=0; for a in yours kit both; do bash "$C17/merge.sh" --take $a "$M17/y3" "$M17/base" "$M17/new" "$M17/t.$a" >/dev/null && ! grep -q -E '^(<<<<<<<|>>>>>>>) ' "$M17/t.$a" && n=$((n+1)); done
grep -q 'and ours' "$M17/t.yours" && ! grep -q 'reworded by the kit' "$M17/t.yours" && grep -q 'reworded by the kit' "$M17/t.kit" && ! grep -q 'and ours' "$M17/t.kit" && [ "$(grep -n 'reworded by the kit\|and ours' "$M17/t.both" | cut -d: -f2- | tr '\n' '|')" = "line two of the kit, reworded by the kit|line two of the kit, and ours|" ] && [ "$n" = 3 ] && ok "177a a conflict is settled by the tool as the sheet answered - yours, the kit's, or both with the kit's lines first - and no marker is left (T-5)" || bad "177a merge --take" "$n $(cat "$M17/t.both" | tr '\n' '|' | cut -c1-200)"
Q17="$T17/g3"; mkdir -p "$Q17/meta-x" "$Q17/installed/meta-x" "$Q17/meta-mechanisms/checks"; cp "$C17/G3-retired.sh" "$C17/retired-phrases.txt" "$Q17/meta-mechanisms/checks/"
printf 'A kit sentence.\n' > "$Q17/installed/meta-x/SKILL.md"; printf 'A kit sentence.\nOur own line still says three-tier here.\n' > "$Q17/meta-x/SKILL.md"
r=$(bash "$Q17/meta-mechanisms/checks/G3-retired.sh"); rc=$?; [ $rc = 0 ] && case "$r" in *"note:"*"project's own"*) ok "177b in a project, a retired wording in a line the pioneer wrote is a note, not a failure (T-5)";; *) bad "177b message" "$r";; esac || bad "177b the pioneer's line failed the check" "$r"
printf 'A kit sentence.\nThe kit itself still says three-tier here.\n' > "$Q17/installed/meta-x/SKILL.md"; cp "$Q17/installed/meta-x/SKILL.md" "$Q17/meta-x/SKILL.md"
r=$(bash "$Q17/meta-mechanisms/checks/G3-retired.sh"); rc=$?; [ $rc = 1 ] && ok "177c ...and the same wording in a line the kit shipped still fails it (T-5)" || bad "177c the kit's stale line passed" "$r"
mkdir -p "$P17/docs/reports"; echo log > "$P17/docs/reports/rehearsal-2026-01-01.md"; r=$(cd "$P17" && bash $PF17 check); rc=$?
[ $rc = 0 ] && ok "177d the rehearsal log the procedure has just written does not count as the pioneer's uncommitted work (T-5)" || bad "177d rehearsal log blocks the run" "$r"
echo other > "$P17/docs/reports/notes.md"; r=$(cd "$P17" && bash $PF17 check); rc=$?; rm -rf "$P17/docs"
[ $rc = 1 ] && ok "177e ...while any other uncommitted file beside it still does (T-2)" || bad "177e" "$r"
rm -rf "$T17"

echo "=== contract-018: the install step is a command, and the rules that mattered are checks ==="
T18=$(mktemp -d); C18="$SRC/meta-mechanisms/checks"; G18="git -c user.name=walk -c user.email=walk@example.invalid"
bash "$SRC/meta-bootstrap/release.sh" --from-last-commit "$T18/rel" >/dev/null 2>&1
for f in install.sh preflight.sh rollback.sh merge.sh hooks-selftest.sh G3-retired.sh; do cp "$C18/$f" "$T18/rel/meta-mechanisms/checks/$f"; done
cp "$SRC/meta-bootstrap/SKILL.md" "$T18/rel/meta-bootstrap/SKILL.md"; cp "$SRC/templates/settings.template.json" "$T18/rel/templates/settings.template.json"
( cd "$T18/rel" && find . -type f ! -name RELEASE ! -name RELEASE.sha1 -print0 | sort -z | while IFS= read -r -d '' f; do printf '%s  %s\n' "$(tr -d '\r' < "$f" | sha1sum | cut -c1-40)" "${f#./}"; done > RELEASE.sha1 )
IN="$T18/rel/meta-mechanisms/checks/install.sh"
# a project: its settings are the ones its last install shipped, its CLAUDE.md carries the markers, and it holds
# two precedent checks - one whose precedent is in its own casebook, one whose is not
mkp18() {
  local P="$1"; rm -rf "$P"; mkdir -p "$P/.claude/skills/templates" "$P/.claude/skills/meta-casebook" "$P/.claude/skills/meta-mechanisms/checks" "$P/.claude/skills/meta-bootstrap/history" "$P/.claude/skills/agents" "$P/.claude/skills/meta-map" "$P/.claude/agents"
  cp "$T18/rel/templates/settings.template.json" "$P/.claude/skills/templates/settings.template.json"
  cp "$T18/rel/templates/settings.template.json" "$P/.claude/settings.json"
  printf 'precedents:\n  - prec_id: P-010\n    status: active\nscenarios: []\n' > "$P/.claude/skills/meta-casebook/CASEBOOK.yaml"
  printf 'exit 0\n' > "$P/.claude/skills/meta-mechanisms/checks/P-010.sh"
  printf 'exit 0\n' > "$P/.claude/skills/meta-mechanisms/checks/P-004.sh"
  printf 'old\n' > "$P/.claude/skills/meta-bootstrap/history/regenerate.sh"
  printf 'the old agent\n' > "$P/.claude/skills/agents/kit-verifier.md"; cp "$P/.claude/skills/agents/kit-verifier.md" "$P/.claude/agents/kit-verifier.md"
  printf 'the old map skill\n' > "$P/.claude/skills/meta-map/SKILL.md"
  printf '<!-- kit-block:start -->\nold block\n<!-- kit-block:end -->\n\n# The project\n\nNotes.\n' > "$P/CLAUDE.md"
  printf '.claude/kit-sealed/\n' > "$P/.gitignore"; printf '*.sh text eol=lf\n' > "$P/.gitattributes"
}
h18() { ( cd "$1" && find .claude CLAUDE.md .gitignore .gitattributes -type f -print0 | sort -z | xargs -0 sha1sum | sha1sum | cut -c1-16 ); }
printf 'take meta-map/SKILL.md\ntake agents/kit-verifier.md\nstale meta-bootstrap/history/regenerate.sh\nstale meta-mechanisms/checks/P-010.sh\nstale meta-mechanisms/checks/P-004.sh\n' > "$T18/plan"
P18="$T18/p"; mkp18 "$P18"; b=$(h18 "$P18")
printf 'take templates/MAP.template.md\n' > "$T18/plan.bad"
r=$(cd "$P18" && bash "$IN" upgrade "$T18/plan.bad" 2>&1); rc=$?
[ $rc = 1 ] && [ "$(h18 "$P18")" = "$b" ] && case "$r" in *"replaced last"*"changed nothing"*) ok "178a a plan that names a template or an installed copy is refused, and the project is untouched (T-1)";; *) bad "178a message" "$r";; esac || bad "178a template not refused" "$rc"
r=$(cd "$P18" && bash "$IN" upgrade "$T18/plan" 2>&1); rc=$?
taken=$(cmp -s "$T18/rel/meta-map/SKILL.md" "$P18/.claude/skills/meta-map/SKILL.md" && echo y || echo n)
dep=$(cmp -s "$T18/rel/agents/kit-verifier.md" "$P18/.claude/agents/kit-verifier.md" && echo y || echo n)
set18=$(cmp -s "$T18/rel/templates/settings.template.json" "$P18/.claude/settings.json" && echo y || echo n)
blk18=$(grep -c 'kit-block:start' "$P18/CLAUDE.md"); kept18=$(grep -c '# The project' "$P18/CLAUDE.md")
[ $rc = 0 ] && [ "$taken$dep$set18" = yyy ] && [ "$blk18" = 1 ] && [ "$kept18" = 1 ] && [ ! -e "$P18/.claude/skills/meta-bootstrap/history/regenerate.sh" ] && [ -f "$P18/.claude/skills/meta-ledger/batches/.gitkeep" ] && grep -q 'session-started' "$P18/.gitignore" && ok "178b it takes the planned files, deploys the agent beside them, writes the settings, replaces the kit block and keeps what follows it, adds the folders and the ignore entries, removes the stale (T-1)" || bad "178b install.sh upgrade" "$rc taken=$taken dep=$dep settings=$set18 block=$blk18 kept=$kept18"
[ -f "$P18/.claude/skills/meta-mechanisms/checks/P-010.sh" ] && [ ! -e "$P18/.claude/skills/meta-mechanisms/checks/P-004.sh" ] && case "$r" in *"spared"*"P-010"*"casebook"*) ok "179a a precedent check whose precedent is in the project's casebook is spared and named; one whose is not is removed (T-2)";; *) bad "179a spared message" "$r";; esac || bad "179a sparing" "P-010 $([ -f "$P18/.claude/skills/meta-mechanisms/checks/P-010.sh" ] && echo kept || echo REMOVED)"
Q18="$T18/q"; mkp18 "$Q18"; sed -i 's/"permissions"/"env": {"OURS": "1"}, "permissions"/' "$Q18/.claude/settings.json"; b=$(h18 "$Q18")
r=$(cd "$Q18" && bash "$IN" upgrade "$T18/plan" 2>&1); rc=$?
[ $rc = 1 ] && [ "$(h18 "$Q18")" = "$b" ] && case "$r" in *"not the one the last install shipped"*"--skip-settings"*) ok "178c a settings file with something of the project's own in it is refused, with what to do, and nothing at all is changed (T-1)";; *) bad "178c message" "$r";; esac || bad "178c settings not refused" "$rc"
r=$(cd "$Q18" && bash "$IN" upgrade "$T18/plan" --skip-settings 2>&1); rc=$?
[ $rc = 0 ] && case "$r" in *"left alone"*) ok "178d ...and with --skip-settings it does the rest and says the settings were left to the agent (T-1)";; *) bad "178d message" "$r";; esac || bad "178d skip-settings" "$rc"
R18="$T18/r"; mkp18 "$R18"; printf '# Kit-Driven Development\n\nLoad these.\n\n**Our own rule.** Run the linter first.\n\n---\n\n# The project\n' > "$R18/CLAUDE.md"; b=$(h18 "$R18")
r=$(cd "$R18" && bash "$IN" upgrade "$T18/plan" 2>&1); rc=$?
[ $rc = 1 ] && [ "$(h18 "$R18")" = "$b" ] && case "$r" in *"no kit-block markers"*"Our own rule"*) ok "178e a CLAUDE.md with no markers is refused, and the span it would have replaced is printed so the pioneer's own paragraph is seen (T-1)";; *) bad "178e message" "$r";; esac || bad "178e markerless" "$rc"
F18="$T18/fresh"; mkdir -p "$F18/.claude/skills"; cp -R "$T18/rel/." "$F18/.claude/skills/"; printf '../shared — the shared library\n' > "$T18/ws"
r=$(cd "$F18" && bash "$IN" install --workspace "$T18/ws" 2>&1); rc=$?
n18=$(ls "$F18/.claude/agents" 2>/dev/null | grep -c '\.md$'); inst18=$(ls "$F18/.claude/skills/installed" 2>/dev/null | wc -l | tr -d ' ')
[ $rc = 0 ] && [ "$n18" -ge 7 ] && [ "$inst18" -ge 15 ] && grep -q '"additionalDirectories": \["../shared"\]' "$F18/.claude/settings.json" && grep -q 'Applications in the system flow, beyond this repository: ../shared' "$F18/CLAUDE.md" && ok "178f an install deploys the agents, writes the installed copies the next upgrade measures against, grants the application in the settings and names it in the kit block (T-1)" || bad "178f install mode" "$rc agents=$n18 installed=$inst18"
# T-3: the check at both points of an upgrade, in a project (contract-018 UC-3)
GQ="$T18/g3b"; mkdir -p "$GQ/meta-x" "$GQ/installed/meta-x" "$GQ/templates" "$GQ/meta-mechanisms/checks"
cp "$C18/G3-retired.sh" "$C18/retired-phrases.txt" "$GQ/meta-mechanisms/checks/"
printf 'A kit sentence.\nThe base the upgrade forgot still says three-tier here.\n' > "$GQ/installed/meta-x/SKILL.md"
cp "$GQ/installed/meta-x/SKILL.md" "$GQ/meta-x/SKILL.md"
printf 'An old template still says it instructs, it does not bind here.\n' > "$GQ/templates/X.template.md"
r=$(bash "$GQ/meta-mechanisms/checks/G3-retired.sh"); rc=$?
nte=$(printf "%s
" "$r" | grep -c "note: templates/X.template.md.*keeps no shipped copy"); brk=$(printf "%s
" "$r" | grep -c "G3-retired broken: meta-x/SKILL.md:2")
[ $rc = 1 ] && [ "$nte" = 1 ] && [ "$brk" = 1 ] && ok "179b mid-upgrade, the old template is a note because whose its line is cannot be told, and a base line the upgrade forgot still fails (T-3)" || bad "179b mid-upgrade" "rc=$rc note=$nte broken=$brk :: $r"
printf 'A kit sentence.\nThe base now says what the kit says.\n' > "$GQ/installed/meta-x/SKILL.md"
cp "$GQ/installed/meta-x/SKILL.md" "$GQ/meta-x/SKILL.md"
printf 'The new template says what the kit says now.\n' > "$GQ/templates/X.template.md"
r=$(bash "$GQ/meta-mechanisms/checks/G3-retired.sh"); rc=$?
[ $rc = 0 ] && [ -z "$r" ] && ok "179c ...and once step 9 has replaced both, the same check is clean with nothing left to read (T-3)" || bad "179c after the upgrade" "rc=$rc $r"
grep -q -F 'install.sh upgrade <plan>' "$SRC/meta-bootstrap/SKILL.md" && grep -q -F 'What it refuses' "$SRC/meta-bootstrap/SKILL.md" && ! grep -q -F 'the settings merge, done by hand with the file tools' "$SRC/meta-bootstrap/SKILL.md" && grep -q -F 'For an agent: install or upgrade this kit' "$SRC/README.md" && grep -q -F 'release.sh <release>' "$SRC/README.md" && grep -q -F 'mkdir -p <project>/.claude/kit-incoming' "$SRC/README.md" && grep -q -F 'mkdir -p <project>/.claude/skills' "$SRC/README.md" && grep -q -F 'install.sh install [--workspace <file>]' "$SRC/meta-bootstrap/SKILL.md" && ! grep -q -F "**Copy the kit** into your project" "$SRC/README.md" && ok "180 step 5 is the command and its refusals; the README opens with the four commands an agent needs, and no longer tells it to copy the repository (T-1, T-4)" || bad "180 the text" "-"
grep -q -F 'The records are eight:' "$SRC/meta-bootstrap/SKILL.md" && grep -q -F 'an entry that is an analysis report is left alone' "$SRC/meta-bootstrap/SKILL.md" && grep -q -F '| published' "$SRC/templates/CONTRACT-LOG.template.yaml" && grep -q -F 'what can this project do now that it could not do before?' "$SRC/meta-bootstrap/SKILL.md" && ok "181 the eight records are named, a report keeps no pre-mortem or red test, the enum admits what a report is, and the report asks what changed for the project (T-5, UC-6)" || bad "181 records and report" "-"
# the release goes where the command was typed, and never into the kit itself (contract-018, from the upgrade rehearsal)
RD18=$(mktemp -d)
( cd "$RD18" && bash "$SRC/meta-bootstrap/release.sh" --from-last-commit rel-rel >/dev/null 2>&1 ) || true
r=$( cd "$RD18" && bash "$SRC/meta-bootstrap/release.sh" --from-last-commit "$SRC/rel-inside" 2>&1 ); rc=$?
[ -f "$RD18/rel-rel/RELEASE" ] && [ ! -e "$SRC/rel-rel" ] && [ $rc = 1 ] && [ ! -e "$SRC/rel-inside" ] && case "$r" in *"inside the kit repository"*"folder of your own"*) ok "182 a release built with a relative path lands where the command was typed, and one aimed inside the kit repository is refused with nothing written (T-4)";; *) bad "182 message" "$r";; esac || bad "182 release path" "rc=$rc relative=$([ -f "$RD18/rel-rel/RELEASE" ] && echo ok || echo MISSING) inside=$([ -e "$SRC/rel-inside" ] && echo WRITTEN || echo none)"
rm -rf "$RD18"
rm -rf "$T18"

echo; echo "contract-007 walk: $pass passed, $fail failed"; rm -rf "$FX"
[ "$fail" = 0 ]
