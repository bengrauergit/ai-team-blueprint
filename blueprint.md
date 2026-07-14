# Agent System Blueprint

A system for orchestrating a team of AI agents as a full delivery squad. Each agent has a narrow job, defined tools, and explicit constraints. The system is designed so that no single agent can confidently ship something wrong: adversarial checks, evidence requirements, and bounded loops catch the failure modes that burn days.

## Architecture

**The orchestrator is the main session**: you, talking to Claude Code. You brief agents, synthesise their outputs, and make the calls. For deterministic multi-agent work, Claude Code's native **Workflow tool** fans out `agent()` calls in parallel or pipeline with schema-validated outputs and budget guards.

There is no standing "orchestrator agent." Orchestration is your job. Agents are specialists you invoke one at a time for their specific lens.

## The default staffing rule

**Default: you + the builder + at most ONE advisor.**

Multi-agent work (workflows, panels, parallel streams) is the exception, justified only when the work genuinely decomposes into independent directions AND is worth roughly 15x the token cost of a single-agent chat. If you can't name what decomposes, don't decompose it.

## Roster: standing agents

| Role | Kind | Model tier | Writes? | One-line remit |
|---|---|---|---|---|
| **Builder** | Builder | Mid (Sonnet) | **Yes**: branch + PR, review-gated | The ONLY builder. Ships slices with evidence blocks; bounded build loops. |
| **Red-teamer** | Advisor | High (Opus) | No | Adversarial review of plans, diagnoses, and major decisions before commitment. |
| **Product owner** | Advisor | Mid (Sonnet) | No | Outcomes, measures of success, thinnest valuable slice, ruthless priority. |
| **Business analyst** | Advisor | Mid (Sonnet) | No | Grooms fuzzy asks into build-ready user stories with acceptance criteria. |
| **Behavioural scientist** | Advisor | High (Opus) | No | Why humans stall; barriers and friction; ranked interventions. |
| **Growth hacker** | Advisor | Mid (Sonnet) | No | New-user acquisition/activation, Day 0–2, smallest experiments. |
| **Data steward** | Advisor | Low (Haiku) | No | Domain data accuracy; adapt this agent to YOUR domain. |
| **Designer** | Advisor | Mid (Sonnet) | No | Visual/interaction review + proposals; browser-driven visual testing. |
| **Tester** | Specialist | Low (Haiku) | No (runs app, edits nothing) | Independent UAT vs acceptance criteria; can't sign off on failures. |
| **Security** | Advisor | High (Opus) | No | Access-control, leak, and escalation red-team. The security-review skill stays the merge gate. |
| **Data analyst** | Advisor | Mid (Sonnet) | No (SELECT-only) | The numbers lens: live counts, funnel walks, cost counting. |
| **Documentation** | Specialist | Low (Haiku) | Yes: docs/ only | Keeps repo docs true; reality, never aspiration. |

### Invoke-only lenses (not standing agents)

For questions that arise occasionally, spawn an ad-hoc agent with a focused prompt rather than maintaining a standing agent:

- **Chief strategy**: direction reviews, competitor moves, pivot questions
- **Finance**: unit-economics models, runway framing (routine cost counting goes to data-analyst)
- **Copywriter**: per-slice copy tasks

## Load-bearing rules

These survive every version of the blueprint. They are not optional.

1. **One lens per question, never the panel.** Pick the one agent whose question matches. Tie-breaks are written in each agent's "when NOT to use me" section.

2. **Advisors are read-only; the builder is the only one who writes code.** Narrow exceptions: documentation writes under `docs/` only; tester runs the app and suites but edits nothing.

3. **Every agent reads the project context file first.** Create a `docs/agents/context.md` with canonical facts about your project (stack, runtimes, known gotchas). Agents read it before starting: no one should be briefed on facts that are already written down.

4. **Merges go through the review gate.** Code-review always; security-review for anything touching auth, payments, or data access. Nothing is done without a last-hop receipt.

## Model tiers and escalation

Default tiers:
- **Opus**: red-teamer, behavioural scientist, security (deep reasoning, adversarial work)
- **Sonnet**: builder, product owner, growth hacker, designer, data analyst, business analyst (everyday work)
- **Haiku**: data steward, tester, documentation (narrow, well-scoped tasks)

**Escalation is a posture, not a rarity.** The per-invocation `model` param overrides the default. Architecture-heavy builds should spawn the builder on Opus. Full multi-source audits should spawn the data steward on Opus. An agent can't switch models mid-task. It names the need and you re-spawn it.

**Extended thinking vs model tier:** The reasoning depth knob is the `effort` frontmatter field (low → max), orthogonal to model tier. Set `effort` when an agent needs deeper reasoning without changing model.

## The canonical build loop

The builder builds, the tester returns a schema-validated verdict, bounded at 5 passes:

```
1. Builder receives the brief + completion criteria
2. Builder implements and self-verifies on the REAL runtime
3. Tester runs independent UAT against acceptance criteria
4. If pass → done (with receipts)
5. If fail → builder gets specific feedback, tries again
6. After 5 passes → escalate to you with the honest state
```

Every "done" carries an **evidence block**: what changed → runtime verified on → the concrete receipt (log line, screenshot, query result). No receipt, no "done."

## Ceremonies (skills the main session runs)

| Ceremony | Cadence | What happens |
|---|---|---|
| `/standup` | Start of each session | Shipped / next / blocked, built from repo state |
| `/sprint-planning` | Each morning | Pick the thin slice, groom it build-ready, agree the measure |
| `/sprint-review` | End of each day | What shipped, receipts, measures read against real numbers |
| `/retro` | After a process learning | What worked, what didn't, land the learning in the repo |

A sprint is one working day. Plan in the morning, review at day's end. Retro stays judgement-based: after a day with a real learning, not ritually every evening.

## Orchestration: when multi-agent work IS justified

When the work genuinely decomposes into independent directions, author a **Workflow**, Claude Code's native tool for deterministic multi-agent scripts:

### How to author an orchestration

1. **Establish state from the repo** (backlog, branches, PRs), never from memory.
2. **Decompose into questions**, one lens each. If three advisors would get the same question, the question is fuzzy. Sharpen it.
3. **Partition parallel streams by non-overlapping file ownership.** Name the hazard files (lockfiles, config, migrations) that force sequencing.
4. **Order by dependency and risk.** The cheapest check that could kill the plan runs first.
5. **Give every multi-pass task checkable completion criteria** and a ~5-pass loop cap. Evaluate each pass against the criteria, return specific feedback, and escalate at the cap with the honest state.
6. **Name the convergence points**: where outputs merge, where you sign off, where the review gate sits.

## Persistent memory

Agents that benefit from cross-session memory (growth hacker, behavioural scientist, data analyst) get memory files at `docs/agents/memory/<name>.md`: what was tried, outcome, takeaway, newest first. The agent reads its file at start and returns a proposed entry; the main session appends it.

File-based, repo-committed memory is a deliberate choice: entries are git-reviewed, survive ephemeral containers, and never write outside the review gate.

## Tool access by role

| Agent | File access | Web search | Prod data (read) | Browser | Writes |
|---|---|---|---|---|---|
| Builder | read + write | yes | yes | yes | code (branch + PR) |
| Red-teamer, Product owner | read | yes | yes | no | none |
| Behavioural scientist, Growth | read | yes | yes | no | none |
| Designer | read | yes | no | yes (screenshots) | none |
| Tester | read | no | no | yes (runs flows) | none |
| Data analyst | read | no | yes (SELECT-only) | no | none |
| Security | read | yes | yes | no | none |
| Documentation | read + write | no | no | no | docs/ only |

## Security and data safety

- Reach your database via scoped API keys, never personal credentials. Secrets in environment variables, none hardcoded.
- Granular permissions: builder gets write access to code tables; analysts get read access for validation. Nobody gets billing or personal data.
- The security agent reviews what each agent can touch.
- Schema changes go on a database branch first, tested, then merged, never first-drafted onto production.
