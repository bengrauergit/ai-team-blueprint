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
| ANY product input (idea, complaint, request, "should we build this?") | **product owner** (the gatekeeper: all product work routes here first) |
| Build / fix / debug it, or "what's the right architecture / what does it cost" | **builder / engineering lead** (the only hands) |
| Is this plan/claim actually true? | **red-teamer** |
| Independent code review of a pushed diff before merge | **reviewer** (never the diff's author) |
| Why do users stall here? | **behavioural scientist** |
| How do we get the next new user to value? | **growth hacker** |
| Is the domain data right? | **data steward** |
| Does this screen look right / design this page | **designer** |
| Independent UAT before I see it | **tester** |
| Could this leak or escalate? (design-time) | **security** |
| Pull the real number from prod | **data analyst** |
| Write it down durably | **documentation** |
| Turn a fuzzy ask into stories / a PRD | **business analyst** |

## Ceremonies (skills, run by the main session; the product owner owns cadence)

Two a day, not four (measured: four was overhead a solo owner never amortized).

- **`/standup`**: every session start. The sync (shipped / next / blocked) AND
  planning the day, merged. Grooming is a gate inside it, not a separate ceremony.
- **`/sprint-review`**: end of each day (what shipped, receipts, measures read,
  plus two workflow-health ratios: sprint-goal hit rate, process-vs-product split).
- **Weekly outcome review**: the product owner reads whether recent slices
  actually moved their outcome metrics, the read a one-day sprint cannot give.
- **`/retro`**: event-driven, only when a day taught a real process lesson. Land
  it in a durable home, ideally a gate.

## Rules that never bend

- **The repo is the only memory.** Sessions are stateless; anything not committed is lost.
- **Reality, never aspiration** in docs.
- **Receipts or it didn't happen.** A green check that stops before the last hop is a hypothesis.
- **Finish before switching.** New request mid-task → capture it, finish to a checkpoint, then pick it up.
- **Schema changes, new deps, force-pushes, irreversible ops → sign off first.** Narrow authorisation, not blanket.
