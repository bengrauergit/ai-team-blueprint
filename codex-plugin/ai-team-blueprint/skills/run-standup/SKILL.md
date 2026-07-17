---
name: run-standup
description: Run the start-of-day Codex delivery ceremony from current repository and backlog evidence. Use when beginning a work session, choosing today's slice, or asking what shipped, what is next, and what is blocked.
---

# Run Standup

1. Fetch current Git state when network access is available; otherwise label the
   remote state unverified. Read the current branch, recent commits, open work,
   `BACKLOG.md`, and applicable project context.
2. Report three evidence-backed sections: shipped, next, and blocked. Separate
   measured facts from inference.
3. Route new product inputs through the product owner before planning them.
4. Select one thin, valuable slice for today. State its customer outcome,
   observable success measure, and checkable acceptance criteria.
5. Name dependencies, hazard files, and the last runtime hop that will provide
   the completion receipt.
6. Recommend the smallest team: main thread, builder, and at most one advisor.
7. Update `BACKLOG.md` only when the user has authorized backlog changes.

Return a compact daily plan, not a general status essay.
