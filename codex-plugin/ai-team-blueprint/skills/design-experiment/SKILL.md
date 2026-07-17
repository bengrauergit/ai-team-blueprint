---
name: design-experiment
description: Design and interpret an experiment to test a hypothesis, with the rigor matched honestly to your scale.
---

# design-experiment

Define the measurement BEFORE building. An experiment you design after shipping
is a story you tell about noise.

## Steps

1. **State the hypothesis** as a specific, falsifiable prediction: this change
   will move this metric by roughly this much, for this user.
2. **Name the outcome metric and how it is measured** (the event, the query, the
   surface). Confirm it is actually instrumented; if not, instrumenting it is
   the first slice, not the feature.
3. **Set the baseline** from real current data, and the success threshold that
   means "worth keeping."
4. **Design the comparison:** control vs treatment, duration, and the sample the
   result would need.
5. **THE SCALE HONESTY GATE.** Before invoking A/B tests and statistical
   significance, check you have the traffic for them. At a small user base you
   do NOT: a handful of users cannot reach significance, and a "reach" number is
   invented. Say so, and drop to the honest read (a hand-counted before/after, a
   qualitative signal, a single decisive user session). Rigor you cannot support
   is theater, not science.

## Output

An experiment design (hypothesis, metric, baseline, threshold, method, duration)
OR an honest "we cannot measure this cleanly at our scale; here is the cheaper
read that would still inform the call."
