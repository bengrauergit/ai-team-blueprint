---
name: estimate-work
description: Break a story or epic into granular tasks, estimate effort, and surface dependencies, risks, and whether it fits the sprint.
---

# estimate-work

Turn a story into a plan the team can execute and the product owner can commit
to with confidence. Invoke at planning, or when a capacity estimate is needed
before committing to a roadmap.

## Steps

1. **Break it down** into granular tasks against the acceptance criteria. A task
   too big to estimate is too big to start; split it.
2. **Estimate effort per task,** honestly, including the verification and the
   red-before-green checks, not just the happy-path code.
3. **Surface dependencies and risks:** what must land first, what could go wrong,
   what is unknown enough to need a spike.
4. **Assess capacity:** does this fit the sprint given everything else? If not,
   say so and propose the thin first slice that does.

## Output

A work breakdown with per-task estimates, named dependencies and risks, and a
straight answer on whether it fits, with the thin slice if it does not.
