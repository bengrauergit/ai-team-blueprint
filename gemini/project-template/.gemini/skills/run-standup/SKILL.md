---
name: run-standup
description: The morning ceremony -- sync AND plan the day from repo state, never from memory.
---

# Standup + plan the day

Run at the start of each working session. Build everything from repo state, never from memory. The default morning briefs zero agents.

## 1. Gather state
- `git fetch`, then read the log for what merged since the last session. Never trust a stale local snapshot: in a multi-stream setup, assume the world moved.
- List branches and open PRs: what is in flight, what awaits review.
- Read `BACKLOG.md` (keep it short: current sprint plus a "next up" queue of about ten; everything older lives in an archive file you grep, not read).
- Check for uncommitted work: ephemeral containers make it a standing risk.

## 2. Report: shipped / next / blocked
- **Shipped**: what merged, each with its receipt status (verified on the real runtime, or "verified through hop N, unverified beyond").
- **Next**: the one thing to do first, as a thin slice with its measure of success.
- **Blocked**: anything waiting on the owner, each with the exact ask.

## 3. Plan the day
- Propose the day's slices from carry-overs and the queue: each with an outcome, a measure of success, and acceptance criteria including degenerate cases.
- **P1-first guardrail:** if a signed-off P1 is open, it is slice #1. Meta or process work scheduled ahead of it needs an explicit "defer the P1" from the owner, recorded in the sprint notes.
- **Prior-art check:** before committing to build any new deliverable, grep the repo and list branches for an existing version. Parallel streams collide otherwise.
- **Grooming gate:** work enters the sprint only as a groomed story (standard format, checkable acceptance criteria, named outcome). An ungroomed entry goes back to grooming, not into the sprint.
- Invoke an advisor only on a named trigger, one lens per question: priorities genuinely unclear → `@product-owner`; entry fuzzy → `@business-analyst`; anything hard to reverse → `@red-teamer`; new paid service or send volume → `@data-analyst`.

## 4. Sign off, then document
Write the agreed plan into `BACKLOG.md` and commit it. The plan is repo memory, not chat memory.
