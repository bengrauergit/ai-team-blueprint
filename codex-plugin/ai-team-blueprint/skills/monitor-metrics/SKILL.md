---
name: monitor-metrics
description: Track outcome metrics after a slice ships and run objective loops until the threshold is hit or a pivot is decided.
---

# monitor-metrics

Shipping is not the finish line; moving the outcome is. Stay close to the metric
after planning and drive toward the threshold, or decide honestly to pivot.

## Steps

1. **Read the metric against its threshold.** Pull the actual number (live query,
   not recall) for the outcome the slice was meant to move, and compare to the
   baseline and success threshold set at planning.
2. **If met:** record the win and the learning; feed it forward into
   prioritisation.
3. **If not met:** run an objective loop. Ask discovery/data what we are
   learning and engineering what can be tweaked; make the smallest change; re-read.
4. **Bound the loop.** Continue until the objective is hit OR a deliberate pivot
   is decided. Do not loop forever on a metric that will not move; a pivot is a
   valid, honest exit.

## Leans on

This is the objective-loop pattern. Use your repo's loop engine and an HONEST
evaluator (never a proxy metric): a loop pointed at the wrong gate optimises the
wrong thing. The human owns the irreversible decisions (kill, pivot, re-scope).

## Output

The metric read against its threshold, and either a recorded win, a specific
next tweak, or a reasoned pivot.
