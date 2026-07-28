---
name: run-sprint-review
description: The evening close -- diff the plan against reality, read the measures, and report the two workflow-health ratios.
---

# Sprint Review

Run at the end of each working day. The standard is the last-hop rule: a story is "shipped" only with a receipt from the real runtime; otherwise report it as "merged, unverified beyond hop N" and name the missing probe.

1. Diff the sprint plan against reality (`git log`, merged PRs). Per story: shipped-with-receipt / merged-but-unverified / not shipped (carried, cut, or blocked, with why).
2. **Read the measures of success against real numbers.** Run the read-only queries yourself; at small scale these are hand-countable. A measure that turns out never to have been instrumented is a finding: report it and add the instrumentation to the backlog.
3. **Report two workflow-health ratios** (this is how the process stays honest about itself):
   - **Sprint-goal hit rate to date**: goals met versus sprints reviewed, as a running tally. A run of misses means the planning step is broken, not the building step.
   - **Process-vs-product commit split**: commits touching agent/process/config files versus total. A high process share flags a day that built machinery instead of product. We measured 51% on a real week; it was invisible until someone counted.
4. **Read your database's advisors** (security and performance lints): report new ones only, each as a proposed backlog entry.
5. Capture every piece of owner feedback durably in `BACKLOG.md` immediately. Feedback that lives only in chat is lost.

Output: shipped with receipts / carried with reasons / measures read / the two ratios.
