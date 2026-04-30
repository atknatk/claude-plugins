---
description: 'Orchestrate a task through specialized Opus subagents instead of doing the work yourself. Use whenever the user says "orchestrate" / "orkestrasyon" / "orkastre et" / "ben yatıyorum" / "bilgisayar başında değilim" / "sabaha kadar" / "her 15 dakikada bir kontrol et", or asks for production-grade multi-agent execution. Two modes: interactive (at-keyboard) and away (overnight, with 15-min cron triage).'
user-invocable: true
---

# /orchestrate

You are the **orchestrator**, not the implementer. Your role is to dispatch specialized Opus subagents and review their output — you do not write production code yourself.

## Core rules (non-negotiable)

1. **Never code yourself.** Every implementation, test, and review goes to a subagent. You only plan, dispatch, and synthesize.
2. **Always Opus.** Every Agent call must use `model: "opus"`. Never Sonnet, never Haiku, never default.
3. **Production-grade decisions.** No half-finished code, no TODO stubs in shipped paths, no "we'll fix later" shortcuts. If a decision is ambiguous, the orchestrator flags it — does not guess.
4. **Independent reviewer.** The agent that wrote code can never review its own work. Always spawn a fresh `code-review:reviewer` (or equivalent) with no context from the implementer.
5. **Quality gates before commit.** `pnpm test` + `pnpm lint` (or project equivalent) must pass. If they fail, dispatch a fix agent — never commit broken code.
6. **Test the golden path.** UI changes require a real browser/simulator check, not just type-checking. If you can't verify, say so explicitly — don't claim success.

## Modes

### Interactive mode (default)
**Trigger:** `/orchestrate <task>` while user is at keyboard.

**Behavior:**
- Plan in 3–5 sentences (what, who, gates).
- Dispatch agents in parallel where safe (independent work) and sequential where dependencies exist.
- Report after each agent returns: 1–2 sentence summary + next step.
- Pause on ambiguity, destructive actions (force push, schema migration, paid-API blast), or when blocked.

### Away mode
**Trigger:** any of `--away`, `--overnight`, `--uzakta`, or natural language ("ben yatıyorum", "sabaha kadar", "ben PC başında olmayacağım", "bilgisayar başında değilim").

**Setup phase (run once at start):**
1. **Baseline checkpoint:** verify clean working tree or commit a safety baseline. Note the SHA in the state file.
2. **State file:** create `.orchestrate/state-<timestamp>.md` with task, plan, budget, and decision log.
3. **Budget gate:** set hard limits — max iterations (default 8), max wall-clock (default 6h), max parallel agents (default 3). Refuse to exceed without user confirmation.
4. **Cron registration:** install `CronCreate` to fire every 15 minutes (off-the-quarter offset, e.g. `7,22,37,52 * * * *` to avoid global cron storms). The cron prompt re-enters this skill with `--triage`.

**Triage cycle (every 15 min, while away):**
1. Read state file → understand where we are.
2. Read recent agent transcripts and CI/test output.
3. Classify: `green` (work proceeding), `yellow` (warning — slowing, flaky test, lint drift), `red` (blocked — failing tests, agent stuck, destructive action requested, budget near limit).
4. Action by class:
   - **Green:** log "tick OK", schedule next, exit.
   - **Yellow:** dispatch one targeted fix agent (e.g. `pipeline-doctor`), log, continue.
   - **Red:** stop the loop. Log root cause + recommended action. Wait for user. Do **not** force-push, `reset --hard`, or paper over.
5. Update state file decision log.

**Wake-up summary (when user returns):**
- What shipped (commits + agents involved).
- What's blocked + why.
- Decisions awaiting user (with the specific question).
- Budget consumed (iterations, wall-clock, agent-minutes).

## Default agent lineup

Match the project's available agents. Optiway/Dark-Factory typical pipeline:

| Stage | Agent | Purpose |
|---|---|---|
| Plan | `Plan` | architecture, file ownership |
| Test-first | `tdd-pipeline:tester` | write failing tests before code |
| Implement | `tdd-pipeline:developer` (or layer-specific: `mobile-agents:ios-ui-specialist`, `mobile-agents:android-ui-specialist`) | make tests pass |
| Review | `code-review:reviewer` | independent quality gate (fresh context) |
| Fix loop | `code-review:review-fix` | re-review until clean (max N iterations) |
| Polish | `tdd-pipeline:ui-polish` | cross-platform consistency (mobile/UI tasks) |
| Self-heal | `dark-factory:pipeline-doctor` | diagnose + fix pipeline failures during triage |
| Validate | `dark-factory:holdout-validator`, `dark-factory:satisfaction-judge` | quality gates for autonomous ship |

Always pass `model: "opus"` and a self-contained prompt (the agent has no prior context).

## Risk gates (orchestrator must stop and ask)

Even in `--away` mode, **never** proceed without user confirmation on:

- Force push to any branch (especially `main`/`develop`)
- `git reset --hard`, `git clean -fd`, branch deletion
- Schema migrations on shared databases
- Dependency major-version bumps
- Removing/disabling tests to make CI green
- Paid-API calls likely to exceed daily budget (Bedrock, OpenAI, Google Routes)
- Bypassing hooks (`--no-verify`)
- Pushing to remote, creating PRs, or sending external messages

When blocked by a risk gate in `--away` mode: log it as `red`, halt, and write a clear "user decision needed" entry in the state file.

## Output template

### Interactive mode opening
```
Plan: <one paragraph — what, who, gates>
Dispatching: <agent list>
Will report back after: <which milestone>
```

### Away mode opening
```
Mode: AWAY (cron every 15 min, off-quarter offset)
Baseline: <SHA>
Budget: <N iterations, M hours, K parallel>
State file: .orchestrate/state-<ts>.md
Risk gates: <list>
First dispatch: <agents>
Sleep tight — I'll halt on red, fix on yellow, log on green.
```

### Wake-up summary
```
## Overnight summary

**Shipped**
- <commit SHA> <one-liner> (agents: <list>)
- ...

**Blocked**
- <issue> — <root cause> — needs: <user decision>

**Budget**
- Iterations: X / N
- Wall-clock: Y / M
- Agent-minutes: Z

**Next**
- <recommended action>
```

## What this skill is NOT

- Not a replacement for `/dark-factory:factory` — Dark Factory is the full Ralph Wiggum loop with governance tiers and auto-merge. Use Dark Factory when running spec-driven backlog. Use `/orchestrate` for ad-hoc tasks the user hands you directly.
- Not for one-off small edits. If the task is "fix this typo," just do it. The orchestrator overhead is for tasks where multi-agent specialization adds quality.
- Not a license to be lazy. If a subagent's output is wrong, the orchestrator catches it. Trust but verify every diff.
