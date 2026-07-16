# How We Operate: One-Page Index

The quick card. It does NOT restate the rules (that is how a third copy drifts,
which this repo has a rule against). It points at the canonical sources and
gives the two things worth having on one page: the daily loop and who to ask.

- **Full system design:** `blueprint.md`
- **Operating rules (the source of truth):** `rules.md`
- **Roles:** `agents/templates/`
- **Enforcement (hooks, CI):** `hooks/README.md`, `ci/ci.yml`
- **Loops, production-readiness, ceremonies:** `loops.md`, `prod-readiness-checklist.md`, `skills/examples.md`

## The daily loop (detail lives in the docs above)

1. `/standup`: shipped / next / blocked from repo state, and plan the day.
2. Pick ONE thin slice with a named outcome, measure of success, and acceptance
   criteria. Product input routes through the product owner first.
3. Default team: you + the builder + at most one advisor. One lens per question.
4. Builder builds in a bounded loop (max ~5 passes), verifies on the REAL
   runtime, red before green.
5. Gate before merge (code-review always; security-review for auth/data). Every
   "done" carries a last-hop receipt.
6. Ship as a draft PR with the evidence block. Merge only after the gate.
7. Close out: run manual probes, tick the backlog, document any infra change.

## Who to ask (one lens per question)

| Question sounds like… | Ask |
|---|---|
| ANY product input, "should we build this?" | **product owner** (the gatekeeper) |
| Build / fix / debug, "what architecture / what does it cost" | **builder / engineering lead** |
| Is this plan/claim actually true? | **red-teamer** |
| Independent code review of a pushed diff before merge | **reviewer** (never the author) |
| Why do users stall here? | **behavioural scientist** |
| How do we get the next new user to value? | **growth hacker** |
| Is the domain data right? | **data steward** |
| Does this screen look right / design this page | **designer** |
| Independent UAT before I see it | **tester** |
| Could this leak or escalate? (design-time) | **security** |
| Pull the real number from prod | **data analyst** |
| Write it down durably | **documentation** |
| Turn a fuzzy ask into stories / a PRD | **business analyst** |

## Ceremonies

Two a day (`/standup` merged with planning, `/sprint-review`), a weekly outcome
review the product owner leads, and `/retro` only after a real process lesson.
The product owner owns the cadence. Definitions: `skills/examples.md`.
