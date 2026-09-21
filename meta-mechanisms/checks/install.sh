#!/usr/bin/env bash
# install.sh — performs the install step, so that it is a command and not a loop each agent writes for itself
# (contract-018 UC-1). Run from the project's root, from the NEW kit's copy of this script:
#   upgrade:  bash .claude/kit-incoming/meta-mechanisms/checks/install.sh upgrade <plan> [options]
#   install:  bash .claude/skills/meta-mechanisms/checks/install.sh install [options]
#
# THE PLAN (upgrade only) is what step 3's classification decided, one line per file, paths relative to
# .claude/skills/. Anything not named is left alone — a skill whose lines the pioneer kept needs no line here.
#   take  meta-map/SKILL.md          install this file from the staged kit (classified untouched or new)
#   stale hooks/reveal-canaries.sh   remove this file from the project (the staged kit no longer ships it)
# Lines may be blank or start with #. `templates/` and `installed/` are refused: they are the bases the later
# steps compare against, and they are replaced last, by hand, after those comparisons.
#
# OPTIONS
#   --workspace <file>   one `path — role` per line: the applications the sheet named. Without it, the manifest's
#                        `workspace` list is read; with neither, the list is empty.
#   --skip-settings      the agent merges .claude/settings.json itself (see the refusal below) — this script then
#   --skip-claude-md     leaves that file alone and says so in its report. Same for the CLAUDE.md block.
#
# WHAT IT DOES, in the step's own order: takes the planned files from the staged kit · deploys the kit's agents to
# .claude/agents/ · merges the settings, granting each application the sheet named in permissions.additionalDirectories · replaces the CLAUDE.md block between its markers, rendering the
# applications line · adds the ignore entries and the two agent folders wherever they are missing · removes the
# stale files. On an install it also writes the installed copies, the yardstick the next upgrade measures against.
#
# WHAT IT REFUSES, rather than guessing — and then it changes NOTHING at all, so a refused run is a safe run:
#   * a settings file that is not the one the last install shipped: something of the project's own is in it, and
#     which groups are the kit's cannot be told from the file alone. The agent merges it by hand (step 5 says how)
#     and runs again with --skip-settings.
#   * a CLAUDE.md with no kit-block markers: where the old block ends is a judgement, and a paragraph of the
#     pioneer's may sit inside it. The script prints the span it would have replaced; the agent does that part and
#     runs again with --skip-claude-md.
#   * removing a `P-NNN.sh` whose precedent is in this project's casebook: that is the project's own check, not the
#     base kit's evidence, and it is never stale (contract-018 UC-2). It is spared and named; nothing else changes.
#   * removing a file named *.project.* — the name the kit reserves for what a project adds beside a kit file, such
#     as its own refusal registry. No release carries one, so it is never stale (contract-023 UC-16). Spared and named.
set -u
mode=""; plan=""; wsfile=""; skip_settings=0; skip_claude=0
while [ $# -gt 0 ]; do
  case "$1" in
    install|upgrade) mode="$1" ;;
    --workspace) wsfile="${2:-}"; shift ;;
    --skip-settings) skip_settings=1 ;;
    --skip-claude-md) skip_claude=1 ;;
    -*) echo "install.sh: unknown option $1" >&2; exit 2 ;;
    *) plan="$1" ;;
  esac
  shift
done
[ -n "$mode" ] || { echo "usage: install.sh install|upgrade [<plan>] [--workspace <file>] [--skip-settings] [--skip-claude-md]" >&2; exit 2; }
here="$(cd "$(dirname "$0")" && pwd)"; REL="$(cd "$here/../.." && pwd)"; ROOT="$PWD"; K="$ROOT/.claude/skills"
[ -d "$ROOT/.claude" ] || { echo "refused: run this from the project's root — there is no .claude folder in $ROOT"; exit 1; }
if [ "$mode" = upgrade ]; then
  [ -n "$plan" ] && [ -f "$plan" ] || { echo "refused: an upgrade needs the plan step 3's classification decided — install.sh upgrade <plan>"; exit 1; }
fi

bad=0; refuse() { bad=1; printf 'refused: %s\n' "$1"; }
takes=(); stales=(); spared=(); notes=()

# ---- read the plan ------------------------------------------------------------------------------------------------
if [ "$mode" = upgrade ]; then
  while IFS= read -r line || [ -n "$line" ]; do
    line="${line%$'\r'}"; line="${line#"${line%%[![:space:]]*}"}"
    case "$line" in ''|'#'*) continue ;; esac
    verb="${line%%[[:space:]]*}"; path="${line#*[[:space:]]}"; path="${path#"${path%%[![:space:]]*}"}"; path="${path%"${path##*[![:space:]]}"}"
    case "$path" in templates/*|installed/*) refuse "the plan names $path, and $verb is not this step's to make: the templates and the installed copies are what the later steps compare against, and they are replaced last"; continue ;; esac
    case "$verb" in
      take)  [ -f "$REL/$path" ] || { refuse "the plan says take $path, and the staged kit has no such file"; continue; }; takes+=("$path") ;;
      stale) [ -e "$K/$path" ] || { notes+=("stale $path was already gone"); continue; }; stales+=("$path") ;;
      *) refuse "the plan line \"$line\" starts with $verb; only take and stale are read here" ;;
    esac
  done < "$plan"
fi

# ---- what is the project's own is never stale (contract-018 UC-2, contract-023 UC-16) -------------------------------
# Two kinds of file sit inside the kit's folders and are not the kit's: a precedent check the case clerk wrote for a
# precedent in this project's casebook, and any file named *.project.* — the name the kit reserves for what a
# project adds beside a kit file (its own refusal registry, today). Both are absent from the staged kit by design,
# so the stale rule would list them; both are spared and named, and nothing else about the run changes.
CASE="$K/meta-casebook/CASEBOOK.yaml"
keep_stales=()
for p in ${stales+"${stales[@]}"}; do
  case "$(basename "$p")" in
    *.project.*)
      spared+=("$p is this project's own file — a name ending .project.<type> is never the kit's — not stale, not removed")
      continue ;;
  esac
  case "$p" in
    *meta-mechanisms/checks/P-*.sh|checks/P-*.sh|*/P-*.sh)
      id="$(basename "$p" .sh)"
      if [ -f "$CASE" ] && grep -q -E "^[[:space:]]*-?[[:space:]]*prec_id:[[:space:]]*$id([[:space:]]|$)" "$CASE"; then
        spared+=("$p is this project's own check for precedent $id, which is in its casebook — not stale, not removed")
        continue
      fi ;;
  esac
  keep_stales+=("$p")
done
stales=(${keep_stales+"${keep_stales[@]}"})

# ---- the applications the sheet named --------------------------------------------------------------------------------
ws_lines=""
if [ -n "$wsfile" ]; then
  [ -f "$wsfile" ] || refuse "--workspace $wsfile does not exist"
  [ -f "$wsfile" ] && ws_lines="$(tr -d '\r' < "$wsfile" | grep '[^[:space:]]' || true)"
elif [ -f "$K/meta-manifest/MANIFEST.yaml" ]; then
  ws_lines="$(awk '/^[[:space:]]+workspace:/{f=1; if ($0 ~ /\[\]/) exit; next} f&&/^[[:space:]]+[a-z_]+:/{exit} f&&/path:/{p=$0; sub(/.*path:[[:space:]]*/,"",p); sub(/[,}].*/,"",p); r=$0; sub(/.*role:[[:space:]]*/,"",r); sub(/[}].*/,"",r); if (p!="") print p " — " r}' "$K/meta-manifest/MANIFEST.yaml")"
fi
ws_render="$(printf '%s' "$ws_lines" | grep '[^[:space:]]' | paste -sd, - 2>/dev/null | sed 's/,/, /g')"

# ---- can the settings be merged without guessing? ----------------------------------------------------------------------
SET="$ROOT/.claude/settings.json"; NEWSET="$REL/templates/settings.template.json"; OLDSET="$K/templates/settings.template.json"
settings_do=0
if [ "$skip_settings" = 0 ]; then
  if [ ! -f "$NEWSET" ]; then refuse "the staged kit has no templates/settings.template.json"
  elif [ ! -f "$SET" ]; then settings_do=1; notes+=("the project had no .claude/settings.json; the staged template is written as it is (5c)")
  elif [ ! -f "$OLDSET" ]; then refuse "this project keeps no copy of the settings template the last install shipped, so which hook groups are the kit's cannot be told from the file alone. Merge .claude/settings.json by hand as step 5 says, then run again with --skip-settings"
  elif [ "$(tr -d ' \t\r\n' < "$SET")" != "$(tr -d ' \t\r\n' < "$OLDSET")" ]; then
    refuse "this project's .claude/settings.json is not the one the last install shipped — something of the project's own is in it, and this script will not guess which groups are the kit's. Merge it by hand as step 5 says (keep every group without a \"_kit\" key, drop every group that carries it, append the staged template's group for that event, keep every permissions.deny entry), then run again with --skip-settings"
  else settings_do=1; fi
fi

# ---- can the CLAUDE.md block be replaced without guessing? ---------------------------------------------------------------
CL="$ROOT/CLAUDE.md"; claude_do=0
if [ "$skip_claude" = 0 ]; then
  blk="$(sed -n '/^> <!-- kit-block:start -->/,/^> <!-- kit-block:end -->/p' "$REL/meta-bootstrap/SKILL.md" | sed -e 's/^> \{0,1\}//')"
  [ -n "$blk" ] || refuse "the staged kit's meta-bootstrap/SKILL.md does not carry the CLAUDE.md block between kit-block markers, so there is nothing to write"
  if [ ! -f "$CL" ]; then claude_do=1; notes+=("the project had no CLAUDE.md; the kit block is written as the whole file (5a)")
  elif grep -q '<!-- kit-block:start -->' "$CL" && grep -q '<!-- kit-block:end -->' "$CL"; then claude_do=1
  else
    span="$(awk '/^# Kit-Driven Development/{f=1} f{ if (NR>s && (/^---[[:space:]]*$/ || (/^#/ && !/^# Kit-Driven Development/))) exit; print; s=NR }' "$CL")"
    refuse "this project's CLAUDE.md has no kit-block markers. Where the old block ends is a judgement, and a paragraph of the pioneer's own may sit inside it — carried over beneath the new block, never dropped (step 5). Do that part by hand and run again with --skip-claude-md. The span it would have replaced:
$(printf '%s' "$span" | sed 's/^/    | /')"
  fi
fi

# ---- nothing is changed until everything above has passed ------------------------------------------------------------------
if [ "$bad" != 0 ]; then
  for s in ${spared+"${spared[@]}"}; do printf 'spared: %s\n' "$s"; done
  echo "install.sh changed nothing."
  exit 1
fi

# ---- act --------------------------------------------------------------------------------------------------------------------
took=0; deployed=0
for p in ${takes+"${takes[@]}"}; do
  mkdir -p "$K/$(dirname "$p")"; cp "$REL/$p" "$K/$p"; took=$((took+1))
done
# the agents to .claude/agents/: the kit's own copy under skills/agents/ is the source, whether this step took it
# or the merge reapplied the project's lines into it, so the deployed copy is never left behind a reapplied one
mkdir -p "$ROOT/.claude/agents"
for f in "$K"/agents/*.md; do
  [ -f "$f" ] || continue
  d="$ROOT/.claude/agents/$(basename "$f")"
  cmp -s "$f" "$d" || { cp "$f" "$d"; deployed=$((deployed+1)); }
done
if [ "$mode" = install ]; then
  mkdir -p "$K/installed"                                   # 5g, the yardstick the next upgrade measures against
  for f in "$K"/meta-*/SKILL.md "$K/meta-foundation/INTENT.md"; do
    [ -f "$f" ] || continue; r="${f#$K/}"; mkdir -p "$K/installed/$(dirname "$r")"; cp "$f" "$K/installed/$r"
  done
fi

if [ "$settings_do" = 1 ]; then
  if [ -n "$ws_lines" ]; then
    dirs="$(printf '%s\n' "$ws_lines" | sed -e 's/[[:space:]]*—.*$//' -e 's/[[:space:]]*$//' | grep '[^[:space:]]' | awk '{printf "%s\"%s\"", (NR>1 ? ", " : ""), $0}')"
    sed -e "s#\"additionalDirectories\": \[\]#\"additionalDirectories\": [$dirs]#" "$NEWSET" > "$SET"
  else cp "$NEWSET" "$SET"; fi
fi

if [ "$claude_do" = 1 ]; then
  if [ -n "$ws_render" ]; then body="$(printf '%s' "$blk" | sed "s#__WORKSPACE__#$ws_render#")"
  else body="$(printf '%s' "$blk" | grep -v 'Applications in the system flow, beyond this repository: __WORKSPACE__' | awk 'BEGIN{p=""} { if (!(prev ~ /^[[:space:]]*$/ && $0 ~ /^[[:space:]]*$/)) print; prev=$0 }')"; fi
  if [ ! -f "$CL" ]; then printf '%s\n' "$body" > "$CL"
  else
    tmp="$(mktemp)"; printf '%s\n' "$body" > "$tmp.blk"
    awk -v blk="$tmp.blk" '
      /<!-- kit-block:start -->/ { while ((getline l < blk) > 0) print l; close(blk); skip=1; next }
      /<!-- kit-block:end -->/   { skip=0; next }
      !skip { print }' "$CL" > "$tmp" && mv "$tmp" "$CL"; rm -f "$tmp.blk"
  fi
fi

# 5d — the ignore entries, and 5e — the two folders only the kit agents write to
added=()
gi="$ROOT/.gitignore"; ga="$ROOT/.gitattributes"
for e in '.claude/kit-sealed/' '.claude/skills/meta-ledger/.session-started'; do
  if [ ! -f "$gi" ] || ! grep -q -x -F -- "$e" "$gi"; then printf '%s\n' "$e" >> "$gi"; added+=(".gitignore: $e"); fi
done
if [ ! -f "$ga" ] || ! grep -q -F -- '*.sh text eol=lf' "$ga"; then printf '%s\n' '*.sh text eol=lf' >> "$ga"; added+=(".gitattributes: *.sh text eol=lf"); fi
for d in "$K/meta-ledger/batches" "$K/meta-casebook/reconstruction" "$K/meta-mechanisms/checks"; do
  [ -d "$d" ] || { mkdir -p "$d"; added+=("${d#$ROOT/}"); }
  case "$d" in */checks) ;; *) [ -f "$d/.gitkeep" ] || : > "$d/.gitkeep" ;; esac
done

removed=0
for p in ${stales+"${stales[@]}"}; do
  rm -rf "$K/$p"; removed=$((removed+1))
  # an agent stands twice, in the kit's own copy and where it is deployed; the pair is one file (step 3)
  case "$p" in agents/*.md) rm -f "$ROOT/.claude/agents/$(basename "$p")" ;; esac
done

# ---- say what was done ----------------------------------------------------------------------------------------------------
printf 'install.sh (%s): %s file(s) taken from the staged kit, %s agent(s) deployed, %s stale file(s) removed.\n' "$mode" "$took" "$deployed" "$removed"
[ "$settings_do" = 1 ] && printf '  settings: written from the staged template%s\n' "$([ -n "$ws_lines" ] && printf ', with %s application(s) granted' "$(printf '%s\n' "$ws_lines" | grep -c '[^[:space:]]')")"
[ "$skip_settings" = 1 ] && printf '  settings: left alone — the agent merged it by hand (--skip-settings)\n'
[ "$claude_do" = 1 ] && printf '  CLAUDE.md: the kit block replaced%s\n' "$([ -n "$ws_render" ] && printf ', applications line rendered' || printf ', no applications line')"
[ "$skip_claude" = 1 ] && printf '  CLAUDE.md: left alone — the agent did that part by hand (--skip-claude-md)\n'
for s in ${spared+"${spared[@]}"}; do printf '  spared: %s\n' "$s"; done
for n in ${notes+"${notes[@]}"}; do printf '  note: %s\n' "$n"; done
for a in ${added+"${added[@]}"}; do printf '  added: %s\n' "$a"; done
exit 0
