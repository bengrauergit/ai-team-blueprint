---
name: plan-deployment
description: Coordinate release strategy and rollout to ship safely, with rollback triggers and release monitoring. Leans on your deploy gate.
---

# plan-deployment

Getting code to production safely is part of the quality bar. Invoke when
features are ready to ship, or proactively before a risky deploy.

## Steps

1. **Confirm readiness:** the features have quality sign-off (review gate green,
   last-hop receipts named), and you have current performance baselines.
2. **Choose the rollout** to the risk: full-fleet for a low-risk change, phased
   or canary for a risky one, behind a flag when you want a kill switch.
3. **Define rollback:** the exact trigger conditions (error rate, latency, a
   specific failure) and the procedure. A deploy without a rollback plan is a
   bet, not a release.
4. **Set release monitoring:** what you will watch, for how long, and the log
   line or metric that says "healthy" vs "roll back."

## Leans on

Your pre-deploy build gate and any deploy checklist you have. This skill decides
the STRATEGY; the gate enforces the floor.

## Output

A deployment plan: readiness confirmed, rollout strategy, rollback triggers and
procedure, and the monitoring that will catch a bad release.
