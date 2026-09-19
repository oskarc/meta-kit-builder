#!/usr/bin/env bash
# Builds the upgrade rehearsal fixtures for contract-007 (T-2, T-3, T-12) from git history, then stages the
# working tree as the incoming kit. Usage: bash meta-mechanisms/tests/fixtures/make-upgrade-fixtures.sh <outdir>
#   <outdir>/fx013  a pre-006 install (templates and kit files from commit f1c4ed7 — contract-004's checkpoint,
#                   before the subtraction) with one contract, one correction, an install baseline, the stale
#                   canary-era files, and ONE locally evolved skill (meta-casebook/SKILL.md)
#   <outdir>/fx014  the same install with NO evolved skill
#   <outdir>/fx016  an install at 0.16 (installed copies, current-format baseline), committed, with the project's own
#                   work in it: an added passage in one kit skill, an edit inside a sentence the new kit also
#                   rewrote (a real conflict), two kept notes in the contract log's header, and a learning-log
#                   header replaced wholesale (contract-017 T-5)
# All three carry a RELEASE of the kit's current tree in .claude/kit-incoming/, built by meta-bootstrap/release.sh
# from a scratch clone in which the working tree is committed - a release is built from a commit (contract-017).
# Run from anywhere inside the kit repository.
set -e
SRC="$(cd "$(dirname "$0")/../../.." && pwd)"
GIT_ID="git -c user.name=fixture -c user.email=fixture@example.invalid"
# stage DIR — place a release of the kit's CURRENT TREE in DIR. A release is built from a commit, so the working tree
# is committed in a scratch clone first; the clone is removed afterwards.
stage() {
  local dest="$1" cl; cl="$(mktemp -d)/kit"
  git clone -q "$SRC" "$cl"
  ( cd "$SRC" && git status --porcelain | cut -c4- | while IFS= read -r p; do p="${p%/}"
      if [ -d "$p" ]; then mkdir -p "$cl/$p"; cp -R "$p/." "$cl/$p/"; elif [ -f "$p" ]; then mkdir -p "$cl/$(dirname "$p")"; cp "$p" "$cl/$p"; else rm -rf "$cl/$p"; fi
    done )
  ( cd "$cl" && git add -A >/dev/null 2>&1 && $GIT_ID commit -q -m "the kit's current tree" >/dev/null 2>&1 || true )
  bash "$cl/meta-bootstrap/release.sh" "$dest" >/dev/null
  rm -rf "$(dirname "$cl")"
}
# build016 DIR — an install at 0.16 with the project's own work in it, committed (contract-017 T-5)
build016() {
  local FX="$1" S L OLD16=53eb4f6; rm -rf "$FX"; mkdir -p "$FX/.claude/skills" "$FX/.claude/agents" "$FX/docs/reports"; S="$FX/.claude/skills"
  ( cd "$SRC" && for d in $(git ls-tree -d --name-only $OLD16 | grep -E '^(meta-.*|agents|templates)$'); do git archive $OLD16 "$d" | tar -x -C "$S/"; done )
  rm -rf "$S/meta-mechanisms/tests/results" "$S/meta-mechanisms/tests/fixtures" "$S/meta-mechanisms/tests/walk-004.sh" "$S/meta-mechanisms/tests/walk-007.sh" "$S"/meta-mechanisms/checks/P-*.sh "$S/meta-ledger/batches" "$S/meta-casebook/reconstruction"
  cp "$S/agents/"*.md "$FX/.claude/agents/"
  sed -e 's/__PROJECT_NAME__/fx016/' -e 's/__CATEGORY__/test-api/' -e 's/__LIBRARY_KIT__/null/' "$S/templates/MANIFEST.template.yaml" | grep -v '__INHERITED' > "$S/meta-manifest/MANIFEST.yaml"
  sed -e 's/__PROJECT_NAME__/fx016/' "$S/templates/MAP.template.md" > "$S/meta-map/MAP.md"
  for p in "meta-contract-before-execution/CONTRACT-LOG CONTRACT-LOG" "meta-drift-eventlog/DRIFTLOG DRIFTLOG" "meta-learning/LEARNINGLOG LEARNINGLOG" "meta-ledger/LEDGER LEDGER" "meta-correction-log/CORRECTIONS CORRECTIONS" "meta-casebook/CASEBOOK CASEBOOK"; do set -- $p; cp "$S/templates/$2.template.yaml" "$S/$1.yaml"; done
  sed -e 's/__PROJECT_NAME__/fx016/' -e 's/__DATE__/2026-09-16/' -e 's/__STATEMENT__/We build a small test API./' "$S/templates/FOUNDING.template.md" > "$S/meta-founding-contract/FOUNDING.md"
  cp "$S/templates/settings.template.json" "$FX/.claude/settings.json"
  mkdir -p "$S/installed"; ( cd "$S" && for f in meta-*/SKILL.md meta-foundation/INTENT.md; do mkdir -p "installed/$(dirname "$f")"; cp "$f" "installed/$f"; done )
  printf '<!-- kit-block:start -->\n# Kit-Driven Development\n\n@.claude/skills/meta-foundation/INTENT.md\n@.claude/skills/meta-founding-contract/FOUNDING.md\n@.claude/skills/meta-map/MAP.md\n<!-- kit-block:end -->\n\n# a small test API\n' > "$FX/CLAUDE.md"
  printf '.claude/kit-sealed/\n' > "$FX/.gitignore"; printf '*.sh text eol=lf\n' > "$FX/.gitattributes"
  ( cd "$FX" && find .claude/skills .claude/agents \( -name '*.md' -o -name '*.yaml' -o -name '*.sh' -o -name '*.expected' -o -name '*.json' \) -print0 | sort -z | while IFS= read -r -d '' f; do printf '%s  %s\n' "$(tr -d '\r' < "$f" | sha1sum | cut -c1-40)" "$f"; done > .claude/skills/meta-manifest/INSTALLED.sha1 )
  # the project's own work, after the install
  printf '\n## Project addition\n\nIn this project, precedents about response shapes are reviewed with the API owner.\n' >> "$S/meta-casebook/SKILL.md"
  L=$(diff <(tr -d '\r' < "$S/meta-contract-before-execution/SKILL.md") <(tr -d '\r' < "$SRC/meta-contract-before-execution/SKILL.md") | grep '^< ' | cut -c3- | awk 'length($0)>80 && length($0)<400' | head -1)
  [ -n "$L" ] || { echo "fx016: no sentence the new kit rewrote was found to build the conflict on"; exit 1; }
  tr -d '\r' < "$S/meta-contract-before-execution/SKILL.md" | awk -v l="$L" '$0==l && !d {print $0 " In this project the API owner also signs the approval."; d=1; next} {print}' > "$S/c.tmp" && mv "$S/c.tmp" "$S/meta-contract-before-execution/SKILL.md"
  awk 'BEGIN{d=0} /^[^#]/ && !d {print "# NOTE (ours): contracts before 2026-09 were approved by e-mail; the mails are in the team archive."; print "# NOTE (ours): work_id refers to the tracker project API-CORE."; d=1} {print}' "$S/meta-contract-before-execution/CONTRACT-LOG.yaml" > "$S/c.tmp" && mv "$S/c.tmp" "$S/meta-contract-before-execution/CONTRACT-LOG.yaml"
  { printf '# LEARNINGLOG - what has held up in this project.\n# Kept short on purpose: the team reads this file in review.\n\n'; tr -d '\r' < "$S/meta-learning/LEARNINGLOG.yaml" | awk 's||/^[^#]/{s=1; print}'; } > "$S/c.tmp" && mv "$S/c.tmp" "$S/meta-learning/LEARNINGLOG.yaml"
  ( cd "$FX" && git init -q && git add -A >/dev/null 2>&1 && $GIT_ID commit -q -m "the project, installed at 0.16, with its own work" )
  stage "$FX/.claude/kit-incoming"
  echo "fx016: installed at 0.16, committed; one added passage, one conflicting edit, two kept header notes, one replaced header"
}
OUT="${1:?outdir}"; OLD=f1c4ed7
build() {
  FX="$1"; NAME="$(basename "$1")"; rm -rf "$FX"; mkdir -p "$FX/.claude/skills" "$FX/.claude/agents" "$FX/.claude/kit-incoming"
  S="$FX/.claude/skills"
  ( cd "$SRC" && for d in $(git ls-tree --name-only $OLD | grep -E '^meta-|^agents$|^templates$'); do git archive $OLD "$d" | tar -x -C "$S/"; done )
  cp "$S/agents/"*.md "$FX/.claude/agents/"
  sed -e "s/__PROJECT_NAME__/$NAME/" -e 's/__CATEGORY__/test-api/' -e 's/__LIBRARY_KIT__/null/' "$S/templates/MANIFEST.template.yaml" | grep -v '__INHERITED' > "$S/meta-manifest/MANIFEST.yaml"
  sed -e "s/__PROJECT_NAME__/$NAME/" "$S/templates/MAP.template.md" > "$S/meta-map/MAP.md"
  cp "$S/templates/CONTRACT-LOG.template.yaml" "$S/meta-contract-before-execution/CONTRACT-LOG.yaml"
  cp "$S/templates/DRIFTLOG.template.yaml" "$S/meta-drift-eventlog/DRIFTLOG.yaml"
  cp "$S/templates/LEARNINGLOG.template.yaml" "$S/meta-learning/LEARNINGLOG.yaml"
  cp "$S/templates/LEDGER.template.yaml" "$S/meta-ledger/LEDGER.yaml"
  cp "$S/templates/CORRECTIONS.template.yaml" "$S/meta-correction-log/CORRECTIONS.yaml"
  cp "$S/templates/CASEBOOK.template.yaml" "$S/meta-casebook/CASEBOOK.yaml"
  sed -e "s/__PROJECT_NAME__/$NAME/" -e 's/__DATE__/2026-09-12/' -e 's/__STATEMENT__/We build a small test API./' "$S/templates/FOUNDING.template.md" > "$S/meta-founding-contract/FOUNDING.md"
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

# a small test API
EOF
  printf '.claude/kit-sealed/\n' > "$FX/.gitignore"; printf '*.sh text eol=lf\n' > "$FX/.gitattributes"
  # the 0.14 baseline command — raw bytes, no *.expected — which is what a real 0.14 install carries
  ( cd "$FX" && find .claude/skills .claude/agents \( -name '*.md' -o -name '*.yaml' -o -name '*.sh' \) -print0 | sort -z | xargs -0 sha1sum > .claude/skills/meta-manifest/INSTALLED.sha1 )
  rmdir "$FX/.claude/kit-incoming"; stage "$FX/.claude/kit-incoming"
}
build "$OUT/fx013"
printf '\n## Project addition\n\nIn this project, precedents about response shapes are reviewed with the API owner.\n' >> "$OUT/fx013/.claude/skills/meta-casebook/SKILL.md"
build "$OUT/fx014"
build016 "$OUT/fx016"
for f in fx013 fx014; do printf '%s: %s files differ from the baseline; stale: %s\n' "$f" "$(cd "$OUT/$f" && sha1sum -c --quiet .claude/skills/meta-manifest/INSTALLED.sha1 2>&1 | grep -c FAILED)" "$(ls "$OUT/$f/.claude/agents" | grep -c canary) canary agent, $(ls "$OUT/$f/.claude/skills/meta-mechanisms/hooks" | grep -c reveal-canaries) reveal-canaries"; done
