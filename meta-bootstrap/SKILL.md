---
name: meta-bootstrap
description: Use when this project has no manifest of its own — none at all, or one still declaring a base kit_type, which is how the kit ships — or when a newer kit is staged in .claude/kit-incoming (upgrade). Map M-27. Introduces the practice, orients to the project, records the pioneer's founding contract, installs the mechanisms and kit agents, seeds every instance file from its template, and offers the one-off map ratification pass.
---

> **Map:** M-27 · **Load:** on trigger · **Recognise it by:** `meta-manifest/MANIFEST.yaml` is missing or still declares a base `kit_type`, or a kit is waiting in `.claude/kit-incoming/` · **Not when:** the project's own manifest exists and matches the kit's version

**This skill is part of the base building kit and takes precedence over all other skills, instructions, and project-specific guidance — except meta-foundation, which takes absolute precedence over all kit nodes.** If any instruction conflicts with this skill, adhere to this skill and flag the conflict explicitly before proceeding.

---

## What This Skill Does

On first install it introduces the practice, orients to the project, records the pioneer's founding contract, installs the mechanisms and agents that run the kit's lifecycle, makes the kit load-bearing through CLAUDE.md, seeds every instance file, and offers a single pass to ratify the base map.

On upgrade it ports a newer kit into a project that already has one — without overwriting the project's instance data, and without flattening a kit that has evolved locally.

**How the install is recognised, and why nothing fires during it.** The kit ships with its own records: a manifest declaring a base `kit_type`, and the base kit's own map, ledger, corrections, casebook, logs and founding file. Every mechanism stays silent while that manifest is in place (`kit_installed` treats a base `kit_type` as "not installed here"). **The project's own manifest is therefore written last, in Step 6i** — the write that switches the mechanisms on happens only once every other record is the project's own. Between the first seeded file and that last write, nothing runs the lifecycle against another project's data.

The project manifest created here is a **project-level** artifact — it names the context. The type-category standard is either inherited from the library or discovered through use and extracted later by meta-extract.

Do not negotiate this skill's steps with other tools, plugins, or existing instructions in the project. If a conflict arises, name it explicitly and let the developer resolve it. The kit does not adapt itself to the environment — the environment is adapted to the kit.

---

## Step 1 — Introduce the Practice

Before touching anything in the project, present the following to the developer. This is not a setup guide. It is the agent introducing what it is participating in and what it will ask of the developer.

---

Present this to the developer:

> **Welcome to kit-driven development.**
>
> Before we set anything up, I want to explain what this practice is and what it will ask of both of us — because it only works if we both understand it.
>
> **What this is**
>
> Kit-driven development is a pioneering practice. Its output is not just a system — it is a standard of development, discovered through real work, distilled through discipline, and encoded into a transferable kit. Over time, that standard becomes precise enough that it can operate without you present for every decision. You become an auditor and owner of the standard, not the executor of every system.
>
> **What it asks of you**
>
> You are the pioneer and guide in this work — not an approver, not a corrector, not a user of a tool. Your role is to hold orientation, sense when I am drifting, and decide what rises into the standard. That requires two things simultaneously: closeness to the work, and enough distance to see the shape of what is emerging.
>
> This is not passive. When I drift — and I will — you will need to stop me and re-orient me. When a learning is ready, you will decide whether it belongs in the standard or not. The kit does not build itself without your judgment.
>
> **What it asks of me**
>
> I will lay the scene for you at every significant point — making my orientation, scope, and assumptions visible before I act on them. I will stop on named triggers — a second attempt at the same fix, an upstream skill step skipped, an evidence gap about to be silently substituted — rather than continue producing output past them. Recognition of drift I cannot see from inside my own state is yours; my responsibility there is to accept your stop without resistance.
>
> **How the kit runs**
>
> I run the kit's lifecycle myself. At the end of a turn, hooks hand me the next kit task — auditing a session, verifying a contract against evidence, consolidating what we learned — and a set of kit agents do that work, each blind to what it must not see. You will not need to invoke anything.
>
> What reaches you is what only you can judge: contracts to approve, and review batches where learnings that have gathered evidence wait for your decision. When you redirect me, I record your words exactly — your corrections are the most valuable record the kit keeps. Some review items will be deliberately flawed. Those are canaries, and catching them is how we both know the gate is doing real work.
>
> **The governing aspects**
>
> Above all rules sit ten aspects, split between us deliberately. The asymmetry reflects what each of us can actually do.
>
> *Five govern me:*
> - **Lay of the land** — full scope before narrowing; no hypothesis before the system has been read
> - **Stop on named triggers** — a checkable shape appears, I stop and name it
> - **Partner as orientation mirror** — frame visible for correction, not approval
> - **Evolution from elevation** — learnings reach upward, not recover from failure
> - **Evidence is the work** — verify the unknown, don't silently substitute
>
> *Five govern you:*
> - **Exercise judgment** — the kit encodes your judgment, it doesn't replace it
> - **Closeness** — present enough to detect drift I can't see from inside my own state
> - **Distance** — above the work enough to see the shape of what's emerging across sessions
> - **Re-orient** — when I'm drifting in shape I can't recognise, you stop me and reset the frame
> - **Hold the approval gate** — decide what enters the standard
>
> The kit can make drift visible. It cannot stop it. You do. Full definitions of each aspect live in `meta-foundation/SKILL.md`.
>
> **What we are building toward**
>
> A kit mature enough that a developer who was not present for its creation can work within it at full quality. That takes time and discipline, and the kit now measures whether it is happening rather than assuming it.
>
> If this is how you want to work, we can proceed. I will read the project first, then ask you the one thing only you can give.

---

Wait for the developer to confirm before proceeding to Step 2.

---

## Step 2 — Orient to the Project

Read the project **before changing anything in it**. Lay of the land applies from the first moment, and an existing hook, agent or instruction that will conflict with the kit has to be found before the kit is installed, not after.

Read:
- The project's existing `CLAUDE.md` or instruction files
- The directory structure — what kind of system is this?
- `.claude/settings.json` and `.claude/settings.local.json` — existing hooks and permissions
- `.claude/agents/` — existing agents, and whether any name collides with the kit's
- Any existing skills, prompts, or agent instructions already in place
- Any README or documentation that describes the project's purpose

Then present an orientation to the developer:

> Here is how I am currently reading this project:
>
> **System type**: [what kind of system this appears to be]
>
> **Stack**: [languages, frameworks, primary technologies observed]
>
> **Existing agent instructions, hooks and agents**: [what's already in place]
>
> **Potential conflicts**: [tools, plugins, hooks, agent names or instructions that may negotiate with the kit — name them explicitly, especially any existing Stop hook]
>
> **Type-category kit needed**: [which domain-specific kit would serve this project — or that one needs to be built from scratch]
>
> **What I am treating as unknown**: [scope or concerns I have not yet read or cannot determine from the files]
>
> Is this orientation correct? Correct anything before we proceed.

Wait for the developer to confirm or correct the orientation. A correction here is the project's first correction — record it once the log exists (Step 6h).

---

## Step 3 — Draw the Founding Contract

**Purpose:** capture what this project is, in the pioneer's own terms, as the thing every future contract will be in service of. Governed by `meta-founding-contract/SKILL.md` — read it before this step.

Placed after orientation, because the pioneer's statement is better made once the agent's reading of the project is on the table and can be corrected. Placed before the install and the manifest, because those are topology and the statement is what the topology is for. It is **recorded** in Step 6e.

Present this to the developer:

> **Now the part only you can give.**
>
> Everything above is the practice. This next thing is *this project* — and it is the one input I cannot derive, infer, or draft for you, because it is what everything else gets derived from.
>
> I need your statement of what this project is. Not a product vision — this is internal, behind the scenes. Not who it is for or what an audience should feel. What it **is**, as a body of work: what should hold it together, what ordering it is meant to have, what would tell you it had stopped being that.
>
> Some questions that may help, though the statement is yours and not a form to fill in:
>
> - What is this project, in your own terms, as a body of work?
> - Why are you making it — what do you want from having made it?
> - What should make it feel like one thing rather than a pile of parts?
> - How do you view it? What is it to you?
> - What would tell you it had stopped being that?
>
> Take the time it needs. It does not have to be long, and it will not be final — it is living. As the work goes on and your understanding deepens, you add dated amendments saying where the project has got to. The original is never rewritten.
>
> Once you give it, I will write it into `FOUNDING.md` verbatim. It is loaded in every session, and every contract's bearing is read against it.

**Agent conduct in this step — the whole of it:**

- **Ask; do not answer.** The agent must not draft a candidate statement, not even one offered "to react to." A drafted founding statement makes the pioneer correct the agent's frame instead of stating their own, and the statement then carries the agent's ordering for the life of the project.
- **Reflecting back is permitted; proposing is not.** "Here is what I heard, correct me" is orientation. "Here is what I think your project is" is substitution.
- **Record it verbatim**, datestamped, in Step 6e. It is never rewritten.
- **A new project with no code yields little at Step 2.** That is fine — the statement carries more weight, not less, when there is nothing yet to read.
- **If the pioneer defers**, say that contracts drawn before the statement exists have nothing to bear against, and record the deferral in Step 6e exactly as that step describes. The session-start hook surfaces it every session until it is given.

Wait for the statement, or an explicit deferral, before proceeding to Step 4.

---

## Step 4 — Check for a Library Kit

Look for `.claude/library/[category]/META.yaml`, where category matches what was identified in Step 2. **Read only** — nothing is copied until Step 5f.

**If a library kit is found**, present it to the developer:

> I found an existing kit for this project type in the library:
>
> **Kit**: [kit_name] · **Version**: [version] — Generation [generation]
> **Covers**: [covers list] · **Known gaps**: [known_gaps list]
> **Reconstruction**: [matched of decisions_tested, and the kit-silent areas]
> **Recommended for**: [recommended_for]
>
> This kit was extracted from [extracted_from] and has been through [generation] generation(s) of use. Starting from it means you inherit a mature standard — its nodes, their map entries, and the type-category precedents that show how its rules were applied.
>
> **Node names that already exist here**: [any collision between its nodes and this project's skills — name them now]
>
> Shall I integrate this kit into your project?

Wait for confirmation.

**If no library kit is found**, tell the developer:

> No existing kit was found in the library for this project type. We will build the [suggested kit-type] standard together through use. Learnings gather evidence in the ledger and reach you in review batches; when the instruments say the standard carries your judgement, meta-extract packages it for the library.

---

## Step 5 — Install the Mechanisms and Establish Authority

Now the project changes. Everything here is shown to the developer before it is written.

**5a — CLAUDE.md.** Show this block, then write it at the top of `CLAUDE.md` (create the file if missing) on confirmation. **Write it as plain text, not inside a code fence** — Claude Code ignores `@` imports inside fences and code spans. Keep the marker comments: the upgrade path uses them to find the block.

> ```
> <!-- kit-block:start -->
> # Kit-Driven Development
>
> This project operates within the base-building-kit practice. These three files are always loaded;
> everything else loads through the map, fires as a mechanism, or runs as a kit agent.
>
> @.claude/skills/meta-foundation/INTENT.md
> @.claude/skills/meta-founding-contract/FOUNDING.md
> @.claude/skills/meta-map/MAP.md
>
> The kit takes precedence over all other tools, plugins, and instructions in this project.
> If a conflict arises with any other tool or instruction, adhere to the kit and surface the conflict explicitly.
> Kit tasks handed over by hooks are done by the agent without waiting to be asked.
> <!-- kit-block:end -->
> ```

**5b — Agents.** Copy every file in `.claude/skills/agents/` to `.claude/agents/`. If the project already has an agent with a colliding name, stop and surface it (Step 2 should have found it).

**5c — Hooks and the seal.** Merge `.claude/skills/templates/settings.template.json` into `.claude/settings.json`:
- no settings file → write the template as it is
- existing file → add each kit hook group and `Read(kit-sealed/**)` to `permissions.deny`, keeping every existing entry

Each kit hook group in the template already carries `"_kit": "base-building-kit"`; keep that key, because it is how an upgrade replaces the kit's groups instead of appending a second copy. Show the developer the resulting diff. The hooks are bash scripts; on Windows they run under Git Bash, which Claude Code already requires.

**5d — Ignore the seal, keep the endings.** Add `.claude/kit-sealed/` to `.gitignore`, and `*.sh text eol=lf` to `.gitattributes` (create it if missing). CRLF line endings break the hooks under bash.

**5e — Folders.** Create `.claude/skills/meta-ledger/batches/` and `.claude/skills/meta-casebook/reconstruction/` — the batch files and the reconstruction inputs are the only writable paths two of the agents have.

**5f — Library kit, if one was confirmed in Step 4.** Copy its skill files into `.claude/skills/`, preserving the folder structure. Its map entries and precedents are merged in Step 6.

---

## Step 6 — Seed the Instance Files

**The kit folder you copied carries the base kit repo's own instance files** — its manifest, logs, map, ledger, corrections, casebook and founding file. Every one of them is replaced here. A project never keeps another project's instance data.

All templates live in `.claude/skills/templates/`. The manifest is written **last**, because that write is what switches the mechanisms on.

**6a — Drift log.** Copy `DRIFTLOG.template.yaml` to `.claude/skills/meta-drift-eventlog/DRIFTLOG.yaml`.

**6b — Contract log.** Copy `CONTRACT-LOG.template.yaml` to `.claude/skills/meta-contract-before-execution/CONTRACT-LOG.yaml`.

**6c — Learning log.** Copy `LEARNINGLOG.template.yaml` to `.claude/skills/meta-learning/LEARNINGLOG.yaml`.

**6d — Ledger.** Copy `LEDGER.template.yaml` to `.claude/skills/meta-ledger/LEDGER.yaml`.

**6e — Founding contract.** Copy `FOUNDING.template.md` to `.claude/skills/meta-founding-contract/FOUNDING.md`, replacing `__PROJECT_NAME__` and `__DATE__`.
- **Statement given:** paste it verbatim over `__STATEMENT__`, as a blockquote, preserving the pioneer's paragraphs. Nothing else in the statement block changes: no tidying, no summarising, no headings they did not write.
- **Statement deferred:** replace the whole statement block — the *Given by the Pioneer* line included — with `*Deferred by the Pioneer on [date].*` so the record never claims a statement that does not exist.

**6f — Map.** Copy `MAP.template.md` to `.claude/skills/meta-map/MAP.md` and replace `__PROJECT_NAME__`. If a library kit was integrated, append its `map_entries` under "Project entries", renumbered in sequence with status `proposed`, and update each inherited node's `triggers` and its skill file's `> **Map:**` header to the new ids.

**6g — Correction log.** Copy `CORRECTIONS.template.yaml` to `.claude/skills/meta-correction-log/CORRECTIONS.yaml`. Record any correction the pioneer made during Steps 1–5, verbatim.

**6h — Casebook, and the rebuild plan.** Copy `CASEBOOK.template.yaml` to `.claude/skills/meta-casebook/CASEBOOK.yaml`. If a library kit was integrated, append its type-category precedents from the library's `CASEBOOK.yaml`, and list every `{binding}` they contain for the pioneer to re-bind.

Then seed the rebuild plan — these two lines, exactly, so the walk that tests them and the install that runs them agree:

```
cp .claude/skills/templates/REBUILD.template.yaml .claude/skills/meta-casebook/REBUILD.yaml
sed -i -e "s/__PROJECT_NAME__/$PROJECT_NAME/" -e "s/__DATE__/$(date +%Y-%m-%d)/" .claude/skills/meta-casebook/REBUILD.yaml
```

and ask the pioneer one question:

> At some milestone — a release, a tag, a date — the kit can rebuild this product from its own records, blind, in an empty folder, and measure what the records carried. That plan has to be written now, before the first contract, or it can be bent later to fit what got built. What milestone should trigger it? You can also defer the choice.

Write the answer as `milestone`, in their words, or leave `deferred`. Nothing else in the file is asked about: the oracle and the arms are the kit's defaults, and the pioneer can read them. From this date the plan is frozen (meta-casebook → The launch rebuild).

**6i — Project manifest, last.** Read `MANIFEST.template.yaml`, replace every double-underscore value, and write it to `.claude/skills/meta-manifest/MANIFEST.yaml`. **This is the write that switches the mechanisms on**, which is why it comes after every record above is the project's own.

| Placeholder | Replace with |
|---|---|
| `__PROJECT_NAME__` | Project name derived from directory name or README |
| `__CATEGORY__` | Type-category identified in Step 2, e.g. `blazor-web-app` |
| `__LIBRARY_KIT__` | If a library kit was integrated: `{kit_name: x, version: y, generation: N, integrated_date: today}` — otherwise `null` |
| `__INHERITED_NODES__` | If integrated: the node list from META.yaml with `inherited: true`, `tier: type-category`, `inherited_from: [kit_name] v[version] generation [N]`, and `triggers` renumbered to this project's map — otherwise remove the comment line |
| `__INHERITED_COVERAGE__` | If integrated: coverage entries from META.yaml — otherwise remove the comment line |

Leave no placeholder in the written file.

**6j — Install baseline.** Now that every file is in its installed state, record the per-file hashes an upgrade will compare against:

```
find .claude/skills .claude/agents \( -name '*.md' -o -name '*.yaml' -o -name '*.sh' \) -print0 \
  | sort -z | xargs -0 sha1sum > .claude/skills/meta-manifest/INSTALLED.sha1
```

It covers the deployed agents as well as the skills, and `-print0` keeps paths with spaces intact. Without this baseline, "untouched here" is a guess at the next upgrade, and a guess is how an evolved fork gets flattened.

History does not inherit. Structure does: the governance of every log travels with the kit, and every instance starts empty except for inherited map entries and type-category precedents.

---

## Step 7 — Check the Mechanisms, Then Offer the Ratification Pass

Run each hook once and confirm it prints valid JSON or nothing. `CLAUDE_PROJECT_DIR` must be set, or the scripts fall back to the current directory:

```
cd <project root>
export CLAUDE_PROJECT_DIR="$PWD"
H=.claude/skills/meta-mechanisms/hooks
echo '{"source":"startup"}'                                                   | bash $H/session-start.sh
echo '{"prompt":"add a feature"}'                                             | bash $H/prompt-submit.sh
echo '{"stop_hook_active":false,"last_assistant_message":"Done."}'             | bash $H/stop-gate.sh
echo '{"agent_type":"kit-verifier"}'                                           | bash $H/subagent-stop.sh
echo "{\"tool_input\":{\"file_path\":\"$PWD/.claude/skills/meta-map/MAP.md\"}}" | bash $H/post-read.sh
echo "{\"tool_input\":{\"file_path\":\"$PWD/.claude/skills/meta-casebook/CASEBOOK.yaml\"}}" | bash $H/owner-check.sh
echo "{\"tool_name\":\"Read\",\"tool_input\":{\"file_path\":\"$PWD/.claude/skills/meta-ledger/LEDGER.yaml\"}}" | bash $H/batch-blind.sh
echo '{"tool_input":{"file_path":"src/x.cs"}}'                                 | bash $H/deny-paths.sh "kit-sealed/"
echo '{"tool_input":{"file_path":"src/x.cs"}}'                                 | bash $H/write-scope.sh "meta-ledger/LEDGER.yaml"
bash $H/close-batch.sh B-001      # expect: no batch file — correct on a fresh install
bash $H/reveal-canaries.sh B-001  # expect: no batch file
tail -3 .claude/skills/meta-ledger/telemetry.log
```

What a correct fresh install shows:
- `session-start.sh` prints **one** backlog line — pioneer-owned items are waiting — because the base map entries arrive `proposed`. It deliberately prints no count. A correction recorded in Steps 1–5 adds a second line, and a deferred statement a third.
- `stop-gate.sh` hands over the batch task (M-16).
- `batch-blind.sh` prints nothing, because no batch is open yet.
- `telemetry.log` ends with a `loaded|meta-map/MAP.md` line from the `post-read.sh` run — an absolute path is required, since the hook matches `*/.claude/skills/*` — followed by an ownership line naming `base-casebook` from the `owner-check.sh` run: the casebook skill was never loaded in this shell, and that is exactly what the check records. No `loaded` line means telemetry is not recording, and the map's only firing evidence is missing. No ownership line means `owns:` did not survive the manifest write in 6i.
- `REBUILD.yaml` exists in `meta-casebook/` with `frozen_on` set to today and `milestone` either in the pioneer's words or `deferred`.

If a script errors, or `session-start.sh` mentions contracts, observations or drift entries, the base kit's records are still in place and Step 6 did not complete.

**Then offer the ratification pass:**

> The kit ships 31 map entries — the index that decides which knowledge loads when. They are drafted, not yours yet, and until you ratify them they will keep asking to be reviewed.
>
> I can put all of them to you now, in one pass: each entry's moment, when it fires, what it loads, and what it is not for. No canaries — this is setup, not a test of the gate. Ratify, decline or reword each one.
>
> If you would rather build first, I will mark the map `ratification: deferred`, and the base entries will stop opening review batches until you ask for the pass.

On a pass: present the entries in their map groups, record each as `ratified`, `declined` or reworded, and remove any `ratification: deferred` marker. On a deferral: add `<!-- ratification: deferred -->` to `MAP.md`'s header comment.

Then tell the developer:

> The kit is installed.
>
> - **Always loaded:** INTENT.md, your founding statement, and the map.
> - **Mechanisms:** hooks in `.claude/settings.json` run the kit's lifecycle. Start a new session so they load for certain.
> - **Agents:** the kit agents in `.claude/agents/`.
> - **Records:** manifest, contract log, learning log, drift log, ledger, correction log and casebook seeded; your founding statement recorded verbatim; the rebuild plan frozen; the install baseline written.
>
> [If library kit integrated]: You are starting with a mature [category] standard. Its nodes, map entries and precedents are your baseline; the inherited map entries are proposed until you ratify them.
>
> Every feature begins with a contract: a bearing read against your statement, a precedent check, then a four-tier proposal ending in the acceptance tests it will be verified by. What the work teaches is held and scored, and reaches you in review batches. You won't need to run anything.
>
> What would you like to build first?

---

## Upgrading an Existing Install

Runs when a project has its own manifest and a newer kit is staged.

**Never copy a new kit over `.claude/skills/`.** The kit folder carries its own instance files and would overwrite this project's manifest, logs, founding statement, ledger and corrections. And a project's kit is often a fork whose skills have evolved; a folder copy flattens those evolutions without anyone seeing it.

**Everything new comes from `.claude/kit-incoming/`** — its `meta-*/` nodes, its `agents/`, its `templates/`, and its `meta-mechanisms/hooks/`. Steps 5b–5e and 6a–6j read from `.claude/skills/` and `.claude/skills/templates/`; on an upgrade, read the incoming copies instead. An upgrade that re-deploys the installed agents and hooks has installed nothing and will report success.

1. **Stage it.** The pioneer places the new kit in `.claude/kit-incoming/`. Compare its `meta-manifest/MANIFEST.yaml → kit_identity.version` with this project's `kit_identity.base_kit_version`. **If that field is absent** — every manifest before v0.14 — treat the project as pre-0.14 and say so; do not guess a version.
2. **Lay of the land.** Read both kits in full. Classify every skill, agent and hook script against `meta-manifest/INSTALLED.sha1`:
   - **untouched here** (hash matches the baseline) → take the incoming version
   - **evolved here** (hash differs, or no baseline exists) → port the incoming changes by hand, node by node, surfacing every conflict
   - **new in the kit** → add it

   Present the classification before changing anything. With no baseline, say plainly that every file must be treated as possibly evolved.
3. **New folders arrive without their records.** A new node's `SKILL.md` is copied; its instance file is **not**. Seed those from the *incoming* templates in step 5 below. The incoming kit's own ledger, corrections, casebook, map and logs are never copied into the project.
4. **Install** from the incoming copies: agents to `.claude/agents/` (porting any that the baseline shows were evolved here), the hook scripts into `.claude/skills/meta-mechanisms/hooks/`, and the settings merge — **replacing** the hook groups whose `"_kit"` key marks them as the kit's, and removing groups whose scripts no longer exist. Replace the CLAUDE.md block between its `kit-block` markers, adding the markers if the old block has none.
5. **Seed missing instance files** (6a–6h, including 6e when the project has no `FOUNDING.md` — pre-v0.13 projects don't, and the CLAUDE.md block imports it). Existing instance files are never replaced.
6. **Migrate existing instance schemas additively:**
   - `CONTRACT-LOG.yaml` — add `verification_state: legacy` and `audited: legacy` to every existing entry. The pioneer may name recent implemented contracts to verify and audit; set `none` and `false` on those.
   - `DRIFTLOG.yaml` — add `mitigation_medium: unknown` to existing elevations.
   - `MANIFEST.yaml` — add `kind`, `load` and `triggers` to every node, register the new base nodes, and set `base_kit_version`.
7. **Map the project's nodes.** For each existing non-base node, draft an entry under "Project entries" from its description, as `proposed`, and add the matching `> **Map:**` header. The pioneer ratifies them in the first review batch, or in a ratification pass as at Step 7.
8. **Regenerate the baseline** (6j) and **report**: present the upgrade as an analysis report — what was taken, ported, conflicted and migrated. Remove `.claude/kit-incoming/` on the pioneer's confirmation, and run Step 7's checks.

---

## What This Skill Does Not Do

- It does not audit the existing codebase for problems or improvements — that comes later, through use
- It does not negotiate its steps with existing tools, plugins or hooks — conflicts are named and surfaced, not resolved by compromise
- It does not change anything in the project before Step 5, and never before the orientation in Step 2 has been confirmed
- It does not run more than once per install, and once per upgrade
- It does not draft, suggest, or shape the founding statement — it asks for it and records it verbatim
- It does not overwrite instance data or folder-copy a kit over an evolved one
- It does not create a type-category manifest — that is meta-extract's artifact, when the instruments say the standard is ready
