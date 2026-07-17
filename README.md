# AI Team Blueprint

A complete system for orchestrating a team of AI agents to build software like a full delivery squad. Solo.

This blueprint was developed while building a production web app solo over ~10 weeks: 300+ shipped pull requests, tens of thousands of lines of production code, one person. The speed came not from the AI itself, but from the system around it: the roles, the rules, the ceremonies, and the adversarial checks that stop bad ideas before they ship.

## What's in here

```
├── blueprint.md              # The full agent system design
├── rules.md                  # Operating rules (born from real mistakes)
├── sop.md                    # One-page standard operating procedure
├── agents/
│   └── templates/            # Ready-to-use agent definitions
│       ├── builder.md        # Builder + Engineering Lead: the only one who writes code, owns quality + trade-offs
│       ├── red-teamer.md     # The devil's advocate, kills bad ideas
│       ├── reviewer.md       # Independent pre-merge review + codebase-health sweeps
│       ├── product-owner.md  # Gatekeeper for all product work: JTBD, evidence, prioritisation, the hub
│       ├── behavioural-scientist.md
│       ├── growth-hacker.md
│       ├── data-steward.md   # Domain data quality (adapt to your domain)
│       ├── designer.md
│       ├── tester.md
│       ├── security.md
│       ├── data-analyst.md
│       ├── business-analyst.md
│       └── documentation.md
├── loops.md                  # Where the system iterates: loops close, loops exit
├── prod-readiness-checklist.md  # Production-grade code: a checklist, not a new agent
├── skills/                   # Invocable skill templates (one dir each) + ceremony examples
│   ├── examples.md           # Ceremony skills (standup, sprint review, weekly outcome review, retro)
│   ├── po-intake/ ... /monitor-metrics/          # 6 product-owner skills
│   └── design-architecture/ ... /orchestrate-team/  # 7 engineering-lead skills
├── hooks/                    # ENFORCEMENT: hooks + settings template + hard-won rules
│   ├── README.md             # Why enforcement beats prose (start here)
│   ├── settings-template.json# .claude/settings.json pattern (track it in git!)
│   ├── pre-commit-check.sh   # Blocks `git commit` when your fast gate fails
│   ├── subagent-log.sh       # Measures which agent seats earn their place
│   └── pre-push              # Blocks direct pushes to main
├── ci/
│   └── ci.yml                # CI gate template + the honesty policies that keep it real
├── workflows/
│   └── build-loop.js         # Registered build→independent-UAT loop, 5-pass cap
└── docs/
    └── setup-guide.md        # Step-by-step setup for Claude Code
```

## The core idea

Stop using "an AI." Orchestrate a **bench of AIs**: each with a narrow job, real rules, and adversarial checks.

The system has four layers:

1. **Agents**: specialist roles with defined responsibilities, tools, and constraints. One builder / engineering lead (writes code, owns technical health). Many advisors (read-only). One red-teamer whose only job is to prove the plan wrong. Two agents sit at the centre: the **product owner** is the single entry point for product work (what and whether), and the **builder** is its technical partner (how and what it costs).

2. **Rules**: operating principles born from real mistakes. "Nothing is done without a receipt from production." "Never state a conclusion from a search alone." These prevent the failure modes that burn days.

3. **Ceremonies** are two lightweight rituals a day, not four: `/standup` (sync + plan the day, merged after we measured that separate standup/planning ceremonies were overhead a solo dev never amortized) and `/sprint-review` (what shipped, measures read against real numbers); `/retro` only when a day taught a real process lesson.

4. **Enforcement**: hooks, CI, and source-level permissions for every rule that must never slip (see `hooks/README.md`). Prose rules drift; shell scripts don't. And measurement: the system logs its own agent usage and reads two workflow ratios (sprint-goal hit rate, process-vs-product commit share) so process growth stays visible and evidence-based.

## The key insight

AI amplifies good process and ruthlessly exposes bad process.

A single AI agent will confidently give you the wrong answer and agree with whatever you already think. The fix isn't a better model. It's a better system:

- A **red-teamer** that challenges every significant decision before you commit
- A **product owner** that gatekeeps every product ask through evidence, framing, and ruthless prioritisation
- A **builder / engineering lead** that must prove every "it works" claim with evidence from the real runtime, and surfaces the technical trade-offs out loud
- **Rules** that force honesty: label every claim MEASURED-FACT or INFERENCE

## Quick start (Claude Code)

1. **Clone this repo** into your project or copy the files you need:

   ```bash
   git clone https://github.com/[your-username]/ai-team-blueprint.git
   ```

2. **Copy agent templates** into your project's `.claude/agents/` directory:

   ```bash
   mkdir -p .claude/agents
   cp ai-team-blueprint/agents/templates/*.md .claude/agents/
   ```

3. **Add the rules** to your project's `CLAUDE.md` (or create one):

   ```bash
   cat ai-team-blueprint/rules.md >> CLAUDE.md
   ```

4. **Adapt the agents** to your domain:
   - Rename them if you like (the names are just identifiers)
   - Update `data-steward.md` for YOUR domain (it's a template; the original was built for a niche forecasting domain)
   - Add your project's MCP tools to each agent's `tools:` frontmatter
   - Read `blueprint.md` for the full system design

5. **Start using them:**
   - Ask a question → invoke the matching agent (one lens per question)
   - Before a significant decision → invoke the red-teamer
   - Before merging → run the code-review and security-review skills
   - Default team: you + the builder + at most one advisor

## Quick start (Codex)

The Codex-native solution lives in two parts:

- `codex/project-template/`: `AGENTS.md`, custom agents, project context,
  backlog, Git hooks, and CI templates to copy into a project.
- `codex-plugin/ai-team-blueprint/`: installable skills and Codex lifecycle
  hooks, including the bounded builder-to-tester loop.

Install the project template without overwriting existing guidance:

```bash
sh codex/install.sh /absolute/path/to/your/project
```

Then adapt the context, fast check, CI commands, and domain data steward before
using the team. See [`docs/codex-setup-guide.md`](docs/codex-setup-guide.md) for
the complete walkthrough and Codex-specific trade-offs.

## What makes this different from "just use AI"

| Without the blueprint | With the blueprint |
|---|---|
| AI agrees with whatever you say | Red-teamer kills bad ideas with evidence |
| "It works" means "it compiled" | "It works" means "here's the production receipt" |
| Scattered prompts, context bloat | Structured ceremonies, one lens per question |
| AI hallucinates confidently | Every claim labelled MEASURED-FACT or INFERENCE |
| Scope creep, gold-plating | Thinnest valuable slice, park the rest |
| No memory between sessions | Rules and docs in the repo: the only thing that persists |

## Principles

- **Default staffing: you + builder + at most one advisor.** Multi-agent work is the exception: it costs ~15x a single chat. Earn it.
- **One lens per question.** Don't convene the panel. Pick the one agent whose question matches.
- **Advisors advise; the builder builds.** Only one agent writes code. Everyone else is read-only.
- **Rules are born from mistakes.** Every rule in `rules.md` exists because something went wrong without it.
- **The repo is the only memory.** Sessions are stateless. Anything not committed is lost.

## Adapting to your stack

This blueprint is stack-agnostic. The original was built on Next.js + Supabase + Vercel, but the agents, rules, and ceremonies work with any stack. The key adaptations:

1. **Update the builder agent** with your specific runtimes and verification methods
2. **Update the data-steward agent** for your domain (or remove it if you don't have domain data)
3. **Add your MCP tools** to each agent's tool list
4. **Customise the rules**: keep the principles, adapt the specifics to your stack

## License

MIT. Use it, adapt it, share it.
