# Variant: stlaaaag

Six of the templates in `agents/templates/`, as they actually ran for one user
between 8 July and 13 August 2026, plus what the usage log says about them.

Nothing here replaces anything. These are additive copies for cherry-picking.
Where the upstream template has since moved ahead of this variant, that is said
below.

## Provenance and scope

Taken from a pre-publication copy of these templates around 8 July 2026, which
is before this repo's first commit on 14 July, so this variant forked earlier
than the public history and has drifted since.

The context is largely non-software: documents, strategy decisions and small web
interfaces rather than a codebase with a running test suite. So the evidence
below is strongest on prose, decisions and UI, and weakest on the parts of the
blueprint that assume tests, CI and a deploy pipeline.

Naming: each template was given a human first name, because "@jackson red-team
this" is a thing you type without thinking and "@red-teamer" is not. One carries
a prefix rather than a bare first name. Its original name collided with a human
who appeared in the same prompts and it was ambiguous within a day, so prefix
any agent whose name could also belong to someone in the room.

## What the log says

53 invocations, reconstructed by parsing local session transcripts and
de-duplicating. Worth noting that this reconstruction was only necessary
because `hooks/subagent-log.sh` was not installed. The rule in `rules.md`
("measure before you elaborate the roster") is correct and this variant learned
it the slow way.

| Variant | Template | Calls | Share |
|---|---|---:|---:|
| jackson | red-teamer | 22 | 42% |
| bens-nikhil | behavioural-scientist | 18 | 34% |
| sylvia | product-owner | 9 | 17% |
| brendan | builder | 3 | 6% |
| taichi | growth-hacker | 1 | 2% |
| glyndon | data-steward | 0 | 0% |

Two seats do three quarters of the work.

## The finding worth reading: the gatekeeper starves, again

`rules.md` carries a measured lesson from this repo's own running system: zero
product-owner invocations in the rule's first week, because an unscoped "at
most one advisor, multi-agent is expensive" economy rule beat the routing rule
every tie, so the gatekeeper silently never spawned.

This variant reproduces that independently, without the economy rule being
written down anywhere. The product owner took 17% of calls and the red-teamer
42%. The pattern is consistent: work arrived already framed as a thing to
critique, and the seat that frames work got skipped in favour of the seat that
attacks it. Nobody decided this. It is just that "pressure-test this" is an
easier thought to have than "should this exist".

So the failure mode does not need a competing economy rule to appear. A cheap,
obvious, satisfying seat will outcompete the gatekeeper on its own. The
receipt requirement in `rules.md` (her framing, from her own spawn, quoted in
the story) looks like the right fix, and it is a stronger fix than this variant
had.

## Per variant: what changed, and whether it is worth pulling back

**jackson (red-teamer), 3.7KB upstream to 9.6KB here.** The biggest divergence
and the one most worth reading. Added: form your own view before dissecting
theirs, as an anti-sycophancy anchor, on the reasoning that a critic who starts
from the plan's framing ends up politely agreeing with it. Judging discipline:
set the rubric before ranking, re-run close calls with the order reversed,
grade every finding BLOCKER / MAJOR / MINOR. Eight strategy lenses applied two
at a time rather than as ceremony (Rumelt's kernel, pre-mortem, outside view,
opportunity cost, unit economics, one-way versus two-way doors, second-order
effects, where to play). A live-check rule. And a closing "what would change my
mind", on the grounds that a verdict nothing could flip is dogma. Worth pulling
back.

**brendan (builder), 10.4KB upstream to 13.4KB here.** One section the upstream
template does not have by heading: production access rules, drawn as an
explicit line. Read-only SQL, logs and deployment metadata are free and should
be used proactively as verification receipts. Writes, migrations against the
remote, env vars and dashboard settings are never direct. Possibly worth
pulling back as a block. The rest of the divergence is mostly restatement, and
upstream's six pillars and seven skills are ahead of this copy.

**bens-nikhil (behavioural-scientist), taichi (growth-hacker), glyndon
(data-steward).** Each gained a Minto deliverable section (lead with the
single biggest barrier or leak, then the grouped findings) and explicit hand-off
routing to the other seats. Modest but real: the hand-off lines are what stop
one seat answering a question that belongs to another. Low risk to pull back.

**sylvia (product-owner), 9.6KB upstream to 7.5KB here.** This variant is
BEHIND. Upstream has since grown the eight pillars, the GTD intake rhythm, the
orchestration hub and the invocable skills, none of which are here. Do not pull
this one back. It is included only so the set is complete and the usage number
above has something to point at.

## Two more failure modes, from the same log

**Over-invocation, unsignalled.** The red-teamer will produce a confident
critique of anything he is pointed at. Aimed at a routine cleanup task with
nothing in it to argue with, he still returned a verdict, and the reaction was
that this was a bad use of the seat. He never signalled that the invocation
itself was wrong. A line telling him to say "this does not need me" would pay
for itself, and the same line probably belongs in every advisor.

**Convening the panel.** Three or four seats on one question mostly returns one
piece of advice in four dialects at four times the cost. The builder template
already warns against this and it is the warning most often ignored, including
by the user who wrote the warning into his own copy. The one clear
counter-example in 53 calls was one document that genuinely had a numbers face,
a scope face and a reader face, where three seats in sequence each found
something the others did not. That is the exception, not the pattern.

**A use that is documented nowhere.** Adjudicating someone else's review
comments. Given a few dozen review comments across two documents, the red-teamer
sorted them into accept, push back and defer with a reason each. It turned a
demoralising pile into a tracker that was worked through in one sitting. This
is one of his best uses and it appears in no description field.

## The tuning lesson that cost the most

The red-teamer is slow and token-hungry. Opus at high effort, and a real
red-team is minutes. The obvious fix was tried and it was wrong: cap him at the
top two to four assumptions, cap output around 600 words, drop the Minto skill.
The user's response, which is the useful part:

> I think you nerfed him too hard. He is known for being really thorough. He'd
> do the deep research and check all the documents. But yes, efficiently.

The rule that came out of it:

> Buy speed with mechanics, never with coverage. Parallel tool calls, skim the
> structure then deep-read only what matters, do not re-verify a fact that
> arrives with a receipt, weight depth by stakes times doubt. Never cap the
> number of assumptions checked and never cap output length.

The cost dial that does work is model tier. Sonnet for routine passes, Opus for
decisions that matter. That costs no coverage.

## Note on style

These copies were converted to this repo's house style: em-dashes replaced with
commas, colons and full stops so `scripts/copy-style-check.sh` passes on the
whole tree. The conversion was verified to change punctuation only. No other
edits were made to the files as they ran.
