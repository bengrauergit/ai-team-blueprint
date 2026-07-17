---
name: run-sprint-review
description: Run the end-of-day Codex delivery review using repository, runtime, and metric evidence. Use when closing a work session, reviewing what shipped, checking receipts, or measuring workflow health.
---

# Run Sprint Review

1. Read the morning goal from `BACKLOG.md` or the recorded plan and inspect the
   actual commits, branches, pull requests, and runtime receipts.
2. Report what shipped, what did not, and why. Do not count unmerged or
   unverified output as shipped.
3. Compare the intended outcome metric with the real observed value when a
   trustworthy source is available. Label missing measurements explicitly.
4. Calculate two workflow ratios from available evidence:
   - sprint-goal hit rate;
   - process-versus-product commit share.
5. Surface blockers and recommend the next smallest action.
6. Trigger `run-retro` only if the day produced a real process learning.
7. Propose backlog or documentation updates; apply them only within the user's
   authorized scope.

Return measured facts, inferences, receipts, and unresolved risks separately.
