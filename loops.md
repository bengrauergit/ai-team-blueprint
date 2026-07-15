# Loops: where the system iterates, and the two rules that keep it honest

A straight-line process ships work; a looped process ships work that gets
better on its own. But loops are dangerous machinery in an agent system, so
two rules govern every loop in this blueprint:

1. **Loops must CLOSE.** A real loop returns signal to its own start:
   ship, measure, decide, ship better. A "loop" that only generates output
   (more PRs, more findings, more reports) is a queue in disguise, and every
   queue drains through the same bottleneck: the human owner's attention.
   Before adding a loop, name what comes BACK around, and who reads it.
2. **Loops must EXIT.** Every loop carries a bounded exit: a pass cap with
   honest escalation (the build loop stops at 5 and reports its failures),
   a collection window with a decision date (usage data: collect two weeks,
   then decide), or an event trigger that fires rarely by design. An
   unbounded loop is how agent systems burn budgets and trust.

## The loop stack (fastest to slowest)

| Loop | Cycle | Close signal | Exit |
|---|---|---|---|
| Red-green (TDD) | minutes | the check turns green | it turns green |
| Build-verify (`workflows/build-loop.js`) | hours | tester's schema verdict | 5-pass cap, escalate with failures |
| CI per PR | minutes | pass/fail on the diff | mechanical |
| Daily ceremony (standup, work, review) | 1 day | measures read against real numbers; two workflow ratios | the day ends |
| Roster measurement (usage log) | ~2 weeks | which agent seats earned their place | a named decision date |
| Retro | event-driven | a rule lands in a durable home, ideally a gate | only fires on a real lesson |

## Loops worth adding as a system matures

- **The product learning loop** (the compounding one): user behaviour feeds
  back into the model or defaults that shaped it. Close it through a
  reviewed path (a steward approves suggested changes; golden tests gate
  them), never by letting one loud user auto-tune shared state.
- **The overnight work loop**: a scheduled session picks the TOP groomed
  story only, runs the build loop under its caps, and leaves one PR for
  morning review. Guardrails that keep it a loop and not a flood: groomed
  stories only, one story per night, PR-only output, and a silent no-op
  when nothing is groomed. The owner's morning review is the close.
- **The growth loop**: share, arrive, sign up, share. Instrument every
  joint end-to-end BEFORE nudging it; an unmeasured growth loop is
  indistinguishable from noise.

## Loops deliberately NOT built

- Calendar-driven audit sweeps over hardened code (run them event-triggered
  on the diffs that introduce risk instead; a pilot run decides which).
- Ritual retros. A retro without a lesson produces ceremony, not process.
- Any new generator loop while the owner's review queue lacks headroom.
  The workflow ratios in the daily review are the headroom gauge.
