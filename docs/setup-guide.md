# Setup Guide — Claude Code

Step-by-step instructions to set up the AI team blueprint in your project using Claude Code.

## Prerequisites

- [Claude Code](https://claude.ai/code) installed (CLI, desktop app, or web app)
- A git repository for your project

## Step 1: Create the agent directory

Claude Code looks for agent definitions in `.claude/agents/` in your project root.

```bash
mkdir -p .claude/agents
```

## Step 2: Copy the agent templates

Copy the agent templates you want to use into your project:

```bash
# Copy all agents
cp agents/templates/*.md .claude/agents/

# Or just the essential three to start
cp agents/templates/builder.md .claude/agents/
cp agents/templates/red-teamer.md .claude/agents/
cp agents/templates/product-owner.md .claude/agents/
```

**Start with three agents.** The builder, red-teamer, and product owner are the minimum viable team. Add others as you need them.

## Step 3: Adapt the agents to your project

Each agent template has comments showing what to customise:

1. **builder.md** — Update the runtime map with YOUR specific runtimes and verification methods. Where does your code actually execute? What proves it's working there?

2. **data-steward.md** — This is a TEMPLATE. Replace the domain with yours (the original tracked surf forecast accuracy). If you don't have domain data to steward, skip this agent.

3. **All agents** — Add your project's MCP tools to each agent's `tools:` frontmatter if you use Supabase, Vercel, GitHub, or other connected services.

## Step 4: Add the rules to CLAUDE.md

Create or update your project's `CLAUDE.md` (the file Claude Code reads for project instructions):

```bash
# If you don't have a CLAUDE.md yet
cp rules.md CLAUDE.md

# Or append to an existing one
echo "" >> CLAUDE.md
cat rules.md >> CLAUDE.md
```

## Step 5: Create the project context file

Create `docs/agents/context.md` with canonical facts about your project — every agent reads this first:

```bash
mkdir -p docs/agents
```

Write a context file with:
- **Stack** — what technologies, what versions
- **Runtime map** — where code actually executes (bundler, deploy target, renderer, delivery surface)
- **Known gotchas** — things that have burned time before
- **Current state** — user count, stage, constraints

## Step 6: Set up the backlog

Create a `BACKLOG.md` in your project root:

```markdown
# Backlog

## Current sprint
<!-- Today's work goes here -->

## Prioritised backlog
<!-- Ordered by value, groomed entries have user stories + acceptance criteria -->

## Icebox
<!-- Ideas parked for later -->
```

## Step 7: Start using the team

### Daily workflow

1. **Start with standup:** Ask "what shipped, what's next, what's blocked?"
2. **Pick one thin slice** from the backlog
3. **Invoke the builder** to implement it
4. **Before any significant decision**, invoke the red-teamer
5. **Before merging**, run code-review (and security-review for auth/data changes)

### How to invoke an agent

In Claude Code, reference an agent by name:

```
Ask @red-teamer to pressure-test this plan before we build it
```

Or describe what you need and Claude Code will suggest the right agent based on the descriptions in the agent files.

### The one-lens rule

Pick ONE agent per question. Don't ask three agents the same thing — it produces the same advice in different jargon. The "when NOT to use me" section in each agent file has the tie-breaks.

## Customising further

### Adding MCP tools

If you use Supabase, Vercel, or other services with MCP connectors, add the tool names to each agent's `tools:` frontmatter. Example:

```yaml
tools: Read, Grep, Glob, Bash, WebSearch, WebFetch, mcp__Supabase__execute_sql, mcp__Supabase__list_tables
```

### Changing model tiers

Each agent has a `model:` field in its frontmatter. The defaults:
- `opus` — for agents that need deep reasoning (red-teamer, security, behavioural scientist)
- `sonnet` — for everyday work (builder, product owner, growth, designer, analysts)
- `haiku` — for narrow, well-scoped tasks (tester, documentation, data steward)

Override per-invocation when needed — spawn the builder on Opus for architecture-heavy work.

### Adding ceremony skills

The blueprint references `/standup`, `/sprint-planning`, `/sprint-review`, and `/retro` skills. These are custom skills you can create in `.claude/skills/`:

```bash
mkdir -p .claude/skills/standup
# Create .claude/skills/standup/SKILL.md with the skill definition
```

See `skills/examples.md` in this repo for example skill definitions.

### Persistent agent memory

For agents that benefit from cross-session memory (growth hacker, behavioural scientist):

```bash
mkdir -p docs/agents/memory
```

Add to the agent's prompt: "At start, read `docs/agents/memory/<your-name>.md`. At end, return a proposed memory entry (what was tried, outcome, takeaway)." The main session appends it.
