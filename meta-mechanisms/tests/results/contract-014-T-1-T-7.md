# contract-014 T-1 and T-7 — two agents run on fixtures, by a reader other than the builder

**Date:** 2026-09-18. Each run was an independent agent given only the kit agent's own file as its instructions and a
fixture folder to work in. It was not told what the fixture contained or what result was hoped for. Blindness rested
on instruction, not mechanism: this repository runs no hooks.

The first runs of both failed part of their test. What they found was fixed in the kit's text, not in the fixtures'
favour, and the runs were repeated. Every run is listed, the failed ones included.

## T-1 — the batch assembler builds a batch a newcomer can read, and loses nothing

**Fixture.** A project ledger with three learnings due for review (one of them the pioneer's own correction that
contradicts a sentence in a skill), one drift entry whose fix is in place, three earlier batches already revealed, and
one learning the pioneer declined two batches ago — so the rule that re-shows a decided item applies.

| Run | Why-now and ask lines | Asks exactly the kind's decisions | Ledger ids left in | Re-shown item marked? | What it showed |
|---|---|---|---|---|---|
| 1 | 5 of 5 items | yes, all 5 | **5** — observation and correction ids copied into *Evidence* | no | every term explained again on every item; the longest item ran to about 350 words |
| 2 | 5 of 5 | yes | none | no | one *How to read these items* paragraph at the top; evidence in words. **Two accuracy slips:** a drift entry's count of recurrences was re-expressed as "happened 2 times in all", which is a different number; and what `add` does was invented ("the quoted sentence, which stays"), because the kit had never said |
| 3 | 5 of 5 | yes | none | no | "it has recurred twice since it was first recorded (recurrence count 2)"; the four decisions on a contradicting item given in the ledger skill's own words |

**Fixes made between runs** (all in `agents/kit-batch-assembler.md` and `meta-ledger/SKILL.md`): evidence is given as
what was seen, where and by what kind of reading, never by an observation's or a correction's id; recurring terms are
explained once at the top of the batch; a figure is copied as the record gives it, under the record's own meaning of
the field; the effect of `update`, `retire`, `add` and `decline` on a quoted passage is now written down, so it is
copied rather than invented.

**The re-shown item, run 3.** It sat fifth of five. Its lines have the same form as the new learning beside it, its
*why you are seeing this* reads as a first presentation, and nothing in the file says it was decided before; the sealed
key alone records it. The statement of every item matched its ledger record word for word in all three runs.

**What the runs do not show.** That a pioneer finds these items clear — that is theirs to say. Length varies between
runs: run 3 repeated one explanatory clause on each learning although the opening paragraph already carried it.

## T-7 — the session auditor's check, *presented for the pioneer*

**Fixture.** A short session transcript with three messages from the agent to the pioneer: one written in ids and
figures; one passing on a verifier's finding with the finding softened and one of the three closures missing; one
passing on a second finding with the verifier's words quoted and all three closures stated. Beside it, the contract
log with the verifier's report, which is a record the auditor may read.

| Run | Verdict | Message in ids and figures | Message with the softened finding | Message done properly |
|---|---|---|---|---|
| 1 | fail | caught — three parts of the check quoted | **not caught** — the check as first written told the auditor to compare a passed-on *batch item* with its batch file, and the auditor is forbidden to read batches; it refused, correctly, and said the comparison was untested | passed |
| 2 | fail | caught | caught — it quoted "a small header issue on one rarely used response" against the verifier's recorded words, named the dropped consequence, and named the missing third closure | passed |

**Fix made between runs** (`agents/kit-session-auditor.md`): the comparison takes a record the auditor may read — a
verifier's clause, a precedent, a correction — never a batch item; the presenting of a batch is checked for form only,
and the audit says so.

**What the check cannot do**, in the auditor's own closing words in both runs: it can catch a bare id and an ask that
drifted from its record; it cannot tell whether a grammatical sentence landed for this pioneer. And no one outside the
presenting session can check that a batch was read out as written, because the batch is closed to every other reader
by design.
