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
> What reaches you is what only you can judge: contracts to approve, and review batches where learnings that have gathered evidence wait for your decision. When you redirect me, I record your words exactly, and ask you three short questions — what you noticed, what would have been right, where you have seen it before — because your corrections are where the standard you already know gets written down. Later on, a review batch may show you something you decided before, without saying so; afterwards you see both decisions side by side. Nothing scores you.
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

**5g — Installed copies.** Copy every `meta-*/SKILL.md` and `meta-foundation/INTENT.md`, exactly as installed, to `.claude/skills/installed/` under the same relative path (`installed/meta-map/SKILL.md`, `installed/meta-foundation/INTENT.md`). This is the yardstick the next upgrade measures the project's own edits against — the same copy the kit already keeps of its agents under `skills/agents/` and of its record templates under `skills/templates/`. It is never loaded, never edited, and never asked about: an upgrade replaces it (contract-008 G-1).

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

**6h — Casebook.** Copy `CASEBOOK.template.yaml` to `.claude/skills/meta-casebook/CASEBOOK.yaml`. If a library kit was integrated, append its type-category precedents from the library's `CASEBOOK.yaml`, and list every `{binding}` they contain for the pioneer to re-bind. Create `.claude/skills/meta-mechanisms/checks/` if the copy lacks it; it is where the case clerk writes checks as the pioneer's corrections turn into standards that can be tested. The kit's own checks stay (`G1-size.sh`, and any later `G*.sh`); **delete the base kit's `P-NNN.sh` checks and its `meta-mechanisms/tests/results/` folder** — they are the base kit's own precedents and evidence, which travel no more than its casebook does.

**6i — Project manifest, last.** Read `MANIFEST.template.yaml`, replace every double-underscore value, and write it to `.claude/skills/meta-manifest/MANIFEST.yaml`. **This is the write that switches the mechanisms on**, which is why it comes after every record above is the project's own.

| Placeholder | Replace with |
|---|---|
| `__PROJECT_NAME__` | Project name: an existing manifest's `kit_name` wins, then the founding file's title, then the README, then the directory name |
| `__CATEGORY__` | Type-category identified in Step 2, e.g. `blazor-web-app` |
| `__LIBRARY_KIT__` | If a library kit was integrated: `{kit_name: x, version: y, generation: N, integrated_date: today}` — otherwise `null` |
| `__INHERITED_NODES__` | If integrated: the node list from META.yaml with `inherited: true`, `tier: type-category`, `inherited_from: [kit_name] v[version] generation [N]`, and `triggers` renumbered to this project's map — otherwise remove the comment line |
| `__INHERITED_COVERAGE__` | If integrated: coverage entries from META.yaml — otherwise remove the comment line |

Leave no placeholder in the written file.

**6j — Install baseline.** Now that every file is in its installed state, record the per-file hashes an upgrade will compare against:

```
find .claude/skills .claude/agents \( -name '*.md' -o -name '*.yaml' -o -name '*.sh' -o -name '*.expected' -o -name '*.json' \) -print0 | sort -z \
  | while IFS= read -r -d '' f; do printf '%s  %s\n' "$(tr -d '\r' < "$f" | sha1sum | cut -c1-40)" "$f"; done \
  > .claude/skills/meta-manifest/INSTALLED.sha1
```

It covers the deployed agents as well as the skills, `-print0` keeps paths with spaces intact, and the hash is taken over the content with carriage returns removed, so a file re-saved with different line endings still matches (contract-007 rehearsal). Baselines written before 0.15 hashed raw bytes; the upgrade allows for that. Without this baseline, "untouched here" is a guess at the next upgrade, and a guess is how an evolved fork gets flattened.

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
bash $H/reveal-key.sh B-001       # expect: no batch file
tail -3 .claude/skills/meta-ledger/telemetry.log
```

What a correct fresh install shows:
- `session-start.sh` prints **one** backlog line — pioneer-owned items are waiting — because the base map entries arrive `proposed`. It deliberately prints no count. A correction recorded in Steps 1–5 adds a second line, and a deferred statement a third.
- `stop-gate.sh` hands over the batch task (M-16).
- `batch-blind.sh` prints nothing, because no batch is open yet.
- `telemetry.log` ends with a `loaded|meta-map/MAP.md` line from the `post-read.sh` run — an absolute path is required, since the hook matches `*/.claude/skills/*` — followed by an ownership line naming `base-casebook` from the `owner-check.sh` run: the casebook skill was never loaded in this shell, and that is exactly what the check records. No `loaded` line means telemetry is not recording, and the map's only firing evidence is missing. No ownership line means `owns:` did not survive the manifest write in 6i.

If a script errors, or `session-start.sh` mentions contracts, observations or drift entries, the base kit's records are still in place and Step 6 did not complete.

**Then offer the ratification pass:**

> The kit ships 30 map entries — the index that decides which knowledge loads when. They are drafted, not yours yet, and until you ratify them they will keep asking to be reviewed.
>
> I can put all of them to you now, in one pass: each entry's moment, when it fires, what it loads, and what it is not for. Nothing is re-presented here — this is setup, not a test of the gate. Ratify, decline or reword each one.
>
> If you would rather build first, I will mark the map `ratification: deferred`, and the base entries will stop opening review batches until you ask for the pass.

On a pass: present the entries in their map groups, record each as `ratified`, `declined` or reworded, and remove any `ratification: deferred` marker. On a deferral: add the line `ratification: deferred` inside `MAP.md`'s header comment (the hooks look for that phrase anywhere in the file; a second comment is not needed).

Then tell the developer:

> The kit is installed.
>
> - **Always loaded:** INTENT.md, your founding statement, and the map.
> - **Mechanisms:** hooks in `.claude/settings.json` run the kit's lifecycle. Start a new session so they load for certain.
> - **Agents:** the kit agents in `.claude/agents/`.
> - **Records:** manifest, contract log, learning log, drift log, ledger, correction log and casebook seeded; your founding statement recorded verbatim; the install baseline written.
>
> [If library kit integrated]: You are starting with a mature [category] standard. Its nodes, map entries and precedents are your baseline; the inherited map entries are proposed until you ratify them.
>
> Every feature begins with a contract: a bearing read against your statement, a precedent check, then a four-tier proposal ending in the acceptance tests it will be verified by. What the work teaches is held until something other than me has seen it, and reaches you in review batches. You won't need to run anything.
>
> What would you like to build first?

---

## Upgrading an Existing Install

Runs when a project has its own manifest and a newer kit is staged.

**Follow the staged kit's copy of this section.** The installed copy describes the upgrades the installed kit knew about; the staged kit knows what it has added since. Open `.claude/kit-incoming/meta-bootstrap/SKILL.md` → *Upgrading an Existing Install* and follow that text wherever the two differ. A project from before the map and the hooks existed (v0.13 and earlier — no `MAP.md`, no `settings.json`, no baseline) is upgraded by the same steps: what is missing is installed and seeded as on a first install, and every skill is treated as possibly evolved.

**Never copy a new kit over `.claude/skills/`.** The kit folder carries its own instance files and would overwrite this project's manifest, logs, founding statement, ledger and corrections. And a project's kit is often a fork whose skills have evolved; a folder copy flattens those evolutions without anyone seeing it.

**What "the kit" is.** Everything the staged folder carries except the base kit's own instance files: every `meta-*/SKILL.md` and `meta-foundation/INTENT.md`; `agents/` — deployed to `.claude/agents/` *and* kept as the kit's own copy under `.claude/skills/agents/`, which the checks read; `templates/`; `meta-mechanisms/hooks/`; the kit's own checks under `checks/` (`G1-size.sh` and any later `G*.sh`); and of `tests/` only `walk.sh` and `walk.expected`, the lifecycle walk that runs in any project. The base kit's `P-NNN.sh` checks, its `tests/results/`, its contract walks (`walk-004.sh`, `walk-007.sh`) and its `tests/fixtures/` are its own precedents and evidence: they read the base repository's templates, docs and manifest, and travel no more than its casebook does. The line history under `meta-bootstrap/history/` is the kit's, and travels with it. The installed copies under `.claude/skills/installed/` are the kit's own record of what it last shipped: replaced on every upgrade from the staged copies, never asked about, and absent from a project installed before contract-008 — step 3 says what stands in for them. The instance files — manifest, map, founding file, contract log, learning log, drift log, ledger, corrections, casebook, `telemetry.log`, `INSTALLED.sha1` — are this project's and are never replaced. Steps 5b–5e and 6a–6j read from `.claude/skills/` and `.claude/skills/templates/`; on an upgrade, read the staged copies instead. An upgrade that re-deploys the installed agents and hooks has installed nothing and will report success.

**The template rule.** Parts of an instance file were written by a template, not by the pioneer: the header comment block; the base map entries; the base node lines and base coverage lines of the manifest. On an upgrade a header comment block is refreshed from the staged template — it is instruction, never record — **but only for a file whose own installed template is present to compare against** — this is decided file by file, not project by project, because a project may hold a template for one record and none for the others. Where a file has no yardstick, its header is not refreshed and not asked about separately: it travels with that file, and the report says which headers were left alone and why. A comment line found in a header that the installed template never had (someone kept a note there) is carried over beneath the refreshed block, and a header is never refreshed onto a record whose own template the project declined to take. A base map entry or base node line is refreshed when it still reads as the installed template wrote it (`.claude/skills/templates/` is the copy the last install shipped, so the comparison is mechanical — **make it in step 3 and write the result into the step 9 report, because step 5 replaces those templates before step 7 runs**) — a map entry's status column excepted, since ratifying is the pioneer's. Parts the pioneer changed, and every part where no installed template exists to compare against (a project from before the template existed), are asked about **once per file**: the question lists the parts and is answered for the file as a whole — overwrite them, keep them, or port. One file, one question, however many parts. Everything the pioneer or the lifecycle wrote — contracts, observations, corrections, precedents, drift entries, project map entries, project nodes — is touched only by the additive field list in step 7.

An upgrade runs in a live session, so the hooks fire throughout it against a half-migrated project — on a first install the manifest written last keeps them silent, on an upgrade nothing does. That is expected; the rehearsal on a copy is where that state is first seen, and a backlog line or a gate task raised mid-upgrade is noted in the log and acted on afterwards.

The pioneer's own failure condition for an upgrade, recorded on contract-007: *"if it human is required to make many manual decisions or the agent needs to troubleshoot to make it work."* So the upgrade asks the pioneer one thing per file that genuinely differs and nothing else, and it is rehearsed on a copy first — if the rehearsal needs troubleshooting, the procedure is fixed before the real run, never during it.

1. **Stage it.** The pioneer places the new kit in `.claude/kit-incoming/`. Compare its `meta-manifest/MANIFEST.yaml → kit_identity.version` with this project's `kit_identity.base_kit_version`. Equal means nothing to do — say so and stop. **If the project's field is absent** — every manifest before v0.14 — treat the project as pre-0.14 and say so; do not guess a version.
2. **Rehearse on a copy first** (contract-007 G-4, *applies P-004*). Copy the project's `.claude/` (and its `CLAUDE.md`) to a temporary folder beside it, and run steps 3–9 there with the pioneer's answers stubbed: *reapply* for every skill with residue (the answer that can hit a conflict — a conflict in rehearsal is logged as an offer, never resolved), *remove* for the stale list, *legacy* for every existing contract (step 7), *none for now* for the map question (step 8, if it is asked), *defer* for the ratification pass (step 9), and the report accepted at the end (so `.claude/kit-incoming/` is removed). In a rehearsal there is no one to present to: the classification and every offer go into the rehearsal log instead. The log is a file, not a transcript: `rehearsal-<date>.md` in the project's report folder (`docs/reports/` where the project has one, else beside the step 9 report), kept after the copy is discarded, holding the three numbers and every defect the copy caught — the step 9 report links it (contract-008 G-5). The stubs count decisions; they do not show whether a reapplied residue still makes sense against the upgraded skill — so the rehearsal report lists every residue line that could not be reapplied cleanly, and every reapplied line that still names something the staged kit removed or renamed, for the pioneer to weigh at the real run. Keep a log of three numbers: **decisions asked**, **files that genuinely differed**, and **troubleshooting steps** — anything you had to do that these steps do not say. Present the log and the step 9 report, whose lists of what was taken, ported, removed and migrated come from the step 3 classification and the step 7 edits, not from a diff of the tree. **A file "genuinely differed" when it differs from the baseline *and* its content differs from the staged copy** — a file the project changed in a way the kit has since made identical did not differ, and neither did one the kit changed that this project never touched. The rehearsal passes only when every decision asked belongs to a file that genuinely differed or is one of the six standing questions — the stale list (step 3); the **instance-file question** — the template rule's one-per-file question on a *record's* base lines (step 7), which is a different question from any skill's overwrite/keep/port and is never answered by inference from those; the contracts the pioneer may name for verification (step 7); the pre-upgrade drift entries at `mitigated` — batches or `legacy` (step 7); the map question when the budget forces it (step 8); and the ratification pass (step 9) — with the pioneer's acceptance of the report at the end not counted, the third number is zero, **and `checks/G2-migration.sh` exits 0 on the migrated copy** (contract-008 G-2); otherwise fix the procedure here, in this node, and rehearse again. Discard the copy. Only then run steps 3–9 on the project.
3. **Lay of the land.** Read both kits in full (the base kit's own evidence under `tests/results/` excepted), and read this project's own records before touching any of them — the contract log above all, then the drift log, the learning log and the manifest — so the upgrade knows what the project has built, verified and learned, and can tell a record it must not change from a template part it may refresh. The pioneer's rule, 2026-09-13: *"get the lay of the land before walking it"* (C-010). Recompute the baseline with the 6j command into a temporary file in the project root (removed at the end) and compare it with `meta-manifest/INSTALLED.sha1` hash to hash, keyed by path — a baseline from before 0.15 marks each path with a leading `*`, which is dropped; classify every kit file (see *What "the kit" is*). A baseline from before 0.15 hashed raw bytes: for a file whose hash differs from such a baseline, hash it once more with CRLF endings (`tr -d '\r' < file | sed 's/$/\r/' | sha1sum` — strip first, so the command reads the same on every sed), and if that matches, the file is untouched — an install made on Windows re-saves files with the other ending, and that differs by nothing. A kit file the old baseline never listed because its pattern did not cover it (`walk.expected` and `settings.template.json` before 0.15) is untouched, not evolved:
   - **untouched here** (hash matches the baseline) → take the staged version, no question asked
   - **evolved here** (hash differs, or no baseline exists) → **measure the residue before asking anything** (contract-008 G-1). Compare the project's copy against its installed copy under `.claude/skills/installed/`, line by line, with carriage returns and trailing whitespace removed and blank lines ignored: every line of the project's copy that the installed copy also has is the kit's; the lines left over are the **residue** — the project's own. No residue → the file is untouched after all (re-wrapping is not an edit): take the staged version, no question. Residue → the question shows the residue lines in full, quoted, not a diff against the staged copy, which would mix the kit's own changes into what the pioneer is asked to judge — and it has two answers, not three: **reapply** the residue on top of the upgraded skill, or **replace**, taking the upgraded skill and dropping the residue. The upgraded skill is taken either way; there is no keeping the old file. A residue line that cannot be reapplied cleanly — the passage it extended is gone or reworded — is a conflict, and the agent asks how to resolve it rather than resolving it. The baseline the pioneer set (C-013, 2026-09-16): meta skills are the kit's and are not meant to be changed by a project; one that changes them is on its own, and this question is what "on its own" costs — a decision per file, never a silent loss. A project with no installed copy — installed before contract-008 — has a stand-in the staged kit carries with it: `meta-bootstrap/history/<skill>.lines`, every line any committed version of that skill ever had (regenerated by `history/regenerate.sh` before a release); a line of the project's copy found there is the kit's, the rest is residue, and the classification says the comparison was made against history, not an installed copy. Nothing outside `.claude/kit-incoming/` is ever consulted. Where the staged kit carries no history either, the classification says plainly that every file must be treated as possibly evolved, and the questions are one per skill. Then, for a file with residue, **show the pioneer what differs** from the staged copy — and when the differing file is under `templates/`, say plainly what keeping it costs: it becomes the yardstick the *next* upgrade compares against, so every base line that the newer template would have refreshed will instead read as pioneer-changed and be asked about again, every time, for as long as the old template is kept — the sections changed, in a few lines each, or, when most of the file changed, the headings that changed and the plain statement of what the staged copy changes; the baseline holds hashes, so the staged copy is the only text to diff against — and ask one question: *reapply your lines on top of the upgraded skill, or replace?* One question per differing file; none where nothing differs (contract-007 G-3; the two answers, contract-008 C-013). For a file under `templates/`, `reapply` means the project's lines carried into the staged template, which then becomes the yardstick the next upgrade compares against
   - **new in the kit** → add it
   - an agent appears twice in the baseline, once where it is deployed and once in the kit's own copy; the pair is **one file** for classification and asks **one** question
   - **present here, absent from the staged kit** → list it as stale (an agent, a hook, a script or a template the kit no longer ships — `kit-canary-author.md`, `reveal-canaries.sh` and the withdrawn rebuild template from before 0.15, for instance) and remove it only on the pioneer's confirmation, in one question for the whole list. Where a file satisfies both this rule and "untouched", stale wins: being absent from the old baseline is not evidence that the base kit's own evidence belongs here. The base kit's own evidence that an earlier install carried — `tests/results/`, any `P-NNN.sh` check in `checks/` whose precedent id is not in this project's casebook, the base kit's contract walks and `tests/fixtures/` — goes on the same list when it is present. Beside each stale file, name any reapplied residue that still refers to it, so the pioneer sees what *reapply* leaves pointing at nothing. A skill whose reapplied residue names, in its `> **Map:**` header, an entry the staged template withdrew has that id removed in step 7, because the header is the map's (meta-map: header and entry are co-owned); this is reported, not asked

   Present the classification before changing anything. With no baseline and no installed copy, say which stand-in the residue was measured against — the base kit's history, or nothing; only in the last case must every file be treated as possibly evolved, with the questions one per skill.
4. **New folders arrive without their records.** A new node's `SKILL.md` is copied; its instance file is **not**. Seed those from the *staged* templates in step 6 below. The staged kit's own ledger, corrections, casebook, map and logs are never copied into the project.
5. **Install** from the staged copies every kit file classified *untouched* or *new* in step 3 — skills and `INTENT.md`, `templates/` (whose old copies step 7 needs as its yardstick, so step 3's comparison must already be recorded), the hooks, the kit's checks, `walk.sh` and `walk.expected`, the kit's own agent copy under `.claude/skills/agents/`, and the installed copies under `.claude/skills/installed/` — refreshed from the staged copies for every meta skill and `INTENT.md`, whatever the pioneer answered for the file itself, so the next upgrade measures residue from what this one shipped — then the agents to `.claude/agents/` (porting any that the baseline shows were evolved here), and the settings merge, done by hand with the file tools (no jq ships with the kit): under each event, keep every group without a `"_kit"` key, drop every group that carries it, append the staged template's group for that event, and keep every existing `permissions.deny` entry — so the kit's groups are **replaced**, never appended a second time, and groups whose scripts no longer exist go with them. Replace the CLAUDE.md block between its `kit-block` markers. When the old block has no markers, it is the contiguous text from the kit's heading to the first horizontal rule or first heading that is not the kit's; replace that span, add the markers, and quote the replaced span in the report. Recreate the 5d–5e entries and folders where a copy lost them. Remove the stale files confirmed in step 3.
6. **Seed missing instance files** (6a–6h, including 6e when the project has no `FOUNDING.md` — pre-v0.13 projects don't, and the CLAUDE.md block imports it). Create `.claude/skills/meta-mechanisms/checks/` if absent. Existing instance files are never replaced.
7. **Migrate existing instance schemas additively** — add what is missing, remove only the retired keys this list names, never change a value that is present; new values are written as plain scalars. Field order carries no meaning: put a new field where it reads naturally in the entry, and do not hunt for an anchor the old entries may not have. Use whatever tooling is reliable for the size of the job — a long migration by hand is its own risk — and **verify by diffing the migrated file against a copy taken before the migration, confirming that every pre-existing line is still there unchanged, except the lines this step itself names for removal or refresh**. The verification is the requirement; the method is yours:
   - `CONTRACT-LOG.yaml` — every existing entry gains `verification_state: legacy` and `audited: legacy` if absent (ask once, as a standing question, whether any recent implemented contract should be verified and audited instead; set `none` and `false` on those — and skip the question entirely when every existing entry already carries these fields, since then both answers write the same file), and `disappointment: legacy`, `premortem: legacy`, `red_test: legacy`, `cost: legacy` if absent (contract-006 fields). An older `approval: gate` stays as it is; the template lists it as the pre-0.15 value.
   - `CORRECTIONS.yaml` — every existing entry gains `noticed`, `would_have_been_right` and `seen_before`, each `not asked`, if absent.
   - `LEDGER.yaml` — every batch gains `represented: []` if absent; under `scores`, `canary_catch_rate`, `brier_stated_confidence` and `brier_pioneer_decisions` are removed if present and `coincidence: []` added if absent; a candidate's `lower_bound` is removed if present.
   - `DRIFTLOG.yaml` — every entry gains `status: unknown` if absent, because the hooks count drift entries by that key and an entry without one is invisible to the backlog; existing elevations written as maps gain `mitigation_medium: unknown` if absent, whether the entry's key is `elevation` or `elevations`; an elevation written as a prose string is left as it is. Entries already at `status: mitigated` from before the upgrade are pioneer-owned resolutions the moment the hooks run — the batch assembler offers two per batch until they are decided — so ask once, as a standing question, whether they are reviewed that way or marked `status: legacy`, which no hook counts and no batch presents; skip the question when there are none (contract-008 G-4).
   - `MANIFEST.yaml` — every node gains `kind` and `load` if absent; project nodes gain `triggers` from the entries step 8 drafts for them (so step 8 runs before this line) and `owns:` naming the node's own skill and data files; every base node gains `triggers` and, when not an agent, `owns:` from the staged template's node of the same id — a base node the project registered under another id is matched by its `skill_file` and takes the template's id, and every `dependencies` list naming the old id is updated; a skill registered under two ids keeps the id whose line names it as `skill_file` first, and the duplicate line stays as it is and is listed in the report; an id with the `base-` prefix whose `skill_file` the staged kit does not carry is a project node; a project node whose entry waits in `proposed-entries.md` gets `triggers: []` and the sentence `entry pending the map question` in its `note:`, appended to whatever that field already says, or as a new `note:` where it has none; a value outside a template's enumeration (a `type`, an `aspect`, a `status` the hooks do not read) is left as it is and listed in the report; `library_kit: null` is added to `kit_identity` if absent; `kit_type` is left as the project declared it; base nodes renamed in the kit (`agent-canary-author` → `agent-batch-assembler`) take the staged template's whole node line and coverage line; new base nodes are registered — every node the staged template's `nodes:` carries, the agent nodes included; base node lines and base coverage lines follow the template rule, and the template rule's question on them is **asked as its own question** — the instance-file question of step 2's list — never answered by inference from what the pioneer said about the skills (contract-008 G-6); `base_kit_version` is set to the staged version.
   - `MAP.md` — every base entry follows the template rule: an entry that still reads as the installed template wrote it takes the staged template's columns and keeps its own status; a base entry the staged template withdrew is removed unless the pioneer reworded it; a reworded entry is asked about. An entry that names a file step 5 removes and was not refreshed here is an error in this list, not a judgement call.
   - The header comment block of every instance file above follows the template rule. Line endings carry no meaning to the kit: kit files arrive with LF endings, an instance file, a kept skill or `settings.json` may come out of an edit with LF endings where it had CRLF, and nothing restores them — a mixed tree is expected and harmless, and no step checks or repairs endings.
   - The `> **Map:**` header of a skill whose residue was reapplied loses any id the staged template withdrew from the map; the rest of the line is the reapplied residue's and stays, and the report lists it where it still names something withdrawn.
8. **Map the project's nodes.** For each existing non-base node, draft an entry under "Project entries" from its description, as `proposed`, and add the matching `> **Map:**` header. Then run `checks/G1-size.sh`. If the map is over its budget, the drafted entries do not go into the map: write them to `.claude/skills/meta-map/proposed-entries.md` (not loaded), draft into the map one entry per **root** — the nodes `checks/roots.sh MANIFEST.yaml` prints: a project node whose manifest id (joined through `skill_file`, since `dependencies` name ids, never folders) appears in no other node's `dependencies`, a skill registered under two ids counted once; the script's output is the list and the count, and `proposed-entries.md` states that count and nothing else (contract-008 G-3) — run the check again, and put the rest to the pioneer as one question — which of these belong in the always-loaded map, and which are reached through the nodes that already name them. If the roots alone still fail the check, the map keeps only its base entries and every drafted entry waits in `proposed-entries.md` for that one question. A `> **Map:**` header is added only to a skill whose entry is in the map. The map is never written past the check. The pioneer ratifies the entries in the first review batch, or in the ratification pass step 9 offers.
9. **Offer the ratification pass** exactly as Step 7 of the install does, and on a deferral add the line `ratification: deferred` inside the map's header comment, so the first session after the upgrade does not open a batch on every drafted entry. Then **regenerate the baseline** (6j) — after the marker, so the baseline records the map as it is — **run every check** under `meta-mechanisms/checks/` — `G2-migration.sh <project .claude/skills> <staged MANIFEST.template.yaml>` among them, which walks each migrated record's structure, counts the migrated fields per entry, and checks every node of the staged template is registered; it exits non-zero naming the file and the figure, and a non-zero exit is a defect to fix before the report, never a note in it — and the install's Step 7 hook commands — on an upgrade the expectation is only that each hook prints valid JSON or nothing, that `close-batch.sh` and `reveal-key.sh` report *no batch file* (exit code 1 — that is the expected result), and that `telemetry.log` gains its `loaded` line; the backlog and the gate's task reflect the project's live records, not a fresh install, and the staged-kit line prints until the folder is removed at the end. The hook commands append real lines to `telemetry.log` (a `loaded` line and a `bypass` line among them); delete those lines afterwards, since they are the check's, not the session's, and delete the file itself if the checks are what created it — and **report**: present the upgrade as an analysis report — what was taken, ported, asked, removed and migrated, with the rehearsal's three numbers beside the real run's, a link to the rehearsal log, and a section naming what the upgrade did **not** check, so that silence is never read as a clean result (contract-008, the pre-mortem). When the pioneer accepts the report, remove `.claude/kit-incoming/`.

---

## What This Skill Does Not Do

- It does not audit the existing codebase for problems or improvements — that comes later, through use
- It does not negotiate its steps with existing tools, plugins or hooks — conflicts are named and surfaced, not resolved by compromise
- It does not change anything in the project before Step 5, and never before the orientation in Step 2 has been confirmed
- It does not run more than once per install, and once per upgrade
- It does not draft, suggest, or shape the founding statement — it asks for it and records it verbatim
- It does not overwrite instance data or folder-copy a kit over an evolved one
- It does not create a type-category manifest — that is meta-extract's artifact, when the instruments say the standard is ready
