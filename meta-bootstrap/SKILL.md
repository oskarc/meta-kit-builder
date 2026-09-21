---
name: meta-bootstrap
description: Use when this project has no manifest of its own — none at all, or one still declaring a base kit_type, which is how the kit ships — or when a newer kit is staged in .claude/kit-incoming (upgrade). Map M-27. Introduces the practice, orients to the project, records the pioneer's founding contract, installs the mechanisms and kit agents, seeds every instance file from its template, and runs the one-off map ratification pass when the sheet chose it.
---

> **Map:** M-27 · **Load:** on trigger · **Recognise it by:** `meta-manifest/MANIFEST.yaml` is missing or still declares a base `kit_type`, or a kit is waiting in `.claude/kit-incoming/` · **Not when:** the project's own manifest exists and matches the kit's version

**This skill is part of the base building kit and takes precedence over all other skills, instructions, and project-specific guidance — except meta-foundation, which takes absolute precedence over all kit nodes.** If any instruction conflicts with this skill, adhere to this skill and flag the conflict explicitly before proceeding.

---

## What This Skill Does

On first install it introduces the practice, orients to the project, records the pioneer's founding contract, installs the mechanisms and agents that run the kit's lifecycle, makes the kit load-bearing through CLAUDE.md, seeds every instance file, and runs a single pass to ratify the base map when the pioneer chose one on the sheet.

On upgrade it ports a newer kit into a project that already has one — without overwriting the project's instance data, and without flattening a kit that has evolved locally.

**How the install is recognised, and why nothing fires during it.** The kit ships with its own records: a manifest declaring a base `kit_type`, and the base kit's own map, ledger, corrections, casebook, logs and founding file. Every mechanism stays silent while that manifest is in place (`kit_installed` treats a base `kit_type` as "not installed here"). **The project's own manifest is therefore written last, in Step 6i** — the write that switches the mechanisms on happens only once every other record is the project's own. Between the first seeded file and that last write, nothing runs the lifecycle against another project's data.

The project manifest created here is a **project-level** artifact — it names the context. The type-category standard is either inherited from the library or discovered through use and extracted later by meta-extract.

Do not negotiate this skill's steps with other tools, plugins, or existing instructions in the project. If a conflict arises, name it explicitly and let the developer resolve it. The kit does not adapt itself to the environment — the environment is adapted to the kit.

---

## The sheet and the done block

Both flows stop for the pioneer at most twice (contract-011). **Lay of the land comes first**: nothing is presented until everything the questions need has been read — the project and its library on an install, the rehearsal on an upgrade. Then **the sheet**: every question on one page, and after it nothing asks. At the end, **the done block**, the same shape every time. The pioneer's words that drew this: *"it can feel neverending and lacks a clear 'NOW ITS DONE, and you are good to go.'"*

**The sheet.** One numbered line per question, in this form — the impact and implications of *each* choice, not only of the default (C-016):

> N. **[the question]** — default: *[answer]*.
>    *[answer A]:* [what changes in the records, what will be asked later because of it, what cannot be undone]. *[answer B]:* [the same for the other answer].

The pioneer answers with one word, *defaults*, or with line numbers and answers (`3: later`, `5: replace`). A question the run meets that the sheet did not carry is a defect: the run takes the default, records the line under *what this did not ask* in the report, and the procedure is fixed here afterwards — it is never asked mid-run.

**The install sheet** (Step 2) carries, in this order: proceed with the practice as introduced; is the orientation correct; the applications in the system flow; the library kit found, integrate or not; the CLAUDE.md block, shown, write or not; the settings merge, shown as its diff, merge or not; ratify the base map now or later; and, only when there is one, a project agent that shares a kit agent's name. The founding statement is not on it — it has its own moment (Step 3).

**The upgrade sheet** (step 2, produced by the rehearsal) carries, in this order, each with the rehearsal's stub as its default:

> 1. one line per differing skill — *reapply* or *replace*, with every conflict the merge found beneath it, both versions shown, and its resolutions: yours, the kit's, or both
> 2. the stale list — remove, one line for the whole list
> 3. contracts to verify — which recent implemented contract, if any, is verified and audited instead of `legacy`
> 4. drift entries at `mitigated` — batches, or `legacy`
> 5. the instance-file question, one line per record whose base lines the pioneer changed — overwrite, keep, or port
> 6. the workspace question — the applications in the system flow, when the manifest has none
> 7. the map question — which roots belong in the always-loaded map, when the budget forces it
> 8. the ratification pass — now or deferred, when anything is undecided
> 9. the acceptance — remove the staged kit when the report is written

Lines whose condition does not hold are left off, and the lines that remain are numbered 1, 2, 3 … as they stand, so an answer like `3: later` can only mean one thing; beneath the sheet, one sentence per question left off says which it was and why. A line the rehearsal did not reach says so. The seven standing questions of step 2's pass rule are lines 2 to 8. Which copy is the project's — the working tree or the last commit — is no longer asked: the run starts from a clean commit (contract-017).

**The done block.** Written at the end of Step 7 (install) and step 9 (upgrade), then `bash .claude/skills/meta-mechanisms/hooks/mark-done.sh install` (or `upgrade`) is run. The hold on the first review batch does not rest on that script: both flows end by writing the baseline (6j), and the stop-gate holds the batch for as long as that baseline is newer than the last session start (contract-015). No question follows the block.

> **Done — installed.** *(or: **Done — upgraded to [version].**)*
> **Verified:** [checks passed, of how many] · [hooks that fired, of how many] · baseline written, [n] files.
> **Nothing is waiting on you now.** *(or:)* **Waiting on you, when you want it:** the map's [n] entries — say *ratify the map* · [n] drift entries, two per batch — say *open a batch* · [contracts named for verification].
> **Not checked:** [what this run did not verify, one line each — or: nothing left unchecked].
> **One change to commit.** Everything this run changed is uncommitted, and nothing else is: commit it as one change, and push it.
> **Next session** the kit greets you with a backlog line. It is a list, not a task; the first review batch waits for that session.
> Start working.

---

## Step 1 — Introduce the Practice

Before changing anything in the project — reading it comes first (Step 2) — present the following to the developer. This is not a setup guide. It is the agent introducing what it is participating in and what it will ask of the developer.

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

Do not wait here. Read the project (Step 2) and present the introduction and the sheet together, so the pioneer answers once; the sheet's first line is where a pioneer who does not want the practice says so (contract-011).

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

Also read `.claude/library/[category]/META.yaml` for the category identified, so the sheet can name the kit found there (Step 4 integrates it; nothing is copied yet).

**Check the ground** (contract-017): run `bash .claude/skills/meta-mechanisms/checks/preflight.sh check install`. It changes nothing. It refuses, each time with its reason, when git is missing, when the kit folder is not a whole release, or when the pioneer has uncommitted work. Put its sentences to the pioneer word for word, above the sheet — the one about uncommitted work asks them to commit and push first and says why: the install uses git for its snapshot and its way back. Nothing is installed until it passes.

Then present the introduction (Step 1), the orientation and the install sheet together, in one turn:

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
> **Applications in the system flow**: [the other repositories this system is made of, each with its path relative to this one and its role in one line — or: none named. What you confirm here the agent writes into the manifest (6i, `workspace`), the settings grant (5c) and the kit block (5a); you edit no settings file (contract-010)]
>
> **What I am treating as unknown**: [scope or concerns I have not yet read or cannot determine from the files]
>
> **The sheet** — answer *defaults*, or line numbers with answers:
>
> 1. **Proceed with the practice as introduced?** — default: *yes*.
>    *yes:* the kit is installed as the lines below say. *no:* nothing is written; the project is left as read.
> 2. **Is this orientation correct?** — default: *yes*.
>    *yes:* the manifest's category, the applications and the library choice are written from it. *a correction:* recorded as the project's first correction (6h) and the reading redone before anything is written.
> 3. **Applications in the system flow** — default: *none named*.
>    *none:* no grant; the agent works in this repository only. *named:* each path is granted in settings (5c), recorded in the manifest (6i) and the kit block (5a); the agent edits there without prompts; their own kits, if any, never run in this session.
> 4. **Library kit** — [name, version, generation and what it covers, or: none found] — default: *integrate* when one was found.
>    *integrate:* its nodes, map entries and precedents seed this project (5f, 6f, 6h) and its bindings are listed for re-binding. *skip:* the standard starts empty and is discovered through use; a kit can be integrated later only by hand.
> 5. **CLAUDE.md block** — [the block of 5a, shown here] at the top of `CLAUDE.md` — default: *write*.
>    *write:* three files load in every session and the kit takes precedence over other instructions. *do not:* the kit is installed but not load-bearing; nothing fires.
> 6. **Settings** — [the diff of 5c, shown here] — default: *merge*.
>    *merge:* the kit's hooks run from the next session; existing hooks and permissions are kept. *do not:* no mechanism runs; the kit is prose only.
> 7. **Ratify the 30 base map entries** — default: *later*.
>    *later:* the map is marked deferred and no batch opens for them until you say *ratify the map*. *now:* one pass of 30 entries in Step 7, each ratified, declined or reworded, before anything else.
> 8. **A project agent shares a name with a kit agent** — [the names; leave this line off when there are none] — default: *rename yours*.
>    *rename yours:* your agent file becomes `<name>-project.md` and keeps working under that name; the kit's agent installs and the lifecycle step it serves runs. *keep yours:* the kit's agent of that name is not installed, and the lifecycle step it serves does not run until you free the name.

Wait for the answers — the one wait before the statement. A correction on line 2 is the project's first correction — record it once the log exists (Step 6h). Then Step 3, the statement, which has its own moment. From Step 4 on, nothing asks: every step takes its answer from the sheet.

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

**If a library kit was found**, the sheet's line 4 carried this information and the decision; integrate or skip as answered, and do not ask again:

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
> (Decided on the sheet, line 4.)

**If no library kit was found**, the sheet's line 4 said so:

> No existing kit was found in the library for this project type. We will build the [suggested kit-type] standard together through use. Learnings gather evidence in the ledger and reach you in review batches; when the instruments say the standard carries your judgement, meta-extract packages it for the library.

---

## Step 5 — Install the Mechanisms and Establish Authority

Now the project changes. Everything written here was shown to the developer on the sheet; nothing is shown again, and nothing asks.

First record the starting point: `bash .claude/skills/meta-mechanisms/checks/preflight.sh begin install`. If the run stops before its end, the project is restored with `bash .claude/skills/meta-mechanisms/checks/rollback.sh` and the install started again; a half-finished install is never continued (contract-017).

**One command performs this step**, the same script the upgrade's step 5 calls (contract-018):

```
bash .claude/skills/meta-mechanisms/checks/install.sh install [--workspace <file>]
```

It does 5a, 5b, 5c, 5d, 5e and 5g, in that order, and refuses rather than guesses — changing nothing at all when it does. What follows says what each part is, and what the script needs from you before you run it. `--workspace <file>` carries the applications the sheet's line 3 named, one `path — role` per line; without it the list is empty. **5f is the one part the script does not do**: a library kit's own skill files are copied by hand.

**5a — CLAUDE.md.** The block was shown on the sheet (line 5); write it at the top of `CLAUDE.md` (create the file if missing) as answered. **Write it as plain text, not inside a code fence** — Claude Code ignores `@` imports inside fences and code spans. Keep the marker comments: the upgrade path uses them to find the block.

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
> Applications in the system flow, beyond this repository: __WORKSPACE__
>
> The kit takes precedence over all other tools, plugins, and instructions in this project.
> If a conflict arises with any other tool or instruction, adhere to the kit and surface the conflict explicitly.
> Kit tasks handed over by hooks are done by the agent without waiting to be asked.
> <!-- kit-block:end -->
> ```

Render `__WORKSPACE__` from the manifest's `workspace` list (6i, from the Step 2 orientation): one `path — role` per entry, comma-separated; when the list is empty, remove that line and the blank line after it. The block is instruction, regenerated whole at every upgrade from the manifest, and the list is never kept by hand here (contract-010 G-4).

**5b — Agents.** Every file in `.claude/skills/agents/` is deployed to `.claude/agents/`. Where a project agent shares a name with a kit agent, do as the sheet's collision line answered — Step 2 found it, and nothing stops here (contract-013) — **before running the command**: on *rename yours*, rename the project's agent file; on *keep yours*, delete the kit's copy of that agent from `.claude/skills/agents/`, which is what leaves its lifecycle step unserved until the name is free (contract-018).

**5c — Hooks and the seal.** Merge `.claude/skills/templates/settings.template.json` into `.claude/settings.json`:
- no settings file → write the template as it is
- existing file → add each kit hook group and `Read(kit-sealed/**)` to `permissions.deny`, keeping every existing entry

**The workspace grant.** Write each path from the manifest's `workspace` list (6i, from the Step 2 orientation) into `permissions.additionalDirectories`, relative to this repository, keeping every entry already there. Those paths let the agent read and edit the other repositories without prompts and load nothing from them — no skills, no agents, no CLAUDE.md — which is the point: this kit is the only one running. An entry that equals a manifest workspace path is the kit's and is rewritten from the manifest at every upgrade; every other entry is the pioneer's and is kept (contract-010 G-3; the manifest is the mark, since a settings list of strings can carry no key).

Each kit hook group in the template already carries `"_kit": "base-building-kit"`; keep that key, because it is how an upgrade replaces the kit's groups instead of appending a second copy. The diff was on the sheet (line 6); write it as answered. The hooks are bash scripts; on Windows they run under Git Bash, which Claude Code already requires.

**5d — Ignore the seal, keep the endings.** Add `.claude/kit-sealed/` and `.claude/skills/meta-ledger/.session-started` (an empty mark the session-start hook leaves; only its age is read) to `.gitignore`, and `*.sh text eol=lf` to `.gitattributes` (create it if missing). CRLF line endings break the hooks under bash.

**5e — Folders.** Create `.claude/skills/meta-ledger/batches/` and `.claude/skills/meta-casebook/reconstruction/`, each with an empty `.gitkeep` in it — git does not record an empty folder, and a clone would lose them — — the batch files and the reconstruction inputs are the only writable paths two of the agents have.

**5f — Library kit, if one was confirmed in Step 4.** Copy its skill files into `.claude/skills/`, preserving the folder structure. Its map entries and precedents are merged in Step 6.

**5g — Installed copies.** Copy every `meta-*/SKILL.md` and `meta-foundation/INTENT.md`, exactly as installed, to `.claude/skills/installed/` under the same relative path (`installed/meta-map/SKILL.md`, `installed/meta-foundation/INTENT.md`). This is the yardstick the next upgrade measures the project's own edits against — the same copy the kit already keeps of its agents under `skills/agents/` and of its record templates under `skills/templates/`. It is never loaded, never edited, and never asked about: an upgrade replaces it (contract-008 G-1).

---

## Step 6 — Seed the Instance Files

**A release of the kit carries none of the base kit's records; a raw copy of its repository carries all of them** — its manifest, logs, map, ledger, corrections, casebook and founding file. Either way every record is seeded here, and where the base kit's copy is present it is replaced. A project never keeps another project's instance data.

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

**6h — Casebook.** Copy `CASEBOOK.template.yaml` to `.claude/skills/meta-casebook/CASEBOOK.yaml`. If a library kit was integrated, append its type-category precedents from the library's `CASEBOOK.yaml`, and list every `{binding}` they contain for the pioneer to re-bind. Create `.claude/skills/meta-mechanisms/checks/` if the copy lacks it; it is where the case clerk writes checks as the pioneer's corrections turn into standards that can be tested. The kit's own checks and tools stay (every `G*.sh`, `roots.sh`, `residue.sh` and `retired-phrases.txt`); **delete the base kit's `P-NNN.sh` checks and its `meta-mechanisms/tests/results/` folder** — they are the base kit's own precedents and evidence, which travel no more than its casebook does.

**6i — Project manifest, last.** Read `MANIFEST.template.yaml`, replace every double-underscore value, and write it to `.claude/skills/meta-manifest/MANIFEST.yaml`. **This is the write that switches the mechanisms on**, which is why it comes after every record above is the project's own.

| Placeholder | Replace with |
|---|---|
| `__PROJECT_NAME__` | Project name: an existing manifest's `kit_name` wins, then the founding file's title, then the README, then the directory name |
| `__CATEGORY__` | Type-category identified in Step 2, e.g. `blazor-web-app` |
| `__LIBRARY_KIT__` | If a library kit was integrated: `{kit_name: x, version: y, generation: N, integrated_date: today}` — otherwise `null` |
| `__INHERITED_NODES__` | If integrated: the node list from META.yaml with `inherited: true`, `tier: type-category`, `inherited_from: [kit_name] v[version] generation [N]`, and `triggers` renumbered to this project's map — otherwise remove the comment line |
| `__INHERITED_COVERAGE__` | If integrated: coverage entries from META.yaml — otherwise remove the comment line |
| `workspace: []` | The applications confirmed in Step 2, one entry per application: `{name: x, path: ../x, role: one line}`, path relative to this repository — or left `[]` when none were named (contract-010) |

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

## Step 7 — Check the Mechanisms, Then the Ratification Pass as the Sheet Answered

Run every hook once, from the project's root:

```
bash .claude/skills/meta-mechanisms/checks/hooks-selftest.sh
```

It runs the eleven hook commands against a throwaway copy of this project's `.claude/`, so the test writes nothing into the project's own records — no telemetry line, no session mark (contract-017). It prints each hook's exit code and whether it printed JSON, text or nothing, what `session-start.sh` and `stop-gate.sh` said, the telemetry the copy gathered, and a verdict; it exits non-zero when a hook did not behave.

What a correct fresh install shows:
- `session-start.sh` prints **one** backlog line — pioneer-owned items are waiting — because the base map entries arrive `proposed`. It deliberately prints no count. A correction recorded in Steps 1–5 adds a second line, and a deferred statement a third.
- `stop-gate.sh` hands over the batch task (M-16).
- `batch-blind.sh` prints nothing, because no batch is open yet.
- the copy's telemetry ends with a `loaded|meta-map/MAP.md` line from the `post-read.sh` run, followed by an ownership line naming `base-casebook` from the `owner-check.sh` run: the casebook skill was never loaded in this shell, and that is exactly what the check records. No `loaded` line means telemetry is not recording, and the map's only firing evidence is missing. No ownership line means `owns:` did not survive the manifest write in 6i.

If a script errors, or `session-start.sh` mentions contracts, observations or drift entries, the base kit's records are still in place and Step 6 did not complete.

**The ratification pass was decided on the sheet (line 7).** The offer's terms, for the record: the kit ships 30 map entries, drafted, not the pioneer's yet; a pass puts each entry's moment, when it fires, what it loads and what it is not for, and nothing is re-presented in it; a deferral marks the map `ratification: deferred` and the base entries stop opening review batches until the pioneer asks for the pass.

On a pass: present the entries in their map groups, record each as `ratified`, `declined` or reworded, and remove any `ratification: deferred` marker. On a deferral: add the line `ratification: deferred` inside `MAP.md`'s header comment (the hooks look for that phrase anywhere in the file; a second comment is not needed).

Then end with the done block (see *The sheet and the done block*) — installed, what was verified, what waits and how to summon it, what was not checked, start working — run `bash .claude/skills/meta-mechanisms/hooks/mark-done.sh install`, and remove the lock with `bash .claude/skills/meta-mechanisms/checks/preflight.sh end`. The block is the end: no question follows it (contract-011 G-4). What it summarises: always loaded are INTENT.md, the founding statement and the map; the hooks in `.claude/settings.json` run the lifecycle from the next session; the kit agents sit in `.claude/agents/`; every record is seeded and the baseline written; a library kit, if integrated, is the starting standard with its entries proposed until ratified. Every feature begins with a contract, and what the work teaches reaches the pioneer in review batches.

---

## Upgrading an Existing Install

Runs when a project has its own manifest and a newer kit is staged.

**Follow the staged kit's copy of this section.** The installed copy describes the upgrades the installed kit knew about; the staged kit knows what it has added since. Open `.claude/kit-incoming/meta-bootstrap/SKILL.md` → *Upgrading an Existing Install* and follow that text wherever the two differ. A project from before the map and the hooks existed (v0.13 and earlier — no `MAP.md`, no `settings.json`, no baseline) is upgraded by the same steps: what is missing is installed and seeded as on a first install, and every skill is treated as possibly evolved.

**Never copy a new kit over `.claude/skills/`.** The kit folder carries its own instance files and would overwrite this project's manifest, logs, founding statement, ledger and corrections. And a project's kit is often a fork whose skills have evolved; a folder copy flattens those evolutions without anyone seeing it.

**What "the kit" is.** Everything the staged folder carries except the base kit's own instance files:
- every `meta-*/SKILL.md` and `meta-foundation/INTENT.md`;
- `agents/` — deployed to `.claude/agents/` *and* kept as the kit's own copy under `.claude/skills/agents/`, which the checks read;
- `templates/`; `meta-mechanisms/hooks/`;
- the kit's own checks and tools under `checks/` — everything the release carries there: every `G*.sh`, `roots.sh`, `residue.sh` and `retired-phrases.txt`, and `preflight.sh`, `rollback.sh`, `merge.sh` and `hooks-selftest.sh`;
- and of `tests/` only `walk.sh` and `walk.expected`, the lifecycle walk that runs in any project.

The base kit's `P-NNN.sh` checks, its `tests/results/`, its contract walks (`walk-004.sh`, `walk-007.sh`) and its `tests/fixtures/` are its own precedents and evidence: they read the base repository's templates, docs and manifest, and travel no more than its casebook does.

**A file named `*.project.*` inside the kit's folders is the project's own** — what a project adds beside a kit file goes in a file of that name, as its refusals go in `checks/refusal-nextsteps.project.txt` beside the kit's registry — so no release carries one, and no upgrade takes, merges or removes one (contract-023).

The line history under `meta-bootstrap/history/` is the kit's, and travels with it.

The staged folder is that travel set and nothing more: a raw clone of the kit repository is not a staged kit — its evidence under `tests/results/`, its fixtures, its contract walks, its `P-NNN.sh` checks and its own instance files are left out when the kit is staged into `.claude/kit-incoming/` (contract-009 G-1).

**The travel set is built, not assembled by hand** (contract-017): in the kit's repository, `bash meta-bootstrap/release.sh <folder>` exports the shipping files from a commit, leaves out what `meta-bootstrap/not-shipped.txt` lists, and writes two files beside them — `RELEASE` (the kit, its version, the commit it was built from) and `RELEASE.sha1` (every file with its hash). That folder, unchanged, is what goes into `.claude/kit-incoming/`. The version is read from `RELEASE`; the base kit's manifest is a record and does not travel.

The installed copies under `.claude/skills/installed/` are the kit's own record of what it last shipped: replaced on every upgrade from the staged copies, never asked about, and absent from a project installed before contract-008 — step 3 says what stands in for them.

The instance files — manifest, map, founding file, contract log, learning log, drift log, ledger, corrections, casebook, `telemetry.log`, `INSTALLED.sha1` — are this project's and are never replaced.

Steps 5b–5e and 6a–6j read from `.claude/skills/` and `.claude/skills/templates/`; on an upgrade, read the staged copies instead. An upgrade that re-deploys the installed agents and hooks has installed nothing and will report success.

**The template rule.** Parts of an instance file were written by a template, not by the pioneer: the header comment block; the base map entries; the base node lines and base coverage lines of the manifest.

On an upgrade a header comment block is refreshed from the staged template — it is instruction, never record — **but only for a file whose own installed template is present to compare against** — this is decided file by file, not project by project, because a project may hold a template for one record and none for the others.

Where a file has no yardstick, its header is not refreshed and not asked about separately: it travels with that file, and the report says which headers were left alone and why.

A comment line found in a header that the installed template never had (someone kept a note there) is carried over beneath the refreshed block, and a header is never refreshed onto a record whose own template the project declined to take.

`checks/merge.sh --header <record> <installed template> <staged template> <out>` applies this rule and says how many of the pioneer's lines it kept. It exits 3, writing nothing, when the record's header shares no line with the installed template's: the pioneer replaced it wholesale, which is the instance-file question below (contract-017).

A base map entry or base node line is refreshed when it still reads as the installed template wrote it (`.claude/skills/templates/` is the copy the last install shipped, so the comparison is mechanical — and those templates, like the installed copies, are **replaced last, in step 9, after every comparison that needs them**: contract-017) — a map entry's status column excepted, since ratifying is the pioneer's.

Parts the pioneer changed, and every part where no installed template exists to compare against (a project from before the template existed), are asked about **once per file**, on the sheet: the question lists the parts and is answered for the file as a whole — overwrite them, keep them, or port. One file, one question, however many parts.

Everything the pioneer or the lifecycle wrote — contracts, observations, corrections, precedents, drift entries, project map entries, project nodes — is touched only by the additive field list in step 7.

An upgrade runs in a live session, so the hooks fire throughout it against a half-migrated project — on a first install the manifest written last keeps them silent, on an upgrade nothing does. That is expected; the rehearsal on a copy is where that state is first seen, and a backlog line or a gate task raised mid-upgrade is noted in the log and acted on afterwards.

**The way back** (contract-017). The real run starts from a recorded point and can always return to it. `checks/preflight.sh begin` records the project's last commit — or, outside a repository, keeps a copy at `.claude.before-upgrade/` — in `.claude/kit-upgrade.lock`. If the run stops before its end, for any reason, `bash .claude/kit-incoming/meta-mechanisms/checks/rollback.sh` restores `.claude/`, `CLAUDE.md`, `.gitignore` and `.gitattributes` exactly, leaves the staged kit in place, and the run is started again from step 1. **A half-finished upgrade is never continued**: its installed copies are already the new kit's, so a second pass would measure the kit's old lines as the pioneer's. The session-start hook reports a lock left behind.

The pioneer's own failure condition for an upgrade, recorded on contract-007: *"if it human is required to make many manual decisions or the agent needs to troubleshoot to make it work."* So the upgrade asks the pioneer one thing per file that genuinely differs and nothing else, and it is rehearsed on a copy first — if the rehearsal needs troubleshooting, the procedure is fixed before the real run, never during it.

1. **Stage it, and check the ground.** The new kit goes into `.claude/kit-incoming/` — a release built with `release.sh` (see *What "the kit" is*), not a raw clone. The pioneer places it, or the agent builds and places it when the kit's repository is within reach.

   Where the clone that feeds it fails on path length (Windows' limit: a project under `Program Files` with the clone under a deep temporary folder), clone the kit to a short path first and stage from there; that is this step, not troubleshooting (contract-009 G-1).

   Then run `bash .claude/kit-incoming/meta-mechanisms/checks/preflight.sh check` from the project's root. It changes nothing, and it refuses — every refusal with its reason — when git is missing, when the staged kit is not a whole release, when a review batch is open, when an earlier run left its lock, and when the pioneer has uncommitted work.

   Put its sentences to the pioneer word for word and stop until it passes. The one about uncommitted work asks them to commit and push first, and says why: the upgrade uses git — their last commit is its snapshot and its way back, and git merges their own lines into the new kit (C-023). That replaces the tree-or-commit question of contract-009: there is one copy of the project's kit, the committed one.

   It exits 3 when the staged version is the installed one: nothing to do — say so and stop. **If the project's `base_kit_version` is absent** — every manifest before v0.14 — treat the project as pre-0.14 and say so; do not guess a version.
2. **Rehearse on a copy first** (contract-007 G-4, *applies P-004*). Copy the project's `.claude/`, its `CLAUDE.md`, and its `.gitignore` and `.gitattributes` (step 5 reads them) to a temporary folder beside it — or, where the project's path is long enough that the copy fails or the checks cannot run there, to a short-pathed folder the rehearsal log names; that choice is this step's, not troubleshooting (contract-009 G-1) — and run steps 3–9 there with the pioneer's answers stubbed:
   - *reapply* for every skill with residue (the answer that can hit a conflict — a conflict in rehearsal is logged as an offer and put on the sheet, never decided; the copy itself takes *the kit's* side, `merge.sh --take kit`, so the steps that follow run on a file with no markers in it),
   - *remove* for the stale list,
   - *legacy* for every existing contract (step 7),
   - *legacy* for the drift entries at `mitigated` (step 7),
   - *keep* for the instance-file question (step 7),
   - *none for now* for the map question (step 8, if it is asked),
   - *defer* for the ratification pass (step 9, when there is something to ratify — otherwise it is *not reached*),
   - *none named* for the workspace question (step 7),
   - and the acceptance answered *yes* (so `.claude/kit-incoming/` is removed).

   In a rehearsal there is no one to present to: the classification and every offer go into the rehearsal log instead. The copy takes no lock and ends without ceremony: `preflight.sh begin`, `preflight.sh end`, `mark-done.sh` and the done block belong to the real run, and a rehearsal runs none of them.

   The log is a file, not a transcript: `rehearsal-<date>.md` in the **project's** `docs/reports/` — the project's, not the copy's, which has no such folder; it is the folder the kit's analysis reports go to, created if the project has none, and the one file a rehearsal writes into the project — kept after the copy is discarded, holding the three numbers and every defect the copy caught — the step 9 report links it (contract-008 G-5). It is the upgrade's own file: `preflight.sh` sets it aside when it looks for uncommitted work, and it is committed with the upgrade, not before it.

   The stubs count decisions; they do not show whether a reapplied residue still makes sense against the upgraded skill — so the rehearsal report lists every residue line that could not be reapplied cleanly, and every reapplied line that still names something the staged kit removed or renamed, for the pioneer to weigh on the sheet, before the real run.

   Keep a log of three numbers: **decisions asked** (the acceptance line is not one), **files that genuinely differed**, and **troubleshooting steps** — anything you had to do that these steps do not say.

   **Every figure that reaches the pioneer comes from a command.** The rehearsal log ends with a table: each figure on the sheet or in the presentation, beside the command that produced it. A count made by eye is not put in front of the pioneer, and the real run runs the same commands again before it acts on the answers — a figure that no longer holds is said in the report (contract-017).

   The rehearsal produces **the sheet** (see *The sheet and the done block*): every question the copy met, one line each, the stub as its default and the impact of each answer, the acceptance last.

   Present the rehearsal log and the sheet together, in one turn, and wait once; the real run takes every answer from the sheet and asks nothing (contract-011).

   The step 9 report's lists of what was taken, ported, removed and migrated come from the step 3 classification and the step 7 edits, not from a diff of the tree.

   **A file "genuinely differed" when it differs from the baseline *and* its content differs from the staged copy** — a file the project changed in a way the kit has since made identical did not differ, and neither did one the kit changed that this project never touched. A record has no staged copy: it counts here when the template rule puts a question about it on the sheet, and not otherwise.

   The rehearsal passes only when every decision asked belongs to a file that genuinely differed or is one of the seven standing questions —
   - the stale list (step 3);
   - the **instance-file question** — the template rule's one-per-file question on a *record's* base lines (step 7), which is a different question from any skill's overwrite/keep/port and is never answered by inference from those;
   - the contracts the pioneer may name for verification (step 7);
   - the pre-upgrade drift entries at `mitigated` — batches or `legacy` (step 7);
   - the workspace question — the applications in the system flow, asked once when the manifest has no `workspace` list yet (step 7);
   - the map question when the budget forces it (step 8);
   - and the ratification pass (step 9, when the sheet carries it) —

   with the sheet's acceptance line not counted, the third number is zero, **and `checks/G2-migration.sh` exits 0 on the migrated copy** (contract-008 G-2), and at the real run every question the run meets was on the sheet — one that was not is a defect recorded in the report under *what this did not ask*, never asked mid-run (contract-011 G-3);

   otherwise the rehearsal has not passed: say so at the top of what is presented, with each step that had to be invented, and do not run the upgrade — the procedure is fixed in the kit's repository and a new release staged. The staged kit is never edited in place.

   Discard the copy. Only then run steps 3–9 on the project, beginning with `bash .claude/kit-incoming/meta-mechanisms/checks/preflight.sh begin`, which records the starting point (see *The way back*).
3. **Lay of the land.** Read both kits in full (the base kit's own evidence under `tests/results/` excepted), and read this project's own records before touching any of them — the contract log above all, then the drift log, the learning log and the manifest — so the upgrade knows what the project has built, verified and learned, and can tell a record it must not change from a template part it may refresh.

   The pioneer's rule, 2026-09-13: *"get the lay of the land before walking it"* (C-010).

   Recompute the baseline with the 6j command into a temporary file in the project root (removed at the end) and compare it with `meta-manifest/INSTALLED.sha1` hash to hash, keyed by path — a baseline from before 0.15 marks each path with a leading `*`, which is dropped; classify every kit file (see *What "the kit" is*).

   A baseline from before 0.15 hashed raw bytes: for a file whose hash differs from such a baseline, hash it once more with CRLF endings (`tr -d '\r' < file | sed 's/$/\r/' | sha1sum` — strip first, so the command reads the same on every sed), and if that matches, the file is untouched — an install made on Windows re-saves files with the other ending, and that differs by nothing.

   A kit file the old baseline never listed because its pattern did not cover it (`walk.expected` and `settings.template.json` before 0.15; the `.lines` history and `retired-phrases.txt` at any version) is untouched, not evolved — a kind of file the baseline never hashed is no evidence of an edit:
   - **untouched here** (hash matches the baseline) → take the staged version, no question asked
   - **evolved here** (hash differs, or no baseline exists) → **measure the residue before asking anything** (contract-008 G-1).

     Compare the project's copy against its installed copy under `.claude/skills/installed/`, line by line, with carriage returns and trailing whitespace removed and blank lines ignored: every line of the project's copy that the installed copy also has is the kit's; the lines left over are the **residue** — the project's own.

     Measure it with the staged kit's `checks/residue.sh <project copy> <installed copy>`, which prints the residue and also knows a **re-wrapped** line for the kit's: its words standing in order inside one line of the yardstick, or running from the end of one line through whole lines to the start of another (contract-013 G-1).

     No residue → the file is untouched after all (re-wrapping is not an edit): take the staged version, no question.

     Residue → the question shows the residue lines in full, quoted, not a diff against the staged copy, which would mix the kit's own changes into what the pioneer is asked to judge — and it has two answers, not three: **reapply** the residue on top of the upgraded skill, or **replace**, taking the upgraded skill and dropping the residue.

     The upgraded skill is taken either way; there is no keeping the old file.

     **Reapplying is a merge, not a judgement** (contract-017): `checks/merge.sh <project copy> <installed copy> <staged copy> <out>` puts the pioneer's edits onto the staged skill with git's three-way merge, each edit where it was made. Exit 0 is a clean result. Exit *n* is *n* conflicts — the pioneer's edit and the kit's change meet in the same lines — and the script prints both versions of each.

     A conflict goes beneath the skill's line on the sheet exactly as printed, with its resolutions: *yours*, *the kit's*, or *both* — the kit's lines, then the pioneer's — which is the usual answer where each side only added something at the same place. A conflict is part of its skill's line, not a decision counted on its own, and its default is *the kit's* — the one answer that leaves no retired wording behind — so *defaults* is still a complete answer; the line says so. The real run applies the answer with `merge.sh --take yours|kit|both`; where one file's conflicts got different answers, each is settled by hand at its markers, and no marker is left. A line of the pioneer's that stays may say what the kit has retired: `G3-retired.sh` holds only the kit's text to its list and reports the pioneer's line as a note. With no installed copy there is no base to merge from: the residue lines are put back where the passage they extended still stands, and a line that cannot be placed — the passage gone or reworded — is a conflict of the same kind.

     One the rehearsal did not find is never resolved by the agent and never asked mid-run — the line is left out, the upgraded text stands, and the done block lists it under *what this did not ask* (contract-013).

     The baseline the pioneer set (C-013, 2026-09-16): meta skills are the kit's and are not meant to be changed by a project; one that changes them is on its own, and this question is what "on its own" costs — a decision per file, never a silent loss.

     A project with no installed copy — installed before contract-008 — has a stand-in the staged kit carries with it: `meta-bootstrap/history/<skill>.lines`, every line any committed version of that skill ever had (regenerated in the kit's repository before a release), read by the same `checks/residue.sh <project copy> <that file>`; a line of the project's copy found there is the kit's, the rest is residue, and the classification says the comparison was made against history, not an installed copy.

     Nothing outside `.claude/kit-incoming/` is ever consulted.

     Where the staged kit carries no history either, the classification says plainly that every file must be treated as possibly evolved, and the questions are one per skill.

     Then, for a file with residue, **show the pioneer what differs** from the staged copy — and when the differing file is under `templates/`, say plainly what keeping it costs: it becomes the yardstick the *next* upgrade compares against, so every base line that the newer template would have refreshed will instead read as pioneer-changed and be asked about again, every time, for as long as the old template is kept — the sections changed, in a few lines each, or, when most of the file changed, the headings that changed and the plain statement of what the staged copy changes; the baseline holds hashes, so the staged copy is the only text to diff against —

     and the sheet carries one line per differing skill: *reapply your lines on top of the upgraded skill, or replace?*, with every conflict the rehearsal found beneath it and its two resolutions.

     One line per differing file; none where nothing differs (contract-007 G-3; the two answers, contract-008 C-013).

     For a file under `templates/`, `reapply` means the project's lines carried into the staged template, which then becomes the yardstick the next upgrade compares against. A template has no line history: in a project with no baseline and no installed templates to compare against, the pioneer's edits to a template cannot be told from an older kit's text, so it is replaced, and the report names each such file and says where the old one is — in the starting commit, or the kept copy (*The way back*)
   - **new in the kit** → add it
   - an agent appears twice in the baseline, once where it is deployed and once in the kit's own copy; the pair is **one file** for classification and asks **one** question
   - **present here, absent from the staged kit** → list it as stale — never the installed copies, never `templates/`, never an instance file, which a release does not carry by design (an agent, a hook, a script or a template the kit no longer ships — `kit-canary-author.md`, `reveal-canaries.sh` and the withdrawn rebuild template from before 0.15, for instance) and remove it only as the sheet's stale line answered, one line for the whole list.

     Where a file satisfies both this rule and "untouched", stale wins: being absent from the old baseline is not evidence that the base kit's own evidence belongs here. The base kit's own evidence that an earlier install carried — `tests/results/`, any `P-NNN.sh` check in `checks/` whose precedent id is not in this project's casebook, the base kit's contract walks and `tests/fixtures/` — goes on the same list when it is present. **A `P-NNN.sh` whose precedent id IS in this project's casebook is the project's own check and is never stale**; `install.sh` refuses to remove one and names it, so the rule does not rest on this sentence being read (contract-018 UC-2). Beside each stale file, name any reapplied residue that still refers to it, so the pioneer sees what *reapply* leaves pointing at nothing. A skill whose reapplied residue names, in its `> **Map:**` header, an entry the staged template withdrew has that id removed in step 7, because the header is the map's (meta-map: header and entry are co-owned); this is reported, not asked

   The classification was presented with the sheet; the real run does not present it again. With no baseline and no installed copy, say which stand-in the residue was measured against — the base kit's history, or nothing; only in the last case must every file be treated as possibly evolved, with the questions one per skill.
4. **New folders arrive without their records.** A new node's `SKILL.md` is copied; its instance file is **not**. Seed those from the *staged* templates in step 6 below. The staged kit's own ledger, corrections, casebook, map and logs are never copied into the project.
5. **Install.** One command performs this step, and the rehearsal and the real run call it the same way:

   ```
   bash .claude/kit-incoming/meta-mechanisms/checks/install.sh upgrade <plan>
   ```

   **The plan is step 3's classification, written down** — one line per file, paths relative to `.claude/skills/`: `take <path>` for a file classified *untouched* or *new*, `stale <path>` for one the staged kit no longer ships. A file nobody named is left alone, so a skill whose lines the merge reapplied needs no line here. `templates/` and the installed copies under `installed/` are refused: they are what steps 7 and 8 compare against, and they are replaced last, in step 9.

   **What it does**, in this step's order: takes the planned files from the staged kit · deploys the kit's agents to `.claude/agents/`, the kit's own copy under `skills/agents/` being the source, so a reapplied agent is never left behind · merges the settings · replaces the CLAUDE.md block between its `kit-block` markers, rendering the applications line from the manifest's `workspace` list, or from `--workspace <file>` when the sheet's answer is not in the manifest yet (5a, 5c, contract-010 G-3 and G-4) · adds the 5d–5e entries and folders wherever they are missing — lost by a copy, or added to the kit since this project was installed · removes the stale files. An install calls `install.sh install`, which also writes the installed copies (5g).

   **What it refuses**, changing nothing at all, so that a refused run is a safe one:
   - a settings file that is not the one the last install shipped — something of the project's own is in it, and which groups are the kit's cannot be told from the file alone. Merge it by hand (under each event keep every group without a `"_kit"` key, drop every group that carries it, append the staged template's group for that event, keep every `permissions.deny` entry) and run again with `--skip-settings`;
   - a `CLAUDE.md` with no `kit-block` markers. Where the old block ends is a judgement, and a paragraph of the pioneer's own may sit inside it: the old block is the contiguous text from the kit's heading up to, and not including, the first horizontal rule or the first heading that is not the kit's. The script prints that span; replace it by hand, add the markers, carry any paragraph of the pioneer's over beneath the end marker — when in doubt, carry it — quote the replaced span in the report, and run again with `--skip-claude-md`;
   - removing a `P-NNN.sh` whose precedent id is in this project's casebook: that is the project's own check, not the base kit's evidence, and it is never stale (contract-018 UC-2). It is spared, named in the script's report, and nothing else changes.
6. **Seed missing instance files** (6a–6h, including 6e when the project has no `FOUNDING.md` — pre-v0.13 projects don't, and the CLAUDE.md block imports it). Such a project has never been asked for its founding statement, and the upgrade is not the agent's moment to write one: the rehearsal seeds the file with the statement block reading `*Not yet given.*` — never a deferral nobody gave — and the presentation asks for the statement beside the sheet, in Step 3's words and under Step 3's conduct. The real run records what the pioneer gave, or their deferral, as 6e says. Create `.claude/skills/meta-mechanisms/checks/` if absent. Existing instance files are never replaced.
7. **Migrate existing instance schemas additively** — add what is missing, remove only the retired keys this list names, never change a value that is present; new values are written as plain scalars. Field order carries no meaning: put a new field where it reads naturally in the entry, and do not hunt for an anchor the old entries may not have. Use whatever tooling is reliable for the size of the job — a long migration by hand is its own risk — and **verify by diffing the migrated file against a copy taken before the migration, confirming that every pre-existing line is still there unchanged, except the lines this step itself names for removal or refresh**. Compare with carriage returns set aside on both sides (`tr -d '\r'`), or a project with mixed line endings shows every line as changed and hides a real loss. Keep the copies outside `.claude/` — a temporary folder — so the new baseline never records them. The verification is the requirement; the method is yours:
   - `CONTRACT-LOG.yaml` — **an entry that is an analysis report is left alone**: a `report-NNN` id or `type: analysis-report` takes none of the fields below, because a document has no disappointment line, no pre-mortem, no red test and no verification; it gains `type: analysis-report` if absent, and `status: published` where its status is one the enum no longer admits (contract-018 UC-5). Every other existing entry gains `verification_state: legacy` and `audited: legacy` if absent (the sheet's line for it says whether any recent implemented contract is verified and audited instead; set `none` and `false` on those — and skip the question entirely when every existing entry already carries these fields, since then both answers write the same file), and `disappointment: legacy`, `premortem: legacy`, `red_test: legacy`, `cost: legacy` if absent (contract-006 fields). An older `approval: gate` stays as it is; the template lists it as the pre-0.15 value.
   - `CORRECTIONS.yaml` — every existing entry gains `noticed`, `would_have_been_right` and `seen_before`, each `not asked`, if absent.
   - `LEDGER.yaml` — every batch gains `represented: []` if absent; under `scores`, `canary_catch_rate`, `brier_stated_confidence` and `brier_pioneer_decisions` are removed if present and `coincidence: []` added if absent; a candidate's `lower_bound` is removed if present.
   - `DRIFTLOG.yaml` — every entry gains `status: unknown` if absent, because the hooks count drift entries by that key and an entry without one is invisible to the backlog; existing elevations written as maps gain `mitigation_medium: unknown` if absent, whether the entry's key is `elevation` or `elevations`; an elevation written as a prose string is left as it is. Entries already at `status: mitigated` from before the upgrade are pioneer-owned resolutions the moment the hooks run — the batch assembler offers two per batch until they are decided — so the sheet's line for them says whether they are reviewed that way or marked `status: legacy`, which no hook counts and no batch presents; skip the question when there are none (contract-008 G-4).
   - `MANIFEST.yaml` — every node gains `kind` and `load` if absent;
     - project nodes gain `triggers` from the entries step 8 drafts for them (so step 8 runs before this line) and `owns:` naming the node's own skill and data files;
     - every base node gains `triggers` and, when not an agent, `owns:` from the staged template's node of the same id — a base node the project registered under another id is matched by its `skill_file` and takes the template's id, and every `dependencies` list naming the old id is updated;
     - a skill registered under two ids keeps the id whose line names it as `skill_file` first, and the duplicate line stays as it is and is listed in the report;
     - an id with the `base-` prefix whose `skill_file` the staged kit does not carry is a project node;
     - a project node whose entry waits in `proposed-entries.md` gets `triggers: []` and the sentence `entry pending the map question` in its `note:`, appended to whatever that field already says, or as a new `note:` where it has none;
     - a value outside a template's enumeration (a `type`, an `aspect`, a `status` the hooks do not read) is left as it is and listed in the report;
     - `library_kit: null` is added to `kit_identity` if absent;
     - `workspace: []` is added to `kit_identity` if absent, and the sheet's workspace line answers the workspace question of step 2's list — the applications in the system flow, written as 6i says, or left `[]` (contract-010 G-1, G-2);
     - `kit_type` is left as the project declared it;
     - base nodes renamed in the kit (`agent-canary-author` → `agent-batch-assembler`) take the staged template's whole node line and coverage line;
     - new base nodes are registered — every node the staged template's `nodes:` carries, the agent nodes included;
     - a base coverage line whose `node_id` the manifest's `coverage_map` lacks is appended from the staged template, in the template's order, and `G2-migration.sh` fails while one is missing (contract-009 G-2) — a project coverage line, `node_id: null` or a project id, is never touched, whatever prefix it carries;
     - base node lines and base coverage lines follow the template rule, and the template rule's question on them is **its own line on the sheet** — the instance-file question of step 2's list — never answered by inference from what the pioneer said about the skills (contract-008 G-6);
     - `base_kit_version` is set to the staged version.
   - `MAP.md` — every base entry follows the template rule: an entry that still reads as the installed template wrote it takes the staged template's columns and keeps its own status; a base entry the staged template withdrew is removed unless the pioneer reworded it; a reworded entry goes on the sheet's instance-file line. An entry that names a file step 5 removes and was not refreshed here is an error in this list, not a judgement call.
   - The header comment block of every record follows the template rule. The records are eight: `CONTRACT-LOG.yaml`, `CORRECTIONS.yaml`, `LEDGER.yaml`, `DRIFTLOG.yaml`, `MANIFEST.yaml`, `MAP.md`, `LEARNINGLOG.yaml` and `CASEBOOK.yaml` — the last two have no fields to migrate and a header all the same: `checks/merge.sh --header`, one record at a time, against the installed template, which is still in place. Line endings carry no meaning to the kit: kit files arrive with LF endings, an instance file, a kept skill or `settings.json` may come out of an edit with LF endings where it had CRLF, and nothing restores them — a mixed tree is expected and harmless, and no step checks or repairs endings.
   - The `> **Map:**` header of a skill whose residue was reapplied loses any id the staged template withdrew from the map; the rest of the line is the reapplied residue's and stays, and the report lists it where it still names something withdrawn.
8. **Map the project's nodes.** For each existing non-base node, draft an entry under "Project entries" from its description, as `proposed`, and add the matching `> **Map:**` header.

   Then run `checks/G1-size.sh`.

   If the map is over its budget, the drafted entries do not go into the map: write them to `.claude/skills/meta-map/proposed-entries.md` (not loaded), draft into the map one entry per **root** — the nodes `checks/roots.sh MANIFEST.yaml` prints: a project node whose manifest id (joined through `skill_file`, since `dependencies` name ids, never folders) appears in no other node's `dependencies`, a skill registered under two ids counted once; the script's output is the list and the count, and `proposed-entries.md` opens by stating that count and no other figure (contract-008 G-3) — run the check again, and the sheet's map line puts the rest to the pioneer — which of these belong in the always-loaded map, and which are reached through the nodes that already name them.

   If the roots alone still fail the check, the map keeps only its base entries and every drafted entry waits in `proposed-entries.md` for that one question.

   A `> **Map:**` header is added only to a skill whose entry is in the map. The map is never written past the check.

   The pioneer ratifies the entries in the first review batch, or in the ratification pass, when the sheet chose it.
9. **The ratification pass** was decided on the sheet, as Step 7 of the install now decides it —

   unless every entry in the map is already decided (`ratified`, `declined` or reworded) and step 8 drafted nothing into it: then there is nothing to ratify; say so in one line, ask nothing, write no marker, and the rehearsal's stub for the pass reads *not reached* (contract-009 G-3) —

   and on a deferral add the line `ratification: deferred` inside the map's header comment, so the first session after the upgrade does not open a batch on every drafted entry.

   First **run every check** under `meta-mechanisms/checks/` — the `G*.sh` scripts; the others there are tools the steps call with arguments — `G2-migration.sh <project .claude/skills> <staged MANIFEST.template.yaml> <the copies step 7 took>` among them — the third argument switches on its check that no block of a record was broken apart — which walks each migrated record's structure, counts the migrated fields per entry, and checks every node and every base coverage line of the staged template is registered; it exits non-zero naming the file and the figure, and a non-zero exit is a defect to fix before the report, never a note in it. The checks come before the bases are replaced on purpose: `G3-retired.sh` tells a line the upgrade forgot to refresh from a line of the pioneer's by looking in the OLD shipped copy, and once that copy is replaced a forgotten line reads as the pioneer's and passes as a note (found by the rehearsal on the first downstream project's copy).

   Then **replace the comparison bases**, now that nothing needs the old ones: `templates/` from the staged copies — for a template the sheet answered *reapply*, the merged file of step 3 instead — and the installed copies under `.claude/skills/installed/` refreshed from the staged copies for every meta skill and `INTENT.md`, whatever the pioneer answered for the file itself, so the next upgrade measures residue from what this one shipped.

   Then **regenerate the baseline** (6j) — after the marker, so the baseline records the map as it is —

   then `bash .claude/skills/meta-mechanisms/checks/hooks-selftest.sh`, which runs every hook once against a throwaway copy and so writes nothing into this project's records — on an upgrade the backlog and the gate's task it shows reflect the project's live records, not a fresh install — and `bash .claude/skills/meta-mechanisms/tests/walk.sh`, the lifecycle walk, which runs inside its own fixture and must end *all states match* (contract-017) —

   and **report**: present the upgrade as an analysis report — what was taken, ported, asked, removed and migrated, with the rehearsal's three numbers beside the real run's (in a real run the first number counts the questions it met that the sheet had not answered, and should be zero), a link to the rehearsal log, a section naming what the upgrade did **not** check, so that silence is never read as a clean result (contract-008, the pre-mortem), and one more section, of a line or two: **what can this project do now that it could not do before?** Every other part of the report measures fidelity — that nothing was lost — and a report can be green in all of them while the thing the pioneer upgraded for is untouched. *Nothing material* is a complete and often true answer; leaving it unasked is how a green report is read as progress (contract-018 UC-6).

   End with the done block (see *The sheet and the done block*) — upgraded to the version, what was verified, what waits, what was not checked and *what this did not ask*, start working — run `bash .claude/skills/meta-mechanisms/hooks/mark-done.sh upgrade`, remove the lock with `bash .claude/skills/meta-mechanisms/checks/preflight.sh end`, and remove `.claude/kit-incoming/` as the sheet's acceptance line answered.

   No question follows the block (contract-011 G-4).

---

## What This Skill Does Not Do

- It does not audit the existing codebase for problems or improvements — that comes later, through use
- It does not negotiate its steps with existing tools, plugins or hooks — conflicts are named and surfaced, not resolved by compromise
- It does not change anything in the project before Step 5, and never before the orientation in Step 2 has been confirmed — an upgrade's rehearsal log, written to `docs/reports/`, is the one exception
- It does not continue a run that stopped halfway — the project is restored with `rollback.sh` and the run started again
- It does not draft, suggest, or shape the founding statement — it asks for it and records it verbatim
- It does not overwrite instance data or folder-copy a kit over an evolved one
- It does not create a type-category manifest — that is meta-extract's artifact, when the instruments say the standard is ready
