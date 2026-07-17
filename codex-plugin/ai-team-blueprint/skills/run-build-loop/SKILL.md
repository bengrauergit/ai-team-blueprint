---
name: run-build-loop
description: Run a bounded builder-to-tester delivery loop for a groomed software story with checkable acceptance criteria. Use when Codex should implement a slice, obtain an independent UAT verdict, revise concrete failures, and stop with receipts or honest escalation after at most five passes.
---

# Run Build Loop

The main Codex thread owns orchestration. The builder is the only code-writing
agent; the tester is independent and edits nothing.

1. Read `AGENTS.md` and `docs/agents/context.md`.
2. Reject an ungroomed brief. Require a named outcome, a success measure, and
   objectively checkable acceptance criteria, including degenerate cases.
3. Set `pass = 1` and preserve the same brief and criteria for the whole loop.
4. Spawn the `builder` custom agent. Tell it to encode failing checks before the
   implementation where the stack allows, implement the thinnest complete
   slice, verify the real runtime, and return an evidence block.
5. After the builder finishes, spawn the `tester` custom agent with the original
   criteria. Require a structured verdict with `done`, `failures`, and
   `receipts`. The tester must not infer success from the diff.
6. If `done` is true, return `DONE`, the pass count, and the receipts.
7. If false, send only the concrete failures and reproduction steps back to the
   builder, increment the pass, and repeat.
8. Stop after five passes or earlier when the remaining budget cannot support a
   complete build and verification pass.
9. Return `ESCALATED` with the last failures and honest state. Never soften this
   into “should work.”

Do not parallelize builder passes. Do not let builder and tester edit the same
files. Do not ask the author to grade its own work.
