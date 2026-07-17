# AI Team Delivery Rules

Read `docs/agents/context.md` before non-trivial work.

## Product routing

- Route ideas, complaints, feature requests, and “should we build this?” through
  the `product-owner` agent before implementation.
- Agree on the customer outcome, observable success measure, and checkable
  acceptance criteria before coding.
- Prefer the thinnest independently valuable vertical slice.

## Team shape

- The `builder` agent is the only agent allowed to edit application code.
- Advisors investigate and recommend but do not modify files.
- Use one specialist lens per question. Default to the main thread, builder,
  and at most one advisor.
- Delegate only independent, bounded work. Avoid parallel code edits and name
  hazard files that force sequencing.

## Evidence and completion

- Separate `MEASURED FACT` from `INFERENCE`.
- Search results and symbol names are clues, not proof; trace real call paths.
- Name the last runtime hop before implementation and obtain a receipt from it.
- A bug fix requires a failing reproduction before the fix and a passing check
  afterward.
- Do not call work done without the relevant checks, runtime verification, and
  an evidence block.

## Delivery

- Plan before non-trivial implementation and avoid unapproved scope expansion.
- Run independent code review before merge. Add security review for auth,
  payments, permissions, secrets, migrations, or data access.
- Never push directly to the default branch.
- Put rules that must never slip into a hook, test, linter, permission, or CI
  gate and verify the failure case.
