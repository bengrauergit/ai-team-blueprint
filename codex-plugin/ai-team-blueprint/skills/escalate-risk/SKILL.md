---
name: escalate-risk
description: Rate a spotted technical risk by impact and urgency and flag it to the product owner and human before it becomes a crisis.
---

# escalate-risk

Do not sit on a risk you have spotted. The whole value is flagging it EARLY,
while there is still time to adjust plans or resources.

## Steps

1. **Name the risk concretely:** the brittle code, the scaling bottleneck, the
   dependency vulnerability, the security issue, with its impact radius (what
   breaks, who is affected).
2. **Rate impact** (low / medium / high / critical) and **urgency** (can it wait
   a sprint, or is it now?). Ground both, do not inflate; a false alarm spends
   trust you will want later.
3. **Recommend a mitigation** proportional to the rating: a hotfix, a sprint
   investment, or an architectural change. Name the cost of doing nothing.
4. **Escalate** with a tight message to the product owner and human: what, how
   bad, how soon, and the recommended call.

## Output

A risk assessment (impact + urgency), a recommended mitigation with the cost of
inaction, and a clear escalation message. Not an essay: a decision-ready flag.
