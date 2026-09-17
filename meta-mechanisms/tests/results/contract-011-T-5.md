# contract-011 T-5 evidence, 2026-09-18

## T-5 - the grace (walk-007 states 145a-145c)
Fixture: an installed kit with three candidates due for review and one contract implemented and unaudited;
telemetry holds a `session-start|startup` line, then `mark-done.sh upgrade` writes `done|upgrade`.
- the stop-gate still hands over the audit (145a): audits and verification are not held;
- with the contract audited away, the gate hands over nothing although three candidates are due (145b);
- a new `session-start|startup` line after the done line brings the batch task back (145c).

## Red test
G-5 broken (the gate's step 10 no longer consults in_grace): state 145b red, 79 passed 1 failed; restored: 80/80.
walk.sh 36/36, walk-004 51/51, every check exits 0, all run alone after the two overlapping runs of 2026-09-17.
