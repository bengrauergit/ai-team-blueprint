---
name: run-build-loop
description: Run a bounded builder-to-tester delivery loop for a groomed software story with checkable acceptance criteria. Use when Gemini should implement a slice, obtain an independent UAT verdict, revise concrete failures, and stop with receipts or honest escalation after at most five passes.
---

# Run Build Loop

The main Gemini CLI session owns orchestration. The builder is the only
code-writing agent; the tester is independent and edits nothing.

**Two known capability losses versus the canonical Claude Code blueprint**
(`workflows/build-loop.js`, which uses Claude Code's native Workflow tool):
this skill has no equivalent of a JSON-Schema-validated tester verdict, and no
live token-budget escalation floor. Both are named explicitly below rather
than silently dropped — read the two callouts before relying on this loop for
anything high-stakes.

1. Read `GEMINI.md` and `docs/agents/context.md`.
2. Reject an ungroomed brief. Require a named outcome, a success measure, and
   objectively checkable acceptance criteria, including degenerate cases.
3. Set `pass = 1` and preserve the same brief and criteria for the whole loop.
4. Invoke `@builder`. Tell it to encode failing checks before the
   implementation where the stack allows, implement the thinnest complete
   slice, verify the real runtime, and return an evidence block.
5. After the builder finishes, invoke `@tester` with the original criteria.
   **Capability loss #1 — no schema validation:** Claude Code's Workflow tool
   requests a JSON-Schema-typed `{done, failures, receipts}` object and the
   platform rejects a malformed response. Gemini subagents return free text,
   so there is no enforced contract. Instead, require the tester to return
   its verdict in this exact convention and treat a response that doesn't
   match it as a FAIL-by-default, not a pass:
   ```
   DONE: true|false
   FAILURES: <bulleted list, or "none">
   RECEIPTS: <bulleted list of concrete evidence, or "none">
   ```
   The tester must not infer success from the diff; it must drive the real
   app or run the real suites.
6. If `DONE: true`, return `DONE`, the pass count, and the receipts.
7. If `DONE: false`, send only the concrete `FAILURES` and reproduction steps
   back to the builder, increment the pass, and repeat from step 4.
8. Stop after five passes.
   **Capability loss #2 — no live token-budget floor:** Claude Code's version
   also escalates early when `budget.remaining() < 30_000` mid-loop. Gemini
   has no equivalent live budget signal available to this skill. The
   substitute guard is the `max_turns` / `timeout_mins` frontmatter fields on
   `.gemini/agents/builder.md` and `.gemini/agents/tester.md` — keep those
   tightened (not left at the 30-turn / 10-minute defaults) so a single pass
   cannot run away silently. Treat this as a bounded-turns proxy, not a real
   budget check, and say so if you escalate because of it.
9. Return `ESCALATED` with the last failures and honest state. Never soften
   this into "should work."

Do not parallelize builder passes. Do not let builder and tester edit the same
files. Do not ask the author to grade its own work.
