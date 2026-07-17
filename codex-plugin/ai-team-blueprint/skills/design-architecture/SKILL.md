---
name: design-architecture
description: Evaluate technical trade-offs and recommend an architecture to the product owner, with options, costs, and an explicit trade-off.
---

# design-architecture

The engineering lead's core partnership skill. Invoke BEFORE the product owner
commits an epic to the roadmap, so feasibility and cost shape the plan rather
than surprising it later.

## Steps

1. **Restate the requirement, targets, and constraints:** the feature, the
   performance/latency/availability targets that actually matter, and the budget,
   timeline, and team constraints.
2. **Generate real options,** at least two. Make the axes explicit: monolith vs
   services, sync vs async, caching strategy, data store, build-vs-buy.
3. **Surface the trade-off for each,** in plain terms: "the fast way takes on
   THIS debt, costing THIS to pay down later; the alternative avoids it at THIS
   cost." Include a scale note: what would have to change for real scale, and
   whether that matters yet.
4. **Estimate cost and effort** per option.
5. **Recommend one, with the rationale,** but leave the decision to the product
   owner (and the human for irreversible calls). Invoke the red-teamer to
   stress-test a major call before committing.

## Output

An architecture proposal: the options, the explicit trade-offs, cost/effort per
option, and a recommendation with its reasoning. The decision is the product
owner's, made with full information.
