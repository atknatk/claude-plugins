# orchestrate

Orchestrator skill that dispatches Opus subagents instead of doing work directly. Two modes:

- **Interactive** (default) — at-keyboard, sequential reporting after each agent.
- **Away / Overnight** — cron-driven 15-min triage loop with risk gates, budget caps, and a wake-up summary.

## Install

```bash
/plugin marketplace update everva
/plugin install orchestrate@everva
```

## Usage

```
/orchestrate <task>                          # interactive
/orchestrate --away <task>                   # overnight cron triage
/orchestrate --overnight <task>              # alias
/orchestrate --uzakta <task>                 # Türkçe alias
```

Natural-language triggers also work: "orkestre et", "ben yatıyorum sabaha kadar", "bilgisayar başında olmayacağım".

## Core rules

- Never code directly — dispatch subagents.
- Always `model: "opus"`.
- Independent reviewer (fresh context, never the implementer).
- Quality gates before commit (`pnpm test` + `pnpm lint` or project equivalent).
- Risk gates always halt: force push, schema migrations, paid-API blast, dep bumps, test deletion to make CI green.

## Away-mode anatomy

1. Baseline commit checkpoint + state file under `.orchestrate/`.
2. Hard budget: max iterations, wall-clock, parallel agents.
3. `CronCreate` every 15 min, off-the-quarter offset.
4. Each tick classifies green/yellow/red, acts accordingly.
5. Wake-up: shipped / blocked / budget / next.

See [`skills/orchestrate/SKILL.md`](./skills/orchestrate/SKILL.md) for the full skill body.

## Relation to Dark Factory

`orchestrate` is for ad-hoc tasks the user hands you directly. `dark-factory:factory` is the spec-driven Ralph Wiggum loop with governance tiers and auto-merge. They complement each other.
