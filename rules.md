# Operating Rules

These rules exist because something went wrong without them. Every one was born from a real mistake: a day lost, a bug shipped, a false confidence that cost real time. Add them to your project's `CLAUDE.md` to make them load-bearing.

---

## Establishing facts

- **Never state a conclusion drawn from a search alone.** A grep/search shows where a word appears, not what the code does. Finding a name is a clue, not proof that the behaviour exists. To claim "X happens", trace the actual path: does the function get called, with what inputs, on which route, and what does it do?

- **Confirm every factual claim with a specific check before stating it.** Read the call site, don't infer from the name. This applies before asking questions too: don't bake an unverified assumption into a question.

- **When unsure, say so explicitly.** "I haven't confirmed this yet" rather than presenting a guess as established fact.

## Delivery practices

- **Finish the task in progress before taking on a new one.** When a new request arrives mid-task, capture it durably (backlog, TODO, comment) so it can't be lost, finish the current task to a committed checkpoint, then pick up the new request. Exception: genuine emergencies (prod broken, data at risk), but say so explicitly.

- **Plan before non-trivial work.** Produce a plan (steps, critical files, trade-offs) and get sign-off before writing code.

- **Ship vertical slices.** Each change should be an independently shippable, reversible end-to-end path. No half-finished layers.

- **The Last-Hop Rule.** Before starting, name the full runtime chain from keyboard to the user's eyes. Nothing is "done" or "fixed" without a receipt from the LAST hop: a production log line, a query as the real role, the artifact rendered on the real surface. A green check that stops earlier is a hypothesis, never a verification.

- **Label every status: MEASURED-FACT vs INFERENCE.** "MEASURED: response time 142ms in prod logs at 14:03." "INFERENCE: so the caching layer is working, not yet confirmed under load." Never present an inference as a fact.

- **Verify in the real app.** For UI and user-facing flows, exercise the feature in a browser before calling it done. Tests prove code correctness, not behaviour.

- **Review gate before merge.** Run a code review on the diff, plus a security review for anything touching auth, payments, or data access. Nothing goes straight to main without the gate.

- **Commit and push at checkpoints.** Your dev environment is ephemeral; only pushed work is durable.

## Scope discipline

- **Smallest increment for maximum value.** Always ship the smallest slice that delivers real user value, then stop and review. Resist gold-plating and "while I'm here" scope creep. Park the extras in the backlog.

- **Measures of success.** For every increment, state up front a concrete, observable measure of success: the metric or signal that tells you it worked. If a measure can't be named, the increment is unclear. Refine it first.

- **Acceptance criteria before coding.** For each story, agree a short checklist that defines "done", including degenerate cases (empty lists, missing names, one/zero items).

## Cross-session memory

Sessions are stateless and environments are ephemeral. The only durable memory is what's committed to the repo.

- **Record every external/infra change in-repo, in the same piece of work.** Keep `docs/infrastructure/` current: DNS records, email paths, env vars, third-party setup. A dashboard change is unfinished until it's documented.

- **Before touching infrastructure, read docs/infrastructure/ first.** Don't reverse-engineer prod state from code when a record should already exist.

- **If you find undocumented infra state, write it down.** Leave the repo more knowable than you found it.

## User-facing content

- **Trace every link to where it actually lands for that recipient.** An organiser and an invitee often need different pages. Never infer the destination from a URL's name.

- **Render the degenerate cases.** Empty lists, missing names, one/zero items, not just populated sample data.

- **Don't self-certify a bulk copy change as "low-risk"** to skip the review gate. Wrong-destination and thin-data bugs hide exactly there.

## Migrations and risk

- **Apply schema changes on a branch first, test, then merge.** Never first-draft a migration straight to production. There's no undo on a dropped column.

- **Confirm before irreversible operations.** Dropped tables, force-push, deleted branches. Authorise narrowly, not blanket.

## Working with AI agents

- **One lens per question, never the panel.** Pick the one agent whose question matches. Don't convene the full roster. It produces the same advice in different jargon.

- **Default staffing: you + builder + at most one advisor.** Multi-agent work costs ~15x a single chat. Earn it.

- **Advisors advise; the builder builds.** Only one agent writes code. Everyone else is read-only.

- **Rules born from mistakes are not suggestions.** When a rule seems overly cautious, it's because something went wrong without it. The cost of the rule is lower than the cost of the mistake it prevents.

## Enforcement & measurement (added 2026-07-14, from a red-team audit of the running system)

- **A rule that must never slip does not belong in prose.** Put it in a hook, a CI step, or a database permission. An audit found our two hardest written rules ("never push to main", "migrations need sign-off") silently unenforced for weeks. The prose said one thing, the machine did another.

- **Verify every guardrail actually fires: run the failure case.** A guardrail you believe is on but isn't is worse than none. Test the hook with a dry-run push; probe the read-only connector with a write and watch the database refuse it. No receipt, no guardrail.

- **Know what your CI can and cannot enforce.** On plans without branch protection, CI is advisory: the human clicking merge is the real gate. Say so in your docs instead of claiming enforcement you don't have.

- **Inherited red vs new red must be checkable, not argued.** If a check is already failing on the base branch, isolate it in its own CI job (temporarily `continue-on-error`, loudly labelled, with an owner and an end date) so the blocking job's red is always NEW red. "It was already broken" must be a receipt, not a vibe.

- **Fetch before you trust local state; one stream per branch.** Parallel sessions ship fast: a 5-day-stale clone falsified an entire evidence-based review, and two streams sharing one branch caused three push races in an afternoon. `git fetch` before analysis; check `git log HEAD..origin/<branch>` before pushing; never let two streams own the same branch.

- **Measure the workflow itself, or process grows unchecked.** Two ratios, read in the existing review ceremony: (1) sprint-goal hit rate; (2) process-vs-product commit share. Our audit found 51% of a week's commits were process scaffolding on a product with only a handful of real users, visible only because someone went looking. Make the ceremony surface it automatically.

- **Measure before you elaborate the roster.** Log agent usage (a SubagentStop hook appending one line per run), collect ~2 weeks, THEN decide which seats earn their place. Rosters grow on vibes and never shrink on their own. Caution: keep the raw log out of shared branches, since parallel streams committing one append-only file is a conflict factory.

- **P1-first.** When a signed-off P1 exists, meta/process work starts only after an explicit "defer" from the owner. Measured failure mode: the day's P1 ran last and nearly missed the day while ops work ran first.

- **Prior-art check before any new deliverable.** Fetch, list branches, and grep for an existing version before building. In a multi-stream setup, assume someone may already have started it (two same-day collisions taught this).

- **Sanitise at birth, not by audit.** Anything published externally gets the no-personal-data/no-product-references sweep AND an anonymised git identity BEFORE the first push. Retro-fitting cleanliness cost a public-history rewrite; doing it at creation costs one checklist pass.

## Rules need landing spots and gates (added late 2026-07-14, from a second red-team pass)

- **A style or content rule without a gate is a suggestion.** A tree carried four merged violations of its own written copy rule, with nothing to catch them. Engineering rules get typecheck and CI; content rules deserve the same: a banned-pattern scan over marketing docs and copy-bearing source strings, wired into CI. Durable-by-test is the only durability that survives sessions.

- **Land every new rule the day it is learned, in a place that survives.** A rule living only in a PRD, a retro note, or one section of one doc is an orphan: the next consolidation drops it silently and nobody notices until it is violated. Two homes count: the always-loaded rules file, and a gate. Prefer both. Track unlanded rules in the backlog as first-class items.

- **Gate honestly.** When a new gate lands, fix the violations it finds in the same slice. If legacy content carries many, scope the gate to what is clean today and surface the counts as a decision for the owner. Never mass-edit live copy just to green a new gate.

## Red before green (test-driven, agent-side)

- **A bugfix without a test that failed first is a hypothesis.** The builder encodes the reproduction as a failing check BEFORE fixing, watches it turn green, and ships the check with the fix as its regression contract. The reviewer treats a bugfix diff arriving without its red-first check as incomplete, not as a style preference.

- **Acceptance criteria become executable checks in the same slice.** A criterion that cannot be encoded as a check is a grooming defect, not a testing gap; send it back to grooming. No new framework is required: lightweight check scripts and golden files are a fine harness, and the CI you already run picks new checks up automatically.

- **Zero ceremony for the owner.** The human writes acceptance criteria once (the grooming gate already requires that); the agents do the red-green-refactor. The only visible change is that PRs arrive carrying tests, with a red-to-green receipt in the evidence block.

## Loops close and loops exit

- **A loop that does not return signal to its own start is a queue in disguise.** Before adding one, name what comes back around and who reads it. Every loop carries a bounded exit: a pass cap with honest escalation, a collection window with a decision date, or an event trigger that fires rarely by design. Full taxonomy: `loops.md`.
