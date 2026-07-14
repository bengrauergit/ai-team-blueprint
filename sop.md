# How We Operate: One-Page SOP

The working rhythm under the agent-system blueprint. This is the quick card; `blueprint.md` is the full spec.

## The loop, start to finish

1. **Start the session with `/standup`.** Shipped / next / blocked, built from repo state (never memory). Agree the day's one priority.

2. **Pick ONE thin slice.** Smallest increment that delivers real value from the backlog. Before any code, it needs: a **measure of success** (the signal that tells us it worked), **acceptance criteria** (the checklist that defines done, including degenerate cases), and a **user story** ("As a \<user\>, I want \<goal\>, so that \<value\>") with a named customer outcome. Can't name them → refine the slice first.

3. **Default team = you + builder + at most ONE advisor.** The wider roster is the exception, reserved for work that genuinely splits into independent directions. One lens per question.

4. **The builder builds in a loop with a hard cap.** Build → verify in the REAL runtime → if a check fails, revise with specific feedback → max ~5 passes, then stop and escalate with the honest state. User-facing slices get an independent tester pass before you see them.

5. **Gate before merge.** Code-review always; security-review whenever the diff touches auth, sign-up, payments, or data access. Every "done" claim carries a **receipt from the last hop** or says plainly "verified through hop N, unverified beyond."

6. **Ship as a draft PR with the evidence block** (change → runtime verified on → the receipt). Merge only after the gate. Never straight to main without it.

7. **Close out.** Run any manual probes (tap the real app, test a real signup), tick the backlog entry, and record any external/dashboard change in `docs/infrastructure/`. An undocumented infra change is unfinished work.

## Who to ask (one lens per question)

| Question sounds like… | Ask |
|---|---|
| Build / fix / debug it | **builder** (the only hands) |
| Is this plan/claim actually true? | **red-teamer** |
| Is this worth building, and what's the smallest version? | **product owner** |
| Why do users stall here? | **behavioural scientist** |
| How do we get the next new user to value? | **growth hacker** |
| Is the domain data right? | **data steward** |
| Does this screen look right / design this page | **designer** |
| Independent UAT before I see it | **tester** |
| Could this leak or escalate? (design-time) | **security** |
| Pull the real number from prod | **data analyst** |
| Write it down durably | **documentation** |
| Turn a fuzzy ask into stories / a PRD | **business analyst** |

## Ceremonies (skills, run by the main session)

- **`/standup`**: every session start. No advisors; it's a sync, not analysis.
- **`/sprint-planning`**: each morning after standup.
- **`/sprint-review`**: end of each day (what shipped, receipts, measures read).
- **`/retro`**: when a day taught us something about process, landed in the repo.

## Rules that never bend

- **The repo is the only memory.** Sessions are stateless; anything not committed is lost.
- **Reality, never aspiration** in docs.
- **Receipts or it didn't happen.** A green check that stops before the last hop is a hypothesis.
- **Finish before switching.** New request mid-task → capture it, finish to a checkpoint, then pick it up.
- **Schema changes, new deps, force-pushes, irreversible ops → sign off first.** Narrow authorisation, not blanket.
