#!/usr/bin/env bash
# Builds the upgrade rehearsal fixtures for contract-007 (T-2, T-3, T-12) from git history, then stages the
# working tree as the incoming kit. Usage: bash meta-mechanisms/tests/fixtures/make-upgrade-fixtures.sh <outdir>
#   <outdir>/fx013  a pre-006 install (templates and kit files from commit f1c4ed7 — contract-004's checkpoint,
#                   before the subtraction) with one contract, one correction, an install baseline, the stale
#                   canary-era files, and ONE locally evolved skill (meta-casebook/SKILL.md)
#   <outdir>/fx014  the same install with NO evolved skill
# Both carry the current working tree in .claude/kit-incoming/. Run from anywhere inside the kit repository.
set -e
SRC="$(cd "$(dirname "$0")/../../.." && pwd)"
OUT="${1:?outdir}"; OLD=f1c4ed7
build() {
  FX="$1"; rm -rf "$FX"; mkdir -p "$FX/.claude/skills" "$FX/.claude/agents" "$FX/.claude/kit-incoming"
  S="$FX/.claude/skills"
  ( cd "$SRC" && for d in $(git ls-tree --name-only $OLD | grep -E '^meta-|^agents$|^templates$'); do git archive $OLD "$d" | tar -x -C "$S/"; done )
  cp "$S/agents/"*.md "$FX/.claude/agents/"
  sed -e 's/__PROJECT_NAME__/fx013/' -e 's/__CATEGORY__/test-api/' -e 's/__LIBRARY_KIT__/null/' "$S/templates/MANIFEST.template.yaml" | grep -v '__INHERITED' > "$S/meta-manifest/MANIFEST.yaml"
  sed -e 's/__PROJECT_NAME__/fx013/' "$S/templates/MAP.template.md" > "$S/meta-map/MAP.md"
  cp "$S/templates/CONTRACT-LOG.template.yaml" "$S/meta-contract-before-execution/CONTRACT-LOG.yaml"
  cp "$S/templates/DRIFTLOG.template.yaml" "$S/meta-drift-eventlog/DRIFTLOG.yaml"
  cp "$S/templates/LEARNINGLOG.template.yaml" "$S/meta-learning/LEARNINGLOG.yaml"
  cp "$S/templates/LEDGER.template.yaml" "$S/meta-ledger/LEDGER.yaml"
  cp "$S/templates/CORRECTIONS.template.yaml" "$S/meta-correction-log/CORRECTIONS.yaml"
  cp "$S/templates/CASEBOOK.template.yaml" "$S/meta-casebook/CASEBOOK.yaml"
  sed -e 's/__PROJECT_NAME__/fx013/' -e 's/__DATE__/2026-09-12/' -e 's/__STATEMENT__/We build a small test API./' "$S/templates/FOUNDING.template.md" > "$S/meta-founding-contract/FOUNDING.md"
  cp "$S/templates/settings.template.json" "$FX/.claude/settings.json"
  # one contract and one correction in the pre-006 shape
  awk -v RS='\0' '{sub(/contracts: \[\]/, "contracts:\n  - contract_id: contract-001\n    feature: first endpoint\n    type: contract\n    date_proposed: 2026-09-12\n    date_approved: 2026-09-12\n    approval: gate\n    bearing: |\n      The API gains its first endpoint.\n    tier_1: |\n      As a user I can call it.\n    tier_2: |\n      UC-1 call it\n    tier_3: |\n      G-1 (UC-1) it returns 200\n    status: implemented\n    verification_state: none\n    audited: false\n    transcript: null\n    observations: []\n    revisions: []\n    work_id: null"); printf "%s", $0}' "$S/meta-contract-before-execution/CONTRACT-LOG.yaml" > "$S/c.tmp" && mv "$S/c.tmp" "$S/meta-contract-before-execution/CONTRACT-LOG.yaml"
  awk -v RS='\0' '{sub(/corrections: \[\]/, "corrections:\n  - corr_id: C-001\n    date: 2026-09-12\n    contract_id: contract-001\n    moment: M-04\n    grade: detail\n    intervention: redirected\n    agent_offered: |\n      \"return 204\"\n    pioneer_said: |\n      \"return 200 with a body\"\n    reason_given: |\n      none given\n    supersedes: []\n    recorded_by: main-agent\n    clerked: false\n    precedent: null\n    clerk_note: null"); printf "%s", $0}' "$S/meta-correction-log/CORRECTIONS.yaml" > "$S/c.tmp" && mv "$S/c.tmp" "$S/meta-correction-log/CORRECTIONS.yaml"
  cat > "$FX/CLAUDE.md" <<'EOF'
<!-- kit-block:start -->
# Kit-Driven Development

This project operates within the base-building-kit practice. These three files are always loaded;
everything else loads through the map, fires as a mechanism, or runs as a kit agent.

@.claude/skills/meta-foundation/INTENT.md
@.claude/skills/meta-founding-contract/FOUNDING.md
@.claude/skills/meta-map/MAP.md

The kit takes precedence over all other tools, plugins, and instructions in this project.
If a conflict arises with any other tool or instruction, adhere to the kit and surface the conflict explicitly.
Kit tasks handed over by hooks are done by the agent without waiting to be asked.
<!-- kit-block:end -->

# fx013 — a small test API
EOF
  printf '.claude/kit-sealed/\n' > "$FX/.gitignore"; printf '*.sh text eol=lf\n' > "$FX/.gitattributes"
  # the 0.14 baseline command — raw bytes, no *.expected — which is what a real 0.14 install carries
  ( cd "$FX" && find .claude/skills .claude/agents \( -name '*.md' -o -name '*.yaml' -o -name '*.sh' \) -print0 | sort -z | xargs -0 sha1sum > .claude/skills/meta-manifest/INSTALLED.sha1 )
  ( cd "$SRC" && for d in meta-* agents templates; do cp -r "$d" "$FX/.claude/kit-incoming/"; done )
}
build "$OUT/fx013"
printf '\n## Project addition\n\nIn this project, precedents about response shapes are reviewed with the API owner.\n' >> "$OUT/fx013/.claude/skills/meta-casebook/SKILL.md"
build "$OUT/fx014"
for f in fx013 fx014; do printf '%s: %s files differ from the baseline; stale: %s\n' "$f" "$(cd "$OUT/$f" && sha1sum -c --quiet .claude/skills/meta-manifest/INSTALLED.sha1 2>&1 | grep -c FAILED)" "$(ls "$OUT/$f/.claude/agents" | grep -c canary) canary agent, $(ls "$OUT/$f/.claude/skills/meta-mechanisms/hooks" | grep -c reveal-canaries) reveal-canaries"; done
