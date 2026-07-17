# Production-readiness: a checklist your reviewer walks, not a new agent

The common complaint about AI-written code is that it works but is not
production grade. The instinct is to hire a "production-readiness agent". Do
not. Ask the litmus question first: what would that persona know that your
existing reviewer does not? Nothing. What is missing is not a reviewer, it is
a CHECKLIST for the reviewer you already have, and a trigger telling them when
to walk it.

Copy this into your repo, adapt the sections to your stack, and point your
reviewer's health-sweep remit at it.

## Order it robustness-first, scale-last

Ordering is the whole design. Most projects are not traffic-bound, and at a
small user base a caching layer buys nothing while a swallowed error silently
drops a user's data forever. So: failures that corrupt or silently lose things
outrank anything about load, and the scale section sits last with an explicit
note about when it is allowed to matter.

Every finding carries a concrete failure scenario or a measurement, and lands
as a proposed backlog entry, never an essay.

## A. Silent failure (highest value first)

- [ ] Every external call has a timeout, and its failure path is LOUD: a
      structured log line a human can find, never a swallowed catch.
- [ ] Known silent-drop paths are enumerated and ticketed.
- [ ] Scheduled jobs fail visibly: a run that throws is distinguishable in
      logs from a run that correctly did nothing.
- [ ] User-visible error states exist for the failure paths users can hit.

## B. Idempotency and re-entry

- [ ] Scheduled jobs are safe to run twice (your platform will retry them):
      guards against double-sending, upserts where re-runs are possible.
- [ ] Webhook and callback handlers tolerate duplicate and out-of-order
      delivery.
- [ ] Tokens and links: single-use where the copy CLAIMS single-use, expiry
      actually enforced, replay considered. (A real finding from our own
      sweep: the email said "can only be used once" while the token was a
      stateless signature, replayable until expiry. The honest fix was the
      copy, not a token table.)

## C. Data integrity and access

- [ ] Row-level security verified AS THE REAL ROLE, not from a service
      context. Documented exceptions stay documented and greppable.
- [ ] Your database's own advisors (security and performance lints) read and
      triaged; zero un-triaged criticals is the standing bar. This is the
      mechanical half of the checklist, so automate the read into a ceremony.
- [ ] Schema changes go through a branch with sign-off; destructive
      operations have a stated recovery path.

## D. Input hardening (the public surfaces)

- [ ] Public endpoints validate and bound their inputs: length caps, type
      checks, rejection logging.
- [ ] Rate limiting on anything that SENDS (email, SMS) or writes from
      anonymous traffic. Enumerate the gaps you are accepting.
- [ ] Anything fetching remote URLs is SSRF-aware: allowlisted hosts, no
      internal-address fetches, response size caps.

## E. Observability floor

- [ ] Every production surface can answer "did it work last night?" from logs
      alone. A self-test line on the risky path is the cheap pattern.
- [ ] A greppable error-prefix convention exists, so "show me every failure
      this week" is one query.

## F. Scale (deliberately last)

Revisit when traffic is genuinely the constraint. Until then, findings here
need exceptional evidence to outrank sections A to E.

- [ ] Unbounded queries on tables that grow.
- [ ] N+1 patterns on hot paths, measured rather than guessed.
- [ ] Per-request re-initialisation of heavy resources that could live at
      module scope.
- [ ] Third-party quota ceilings documented with headroom estimates.

## Cadence: event-triggered, not calendar

Our pilot ran this over a mature codebase and found two net-new items in a
tree that was already well hardened. A monthly sweep would mostly re-read
hardened code. The trigger that earns the walk: **a diff that adds a new
scheduled job, a new external-call site, or a new public endpoint.** Wire that
trigger into your review gate. That is exactly where the drift enters: the
pilot's one real finding was a new job that had not copied the guard its seven
siblings all had.
