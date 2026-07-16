---
name: orchestrate-team
description: When a slice decomposes, assign work to nested sub-agents, track it, unblock, and flag a mismatch to the human. Leans on the build loop.
---

# orchestrate-team

Lightweight downward orchestration. The engineering lead is primarily the single
builder; invoke this only when a slice GENUINELY decomposes into independent
parts (non-overlapping files, an isolated audit), not to manufacture a team.

## Steps

1. **Break the work down** (see `estimate-work`) into parts that can run without
   stepping on each other. Name the hazard files that force sequencing.
2. **Assign** each part to a nested sub-agent with a tight brief and its
   completion criteria.
3. **Track and unblock:** collect outputs, clear blockers, keep every part to
   the quality bar before it merges.
4. **Bound it.** Each part runs the build loop with its cap; escalate at the cap
   with the honest state rather than looping forever.
5. **Flag a mismatch** to the human: if a sub-agent is repeatedly wrong for a
   task, that is a routing or capability decision for a person, not something to
   paper over.

## Leans on

The build loop (the engine each part runs), the non-overlapping-file-ownership
rule, and the human gate for the irreversible steps. True lateral peer teams are
the platform's experimental agent-teams feature; nested sub-agents work today.

## Output

Work assigned, tracked to the quality bar, blockers cleared or escalated, and any
capability mismatch flagged for a human decision.
