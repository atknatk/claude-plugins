---
description: 'Dark Factory — start/stop/status of the Ralph Wiggum autonomous loop, sync backlog, run single task, or validate sessions.'
user-invocable: true
---

# /dark-factory:factory

Dark Factory — AI-driven autonomous development pipeline.

## Usage

```
/dark-factory:factory start [count] [hours]   — Start Ralph Wiggum loop (default: 5 tasks, 6h)
/dark-factory:factory status                   — Show factory dashboard
/dark-factory:factory sync                     — Sync GitHub Issues → backlog
/dark-factory:factory run <spec-or-issue>      — Run single task through full pipeline
/dark-factory:factory backlog                  — Show current backlog
/dark-factory:factory validate <session-id>    — Validate a completed session
/dark-factory:factory stop                     — Gracefully stop the Ralph loop
```

## Commands

### `start [count] [hours]`
Launch the Ralph Wiggum autonomous loop.
```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/ralph.sh" ${count:-5} ${hours:-6}
```

### `status`
Show the observability dashboard.
```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/dashboard.sh"
```

### `sync`
Sync GitHub Issues with `status:ready` label into the backlog.
```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/sync-backlog.sh"
```

### `run <spec-path-or-issue>`
Run a single task through the full Dark Factory pipeline.
```bash
# By intent spec file:
bash "${CLAUDE_PLUGIN_ROOT}/scripts/run-task.sh" docs/specs/backend-something.intent.md

# By issue number:
bash "${CLAUDE_PLUGIN_ROOT}/scripts/run-task.sh" --issue 42
```

### `backlog`
Display the current backlog.
```bash
cat .dark-factory/backlog.md
```

### `validate <session-id>`
Validate and inspect a completed session.
```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/validate-session.sh" <session-id>
```

### `stop`
Gracefully stop the Ralph loop (completes current task, then exits).
```bash
touch .dark-factory/.stop-signal
```

## Governance Tiers

| Tier | Action | Condition |
|------|--------|-----------|
| T0 | Auto-merge | Risk < 15, Satisfaction >= 80, Holdout pass |
| T1 | Auto-PR (CI gate) | Risk 15-40, Satisfaction >= 75, Holdout pass |
| T2 | PR + 1 review | Risk 40-60, Satisfaction >= 70 |
| T3 | PR + 2 reviews | Risk > 60 |
| T4 | Blocked | Holdout fail, Satisfaction < 50, or impl fail |
