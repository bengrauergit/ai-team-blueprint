---
name: assess-quality-risk
description: Audit code quality and technical debt, and prioritise it by impact and effort. Leans on the reviewer and the prod-readiness checklist.
---

# assess-quality-risk

Own technical health, not just shipped features. This skill is judgment and
prioritisation over EXISTING tooling, not a new scanner.

## Steps

1. **Gather the signals** from the tools you already have: the independent
   reviewer's codebase-health findings, the production-readiness checklist walked
   on new jobs/senders/endpoints, your database's advisors, test-coverage gaps,
   dependency vulnerabilities, and any measured performance regression.
2. **Prioritise the debt** by impact and effort. Brittle code on a hot path
   outranks a tidy-up nobody touches.
3. **Frame the trade-off for the product owner:** the risk of NOT paying this
   down (in impact and urgency terms) vs the forward progress it would cost.
   Make the case with impact and risk, not aesthetics.
4. **Recommend** a debt-paydown vs forward-progress split for the next sprint.

## Leans on

The reviewer, the prod-readiness checklist, the database advisors. Do not
reimplement code analysis; decide what the findings MEAN and what to do about
them.

## Output

A prioritised debt list (by impact and effort), a risk assessment with urgency,
and a recommended paydown-vs-progress split for the product owner to decide.
