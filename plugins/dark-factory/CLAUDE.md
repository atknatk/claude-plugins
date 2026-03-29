# Dark Factory Plugin

This plugin provides the **Dark Factory** autonomous AI development pipeline.

## What It Provides

- **Agents**: holdout-validator, satisfaction-judge, readiness-auditor, pipeline-doctor, regression-runner, task-analyzer
- **Skills**: `/dark-factory:factory`, `/dark-factory:task`, `/dark-factory:readiness`, `/dark-factory:satisfaction`, `/dark-factory:dashboard`, `/dark-factory:validate`, `/dark-factory:init`
- **Hooks**: holdout-guard (PreToolUse) — blocks implementation agents from reading holdout scenarios
- **Scripts**: ralph.sh, run-task.sh, validate-session.sh, alert.sh, dashboard.sh, sync-backlog.sh

## Project Configuration

Each project must have a `.dark-factory/config.yaml` file. Run `/dark-factory:init` to set up.

## Governance Tiers

| Tier | Action | Condition |
|------|--------|-----------|
| T0 | Auto-merge | Risk < 15, Satisfaction >= 80, Holdout pass |
| T1 | Auto-PR (CI gate) | Risk 15-40, Satisfaction >= 75, Holdout pass |
| T2 | PR + 1 review | Risk 40-60, Satisfaction >= 70 |
| T3 | PR + 2 reviews | Risk > 60 |
| T4 | Blocked | Holdout fail, Satisfaction < 50, or impl fail |
