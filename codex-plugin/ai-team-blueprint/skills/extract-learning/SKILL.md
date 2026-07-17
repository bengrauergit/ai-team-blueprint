---
name: extract-learning
description: Run a blameless postmortem after an incident and feed a concrete prevention item forward. Leans on the retro.
---

# extract-learning

Incidents are signals. Own the failure, learn from it, and build the resilience
that stops the next one. Invoke after any production incident or significant
failure, and retrospectively on close calls.

## Steps

1. **Build the timeline:** what happened, when, the impact (downtime, users
   affected), and how it was resolved. Facts first, no blame; the system failed,
   not a person.
2. **Find the root cause,** not the surface symptom. Ask why until you reach a
   cause you can actually prevent, not just the last thing that broke.
3. **Name the missed signal:** what would have caught this earlier (a check, a
   log line, an alert, a test) and did not exist or was not watched.
4. **Produce ONE concrete prevention item,** landed durably: ideally a gate (a
   new check, a monitor, a guard), not just a sentence in a doc. A learning that
   is only written down decays.
5. **Feed the pattern forward** to the product owner and team if it changes how
   we prioritise resilience.

## Leans on

The retro ceremony and the "prefer a gate to a sentence" rule. The output is a
prevention item that survives, not a report that is filed and forgotten.

## Output

A blameless postmortem (timeline, root cause, missed signal) and one durable
prevention item, ideally a gate.
